import 'package:ribs_rill/src/pipes/compression/compression.dart';
import 'package:ribs_rill/src/pipes/text.dart';

final class Pipes {
  Pipes._();

  static final compression = CompressionPipes();

  static final text = TextPipes();
}
