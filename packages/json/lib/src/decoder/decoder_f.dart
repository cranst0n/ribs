import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] backed by a plain function.
///
/// Prefer constructing instances via [Decoder.instance] rather than directly.
final class DecoderF<A> extends Decoder<A> {
  /// The function that performs decoding from an [HCursor].
  final Function1<HCursor, DecodeResult<A>> decodeF;

  /// Creates a decoder that delegates to [decodeF].
  DecoderF(this.decodeF);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => decodeF(cursor);
}
