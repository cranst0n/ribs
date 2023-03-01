import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class OptionDecoder<A> extends Decoder<Option<A>> {
  final Decoder<A> decodeA;

  OptionDecoder(this.decodeA);

  @override
  DecodeResult<Option<A>> decode(HCursor cursor) => tryDecode(cursor);

  @override
  DecodeResult<Option<A>> tryDecode(ACursor cursor) {
    if (cursor is HCursor) {
      if (cursor.value.isNull) {
        return none<A>().asRight();
      } else {
        return decodeA
            .decode(cursor)
            .fold((err) => err.asLeft(), (a) => a.some.asRight());
      }
    } else if (cursor is FailedCursor) {
      if (!cursor.incorrectFocus) {
        return none<A>().asRight();
      } else {
        return DecodingFailure(MissingField(), cursor.history()).asLeft();
      }
    } else {
      return DecodingFailure.fromString('Unhandled cursor: $cursor', cursor)
          .asLeft();
    }
  }
}
