import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/key_decoder.dart';

class KeyDecoderF<A> extends KeyDecoder<A> {
  final Function1<String, Option<A>> f;

  KeyDecoderF(this.f);

  @override
  Option<A> decode(String key) => f(key);
}
