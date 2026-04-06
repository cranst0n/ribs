import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that transforms the cursor before delegating to [decodeA].
///
/// The transformation [f] is applied to the cursor first, allowing navigation
/// or modification before decoding begins. Created by [Decoder.prepare].
final class PreparedDecoder<A> extends Decoder<A> {
  /// The decoder that receives the transformed cursor.
  final Decoder<A> decodeA;

  /// The cursor transformation applied before decoding.
  final Function1<ACursor, ACursor> f;

  /// Creates a [PreparedDecoder] from [decodeA] and cursor transform [f].
  PreparedDecoder(this.decodeA, this.f);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => decodeA.tryDecodeC(f(cursor));
}
