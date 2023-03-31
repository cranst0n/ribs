import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class FlatMapDecoder<A, B> extends Decoder<B> {
  final Decoder<A> decodeA;
  final Function1<A, Decoder<B>> f;

  FlatMapDecoder(this.decodeA, this.f);

  @override
  DecodeResult<B> decode(HCursor cursor) => decodeA.decode(cursor).fold(
        (failure) => failure.asLeft(),
        (a) => f(a).decode(cursor),
      );

  @override
  DecodeResult<B> tryDecode(ACursor cursor) {
    return decodeA.tryDecode(cursor).fold(
          (failure) => failure.asLeft(),
          (a) => f(a).tryDecode(cursor),
        );
  }
}
