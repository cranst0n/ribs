import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform_stub.dart'
    if (dart.library.io) 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform_io.dart';

/// Platform abstraction for GZip compress/decompress operations.
abstract class GZipPlatform {
  factory GZipPlatform() => GZipPlatformImpl();

  /// Decompresses a GZip-compressed stream of raw bytes.
  Pipe<int, int> get decode;

  /// Compresses a stream of raw bytes using GZip.
  Pipe<int, int> get encode;
}
