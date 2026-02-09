import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class OptionDecoder<A> extends Decoder<Option<A>> {
  final Decoder<A> decodeA;

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
