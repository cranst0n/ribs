import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// Bidirectional codec for [JsonObject] keys, combining [KeyDecoder] and
/// [KeyEncoder] into a single type.
abstract class KeyCodec<A> extends KeyDecoder<A> with KeyEncoder<A> {
  /// Creates a [KeyCodec] from a decode function that returns `Some(value)` on
  /// success or `None` on failure, and an encode function.
  static KeyCodec<A> instance<A>(
    Function1<String, Option<A>> decodeK,
    Function1<A, String> encodeK,
  ) => _KeyCodecF(KeyDecoder.instance(decodeK), KeyEncoder.instance(encodeK));

  /// A [KeyCodec] for [String] keys (identity in both directions).
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
