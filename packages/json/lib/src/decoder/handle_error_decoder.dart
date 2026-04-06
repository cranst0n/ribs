import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that runs [primary] and, on failure, invokes [errorHandler] to
/// choose a recovery decoder.
///
/// Created by [Decoder.handleError] and [Decoder.recover].
final class HandleErrorDecoder<A> extends Decoder<A> {
  /// The decoder to try first.
  final Decoder<A> primary;

  /// Returns a fallback decoder given the [DecodingFailure] from [primary].
  final Function1<DecodingFailure, Decoder<A>> errorHandler;

  /// Creates a [HandleErrorDecoder] from [primary] and [errorHandler].
  HandleErrorDecoder(this.primary, this.errorHandler);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => cursor
      .decode(primary)
      .fold(
        (err) => cursor.decode(errorHandler(err)),
        (a) => a.asRight(),
      );
}
