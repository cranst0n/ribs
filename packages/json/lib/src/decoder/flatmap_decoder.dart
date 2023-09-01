import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class FlatMapDecoder<A, B> extends Decoder<B> {
  final Decoder<A> decodeA;
  final Function1<A, Decoder<B>> f;

  FlatMapDecoder(this.decodeA, this.f);

  @override
  DecodeResult<B> decodeC(HCursor cursor) => decodeA.decodeC(cursor).fold(
        (failure) => failure.asLeft(),
        (a) => f(a).decodeC(cursor),
      );

  @override
  DecodeResult<B> tryDecodeC(ACursor cursor) {
    return decodeA.tryDecodeC(cursor).fold(
          (failure) => failure.asLeft(),
          (a) => f(a).tryDecodeC(cursor),
        );
  }
}
