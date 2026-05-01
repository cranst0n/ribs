import 'package:ribs_rill/src/pipes/compression/gzip.dart';

/// A convenience namespace grouping compression pipes.
///
/// Obtained via [Pipes.compression] or `CompressionPipes()`.
///
/// ```dart
/// final compressed = rawBytes.through(Pipes.compression.gzip.encode);
/// final decompressed = compressed.through(Pipes.compression.gzip.decode);
/// ```
final class CompressionPipes {
  static final CompressionPipes _singleton = CompressionPipes._();

  factory CompressionPipes() => _singleton;

  CompressionPipes._();

  /// GZip compress/decompress pipes.
  GZipPipes get gzip => GZipPipes();
}
