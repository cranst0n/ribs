import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class ListDecoder<A> extends Decoder<List<A>> {
  final Decoder<A> decodeA;

  ListDecoder(this.decodeA);

  @override
  DecodeResult<List<A>> decodeC(HCursor cursor) {
    var current = cursor.downArray();

    if (current.succeeded) {
      final l = List<A>.empty(growable: true);
      DecodingFailure? failure;

      while (failure == null && current.succeeded) {
        decodeA.decodeC(current as HCursor).fold(
          (err) => failure = err,
          (a) {
            l.add(a);
            current = current.right();
          },
        );
      }

      return Either.cond(
        () => failure == null,
        () => l,
        () => failure!,
      );
    } else if (cursor.value.isArray) {
      return List<A>.empty().asRight();
    } else {
      return DecodingFailure(WrongTypeExpectation('array', cursor.value), cursor.history())
          .asLeft();
    }
  }
}
