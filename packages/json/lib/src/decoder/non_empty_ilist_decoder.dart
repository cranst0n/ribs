import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that decodes a non-empty JSON array into a [NonEmptyIList].
///
/// Fails with a [DecodingFailure] if the array is empty or the focused value
/// is not an array. Created by [Decoder.nonEmptyIList].
final class NonEmptyIListDecoder<A> extends Decoder<NonEmptyIList<A>> {
  /// The decoder applied to each array element.
  final Decoder<A> decodeA;

  /// Creates a [NonEmptyIListDecoder] that applies [decodeA] to each element.
  NonEmptyIListDecoder(this.decodeA);

  @override
  DecodeResult<NonEmptyIList<A>> decodeC(HCursor cursor) {
    final arr = cursor.downArray();
    final tailDecoder = Decoder.ilist(decodeA);

    return decodeA.tryDecodeC(arr).fold(
      (failure) => failure.asLeft(),
      (head) {
        return tailDecoder
            .tryDecodeC(arr.delete())
            .fold(
              (failure) => failure.asLeft(),
              (tail) => NonEmptyIList(head, tail).asRight(),
            );
      },
    );
  }
}
