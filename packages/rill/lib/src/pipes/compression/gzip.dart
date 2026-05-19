import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform.dart';

/// GZip compression and decompression pipes.
///
/// Obtained via [Pipes.compression].gzip or `GZipPipes()`.
///
/// ```dart
/// final compressed = rawBytes.through(Pipes.compression.gzip.encode);
/// final decompressed = compressed.through(Pipes.compression.gzip.decode);
/// ```
class GZipPipes {
  static final GZipPipes _singleton = GZipPipes._();

  /// Returns the singleton [GZipPipes] instance.
  factory GZipPipes() => _singleton;

  GZipPipes._();

  static final _platform = GZipPlatform();

  /// Decompresses a GZip-compressed stream of raw bytes.
  Pipe<int, int> get decode => _platform.decode;

  /// Compresses a stream of raw bytes using GZip.
  Pipe<int, int> get encode => _platform.encode;
}
