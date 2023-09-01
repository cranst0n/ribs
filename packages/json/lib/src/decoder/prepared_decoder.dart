import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class PreparedDecoder<A> extends Decoder<A> {
  final Decoder<A> decodeA;
  final Function1<ACursor, ACursor> f;

  PreparedDecoder(this.decodeA, this.f);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => decodeA.tryDecodeC(f(cursor));
}
