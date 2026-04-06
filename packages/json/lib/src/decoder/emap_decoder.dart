import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that runs [aDecoder] and then applies [f] to validate or
/// transform the result.
///
/// If [f] returns `Left(message)`, the message is wrapped in a
/// [DecodingFailure] with a [CustomReason]. Created by [Decoder.emap].
final class EmapDecoder<A, B> extends Decoder<B> {
  /// The underlying decoder whose output is passed to [f].
  final Decoder<A> aDecoder;

  /// The validation/transformation function; returns `Right(b)` on success or
  /// `Left(message)` on failure.
  final Function1<A, Either<String, B>> f;

  /// Creates an [EmapDecoder] from [aDecoder] and [f].
  EmapDecoder(this.aDecoder, this.f);

  @override
  DecodeResult<B> decode(Json json) {
    return aDecoder
        .decode(json)
        .fold(
          (failure) => failure.asLeft(),
          (a) => f(a).leftMap((str) => DecodingFailure(CustomReason(str), nil<CursorOp>())),
        );
  }

  @override
  DecodeResult<B> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<B> tryDecodeC(ACursor cursor) {
    return aDecoder
        .tryDecodeC(cursor)
        .fold(
          (failure) => failure.asLeft(),
          (a) => f(a).leftMap((str) => DecodingFailure.fromString(str, cursor)),
        );
  }
}
