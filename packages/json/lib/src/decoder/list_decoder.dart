import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that decodes a [JArray] into a Dart [List].
///
/// Uses a fast path that avoids cursor allocation when decoding directly from
/// [Json]. Created by [Decoder.list].
final class ListDecoder<A> extends Decoder<List<A>> {
  /// The decoder applied to each array element.
  final Decoder<A> decodeA;

  /// Creates a [ListDecoder] that applies [decodeA] to each element.
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
