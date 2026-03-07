import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that operates directly on [Json] without cursor indirection on
/// the fast path, avoiding [TopCursor] allocation and closure overhead.
final class PrimitiveDecoder<A> extends Decoder<A> {
  final Function1<Json, DecodeResult<A>> _jsonF;
  final Function1<HCursor, DecodeResult<A>> _cursorF;

  PrimitiveDecoder(this._jsonF, this._cursorF);

  /// Fast path: no cursor created.
  @override
  DecodeResult<A> decode(Json json) => _jsonF(json);

  /// Cursor path: full history available for error reporting.
  @override
  DecodeResult<A> decodeC(HCursor cursor) => _cursorF(cursor);
}
