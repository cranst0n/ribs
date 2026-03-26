import 'package:ribs_rill/src/pipes/compression/gzip.dart';

final class CompressionPipes {
  static final CompressionPipes _singleton = CompressionPipes._();

  factory CompressionPipes() => _singleton;

  CompressionPipes._();

  GZipPipes get gzip => GZipPipes();
}
