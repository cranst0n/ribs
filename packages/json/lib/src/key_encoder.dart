import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/encoder/key_encoder_f.dart';

@immutable
abstract class KeyEncoder<A> {
  String encode(A a);

  static KeyEncoder<A> instance<A>(Function1<A, String> f) => KeyEncoderF(f);

  static final string = KeyEncoderF<String>(id);
}
