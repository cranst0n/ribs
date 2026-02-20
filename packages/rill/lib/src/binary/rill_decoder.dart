import 'dart:math';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

class RillDecoder<A> {
  final Step<A> _step;

  const RillDecoder._(this._step);

  static RillDecoder<A> emit<A>(A a) => RillDecoder._(Result(a));

  static RillDecoder<A> emits<A>(List<A> values) =>
      values.fold(RillDecoder.empty, (acc, a) => acc.append(() => RillDecoder.emit(a)));

  static final RillDecoder<Never> empty = RillDecoder._(Empty());

  static RillDecoder<Never> ignore<A>(int bits) =>
      once(Codec.ignore(bits)).flatMap((_) => RillDecoder.empty);

  static RillDecoder<A> isolate<A>(int bits, RillDecoder<A> decoder) =>
      RillDecoder._(Isolate(max(0, bits), decoder));

  static RillDecoder<A> many<A>(Decoder<A> decoder) => RillDecoder._(
    Decode(
      (bv) => decoder.decode(bv).map((res) => res.map((a) => RillDecoder.emit(a))),
      false,
      true,
    ),
  );

  static RillDecoder<A> once<A>(Decoder<A> decoder) => RillDecoder._(
    Decode(
      (bv) => decoder.decode(bv).map((res) => res.map((a) => RillDecoder.emit(a))),
      true,
      true,
    ),
  );

  static RillDecoder<Never> raiseError(Object err) => RillDecoder._(Failed(err));

  static RillDecoder<A> tryMany<A>(Decoder<A> decoder) => RillDecoder._(
    Decode(
      (bv) => decoder.decode(bv).map((res) => res.map((a) => RillDecoder.emit(a))),
      false,
      false,
    ),
  );

  static RillDecoder<A> tryOnce<A>(Decoder<A> decoder) => RillDecoder._(
    Decode(
      (bv) => decoder.decode(bv).map((res) => res.map((a) => RillDecoder.emit(a))),
      true,
      false,
    ),
  );

  Pipe<BitVector, A> get toPipe => (rill) => decode(rill);

  Pipe<int, A> get toPipeByte =>
      (rill) => rill.chunks().map((chunk) => chunk.toBitVector).through(toPipe);

  Rill<A> decode(Rill<BitVector> rill) => this(rill).voided.rillNoScope;

  Pull<A, Option<Rill<BitVector>>> call(Rill<BitVector> r) {
    switch (_step) {
      case Empty _:
        return Pull.pure(Some(r));
      case Result(:final value):
        return Pull.output1(value).as(Some(r));
      case Failed(:final reason, :final stackTrace):
        return Pull.raiseError(reason, stackTrace);
      case Append(:final x, :final y):
        return x(r).flatMap(
          (next) => next.fold(
            () => Pull.pure(const None()),
            (rem) => y()(rem),
          ),
        );
      case Decode(f: final decoder, :final once, :final failOnErr):
        Pull<A, Option<Rill<BitVector>>> loop(
          BitVector carry,
          Rill<BitVector> r,
          Option<Err> carriedError,
        ) {
          return r.pull.uncons1.flatMap((hdtl) {
            return hdtl.foldN(
              () {
                late final Pull<A, Option<Rill<BitVector>>> done =
                    carry.isEmpty ? Pull.pure(none()) : Pull.pure(Some(Rill.emit(carry)));

                return carriedError.filter((_) => failOnErr).fold(
                  () => done,
                  (err) {
                    if (!once && err is InsufficientBits) {
                      return done;
                    } else {
                      return Pull.raiseError('Codec Error: err');
                    }
                  },
                );
              },
              (hd, tl) {
                final buffer = carry.concat(hd);

                return decoder(buffer).fold(
                  (err) {
                    if (err is InsufficientBits) {
                      return loop(buffer, tl, Some(err));
                    } else if (failOnErr) {
                      return Pull.raiseError('Codec Error: $err');
                    } else {
                      return Pull.pure(Some(tl.cons1(buffer)));
                    }
                  },
                  (success) {
                    final next = success.remainder.isEmpty ? tl : tl.cons1(success.remainder);
                    final p = success.value(next);

                    if (once) {
                      return p;
                    } else {
                      return p.flatMap((nextOpt) {
                        return nextOpt.fold(
                          () => Pull.pure(none()),
                          (next) => loop(BitVector.empty, next, carriedError),
                        );
                      });
                    }
                  },
                );
              },
            );
          });
        }

        return loop(BitVector.empty, r, none());

      case Isolate(:final bits, :final decoder):
        Pull<A, Option<Rill<BitVector>>> loop(
          BitVector carry,
          Rill<BitVector> r,
          Option<Err> carriedError,
        ) {
          return r.pull.uncons1.flatMap((hdtl) {
            return hdtl.foldN(
              () => carriedError.fold(
                () => carry.isEmpty ? Pull.pure(none()) : Pull.pure(Some(Rill.emit(carry))),
                (e) => Pull.raiseError('Codec Error: $e'),
              ),
              (hd, tl) {
                final (buffer, remainder) = carry.concat(hd).splitAt(bits);

                if (buffer.size == bits) {
                  return decoder(
                    Rill.emit(buffer),
                  ).append(() => Pull.pure(Some(tl.cons1(remainder))));
                } else {
                  return loop(buffer, tl, Some(Err.insufficientBits(bits, buffer.size)));
                }
              },
            );
          });
        }

        return loop(BitVector.empty, r, none());
    }
  }

  RillDecoder<A> append(Function0<RillDecoder<A>> s2) => RillDecoder._(Append(this, s2));

  RillDecoder<B> flatMap<B>(Function1<A, RillDecoder<B>> f) {
    return RillDecoder._(switch (_step) {
      Empty _ => Empty(),
      Result(:final value) => f(value)._step,
      Failed(:final reason, :final stackTrace) => Failed(reason, stackTrace),
      Decode(f: final g, :final once, :final failOnErr) => Decode(
        (bv) => g(bv).map((res) => res.map((a) => a.flatMap(f))),
        once,
        failOnErr,
      ),
      Isolate(:final bits, :final decoder) => Isolate(bits, decoder.flatMap(f)),
      Append(:final x, :final y) => Append(x.flatMap(f), () => y().flatMap(f)),
    });
  }

  RillDecoder<A> filter(Function1<A, bool> p) =>
      flatMap((a) => p(a) ? RillDecoder.emit(a) : RillDecoder.empty);

  RillDecoder<A> handleErrorWith(Function1<Object, RillDecoder<A>> f) {
    return RillDecoder._(switch (_step) {
      Empty _ => Empty(),
      Result(:final value) => Result(value),
      Failed(:final reason) => f(reason)._step,
      Decode(f: final g, :final once, :final failOnErr) => Decode(
        (bv) => g(bv).map((res) => res.map((a) => a.handleErrorWith(f))),
        once,
        failOnErr,
      ),
      Isolate(:final bits, :final decoder) => Isolate(bits, decoder.handleErrorWith(f)),
      Append(:final x, :final y) => Append(x.handleErrorWith(f), () => y().handleErrorWith(f)),
    });
  }

  RillDecoder<B> map<B>(Function1<A, B> f) => flatMap((a) => RillDecoder.emit(f(a)));
}

sealed class Step<A> {
  const Step();
}

class Empty extends Step<Never> {}

class Result<A> extends Step<A> {
  final A value;

  const Result(this.value);
}

class Failed extends Step<Never> {
  final Object reason;
  final StackTrace? stackTrace;

  const Failed(this.reason, [this.stackTrace]);
}

class Decode<A> extends Step<A> {
  final Function1<BitVector, Either<Err, DecodeResult<RillDecoder<A>>>> f;
  final bool once;
  final bool failOnErr;

  const Decode(this.f, this.once, this.failOnErr);
}

class Isolate<A> extends Step<A> {
  final int bits;
  final RillDecoder<A> decoder;

  const Isolate(this.bits, this.decoder);
}

class Append<A> extends Step<A> {
  final RillDecoder<A> x;
  final Function0<RillDecoder<A>> y;

  const Append(this.x, this.y);
}
