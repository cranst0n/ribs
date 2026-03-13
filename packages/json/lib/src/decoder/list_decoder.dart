import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class ListDecoder<A> extends Decoder<List<A>> {
  final Decoder<A> decodeA;

  ListDecoder(this.decodeA);

  @override
  DecodeResult<List<A>> decode(Json json) {
    if (json is JArray) return _fastDecode(json.value);
    return DecodingFailure(WrongTypeExpectation('array', json), nil<CursorOp>()).asLeft();
  }

  @override
  DecodeResult<List<A>> decodeC(HCursor cursor) {
    final json = cursor.value;
    if (json is JArray) return _fastDecode(json.value);
    return DecodingFailure(WrongTypeExpectation('array', json), cursor.history()).asLeft();
  }

  DecodeResult<List<A>> _fastDecode(IList<Json> elems) {
    final l = List<A>.empty(growable: true);
    IList<Json> current = elems;
    DecodingFailure? failure;

    while (failure == null && current is Cons<Json>) {
      decodeA
          .decode(current.head)
          .fold(
            (err) => failure = err,
            l.add,
          );
      current = current.tail;
    }

    if (failure != null) return failure!.asLeft();
    return l.asRight();
  }
}
