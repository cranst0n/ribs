// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// #region streaming-1
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
// #endregion streaming-1

// #region streaming-2
// Original stream of bytes
final Stream<List<int>> byteStream = File('path/to/big-array-file.json').openRead();

// Use JsonTransformer to transform the bytes into individual JSON events
final Stream<Json> jsonStream = byteStream.transform(
  JsonTransformer.bytes(AsyncParserMode.unwrapArray),
);

// Decode each Json stream element into an event, accounting for failure
final Stream<Either<DecodingFailure, Event>> decodeStream = jsonStream.map(
  (json) => Event.codec.decode(json),
);

// One step further...drop any decoding errors
final Stream<Event> eventStream = decodeStream.expand(
  (element) => element.fold(
    (err) => <Event>[],
    (event) => [event],
  ),
);
// #endregion streaming-2

Future<void> snippet3() async {
  // #region streaming-3
  final Socket sock = await Socket.connect('192.168.0.100', 12345);

  final Stream<Json> jsonStream = sock
      .map((event) => event.toList())
      .transform(JsonTransformer.bytes(AsyncParserMode.valueStream));
  // #endregion streaming-3
}

// #region streaming-4
// singleValue buffers the entire stream before emitting exactly one Json value.
// Useful when you receive a complete JSON document in chunks and want a single
// fully-parsed result at the end.
final Stream<Json> singleDocument = File(
  'config.json',
).openRead().transform(JsonTransformer.bytes(AsyncParserMode.singleValue));
// #endregion streaming-4

// #region streaming-5
// JsonTransformer.strings accepts a Stream<String> instead of Stream<List<int>>.
// This is convenient when the data source already decodes bytes to UTF-8 text
// (e.g. some HTTP clients, or a text file reader).
final Stream<String> stringChunks = Stream.fromIterable([
  '[{"id": "1", "type": "PushEvent", "repo": {"id": 1, "name": "a/b"}}, ',
  ' {"id": "2", "type": "CreateEvent", "repo": {"id": 2, "name": "c/d"}}]',
]);

final Stream<Json> fromStrings = stringChunks.transform(
  JsonTransformer.strings(AsyncParserMode.unwrapArray),
);
// #endregion streaming-5
