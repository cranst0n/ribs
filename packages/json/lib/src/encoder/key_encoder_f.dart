import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class KeyEncoderF<A> extends KeyEncoder<A> {
  final Function1<A, String> f;

  KeyEncoderF(this.f);

  @override
  String encode(A a) => f(a);
}
