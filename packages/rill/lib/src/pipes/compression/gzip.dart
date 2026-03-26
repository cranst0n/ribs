import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform.dart';

class GZipPipes {
  static final GZipPipes _singleton = GZipPipes._();

  factory GZipPipes() => _singleton;

  GZipPipes._();

  static final _platform = GZipPlatform();

  Pipe<int, int> get decode => _platform.decode;

  Pipe<int, int> get encode => _platform.encode;
}
