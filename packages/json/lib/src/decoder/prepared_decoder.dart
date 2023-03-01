import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

class PreparedDecoder<A> extends Decoder<A> {
  final Decoder<A> decodeA;
  final Function1<ACursor, ACursor> f;

  PreparedDecoder(this.decodeA, this.f);

  @override
  DecodeResult<A> decode(HCursor cursor) => tryDecode(cursor);

  @override
  DecodeResult<A> tryDecode(ACursor cursor) => decodeA.tryDecode(f(cursor));
}
