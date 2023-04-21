import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class HandleErrorDecoder<A> extends Decoder<A> {
  final Decoder<A> primary;
  final Function1<DecodingFailure, Decoder<A>> errorHandler;

  HandleErrorDecoder(this.primary, this.errorHandler);

  @override
  DecodeResult<A> decode(HCursor cursor) => tryDecode(cursor);

  @override
  DecodeResult<A> tryDecode(ACursor cursor) => cursor.as(primary).fold(
        (err) => cursor.as(errorHandler(err)),
        (a) => a.asRight(),
      );
}
