import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

abstract class KeyCodec<A> extends KeyDecoder<A> with KeyEncoder<A> {
  static KeyCodec<A> instance<A>(
    Function1<String, Option<A>> decodeK,
    Function1<A, String> encodeK,
  ) => _KeyCodecF(KeyDecoder.instance(decodeK), KeyEncoder.instance(encodeK));

  static final string = KeyCodec.instance<String>((a) => Some(a), identity);
}

final class _KeyCodecF<A> extends KeyCodec<A> {
  final KeyDecoder<A> decodeK;
  final KeyEncoder<A> encodeK;

  _KeyCodecF(this.decodeK, this.encodeK);

  @override
  Option<A> decode(String key) => decodeK.decode(key);

  @override
  String encode(A a) => encodeK.encode(a);
}
