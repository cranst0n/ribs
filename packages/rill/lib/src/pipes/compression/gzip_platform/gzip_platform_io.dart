import 'dart:io';

import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/compression/gzip_platform/gzip_platform.dart';

class GZipPlatformImpl implements GZipPlatform {
  @override
  Pipe<int, int> get decode {
    final codec = GZipCodec();
    return (rill) => rill.mapChunks((chunk) => Chunk.fromDart(codec.decode(chunk.asUint8List)));
  }

  @override
  Pipe<int, int> get encode {
    final codec = GZipCodec();
    return (rill) => rill.mapChunks((chunk) => Chunk.fromDart(codec.encode(chunk.asUint8List)));
  }
}
