import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that wraps [decodeA] to produce `Option<A>`.
///
/// Returns [None] for a JSON `null` value or a missing (but not wrong-focus)
/// field; returns `Some(a)` when [decodeA] succeeds.
///
/// Created by [Decoder.optional].
final class OptionDecoder<A> extends Decoder<Option<A>> {
  /// The underlying decoder applied when the value is present and non-null.
  final Decoder<A> decodeA;

  /// Creates an [OptionDecoder] wrapping [decodeA].
  OptionDecoder(this.decodeA);

  @override
  DecodeResult<Option<A>> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<Option<A>> tryDecodeC(ACursor cursor) {
    if (cursor is HCursor) {
      if (cursor.value.isNull) {
        return none<A>().asRight();
      } else {
        return decodeA.decodeC(cursor).fold((err) => err.asLeft(), (a) => Some(a).asRight());
      }
    } else if (cursor is FailedCursor) {
      if (!cursor.incorrectFocus) {
        return none<A>().asRight();
      } else {
        return DecodingFailure(MissingField(), cursor.history()).asLeft();
      }
    } else {
      return DecodingFailure.fromString('Unhandled cursor: $cursor', cursor).asLeft();
    }
  }
}
