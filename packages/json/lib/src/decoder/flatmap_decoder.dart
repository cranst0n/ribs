import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [Decoder] that sequences two decoders: first decodes an [A], then uses
/// the result to choose the [Decoder] for [B].
///
/// Created by [Decoder.flatMap].
final class FlatMapDecoder<A, B> extends Decoder<B> {
  /// The first decoder whose result drives decoder selection.
  final Decoder<A> decodeA;

  /// Returns the decoder for [B] given a successfully decoded [A].
  final Function1<A, Decoder<B>> f;

  /// Creates a [FlatMapDecoder] from [decodeA] and [f].
  FlatMapDecoder(this.decodeA, this.f);

  @override
  DecodeResult<B> decodeC(HCursor cursor) => decodeA
      .decodeC(cursor)
      .fold(
        (failure) => failure.asLeft(),
        (a) => f(a).decodeC(cursor),
      );

  @override
  DecodeResult<B> tryDecodeC(ACursor cursor) {
    return decodeA
        .tryDecodeC(cursor)
        .fold(
          (failure) => failure.asLeft(),
          (a) => f(a).tryDecodeC(cursor),
        );
  }
}
