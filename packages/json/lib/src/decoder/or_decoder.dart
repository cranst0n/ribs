import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that tries [decodeA] first, falling back to [decodeB] if it
/// fails.
///
/// Created by [Decoder.or].
final class OrDecoder<A> extends Decoder<A> {
  /// The first decoder to attempt.
  final Decoder<A> decodeA;

  /// The fallback decoder used when [decodeA] fails.
  final Decoder<A> decodeB;

  /// Creates an [OrDecoder] from [decodeA] and [decodeB].
  OrDecoder(this.decodeA, this.decodeB);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) {
    return decodeA
        .tryDecodeC(cursor)
        .fold(
          (err) => decodeB.tryDecodeC(cursor),
          (a) => a.asRight(),
        );
  }
}
