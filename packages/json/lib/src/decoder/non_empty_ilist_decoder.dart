import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class NonEmptyIListDecoder<A> extends Decoder<NonEmptyIList<A>> {
  final Decoder<A> decodeA;

  NonEmptyIListDecoder(this.decodeA);

  @override
  DecodeResult<NonEmptyIList<A>> decodeC(HCursor cursor) {
    final arr = cursor.downArray();
    final tailDecoder = Decoder.ilist(decodeA);

    return decodeA.tryDecodeC(arr).fold(
      (failure) => failure.asLeft(),
      (head) {
        return tailDecoder.tryDecodeC(arr.delete()).fold(
              (failure) => failure.asLeft(),
              (tail) => NonEmptyIList(head, tail).asRight(),
            );
      },
    );
  }
}
