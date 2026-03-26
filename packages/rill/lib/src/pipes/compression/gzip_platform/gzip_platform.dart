import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform_stub.dart'
    if (dart.library.io) 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform_io.dart';

abstract class GZipPlatform {
  factory GZipPlatform() => GZipPlatformImpl();

  Pipe<int, int> get decode;

  Pipe<int, int> get encode;
}
