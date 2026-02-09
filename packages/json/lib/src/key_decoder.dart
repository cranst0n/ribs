import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/decoder/key_decoder_f.dart';

@immutable
abstract class KeyDecoder<A> {
  static KeyDecoder<A> instance<A>(Function1<String, Option<A>> decodeF) => KeyDecoderF(decodeF);

  Option<A> decode(String key);

  KeyDecoder<B> flatMap<B>(covariant Function1<A, KeyDecoder<B>> f) =>
      KeyDecoder.instance((k) => decode(k).flatMap((a) => f(a).decode(k)));

  KeyDecoder<B> map<B>(Function1<A, B> f) => KeyDecoder.instance((k) => decode(k).map(f));

  static KeyDecoder<String> string = lift(Some.new);

  static KeyDecoder<A> lift<A>(Function1<String, Option<A>> f) => KeyDecoderF(f);
}
