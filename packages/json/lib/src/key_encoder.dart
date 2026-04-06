import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/encoder/key_encoder_f.dart';

/// Converts values of type [A] to JSON object key strings.
///
/// Used alongside [KeyDecoder] and [KeyCodec] to support typed keys in
/// [JsonObject]-backed [Map] encoding.
@immutable
abstract mixin class KeyEncoder<A> {
  /// Encodes [a] as a JSON object key string.
  String encode(A a);

  /// Creates a [KeyEncoder] from a plain function.
  static KeyEncoder<A> instance<A>(Function1<A, String> f) => KeyEncoderF(f);
}
