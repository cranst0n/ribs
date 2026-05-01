import 'package:ribs_rill/src/pipes/compression/compression.dart';
import 'package:ribs_rill/src/pipes/text.dart';

/// Namespace for built-in [Rill] transformation pipelines.
///
/// Access individual pipe families through the static fields:
/// ```dart
/// Rill.of(bytes).through(Pipes.compression.gunzip());
/// ```
final class Pipes {
  Pipes._();

  /// Compression and decompression pipes (gzip, zlib, deflate).
  static final compression = CompressionPipes();

  /// Text encoding/decoding pipes (UTF-8, line splitting, etc.).
  static final text = TextPipes();
}
