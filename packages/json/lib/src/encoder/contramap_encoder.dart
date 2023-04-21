import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class ContramapEncoder<A, B> extends Encoder<B> {
  final Encoder<A> encodeA;
  final Function1<B, A> f;

  ContramapEncoder(this.encodeA, this.f);

  @override
  Json encode(B b) => encodeA.encode(f(b));
}
