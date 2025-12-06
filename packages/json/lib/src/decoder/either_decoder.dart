import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class EitherDecoder<A, B> extends Decoder<Either<A, B>> {
  final Decoder<A> decodeA;
  final Decoder<B> decodeB;

  EitherDecoder(this.decodeA, this.decodeB);

  @override
  DecodeResult<Either<A, B>> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<Either<A, B>> tryDecodeC(ACursor cursor) => decodeA
      .tryDecodeC(cursor)
      .fold(
        (_) => decodeB
            .tryDecodeC(cursor)
            .fold((err) => err.asLeft(), (b) => b.asRight<A>().asRight<DecodingFailure>()),
        (a) => a.asLeft<B>().asRight<DecodingFailure>(),
      );
}
