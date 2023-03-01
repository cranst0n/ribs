import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class EncoderF<A> extends Encoder<A> {
  final Function1<A, Json> f;

  EncoderF(this.f);

  @override
  Json encode(A a) => f(a);
}
