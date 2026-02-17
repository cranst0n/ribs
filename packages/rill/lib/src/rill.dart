import 'dart:async';
import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
// ignore: implementation_imports
import 'package:ribs_effect/src/resource.dart';
import 'package:ribs_rill/ribs_rill.dart';

part 'compiler.dart';
part 'pull.dart';
part 'to_pull.dart';

typedef Pipe<I, O> = Function1<Rill<I>, Rill<O>>;

class Rill<O> {
  final Pull<O, Unit> underlying;

  factory Rill._scoped(Pull<O, Unit> pull) => Pull.scope(pull).rillNoScope;

  factory Rill._noScope(Pull<O, Unit> p) => Rill._(p);

  Rill._(this.underlying);

  static Rill<Duration> awakeEvery(Duration period, {bool dampen = true}) {
    return Rill.eval(IO.now).flatMap((start) {
      return _fixedRate(
        period,
        start,
        dampen,
      ).flatMap((_) => Rill.eval(IO.now.map((now) => now.difference(start))));
    });
  }

  static Rill<R> bracket<R>(IO<R> acquire, Function1<R, IO<Unit>> release) =>
      bracketFull((_) => acquire, (r, _) => release(r));

  static Rill<R> bracketCase<R>(IO<R> acquire, Function2<R, ExitCase, IO<Unit>> release) =>
      bracketFull((_) => acquire, release);

  static Rill<R> bracketFull<R>(
    Function1<Poll, IO<R>> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => Pull.acquireCancelable(acquire, release).flatMap(Pull.output1).rillNoScope;

  static Rill<O> chunk<O>(Chunk<O> values) =>
      values.nonEmpty ? Pull.output(values).rillNoScope : Rill.empty();

  static Rill<O> constant<O>(O o, {int chunkSize = 256}) =>
      chunkSize > 0 ? chunk(Chunk.fill(chunkSize, o)).repeat() : Rill.empty();

  static Rill<Duration> duration() =>
      Rill.eval(IO.now).flatMap((t0) => Rill.repeatEval(IO.now.map((now) => now.difference(t0))));

  static Rill<O> emit<O>(O value) => Pull.output1(value).rill;

  static Rill<O> emits<O>(List<O> values) => Rill.chunk(Chunk.fromList(values));

  static Rill<O> eval<O>(IO<O> io) => Pull.eval(io).flatMap(Pull.output1).rill;

  static Rill<O> exec<O>(IO<Unit> io) => Rill._noScope(Pull.eval(io).flatMap((_) => Pull.done));

  static Rill<O> empty<O>() => Rill._noScope(Pull.done);

  static Rill<Unit> fixedDelay(Duration period) => sleep(period).repeat();

  static Rill<Unit> fixedRate(Duration period, {bool dampen = true}) =>
      Rill.eval(IO.now).flatMap((t) => _fixedRate(period, t, dampen));

  static Rill<Unit> fixedRateStartImmediately(Duration period, {bool dampen = true}) =>
      Rill.eval(IO.now).flatMap((t) => Rill.unit.append(() => _fixedRate(period, t, dampen)));

  static Rill<Unit> _fixedRate(
    Duration period,
    DateTime lastAwakeAt,
    bool dampen,
  ) {
    if (period.inMicroseconds == 0) {
      return Rill.unit.repeat();
    } else {
      return Rill.eval(IO.now).flatMap((now) {
        final next = lastAwakeAt.add(period);

        if (next.isAfter(now)) {
          return Rill.sleep(next.difference(now)).append(() => _fixedRate(period, next, dampen));
        } else {
          final ticks =
              (now.microsecondsSinceEpoch - lastAwakeAt.microsecondsSinceEpoch - 1) ~/
              period.inMicroseconds;

          final Rill<Unit> step = switch (ticks) {
            final count when count < 0 => Rill.empty(),
            final count when count == 0 || dampen => Rill.unit,
            final count => Rill.unit.repeatN(count),
          };

          return step.append(() => _fixedRate(period, lastAwakeAt.add(period * ticks), dampen));
        }
      });
    }
  }

  static Rill<O> force<O>(IO<Rill<O>> io) => Rill.eval(io).flatMap(identity);

  static Rill<O> fromEither<E extends Object, O>(Either<E, O> either) =>
      either.fold((err) => Rill.raiseError(err), (o) => Rill.emit(o));

  static Rill<O> fromOption<E extends Object, O>(Option<O> option) =>
      option.fold(() => Rill.empty(), (o) => Rill.emit(o));

  static Rill<O> fromStream<O>(
    Stream<O> stream, {
    OverflowStrategy strategy = const _DropOldest(100),
  }) {
    final IO<Queue<Either<Object, Option<O>>>> createQueue = switch (strategy) {
      _DropNewest(:final bufferSize) => Queue.dropping(bufferSize),
      _DropOldest(:final bufferSize) => Queue.circularBuffer(bufferSize),
      _Unbounded() => Queue.unbounded(),
    };

    return Rill.eval(createQueue).flatMap((queue) {
      Rill<O> consumeStreamQueue() {
        return Rill.eval(queue.take()).flatMap((event) {
          return event.fold(
            (err) => Rill.raiseError(err),
            (opt) => opt.fold(
              () => Rill.empty(),
              (o) => Rill.emit(o).append(() => consumeStreamQueue()),
            ),
          );
        });
      }

      final acquire = IO.delay(() {
        return stream.listen(
          (data) => queue.offer(Right(Some(data))).unsafeRunAndForget(),
          onError: (Object err) => queue.offer(Left(err)).unsafeRunAndForget(),
          onDone: () => queue.offer(Right(none())).unsafeRunAndForget(),
          cancelOnError: false, // handle manually
        );
      });

      IO<Unit> release(StreamSubscription<O> sub) => IO.fromFutureF(() => sub.cancel()).voided();

      return Rill.bracket(acquire, release).flatMap((_) => consumeStreamQueue());
    });
  }

  static Rill<O> iterate<O>(O start, Function1<O, O> f) =>
      Rill.emit(start).append(() => iterate(f(start), f));

  static Rill<O> iterateEval<O>(O start, Function1<O, IO<O>> f) =>
      Rill.emit(start).append(() => Rill.eval(f(start)).flatMap((o) => iterateEval(o, f)));

  static final Rill<Never> never = Rill.eval(IO.never());

  static Rill<O> pure<O>(O value) => Rill._noScope(Pull.output1(value));

  static Rill<O> raiseError<O>(Object error, [StackTrace? stackTrace]) =>
      Pull.raiseError(error, stackTrace).rill;

  static Rill<int> range(int start, int stopExclusive, {int step = 1}) {
    Rill<int> go(int n) {
      if ((step > 0 && n < stopExclusive && start < stopExclusive) ||
          (step < 0 && n > stopExclusive && start > stopExclusive)) {
        return emit(n).append(() => go(n + step));
      } else {
        return empty();
      }
    }

    return go(start);
  }

  static Rill<O> repeatEval<O>(IO<O> fo) => Rill.eval(fo).repeat();

  static Rill<O> resource<O>(Resource<O> r) {
    return switch (r) {
      Pure(:final value) => Rill.emit(value),
      Eval(:final task) => Rill.eval(task),
      Bind(:final source, :final f) => Rill.resource(source).flatMap((o) => Rill.resource(f(o))),
      Allocate(:final resource) => Rill.bracketFull(
        (poll) => resource(poll),
        (resAndRelease, exitCase) => resAndRelease.$2(exitCase),
      )._mapNoScope((x) => x.$1),
      _ => throw StateError('Unhandled Resource ADT: $r'),
    }.scope;
  }

  static Rill<O> retry<O>(
    IO<O> fo,
    Duration delay,
    Function1<Duration, Duration> nextDelay,
    int maxAttempts, {
    Function1<Object, bool>? retriable,
  }) {
    final delays = Rill.unfold(delay, (d) => Some((d, nextDelay(d))));
    final canRetry = retriable ?? (_) => true;

    return Rill.eval(fo)
        .attempts(delays)
        .take(maxAttempts)
        .takeThrough((r) => r.fold((err) => canRetry(err), (_) => false))
        .last
        .unNone
        .rethrowError;
  }

  static Rill<Unit> sleep(Duration duration) => Rill.eval(IO.sleep(duration));

  static Rill<O> sleep_<O>(Duration duration) => Rill.exec(IO.sleep(duration));

  static Rill<IOFiber<O>> supervise<O>(IO<O> fo) =>
      Rill.bracket(fo.start(), (fiber) => fiber.cancel());

  static Rill<O> suspend<O>(Function0<Rill<O>> f) => Pull.suspend(() => f().underlying).rillNoScope;

  static Rill<O> unfold<S, O>(S s, Function1<S, Option<(O, S)>> f) {
    Rill<O> go(S s) {
      return f(s).foldN(
        () => Rill.empty(),
        (o, s) => emit(o).append(() => go(s)),
      );
    }

    return suspend(() => go(s));
  }

  static final Rill<Unit> unit = Pull.outUnit.rillNoScope;

  Rill<O> operator +(Rill<O> other) => underlying.flatMap((_) => other.underlying).rillNoScope;

  Rill<O> andWait(Duration duration) => append(() => Rill.sleep_<O>(duration));

  Rill<O> append(Function0<Rill<O>> s2) => underlying.append(() => s2().underlying).rillNoScope;

  Rill<O2> as<O2>(O2 o2) => map((_) => o2);

  Rill<Either<Object, O>> attempt() =>
      map((o) => o.asRight<Object>()).handleErrorWith((err) => Rill.emit(Left(err)));

  Rill<Either<Object, O>> attempts(Rill<Duration> delays) => attempt().append(
    () => delays.flatMap((delay) => Rill.sleep(delay).flatMap((_) => attempt())),
  );

  Rill<O> buffer(int n) {
    if (n <= 0) {
      return this;
    } else {
      return repeatPull((tp) {
        return tp.unconsN(n, allowFewer: true).flatMap((hdtl) {
          return hdtl.foldN(
            () => Pull.pure(none()),
            (hd, tl) => Pull.output(hd).as(Some(tl)),
          );
        });
      });
    }
  }

  Rill<O> changes() => filterWithPrevious((a, b) => a != b);

  Rill<O> changesBy<O2>(Function1<O, O2> f) => filterWithPrevious((a, b) => f(a) != f(b));

  Rill<O> changesWith(Function2<O, O, bool> f) => filterWithPrevious((a, b) => f(a, b));

  Rill<Chunk<O>> chunkAll() {
    Pull<Chunk<O>, Unit> loop(Rill<O> s, Chunk<O> acc) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.output1(acc),
          (hd, tl) => loop(tl, acc.concat(hd)),
        );
      });
    }

    return loop(this, Chunk.empty()).rill;
  }

  Rill<Chunk<O>> chunks() => underlying.unconsFlatMap(Pull.output1).rill;

  Rill<Chunk<O>> chunkLimit(int n) {
    Pull<Chunk<O>, Unit> breakup(Chunk<O> ch) {
      if (ch.size <= n) {
        return Pull.output1(ch);
      } else {
        final (pre, rest) = ch.splitAt(n);
        return Pull.output1(pre).append(() => breakup(rest));
      }
    }

    return underlying.unconsFlatMap(breakup).rill;
  }

  Rill<Chunk<O>> chunkMin(int n, {bool allowFewerTotal = true}) => repeatPull((p) {
    return p.unconsMin(n, allowFewerTotal: allowFewerTotal).flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(none()),
        (hd, tl) => Pull.output1(hd).as(Some(tl)),
      );
    });
  });

  Rill<Chunk<O>> chunkN(int n, {bool allowFewer = true}) => repeatPull((tp) {
    return tp.unconsN(n, allowFewer: allowFewer).flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(none()),
        (hd, tl) => Pull.output1(hd).as(Some(tl)),
      );
    });
  });

  Rill<O> concurrently<O2>(Rill<O2> that) {
    final daemon = that.drain().flatMap((_) => Rill.never);
    return mergeHaltBoth(daemon);
  }

  Rill<O> cons(Chunk<O> c) => c.isEmpty ? this : Rill.chunk(c).append(() => this);

  Rill<O> cons1(O o) => Rill.emit(o).append(() => this);

  Rill<O2> collect<O2>(Function1<O, Option<O2>> f) => mapChunks((c) => c.collect(f));

  Rill<O2> collectFirst<O2>(Function1<O, Option<O2>> f) => collect(f).take(1);

  Rill<O2> collectWhile<O2>(Function1<O, Option<O2>> f) =>
      map(f).takeWhile((b) => b.isDefined).unNone;

  Rill<O> debounce(Duration d) => switchMap((o) => Rill.sleep(d).as(o));

  Rill<O> delayBy(Duration duration) => Rill.sleep_<O>(duration).append(() => this);

  Rill<O> delete(Function1<O, bool> p) =>
      pull
          .takeWhile((o) => !p(o))
          .flatMap((r) => r.fold(() => Pull.done, (s) => s.drop(1).pull.echo))
          .rill;

  /// WARN: For long streams and/or large elements, this can be a memory hog.
  ///   Use with caution;
  Rill<O> get distinct {
    return scanChunksOpt(ISet.empty<O>(), (seen) {
      return Some((chunk) {
        return (seen.concat(chunk), chunk);
      });
    });
  }

  Rill<Never> drain() => underlying.unconsFlatMap((_) => Pull.done).rill;

  Rill<O> drop(int n) =>
      pull.drop(n).flatMap((opt) => opt.fold(() => Pull.done, (rest) => rest.pull.echo)).rill;

  Rill<O> get dropLast => dropLastIf((_) => true);

  Rill<O> dropLastIf(Function1<O, bool> p) {
    Pull<O, Unit> go(Chunk<O> last, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () {
            final o = last[last.size - 1];

            if (p(o)) {
              final (prefix, _) = last.splitAt(last.size - 1);
              return Pull.output(prefix);
            } else {
              return Pull.output(last);
            }
          },
          (hd, tl) => Pull.output(last).append(() => go(hd, tl)),
        );
      });
    }

    return pull.uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done,
        (hd, tl) => go(hd, tl),
      );
    }).rill;
  }

  Rill<O> dropRight(int n) {
    if (n <= 0) {
      return this;
    } else {
      Pull<O, Unit> go(Chunk<O> acc, Rill<O> s) {
        return s.pull.uncons.flatMap((hdtl) {
          return hdtl.foldN(
            () => Pull.done,
            (hd, tl) {
              final all = acc.concat(hd);
              return Pull.output(all.dropRight(n)).append(() => go(all.takeRight(n), tl));
            },
          );
        });
      }

      return go(Chunk.empty(), this).rill;
    }
  }

  Rill<O> dropThrough(Function1<O, bool> p) =>
      pull
          .dropThrough(p)
          .flatMap((tl) => tl.map((tl) => tl.pull.echo).getOrElse(() => Pull.done))
          .rill;

  Rill<O> dropWhile(Function1<O, bool> p) =>
      pull
          .dropWhile(p)
          .flatMap((tl) => tl.map((tl) => tl.pull.echo).getOrElse(() => Pull.done))
          .rill;

  Rill<Either<O, O2>> either<O2>(Rill<O2> that) =>
      map((o) => o.asLeft<O2>()).merge(that.map((o2) => o2.asRight<O>()));

  Rill<O> evalFilter(Function1<O, IO<bool>> p) =>
      underlying
          .flatMapOutput(
            (o) => Pull.eval(p(o)).flatMap((pass) => pass ? Pull.output1(o) : Pull.done),
          )
          .rillNoScope;

  Rill<O> evalFilterNot(Function1<O, IO<bool>> p) =>
      flatMap((o) => Rill.eval(p(o)).ifM(() => Rill.empty(), () => Rill.emit(o)));

  Rill<O2> evalFold<O2>(O2 z, Function2<O2, O, IO<O2>> f) {
    Pull<O2, Unit> go(O2 z, Rill<O> r) {
      return r.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.output1(z),
          (hd, tl) => Pull.eval(f(z, hd)).flatMap((ns) => go(ns, tl)),
        );
      });
    }

    return go(z, this).rill;
  }

  Rill<O2> evalMap<O2>(Function1<O, IO<O2>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o)).flatMap(Pull.output1)).rillNoScope;

  Rill<O> evalMapFilter(Function1<O, IO<Option<O>>> f) =>
      underlying
          .flatMapOutput((o) => Pull.eval(f(o)).flatMap((opt) => Pull.outputOption1(opt)))
          .rillNoScope;

  Rill<O2> evalScan<O2>(O2 z, Function2<O2, O, IO<O2>> f) {
    Pull<O2, Unit> go(O2 z, Rill<O> s) {
      return s.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) => Pull.eval(f(z, hd)).flatMap((o) => Pull.output1(o).append(() => go(o, tl))),
        );
      });
    }

    return Pull.output1(z).append(() => go(z, this)).rill;
  }

  Rill<O> evalTap<O2>(Function1<O, IO<O2>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o)).flatMap((_) => Pull.output1(o))).rillNoScope;

  Rill<bool> exists(Function1<O, bool> p) =>
      pull.forall((o) => !p(o)).flatMap((r) => Pull.output1(!r)).rill;

  Rill<O> filter(Function1<O, bool> p) => mapChunks((c) => c.filter(p));

  Rill<O> filterNot(Function1<O, bool> p) => mapChunks((c) => c.filterNot(p));

  Rill<O> filterWithPrevious(Function2<O, O, bool> p) {
    Pull<O, Unit> go(O last, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            // can it be emitted unmodified?
            final (allPass, newLast) = hd.foldLeft((
              true,
              last,
            ), (acc, a) => (acc.$1 && p(acc.$2, a), a));

            if (allPass) {
              return Pull.output(hd).append(() => go(newLast, tl));
            } else {
              final (acc, newLast) = hd.foldLeft((IVector.empty<O>(), last), (acc, a) {
                if (p(acc.$2, a)) {
                  return (acc.$1.appended(a), a);
                } else {
                  return (acc.$1, acc.$2);
                }
              });

              return Pull.output(Chunk.from(acc)).append(() => go(newLast, tl));
            }
          },
        );
      });
    }

    return pull.uncons1.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done,
        (hd, tl) => Pull.output1(hd).append(() => go(hd, tl)),
      );
    }).rill;
  }

  Rill<O2> flatMap<O2>(Function1<O, Rill<O2>> f) => Rill.suspend(() {
    // Implemented this way for stack safety
    Pull<O2, Unit> loop(Rill<O> rill) {
      return rill.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            final chunkPull = hd.foldLeft<Pull<O2, Unit>>(Pull.done, (acc, element) {
              return acc.flatMap((_) => f(element).pull.echo);
            });

            return chunkPull.append(() => loop(tl));
          },
        );
      });
    }

    return loop(this).rillNoScope;
  });

  Rill<O2> fold<O2>(O2 z, Function2<O2, O, O2> f) => pull.fold(z, f).flatMap(Pull.output1).rill;

  Rill<O> fold1(Function2<O, O, O> f) =>
      pull.fold1(f).flatMap((opt) => opt.map(Pull.output1).getOrElse(() => Pull.done)).rill;

  Rill<bool> forall(Function1<O, bool> p) =>
      pull.forall(p).flatMap((res) => Pull.output1(res)).rill;

  Rill<Never> foreach(Function1<O, IO<Unit>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o))).rillNoScope;

  Rill<(O2, Chunk<O>)> groupAdjacentBy<O2>(Function1<O, O2> f) =>
      groupAdjacentByLimit(Integer.MaxValue, f);

  Rill<(O2, Chunk<O>)> groupAdjacentByLimit<O2>(int limit, Function1<O, O2> f) {
    Pull<(O2, Chunk<O>), Unit> go(Option<(O2, Chunk<O>)> current, Rill<O> s) {
      Pull<(O2, Chunk<O>), Unit> doChunk(
        Chunk<O> chunk,
        Rill<O> s,
        O2 k1,
        Chunk<O> out,
        IQueue<(O2, Chunk<O>)> acc,
      ) {
        final differsAt = chunk.indexWhere((v) => f(v) != k1).getOrElse(() => -1);

        if (differsAt == -1) {
          // whole chunk matches the current key, add this chunk to the accumulated output
          if (out.size + chunk.size < limit) {
            final newCurrent = Some((k1, out.concat(chunk)));
            return Pull.output(Chunk.from(acc)).append(() => go(newCurrent, s));
          } else {
            final (prefix, suffix) = chunk.splitAt(limit - out.size);
            return Pull.output(
              Chunk.from(acc.appended((k1, out.concat(prefix)))),
            ).append(() => go(Some((k1, suffix)), s));
          }
        } else {
          // at least part of this chunk does not match the current key, need to group and retain chunkiness
          // split the chunk into the bit where the keys match and the bit where they don't
          final matching = chunk.take(differsAt);

          late IQueue<(O2, Chunk<O>)> newAcc;

          final newOutSize = out.size + matching.size;

          if (newOutSize == 0) {
            newAcc = acc;
          } else if (newOutSize > limit) {
            final (prefix, suffix) = matching.splitAt(limit - out.size);
            newAcc = acc.appended((k1, out.concat(prefix))).appended((k1, suffix));
          } else {
            newAcc = acc.appended((k1, out.concat(matching)));
          }

          final nonMatching = chunk.drop(differsAt);

          // nonMatching is guaranteed to be non-empty here, because we know the last element of the chunk doesn't have
          // the same key as the first
          final k2 = f(nonMatching[0]);

          return doChunk(nonMatching, s, k2, Chunk.empty(), newAcc);
        }
      }

      return s.pull.unconsLimit(limit).flatMap((hdtl) {
        return hdtl.foldN(
          () => current
              .mapN(
                (k1, out) => out.size == 0 ? Pull.done : Pull.output1((k1, out)),
              )
              .getOrElse(() => Pull.done),
          (hd, tl) {
            final (k1, out) = current.getOrElse(() => (f(hd[0]), Chunk.empty()));
            return doChunk(hd, tl, k1, out, IQueue.empty());
          },
        );
      });
    }

    return go(none(), this).rill;
  }

  Rill<Chunk<O>> groupWithin(int chunkSize, Duration timeout) {
    if (chunkSize <= 0) throw ArgumentError('Rill.groupWithin: chunkSize must be > 0');

    return Rill.eval(Queue.unbounded<Option<Chunk<O>>>()).flatMap((queue) {
      // Producer: runs in background pushing chunks to the queue
      final producer = chunks()
          .map((c) => Some(c))
          .evalMap(queue.offer)
          .compile
          .drain
          .guarantee(queue.offer(const None()));

      // Consumer: buffers data and races agaist timeout
      //
      // [deadline]: Monotonic time (micros) the current buffer MUST be emitted or null for empty buffer
      Pull<Chunk<O>, Unit> consumeLoop(Chunk<O> buffer, int? deadline) {
        if (buffer.size >= chunkSize) {
          final (toEmit, remainder) = buffer.splitAt(chunkSize);

          if (remainder.isEmpty) {
            return Pull.output1(toEmit).append(() => consumeLoop(Chunk.empty(), null));
          } else {
            // set new deadline
            return Pull.eval(IO.now).flatMap((now) {
              return Pull.output1(toEmit).append(() {
                return consumeLoop(remainder, now.microsecondsSinceEpoch + timeout.inMicroseconds);
              });
            });
          }
        } else {
          // Buffer isn't full so wait for data or timeout
          if (buffer.isEmpty) {
            // no buffered data, don't care about time. wait for next chunk
            return Pull.eval(queue.take()).flatMap((opt) {
              return opt.fold(
                () => Pull.done,
                (chunk) {
                  // data has arrived, start the clock
                  return Pull.eval(IO.now).flatMap((now) {
                    return consumeLoop(chunk, now.microsecondsSinceEpoch + timeout.inMicroseconds);
                  });
                },
              );
            });
          } else {
            // buffer has data, race queue againt the clock
            return Pull.eval(IO.now).flatMap((now) {
              final remainingMicros = deadline! - now.microsecondsSinceEpoch;

              if (remainingMicros <= 0) {
                // timeout reached, emit whatever is buffered
                return Pull.output1(buffer).append(() => consumeLoop(Chunk.empty(), null));
              } else {
                final waitOp = IO.sleep(Duration(microseconds: remainingMicros));
                final takeOp = queue.take();

                return Pull.eval(IO.race(takeOp, waitOp)).flatMap((raceResult) {
                  return raceResult.fold(
                    (takeResult) {
                      return takeResult.fold(
                        () => Pull.output1(buffer), // producer finished
                        (newChunk) => consumeLoop(buffer.concat(newChunk), deadline),
                      );
                    },
                    (_) => Pull.output1(buffer).append(() => consumeLoop(Chunk.empty(), null)),
                  );
                });
              }
            });
          }
        }
      }

      return Rill.bracket(
        producer.start(),
        (fiber) => fiber.cancel(),
      ).flatMap((_) => consumeLoop(Chunk.empty(), null).rill);
    });
  }

  Rill<O> handleErrorWith(Function1<Object, Rill<O>> f) =>
      underlying.handleErrorWith((err) => f(err).underlying).rillNoScope;

  Rill<O> get head => take(1);

  Rill<O> ifEmpty(Function0<Rill<O>> fallback) =>
      pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => fallback().underlying,
          (hd, tl) => Pull.output(hd).append(() => tl.underlying),
        );
      }).rill;

  Rill<O> ifEmptyEmit(Function0<O> o) => ifEmpty(() => Rill.emit(o()));

  Rill<O> interleave(Rill<O> that) => zip(that).flatMap((t) => Rill.emits([t.$1, t.$2]));

  Rill<O> interleaveAll(Rill<O> that) => map(
    (o) => Option(o),
  ).zipAll<Option<O>>(that.map((o) => Option(o)), none(), none()).flatMap((t) {
    final (thisOpt, thatOpt) = t;
    return Rill.chunk(Chunk.from(thisOpt).concat(Chunk.from(thatOpt)));
  });

  Rill<O> intersperse(O separator) {
    Chunk<O> doChunk(Chunk<O> hd, bool isFirst) {
      final bldr = <O>[];

      final iter = hd.iterator;

      if (isFirst) bldr.add(iter.next());

      iter.foreach((o) {
        bldr.add(separator);
        bldr.add(o);
      });

      return Chunk.fromList(bldr);
    }

    Pull<O, Unit> go(Rill<O> str) {
      return str.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) => Pull.output(doChunk(hd, false)).append(() => go(tl)),
        );
      });
    }

    return pull.uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done,
        (hd, tl) => Pull.output(doChunk(hd, true)).append(() => go(tl)),
      );
    }).rill;
  }

  Rill<O> interruptAfter(Duration duration) => interruptWhen(IO.sleep(duration));

  Rill<O> interruptWhen<B>(IO<B> signal) {
    return Rill.eval(IO.deferred<Unit>()).flatMap((stopEvent) {
      final startSignalFiber = signal.attempt().flatMap((_) => stopEvent.complete(Unit())).start();

      return Rill.eval(startSignalFiber).flatMap((fiber) {
        return Rill._noScope(
          _interruptibleLoop(underlying, stopEvent.value()),
        ).onFinalize(fiber.cancel());
      });
    });
  }

  Rill<O> interruptWhenTrue(Rill<bool> signal) {
    final trigger = signal
        .exists(identity)
        .take(1)
        .compile
        .last
        .flatMap(
          (lastOpt) => lastOpt.fold(
            () => IO.never<Unit>(),
            (_) => IO.unit,
          ),
        );

    return interruptWhen(trigger);
  }

  static Pull<O, Unit> _interruptibleLoop<O>(Pull<O, Unit> original, IO<Unit> barrier) {
    return Pull.getScope.flatMap((scope) {
      return Pull.eval(IO.race(barrier, _stepPull(original, scope))).flatMap((either) {
        return either.fold(
          (signalWon) => Pull.done,
          (stepWon) {
            return switch (stepWon) {
              final _StepDone<dynamic, dynamic> _ => Pull.done,
              final _StepOut<O, Unit> so => Pull.output(
                so.head,
              ).flatMap((_) => _interruptibleLoop(so.next, barrier)),
              final _StepError<dynamic, dynamic> se => Pull.raiseError(se.error),
            };
          },
        );
      });
    });
  }

  Rill<O> keepAlive(Duration maxIdle, IO<O> heartbeat) {
    return Rill.eval(Queue.unbounded<Option<Chunk<O>>>()).flatMap((queue) {
      final producer = chunks()
          .map((c) => Some(c))
          .evalMap(queue.offer)
          .compile
          .drain
          .guarantee(queue.offer(none()));

      Pull<O, Unit> consumeLoop() {
        final takeOp = queue.take();
        final timerOp = IO.sleep(maxIdle);

        return Pull.eval(IO.race(takeOp, timerOp)).flatMap((raceResult) {
          return raceResult.fold(
            (queueResult) => queueResult.fold(
              () => Pull.done,
              (chunk) => Pull.output(chunk).append(consumeLoop),
            ),
            (_) => Pull.eval(heartbeat).flatMap((o) => Pull.output1(o)).append(consumeLoop),
          );
        });
      }

      return Rill.bracket(
        producer.start(),
        (fiber) => fiber.cancel(),
      ).flatMap((_) => consumeLoop().rill);
    });
  }

  Rill<Option<O>> get last => pull.last.flatMap(Pull.output1).rill;

  Rill<O> lastOr(Function0<O> fallback) =>
      pull.last.flatMap((o) => o.fold(() => Pull.output1(fallback()), (o) => Pull.output1(o))).rill;

  Rill<O2> map<O2>(Function1<O, O2> f) =>
      pull.echo.unconsFlatMap((hd) => Pull.output(hd.map(f))).rillNoScope;

  Rill<(S, O2)> mapAccumulate<S, O2>(S initial, Function2<S, O, (S, O2)> f) {
    (S, (S, O2)) go(S s, O a) {
      final (newS, newO) = f(s, a);
      return (newS, (newS, newO));
    }

    return scanChunks(initial, (acc, c) => c.mapAccumulate(acc, go));
  }

  /// Alias for [parEvalMap].
  Rill<O2> mapAsync<O2>(int maxConcurrent, Function1<O, IO<O2>> f) => parEvalMap(maxConcurrent, f);

  /// Alias for [parEvalMapUnordered].
  Rill<O2> mapAsyncUnordered<O2>(int maxConcurrent, Function1<O, IO<O2>> f) =>
      parEvalMapUnordered(maxConcurrent, f);

  Rill<O2> mapChunks<O2>(Function1<Chunk<O>, Chunk<O2>> f) =>
      underlying.unconsFlatMap((hd) => Pull.output(f(hd))).rill;

  Rill<O> get mask => handleErrorWith((_) => Rill.empty());

  Rill<O> merge(Rill<O> that) {
    Rill<O> consumeMergeQueue(Queue<Either<Object, Option<O>>> q) {
      return Rill.eval(q.take()).flatMap((event) {
        return event.fold(
          (err) => Rill.raiseError(err),
          (eventOpt) => eventOpt.fold(
            () => Rill.empty(),
            (element) => Rill.pure(element).append(() => consumeMergeQueue(q)),
          ),
        );
      });
    }

    return Rill.eval(Queue.unbounded<Either<Object, Option<O>>>()).flatMap((queue) {
      return Rill.eval(Ref.of(2)).flatMap((activeCount) {
        IO<Unit> run(Rill<O> s) {
          return s
              .map((o) => Some(o).asRight<Object>())
              .evalMap(queue.offer)
              .compile
              .drain
              .handleErrorWith(
                (err) => queue.offer(err.asLeft()),
              )
              .guarantee(
                activeCount.updateAndGet((n) => n - 1).flatMap((n) {
                  return n == 0 ? queue.offer(none<O>().asRight()) : IO.unit;
                }),
              );
        }

        final runBoth = (run(this).start(), run(that).start()).tupled;
        IO<Unit> cleanup((IOFiber<Unit>, IOFiber<Unit>) fibers) =>
            fibers.$1.cancel().product(fibers.$2.cancel()).voided();

        return Rill.bracket(runBoth, cleanup).flatMap((_) {
          return consumeMergeQueue(queue);
        });
      });
    });
  }

  Rill<O> mergeHaltBoth(Rill<O> that) {
    return Rill.eval(Queue.unbounded<Option<O>>()).flatMap((queue) {
      IO<Unit> run(Rill<O> s) {
        return s.map((o) => o.some).evalMap(queue.offer).compile.drain;
      }

      Rill<O> dequeueLoop(Queue<Option<O>> q) {
        return Rill.eval(q.take()).flatMap((opt) {
          return opt.fold(
            () => Rill.empty(),
            (item) => Rill.pure(item) + dequeueLoop(q),
          );
        });
      }

      final driver = IO.race(run(this), run(that)).guarantee(queue.offer(none()));

      return Rill.bracket(
        driver.start(),
        (fiber) => fiber.cancel(),
      ).flatMap((_) => dequeueLoop(queue));
    });
  }

  Rill<O> mergeHaltL(Rill<O> that) =>
      noneTerminate().merge(that.map((o) => Option(o))).unNoneTerminate;

  Rill<O> mergeHaltR(Rill<O> that) => that.mergeHaltL(this);

  Rill<O> metered(Duration rate) => Rill.fixedRate(rate).zipRight(this);

  Rill<O> meteredStartImmediately(Duration rate) =>
      Rill.fixedRateStartImmediately(rate).zipRight(this);

  Rill<Option<O>> noneTerminate() => map((o) => Option(o)).append(() => Rill.emit(none()));

  Rill<O> onComplete(Function0<Rill<O>> s2) =>
      handleErrorWith((e) => s2().append(() => Pull.fail(e).rill)).append(() => s2());

  Rill<O> onFinalize(IO<Unit> finalizer) => //Rill.noScope(underlying.onFinalize(finalizer));
      onFinalizeCase((_) => finalizer);

  Rill<O> onFinalizeCase(Function1<ExitCase, IO<Unit>> finalizer) =>
  //Rill.noScope(underlying.onFinalizeCase(finalizer));
  Rill.bracketCase(IO.unit, (_, ec) => finalizer(ec)).flatMap((_) => this);

  Rill<O2> parEvalMap<O2>(int maxConcurrent, Function1<O, IO<O2>> f) {
    return Rill.eval(Queue.unbounded<Either<Object, Option<IOFiber<O2>>>>()).flatMap((queue) {
      return Rill.eval(Semaphore.permits(maxConcurrent)).flatMap((sem) {
        final backgroundProducer = evalMap((o) {
              return sem.acquire().flatMap((_) {
                return f(o).guarantee(sem.release()).start();
              });
            })
            .map((fiber) => Right<Object, Option<IOFiber<O2>>>(Some(fiber)))
            .evalMap(queue.offer)
            .compile
            .drain
            .handleErrorWith((err) => queue.offer(Left(err)))
            .guarantee(queue.offer(Right(none())));

        // Read fibers from queue and joins in order
        Rill<O2> consume() {
          return Rill.eval(queue.take()).flatMap((event) {
            return event.fold(
              (err) => Rill.raiseError(err),
              (opt) => opt.fold(
                () => Rill.empty(),
                (fiber) {
                  // join the fiber, maintaining order
                  return Rill.eval(fiber.join()).flatMap((outcome) {
                    return outcome.fold(
                      () => Rill.raiseError('Inner task canceled'),
                      (err, stackTrace) => Rill.raiseError(err, stackTrace),
                      (result) => Rill.emit(result).append(() => consume()),
                    );
                  });
                },
              ),
            );
          });
        }

        return Rill.bracket(
          backgroundProducer.start(),
          (fiber) => fiber.cancel(),
        ).flatMap((_) => consume());
      });
    });
  }

  Rill<O2> parEvalMapUnbounded<O2>(int maxConcurrent, Function1<O, IO<O2>> f) =>
      parEvalMapUnordered(Integer.MaxValue, f);

  Rill<O2> parEvalMapUnordered<O2>(int maxConcurrent, Function1<O, IO<O2>> f) =>
      map((o) => Rill.eval(f(o))).parJoin(maxConcurrent);

  Rill<O2> parEvalMapUnorderedUnbounded<O2>(Function1<O, IO<O2>> f) =>
      parEvalMapUnordered(Integer.MaxValue, f);

  /// Access the Pull API for this Rill.
  ToPull<O> get pull => ToPull(this);

  Rill<O> rechunkRandomly({double minFactor = 0.1, double maxFactor = 2.0, int? seed}) {
    if (minFactor <= 0 || maxFactor < minFactor) {
      throw ArgumentError('Invalid rechunk factors. Ensure 0 < minFactor <= maxFactor');
    }

    return Rill.suspend(() {
      final rng = Random(seed);

      Pull<O, Unit> loop(Rill<O> s) {
        return s.pull.uncons.flatMap((hdtl) {
          return hdtl.foldN(
            () => Pull.done,
            (hd, tl) {
              if (hd.isEmpty) {
                return loop(tl);
              } else {
                final factor = minFactor + (rng.nextDouble() * (maxFactor - minFactor));
                final nextSize = max(hd.size * factor, 1).round();

                if (hd.size == nextSize) {
                  return Pull.output(hd).append(() => loop(tl));
                } else if (hd.size > nextSize) {
                  final (toEmit, remainder) = hd.splitAt(nextSize);
                  return Pull.output(toEmit).append(() => loop(tl.cons(remainder)));
                } else {
                  final needed = nextSize - hd.size;

                  return tl.pull.unconsN(needed).flatMap((hdtl) {
                    return hdtl.foldN(
                      () => Pull.output(hd),
                      (nextHd, tl) {
                        return Pull.output(hd.concat(nextHd)).append(() => loop(tl));
                      },
                    );
                  });
                }
              }
            },
          );
        });
      }

      return loop(this).rill;
    });
  }

  Rill<O> pauseWhen(Rill<bool> signal) {
    return Rill.eval(Semaphore.permits(1)).flatMap((gate) {
      return Rill.eval(Ref.of(false)).flatMap((pausedState) {
        final signalProcessor =
            signal
                .evalMap((shouldPause) {
                  return pausedState.value().flatMap((isPaused) {
                    if (isPaused == shouldPause) {
                      return IO.unit;
                    } else {
                      return pausedState.setValue(shouldPause).flatMap((_) {
                        // If pausing: drain the permit
                        // If resuming: acquire the permit
                        return shouldPause ? gate.acquire() : gate.release();
                      });
                    }
                  });
                })
                .compile
                .drain;

        final gatedStream = chunks().flatMap((chunk) {
          final wait = gate.acquire().flatMap((_) => gate.release());
          return Rill.eval(wait).flatMap((_) => Rill.chunk(chunk));
        });

        return Rill.bracket(
          signalProcessor.start(),
          (fiber) => fiber.cancel(),
        ).flatMap((_) => gatedStream);
      });
    });
  }

  Rill<O> reduce(Function2<O, O, O> f) => fold1(f);

  Rill<O> repeat() => append(repeat);

  Rill<O> repeatN(int n) => n > 0 ? append(() => repeatN(n - 1)) : Rill.empty();

  Rill<O2> repeatPull<O2>(Function1<ToPull<O>, Pull<O2, Option<Rill<O>>>> f) {
    Pull<O2, Unit> go(ToPull<O> tp) {
      return f(tp).flatMap((tail) {
        return tail.fold(() => Pull.done, (tail) => go(tail.pull));
      });
    }

    return go(pull).rill;
  }

  Rill<O2> scan<O2>(O2 z, Function2<O2, O, O2> f) => Pull.output1(z).append(() => _scan(z, f)).rill;

  Rill<O> scan1(Function2<O, O, O> f) =>
      pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            final (pre, post) = hd.splitAt(1);
            return Pull.output(pre).append(() => tl.cons(post)._scan(pre[0], f));
          },
        );
      }).rill;

  Pull<O2, Unit> _scan<O2>(O2 z, Function2<O2, O, O2> f) => pull.uncons.flatMap((hdtl) {
    return hdtl.foldN(
      () => Pull.done,
      (hd, tl) {
        final (out, carry) = hd.scanLeftCarry(z, f);
        return Pull.output(out).append(() => tl._scan(carry, f));
      },
    );
  });

  Rill<O2> scanChunks<S, O2>(S initial, Function2<S, Chunk<O>, (S, Chunk<O2>)> f) =>
      scanChunksOpt(initial, (s) => Some((c) => f(s, c)));

  Rill<O2> scanChunksOpt<S, O2>(
    S initial,
    Function1<S, Option<Function1<Chunk<O>, (S, Chunk<O2>)>>> f,
  ) => pull.scanChunksOpt(initial, f).voided.rill;

  Rill<O> get scope => Pull.scope(underlying).rillNoScope;

  Rill<Chunk<O>> sliding(int size, {int step = 1}) {
    Pull<Chunk<O>, Unit> stepNotSmallerThanSize(Rill<O> s, Chunk<O> prev) {
      return s.pull.uncons.flatMap(
        (hdtl) => hdtl.foldN(
          () => prev.isEmpty ? Pull.done : Pull.output1(prev.take(size)),
          (hd, tl) {
            final bldr = <Chunk<O>>[];

            var current = prev.concat(hd);

            while (current.size >= step) {
              final (nHeads, nTails) = current.splitAt(step);
              bldr.add(nHeads.take(size));
              current = nTails;
            }

            return Pull.output(
              Chunk.fromList(bldr),
            ).append(() => stepNotSmallerThanSize(tl, current));
          },
        ),
      );
    }

    Pull<Chunk<O>, Unit> stepSmallerThanSize(Rill<O> s, Chunk<O> window, Chunk<O> prev) {
      return s.pull.uncons.flatMap(
        (hdtl) => hdtl.foldN(
          () => prev.isEmpty ? Pull.done : Pull.output1(window.concat(prev).take(size)),
          (hd, tl) {
            final bldr = <Chunk<O>>[];

            var w = window;
            var current = prev.concat(hd);

            while (current.size >= step) {
              final (head, tail) = current.splitAt(step);
              final wind = w.concat(head);

              bldr.add(wind);
              w = wind.drop(step);

              current = tail;
            }

            return Pull.output(
              Chunk.fromList(bldr),
            ).append(() => stepSmallerThanSize(tl, w, current));
          },
        ),
      );
    }

    if (step < size) {
      return pull
          .unconsN(size, allowFewer: true)
          .flatMap(
            (hdtl) => hdtl.foldN(
              () => Pull.done,
              (hd, tl) => Pull.output1(
                hd,
              ).append(() => stepSmallerThanSize(tl, hd.drop(step), Chunk.empty())),
            ),
          )
          .rill;
    } else {
      return stepNotSmallerThanSize(this, Chunk.empty()).rill;
    }
  }

  Rill<O> spaced(Duration delay, {bool startImmediately = true}) {
    // TODO: _Pure, and other Pull ADT nodes probably can't use Never type
    final start = startImmediately ? Rill.unit : Rill.unit.drop(1);
    return start.append(() => Rill.fixedDelay(delay)).zipRight(this);
  }

  Rill<Chunk<O>> split(Function1<O, bool> p) {
    Pull<Chunk<O>, Unit> go(Chunk<O> buffer, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => buffer.nonEmpty ? Pull.output1(buffer) : Pull.done,
          (hd, tl) {
            return hd.indexWhere(p).fold(
              () => go(buffer.concat(hd), tl),
              (idx) {
                final pfx = hd.take(idx);
                final b2 = buffer.concat(pfx);

                return Pull.output1(b2).append(() => go(Chunk.empty(), tl.cons(hd.drop(idx + 1))));
              },
            );
          },
        );
      });
    }

    return go(Chunk.empty(), this).rill;
  }

  Rill<O2> switchMap<O2>(Function1<O, Rill<O2>> f) {
    return Rill.eval(Queue.unbounded<Either<Object, Option<O2>>>()).flatMap((queue) {
      // track currently running fiber
      return Rill.eval(Ref.of<Option<IOFiber<Unit>>>(none())).flatMap((activeFiber) {
        IO<Unit> runInner(O element) {
          return f(element)
              .map((o2) => Right<Object, Option<O2>>(Some(o2)))
              .evalMap(queue.offer)
              .compile
              .drain
              .handleErrorWith((err) => queue.offer(Left(err)));
        }

        // outer consume / driver
        final driver = evalMap((element) {
              return activeFiber.value().flatMap((optFiber) {
                final cancelPrevious = optFiber.fold(() => IO.unit, (fiber) => fiber.cancel());

                return cancelPrevious.flatMap((_) {
                  return runInner(element).start().flatMap((newFiber) {
                    return activeFiber.setValue(Some(newFiber));
                  });
                });
              });
            }).compile.drain
            .flatMap((_) {
              // when outer finishes, wait for final inner to complete

              return activeFiber.value().flatMap((optFiber) {
                return optFiber.fold(
                  () => IO.unit,
                  (fiber) => fiber.join().voided(),
                );
              });
            })
            .handleErrorWith((err) => queue.offer(Left(err)))
            .guarantee(queue.offer(Right(none())));

        final cleanupInner = activeFiber.value().flatMap((optFiber) {
          return optFiber.fold(() => IO.unit, (fiber) => fiber.cancel());
        });

        Rill<O2> consumeSwitchMap() {
          return Rill.eval(queue.take()).flatMap((event) {
            return event.fold(
              (err) => Rill.raiseError(err),
              (opt) => opt.fold(
                () => Rill.empty(),
                (o2) => Rill.emit(o2).append(consumeSwitchMap),
              ),
            );
          });
        }

        return Rill.bracket(
          driver.start(),
          (driverFiber) => driverFiber.cancel().productL(() => cleanupInner),
        ).flatMap((_) => consumeSwitchMap());
      });
    });
  }

  Rill<O> get tail => drop(1);

  Rill<O> take(int n) => pull.take(n).voided.rill;

  Rill<O> takeRight(int n) => pull.takeRight(n).flatMap(Pull.output).rill;

  Rill<O> takeThrough(Function1<O, bool> p) => pull.takeThrough(p).voided.rill;

  Rill<O> takeWhile(Function1<O, bool> p, {bool takeFailure = false}) =>
      pull.takeWhile(p, takeFailure: takeFailure).voided.rill;

  Rill<O2> through<O2>(Pipe<O, O2> f) => f(this);

  Rill<O> timeout(Duration timeout) => interruptWhen(IO.sleep(timeout));

  Rill<(O, O2)> zip<O2>(Rill<O2> that) => zipWith(that, (o, o2) => (o, o2));

  Rill<O> zipLeft<O2>(Rill<O2> other) => zipWith(other, (a, _) => a);

  Rill<O2> zipRight<O2>(Rill<O2> other) => zipWith(other, (_, b) => b);

  Rill<O3> zipWith<O2, O3>(Rill<O2> that, Function2<O, O2, O3> f) {
    Pull<O3, Unit> loop(Rill<O> s1, Rill<O2> s2) {
      return s1.pull.uncons.flatMap((hdtl1) {
        return hdtl1.foldN(
          () => Pull.done,
          (hd1, tl1) {
            return s2.pull.uncons.flatMap((hdtl2) {
              return hdtl2.foldN(
                () => Pull.done,
                (hd2, tl2) {
                  final len = min(hd1.size, hd2.size);

                  final nextS1 = tl1.cons(hd1.drop(len));
                  final nextS2 = tl2.cons(hd2.drop(len));

                  return Pull.output(
                    hd1.zip(hd2).map((t) => f(t.$1, t.$2)),
                  ).flatMap((_) => loop(nextS1, nextS2));
                },
              );
            });
          },
        );
      });
    }

    return loop(this, that).rillNoScope;
  }

  Rill<(O, O2)> zipAll<O2>(Rill<O2> that, O padLeft, O2 padRight) =>
      zipAllWith(that, padLeft, padRight, (o, o2) => (o, o2));

  Rill<O3> zipAllWith<O2, O3>(Rill<O2> that, O padLeft, O2 padRight, Function2<O, O2, O3> f) {
    Pull<O3, Unit> loop(Rill<O> s1, Rill<O2> s2) {
      return s1.pull.uncons.flatMap((hdtl1) {
        return hdtl1.foldN(
          () => s2.map((o2) => f(padLeft, o2)).pull.echo,
          (hd1, tl1) {
            return s2.pull.uncons.flatMap((hdtl2) {
              return hdtl2.foldN(
                () {
                  final zippedChunk = hd1.map((o) => f(o, padRight));
                  return Pull.output(zippedChunk).flatMap((_) {
                    return tl1.map((o) => f(o, padRight)).pull.echo;
                  });
                },
                (hd2, tl2) {
                  final len = min(hd1.size, hd2.size);

                  final nextS1 = tl1.cons(hd1.drop(len));
                  final nextS2 = tl2.cons(hd2.drop(len));

                  return Pull.output(
                    hd1.zip(hd2).map((t) => f(t.$1, t.$2)),
                  ).flatMap((_) => loop(nextS1, nextS2));
                },
              );
            });
          },
        );
      });
    }

    return loop(this, that).rill;
  }

  Rill<(O, O2)> zipLatest<O2>(Rill<O2> that) => zipLatestWith(that, (o, o2) => (o, o2));

  Rill<O3> zipLatestWith<O2, O3>(Rill<O2> that, Function2<O, O2, O3> f) {
    return Rill.eval(Queue.unbounded<Either<Object, Option<O3>>>()).flatMap((queue) {
      return Rill.eval(Ref.of<Option<O>>(none())).flatMap((refLeft) {
        return Rill.eval(Ref.of<Option<O2>>(none())).flatMap((refRight) {
          IO<Unit> tryEmit() {
            return refLeft.value().flatMap((optL) {
              return refRight.value().flatMap((optR) {
                return optL.fold(
                  () => IO.unit,
                  (l) => optR.fold(
                    () => IO.unit,
                    (r) => queue.offer(Right(Some(f(l, r)))),
                  ),
                );
              });
            });
          }

          IO<Unit> runLeft() => evalMap(
            (o) => refLeft.setValue(Some(o)).productL(tryEmit),
          ).compile.drain.handleErrorWith((err) => queue.offer(Left(err)));

          IO<Unit> runRight() => that
              .evalMap((o2) => refRight.setValue(Some(o2)).productL(tryEmit))
              .compile
              .drain
              .handleErrorWith((err) => queue.offer(Left(err)));

          Rill<O3> consumeQueue() {
            return Rill.eval(queue.take()).flatMap((event) {
              return event.fold(
                (err) => Rill.raiseError(err),
                (opt) => opt.fold(
                  () => Rill.empty(),
                  (o3) => Rill.emit(o3).append(() => consumeQueue()),
                ),
              );
            });
          }

          final driver = IO.both(runLeft(), runRight()).guarantee(queue.offer(Right(none())));

          return Rill.bracket(
            driver.start(),
            (fiber) => fiber.cancel(),
          ).flatMap((_) => consumeQueue());
        });
      });
    });
  }

  Rill<(O, int)> zipWithIndex() => scanChunks(0, (index, c) {
    var idx = index;

    final out = c.map((o) {
      final r = (o, idx);
      idx += 1;
      return r;
    });

    return (idx, out);
  });

  Rill<(O, Option<O>)> zipWithNext() {
    Pull<(O, Option<O>), Unit> go(O last, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.output1((last, none())),
          (hd, tl) {
            final (newLast, out) = hd.mapAccumulate(last, (prev, next) {
              return (next, (prev, Option(next)));
            });

            return Pull.output(out).append(() => go(newLast, tl));
          },
        );
      });
    }

    return pull.uncons1.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done,
        (hd, tl) => go(hd, tl),
      );
    }).rill;
  }

  Rill<(Option<O>, O)> zipWithPrevious() =>
      mapAccumulate(none<O>(), (prev, next) => (Option(next), (prev, next))).map((x) => x.$2);

  Rill<(Option<O>, O, Option<O>)> zipWithPreviousAndNext() =>
      zipWithPrevious().zipWithNext().map((tuple) {
        final ((prev, curr), next) = tuple;

        return next.foldN(
          () => (prev, curr, const None()),
          (_, next) => (prev, curr, Some(next)),
        );
      });

  Rill<(O, O2)> zipWithScan<O2>(O2 z, Function2<O2, O, O2> f) => mapAccumulate(
    z,
    (s, o) => (f(s, o), (o, s)),
  ).map((t) => t.$2);

  Rill<(O, O2)> zipWithScan1<O2>(O2 z, Function2<O2, O, O2> f) => mapAccumulate(
    z,
    (s, o) {
      final s2 = f(s, o);
      return (s2, (o, s2));
    },
  ).map((t) => t.$2);

  RillCompile<O> get compile => RillCompile(underlying);

  Rill<O2> _mapNoScope<O2>(Function1<O, O2> f) => Pull.mapOutputNoScope(this, f).rillNoScope;
}

sealed class OverflowStrategy {
  const OverflowStrategy();

  factory OverflowStrategy.dropOldest(int bufferSize) => _DropOldest(bufferSize);
  factory OverflowStrategy.dropNewest(int bufferSize) => _DropNewest(bufferSize);
  factory OverflowStrategy.unbounded() => const _Unbounded();
}

class _DropOldest extends OverflowStrategy {
  final int bufferSize;

  const _DropOldest(this.bufferSize);
}

class _DropNewest extends OverflowStrategy {
  final int bufferSize;

  const _DropNewest(this.bufferSize);
}

class _Unbounded extends OverflowStrategy {
  const _Unbounded();
}
