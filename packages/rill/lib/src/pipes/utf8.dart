import 'dart:convert';

import 'package:ribs_rill/ribs_rill.dart';

final class Utf8Pipes {
  static final Utf8Pipes _singleton = Utf8Pipes._();

  factory Utf8Pipes() => _singleton;

  Utf8Pipes._();

  Pipe<int, String> decode = (rill) => rill.chunks().through(Utf8Pipes().decodeChunks);

  Pipe<Chunk<int>, String> decodeChunks =
      (rill) => rill.map((chunk) => const Utf8Decoder().convert(chunk.toDartList()));

  Pipe<String, int> encode = (rill) => rill.through(Utf8Pipes().encodeChunks).unchunks;

  Pipe<String, Chunk<int>> encodeChunks =
      (rill) => rill.map((chunk) => Chunk.bytes(const Utf8Encoder().convert(chunk)));
}
