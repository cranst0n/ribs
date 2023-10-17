// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// streaming-1

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

// streaming-1

// streaming-2

// Original stream of bytes
final Stream<List<int>> byteStream =
    File('path/to/big-array-file.json').openRead();

// Use JsonTransformer to transform the bytes into individual JSON events
final Stream<Json> jsonStream =
    byteStream.transform(JsonTransformer.bytes(AsyncParserMode.unwrapArray));

// Decode each Json stream element into an event, accounting for failure
final Stream<Either<DecodingFailure, Event>> decodeStream =
    jsonStream.map((json) => Event.codec.decode(json));

// One step further...drop any decoding errors
final Stream<Event> eventStream = decodeStream.expand((element) => element.fold(
      (err) => <Event>[],
      (event) => [event],
    ));

// streaming-2

Future<void> snippet3() async {
  // streaming-3

  final Socket sock = await Socket.connect('192.168.0.100', 12345);

  final Stream<Json> jsonStream = sock
      .map((event) => event.toList())
      .transform(JsonTransformer.bytes(AsyncParserMode.valueStream));

  // streaming-3
}
