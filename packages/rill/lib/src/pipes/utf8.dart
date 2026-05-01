import 'dart:convert';

import 'package:ribs_rill/ribs_rill.dart';

/// Pipes for UTF-8 encoding and decoding.
///
/// Obtained via [Pipes.utf8] or `Utf8Pipes()`. Both chunk-level and
/// element-level variants are provided so callers can choose between
/// convenience and efficiency.
///
/// ```dart
/// final text = Rill.emits([72, 101, 108, 108, 111])
///     .through(Pipes.utf8.decode);
/// ```
final class Utf8Pipes {
  static final Utf8Pipes _singleton = Utf8Pipes._();

  factory Utf8Pipes() => _singleton;

  Utf8Pipes._();

  /// Decodes a stream of raw bytes to UTF-8 strings, one string per chunk.
  Pipe<int, String> decode = (rill) => rill.chunks().through(Utf8Pipes().decodeChunks);

  /// Decodes a stream of byte chunks to UTF-8 strings.
  Pipe<Chunk<int>, String> decodeChunks =
      (rill) => rill.map((chunk) => const Utf8Decoder().convert(chunk.toDartList()));

  /// Encodes a stream of strings to raw UTF-8 bytes.
  Pipe<String, int> encode = (rill) => rill.through(Utf8Pipes().encodeChunks).unchunks;

  /// Encodes a stream of strings to UTF-8 byte chunks, one chunk per string.
  Pipe<String, Chunk<int>> encodeChunks =
      (rill) => rill.map((chunk) => Chunk.bytes(const Utf8Encoder().convert(chunk)));
}
