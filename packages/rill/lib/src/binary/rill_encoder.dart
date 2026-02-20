import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

typedef Step<A> = Function1<Rill<A>, Pull<BitVector, Option<(Rill<A>, RillEncoder<A>)>>>;

class RillEncoder<A> {
  final Step<A> _step;

  RillEncoder._(this._step);

  static RillEncoder<A> emit<A>(BitVector bits) => RillEncoder._(
    (r) => Pull.output1(bits).append(() => Pull.pure(Some((r, RillEncoder.empty())))),
  );

  static RillEncoder<A> empty<A>() => RillEncoder._((r) => Pull.pure(const None()));

  static RillEncoder<A> many<A>(Encoder<A> encoder) => RillEncoder.once(encoder).repeat();

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

  static RillEncoder<A> raiseError<A>(Object reason, [StackTrace? stackTrace]) =>
      RillEncoder._((r) => Pull.raiseError(reason, stackTrace));

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

  static RillEncoder<A> tryMany<A>(Encoder<A> encoder) => tryOnce(encoder).repeat();

  RillEncoder<A> append(Function0<RillEncoder<A>> that) => RillEncoder._(
    (r) => _step(r).map((nextOpt) => nextOpt.mapN((s, next) => (s, next.or(that())))),
  );

  Rill<BitVector> encode(Rill<A> rill) => _apply(rill).voided.rillNoScope;

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

  RillEncoder<A> repeat() => append(repeat);

  Pipe<A, BitVector> get toPipe => (rill) => encode(rill);

  Pipe<A, int> get toPipeByte =>
      (rill) => encode(rill).flatMap((bits) => Rill.chunk(Chunk.byteVector(bits.bytes)));

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
