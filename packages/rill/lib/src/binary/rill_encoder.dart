import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Internal step function type for [RillEncoder].
typedef Step<A> = Function1<Rill<A>, Pull<BitVector, Option<(Rill<A>, RillEncoder<A>)>>>;

/// A streaming binary encoder that applies an [Encoder] to each element of a
/// [Rill], emitting [BitVector] values.
///
/// [RillEncoder] is built by composing static factories and combinators before
/// being run via [toPipe], [toPipeByte], or [encode]. Combinators like [or]
/// and [repeat] allow building stateful, protocol-aware encoders.
///
/// ```dart
/// final encoder = RillEncoder.many(Codecs.int32);
/// final bits = Rill.emits([1, 2, 3]).through(encoder.toPipe);
/// ```
class RillEncoder<A> {
  final Step<A> _step;

  RillEncoder._(this._step);

  /// Creates an encoder that emits [bits] without consuming any stream element.
  static RillEncoder<A> emit<A>(BitVector bits) => RillEncoder._(
    (r) => Pull.output1(bits).append(() => Pull.pure(Some((r, RillEncoder.empty())))),
  );

  /// Creates an encoder that terminates immediately without consuming any input.
  static RillEncoder<A> empty<A>() => RillEncoder._((r) => Pull.pure(const None()));

  /// Repeatedly encodes elements using [encoder], failing on the first error.
  static RillEncoder<A> many<A>(Encoder<A> encoder) => RillEncoder.once(encoder).repeat();

  /// Encodes a single element using [encoder], failing if encoding fails.
  static RillEncoder<A> once<A>(Encoder<A> encoder) => RillEncoder._((r) {
    return r.pull.uncons1.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(const None()),
        (hd, tl) => encoder
            .encode(hd)
            .fold((err) => Pull.raiseError(err), (bits) => Pull.output1(bits))
            .append(() => Pull.pure(Some((tl, RillEncoder.empty())))),
      );
    });
  });

  /// Creates an encoder that immediately raises [reason] as an error.
  static RillEncoder<A> raiseError<A>(Object reason, [StackTrace? stackTrace]) =>
      RillEncoder._((r) => Pull.raiseError(reason, stackTrace));

  /// Like [once] but leaves the element in the stream when encoding fails
  /// instead of raising an error.
  static RillEncoder<A> tryOnce<A>(Encoder<A> encoder) => RillEncoder._((r) {
    return r.pull.uncons1.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(const None()),
        (hd, tl) => encoder
            .encode(hd)
            .fold(
              (_) => Pull.pure(Some((tl.cons1(hd), RillEncoder.empty()))),
              (bits) => Pull.output1(bits).append(() => Pull.pure(Some((tl, RillEncoder.empty())))),
            ),
      );
    });
  });

  /// Like [many] but stops quietly on the first encoding failure.
  static RillEncoder<A> tryMany<A>(Encoder<A> encoder) => tryOnce(encoder).repeat();

  /// Sequences this encoder followed by [that] on the remaining input.
  RillEncoder<A> append(Function0<RillEncoder<A>> that) => RillEncoder._(
    (r) => _step(r).map((nextOpt) => nextOpt.mapN((s, next) => (s, next.or(that())))),
  );

  /// Runs this encoder on [rill], returning a stream of [BitVector] values.
  Rill<BitVector> encode(Rill<A> rill) => _apply(rill).voided.rillNoScope;

  /// Falls back to [other] if this encoder produces no output for an element.
  RillEncoder<A> or(RillEncoder<A> other) {
    return RillEncoder._((r) {
      return _step(r).flatMap((nextOpt) {
        return nextOpt.fold(
          () => other._step(r),
          (x) => Pull.pure(Some(x)),
        );
      });
    });
  }

  /// Repeats this encoder until the input stream is exhausted.
  RillEncoder<A> repeat() => append(repeat);

  /// Exposes this encoder as a [Pipe] from values to [BitVector] chunks.
  Pipe<A, BitVector> get toPipe => (rill) => encode(rill);

  /// Exposes this encoder as a [Pipe] from values to raw bytes.
  Pipe<A, int> get toPipeByte =>
      (rill) => encode(rill).flatMap((bits) => Rill.chunk(Chunk.byteVector(bits.bytes)));

  /// Adapts this encoder to work on type [B] by mapping input values with [g]
  /// before encoding and output values with [f] after decoding.
  RillEncoder<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) => RillEncoder._(
    (r) => _step(r.map(g)).map((nextOpt) => nextOpt.mapN((s1, e1) => (s1.map(f), e1.xmap(f, g)))),
  );

  Pull<BitVector, Option<(Rill<A>, RillEncoder<A>)>> _apply(Rill<A> rill) {
    Pull<BitVector, Option<(Rill<A>, RillEncoder<A>)>> loop(Rill<A> r, RillEncoder<A> encoder) {
      return encoder._step(r).flatMap((nextOpt) {
        return nextOpt.foldN(
          () => Pull.pure(const None()),
          (s, next) => loop(s, next),
        );
      });
    }

    return loop(rill, this);
  }
}
