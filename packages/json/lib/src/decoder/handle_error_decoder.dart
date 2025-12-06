import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class HandleErrorDecoder<A> extends Decoder<A> {
  final Decoder<A> primary;
  final Function1<DecodingFailure, Decoder<A>> errorHandler;

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
