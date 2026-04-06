import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/key_decoder.dart';

/// A [KeyDecoder] backed by a plain function.
///
/// Prefer constructing instances via [KeyDecoder.instance] rather than
/// directly.
final class KeyDecoderF<A> extends KeyDecoder<A> {
  /// The function that decodes a string key, returning [Some] on success or
  /// [None] on failure.
  final Function1<String, Option<A>> f;

  /// Creates a [KeyDecoderF] that delegates to [f].
  KeyDecoderF(this.f);

  @override
  Option<A> decode(String key) => f(key);
}
