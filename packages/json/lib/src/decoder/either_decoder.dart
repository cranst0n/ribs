import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that tries [decodeA] first and, if it succeeds, wraps the
/// result in [Left]; otherwise tries [decodeB] and wraps the result in [Right].
///
/// Created by [Decoder.either].
final class EitherDecoder<A, B> extends Decoder<Either<A, B>> {
  /// The decoder whose success produces a [Left] value.
  final Decoder<A> decodeA;

  /// The decoder whose success produces a [Right] value.
  final Decoder<B> decodeB;

  /// Creates an [EitherDecoder] from [decodeA] and [decodeB].
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
