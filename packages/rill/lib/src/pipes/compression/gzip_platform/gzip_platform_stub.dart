import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform.dart';

class GZipPlatformImpl implements GZipPlatform {
  @override
  Pipe<int, int> get decode => throw UnimplementedError('GZip.decode');

  @override
  Pipe<int, int> get encode => throw UnimplementedError('GZip.decode');
}
