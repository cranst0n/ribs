import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class DecoderF<A> extends Decoder<A> {
  final Function1<HCursor, DecodeResult<A>> decodeF;

  DecoderF(this.decodeF);

  @override
  DecodeResult<A> decode(HCursor cursor) => decodeF(cursor);
}
