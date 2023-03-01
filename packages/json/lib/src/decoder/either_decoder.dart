import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class EitherDecoder<A, B> extends Decoder<Either<A, B>> {
  final Decoder<A> decodeA;
  final Decoder<B> decodeB;

  EitherDecoder(this.decodeA, this.decodeB);

  @override
  DecodeResult<Either<A, B>> decode(HCursor cursor) => tryDecode(cursor);

  @override
  DecodeResult<Either<A, B>> tryDecode(ACursor cursor) =>
      decodeA.tryDecode(cursor).fold(
            (_) => decodeB.tryDecode(cursor).fold((err) => err.asLeft(),
                (b) => b.asRight<A>().asRight<DecodingFailure>()),
            (a) => a.asLeft<B>().asRight<DecodingFailure>(),
          );
}
