import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/decoder/key_decoder_f.dart';

/// Decodes JSON object key strings into values of type [A].
///
/// Used alongside [KeyEncoder] and [KeyCodec] to support typed keys in
/// [JsonObject]-backed [Map] decoding.
@immutable
abstract class KeyDecoder<A> {
  /// Creates a [KeyDecoder] from a function that returns [Some] on success or
  /// [None] on failure.
  static KeyDecoder<A> instance<A>(Function1<String, Option<A>> decodeF) => KeyDecoderF(decodeF);

  /// Decodes [key], returning [Some] on success or [None] on failure.
  Option<A> decode(String key);

  /// Returns a decoder that decodes a key with this decoder and then passes
  /// the result to [f] to select the next decoder.
  KeyDecoder<B> flatMap<B>(Function1<A, KeyDecoder<B>> f) =>
      KeyDecoder.instance((k) => decode(k).flatMap((a) => f(a).decode(k)));

  /// Returns a decoder that transforms a successfully decoded key with [f].
  KeyDecoder<B> map<B>(Function1<A, B> f) => KeyDecoder.instance((k) => decode(k).map(f));

  /// A [KeyDecoder] for [String] keys (identity).
  static KeyDecoder<String> string = lift(Some.new);

  /// Creates a [KeyDecoder] from a plain function.
  static KeyDecoder<A> lift<A>(Function1<String, Option<A>> f) => KeyDecoderF(f);
}
