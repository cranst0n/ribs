// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

// Domain models — same as streaming.dart
final class Event {
  final String id;
  final String type;
  final Repo repo;

  const Event(this.id, this.type, this.repo);

  static final codec = Codec.product3(
    'id'.as(Codec.string),
    'type'.as(Codec.string),
    'repo'.as(Repo.codec),
    Event.new,
    (evt) => (evt.id, evt.type, evt.repo),
  );
}

final class Repo {
  final int id;
  final String name;

  const Repo(this.id, this.name);

  static final codec = Codec.product2(
    'id'.as(Codec.integer),
    'name'.as(Codec.string),
    Repo.new,
    (repo) => (repo.id, repo.name),
  );
}

IO<Unit> storeEvent(Event _) => IO.unit;

// #region streaming-rill-file
// Drive AsyncParser directly from a Rill<int> byte stream.
//
// Each Chunk<int> is fed to parser.absorb via IO.delay, keeping side effects
// inside IO. A final flush (finalAbsorb) is appended to handle modes that
// buffer until EOF — notably singleValue.
Rill<Json> parseJsonRill(Rill<int> bytes, AsyncParserMode mode) =>
    Rill.pure(AsyncParser(mode: mode)).flatMap((parser) {
      final absorbed = bytes
          .chunks()
          .evalMap((chunk) => IO.delay(() => parser.absorb(Uint8List.fromList(chunk.toDartList()))))
          .flatMap(
            (result) => result.fold(
              (err) => Rill.raiseError<Json>(err),
              (jsons) => Rill.emits(jsons.toList()),
            ),
          );

      final flushed = Rill.eval(
        IO.delay(() => parser.finalAbsorb(Uint8List(0))),
      ).flatMap(
        (result) => result.fold(
          (err) => Rill.raiseError<Json>(err),
          (jsons) => Rill.emits(jsons.toList()),
        ),
      );

      return absorbed + flushed;
    });

// Files.readAll streams the file as Rill<int>; parseJsonRill feeds each chunk
// directly into AsyncParser without leaving the Rill ecosystem.
IO<Unit> processEventsFromFile(Path path) =>
    parseJsonRill(
      Files.readAll(path),
      AsyncParserMode.unwrapArray,
    ).evalMap((json) => IO.fromEither(Event.codec.decode(json))).foreach(storeEvent).compile.drain;
// #endregion streaming-rill-file

// #region streaming-rill-socket
// Network.connect gives a Resource<Socket> whose reads is Rill<int>.
// The same parseJsonRill helper slots in unchanged.
IO<Unit> consumeSocketEvents(SocketAddress addr) => Network.connect(addr).use(
  (socket) =>
      parseJsonRill(socket.reads, AsyncParserMode.valueStream)
          .evalMap((json) => IO.fromEither(Event.codec.decode(json)))
          .foreach(storeEvent)
          .compile
          .drain,
);
// #endregion streaming-rill-socket
