import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class NonEmptyIListDecoder<A> extends Decoder<NonEmptyIList<A>> {
  final Decoder<A> decodeA;

  NonEmptyIListDecoder(this.decodeA);

  @override
  DecodeResult<NonEmptyIList<A>> decode(HCursor cursor) {
    final arr = cursor.downArray();
    final tailDecoder = Decoder.ilist(decodeA);

    return decodeA.tryDecode(arr).fold(
      (failure) => failure.asLeft(),
      (head) {
        return tailDecoder.tryDecode(arr.delete()).fold(
              (failure) => failure.asLeft(),
              (tail) => NonEmptyIList(head, tail).asRight(),
            );
      },
    );
  }
}
