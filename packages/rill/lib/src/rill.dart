import 'dart:async';
import 'dart:math' as math;

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart' hide Eval;
import 'package:ribs_effect/ribs_effect.dart';
// ignore: implementation_imports
import 'package:ribs_effect/src/resource.dart';
import 'package:ribs_rill/ribs_rill.dart';

part 'compiler.dart';
part 'pull.dart';
part 'to_pull.dart';

/// A function that transforms a [Rill<I>] into a [Rill<O>].
///
/// Pipes are plain functions and compose with [Rill.through]:
/// ```dart
/// Pipe<int, String> stringify = (s) => s.map((n) => n.toString());
/// source.through(stringify);
/// ```
typedef Pipe<I, O> = Function1<Rill<I>, Rill<O>>;

/// A lazy, effectful, chunked stream of values of type [O].
///
/// Every [Rill] is backed by a [Pull<O, Unit>]. Operations are lazy — nothing
/// executes until a compile terminal (e.g. [compile.drain]) is called.
/// Elements are delivered in [Chunk]s for efficiency; most operators are
/// chunk-transparent.
///
/// ## Creating a Rill
/// ```dart
/// Rill.emit(42)                  // single element
/// Rill.emits([1, 2, 3])          // multiple elements
/// Rill.eval(someIO)              // effectful single element
/// Rill.repeatEval(IO.now)        // infinite effectful stream
/// Channel.bounded<int>(16).map((ch) => ch.rill)  // from a Channel
/// ```
///
/// ## Running a Rill
/// ```dart
/// await rill.compile.drain.run();
/// await rill.compile.toIList.run();
/// ```
class Rill<O> {
  final Pull<O, Unit> underlying;

  factory Rill._scoped(Pull<O, Unit> pull) => Pull.scope(pull).rillNoScope;

  factory Rill._noScope(Pull<O, Unit> p) => Rill._(p);

  Rill._(this.underlying);

  /// Emits the elapsed time since stream subscription at a fixed [period].
  ///
  /// When [dampen] is `true` (default), missed ticks due to slow consumers are
  /// coalesced into a single emission; set to `false` to emit all missed ticks.
  static Rill<Duration> awakeEvery(Duration period, {bool dampen = true}) {
    return Rill.eval(IO.now).flatMap((start) {
      return _fixedRate(
        period,
        start,
        dampen,
      ).flatMap((_) => Rill.eval(IO.now.map((now) => now.difference(start))));
    });
  }

  /// Emits the acquired resource [R] and releases it via [release] when the
  /// stream's scope closes.
  static Rill<R> bracket<R>(IO<R> acquire, Function1<R, IO<Unit>> release) =>
      bracketFull((_) => acquire, (r, _) => release(r));

  /// Like [bracket] but [release] receives the [ExitCase] (succeeded, errored,
  /// or canceled) so it can react accordingly.
  static Rill<R> bracketCase<R>(IO<R> acquire, Function2<R, ExitCase, IO<Unit>> release) =>
      bracketFull((_) => acquire, release);

  /// Fully general resource bracket: [acquire] is cancelable (via [Poll]) and
  /// [release] receives the [ExitCase].
  static Rill<R> bracketFull<R>(
    Function1<Poll, IO<R>> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => Pull.acquireCancelable(acquire, release).flatMap(Pull.output1).rillNoScope;

  /// Emits a single pre-built [Chunk].
  static Rill<O> chunk<O>(Chunk<O> values) => Pull.output(values).rillNoScope;

  /// Infinite stream that repeats [o] forever, emitting [chunkSize] copies per chunk.
  static Rill<O> constant<O>(O o, {int chunkSize = 256}) =>
      chunkSize > 0 ? chunk(Chunk.fill(chunkSize, o)).repeat() : Rill.empty();

  /// Emits the elapsed time since subscription, polling on every element.
  static Rill<Duration> duration() =>
      Rill.eval(IO.now).flatMap((t0) => Rill.repeatEval(IO.now.map((now) => now.difference(t0))));

  /// Emits a single [value] and terminates.
  static Rill<O> emit<O>(O value) => Pull.output1(value).rillNoScope;

  /// Emits all elements of [values] in order and terminates.
  static Rill<O> emits<O>(List<O> values) => Rill.chunk(Chunk.fromList(values));

  /// Evaluates [io] once and emits its result.
  static Rill<O> eval<O>(IO<O> io) => Pull.eval(io).flatMap(Pull.output1).rillNoScope;

  /// Evaluates [io] for its side effect and emits no elements.
  static Rill<O> exec<O>(IO<Unit> io) => Rill._noScope(Pull.eval(io).flatMap((_) => Pull.done));

  /// An empty stream that terminates immediately without emitting any elements.
  static Rill<O> empty<O>() => Rill._noScope(Pull.done);

  /// Emits [Unit] repeatedly, waiting [period] after each emission.
  ///
  /// Unlike [fixedRate], the interval is measured from the end of the previous
  /// emission, so each tick fires at least [period] after the last.
  static Rill<Unit> fixedDelay(Duration period) => sleep(period).repeat();

  /// Emits [Unit] at a fixed rate, attempting to maintain the cadence even if
  /// a consumer is slow. When [dampen] is `true`, missed ticks are collapsed.
  static Rill<Unit> fixedRate(Duration period, {bool dampen = true}) =>
      Rill.eval(IO.now).flatMap((t) => _fixedRate(period, t, dampen));

  /// Like [fixedRate] but emits immediately on subscription before waiting for
  /// the first interval.
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

  /// Evaluates [io] to obtain a [Rill] and then runs it.
  static Rill<O> force<O>(IO<Rill<O>> io) => Rill.eval(io).flatMap(identity);

  /// Emits the right value of [either], or raises the left value as an error.
  static Rill<O> fromEither<E extends Object, O>(Either<E, O> either) =>
      either.fold((err) => Rill.raiseError(err), (o) => Rill.emit(o));

  /// Drains a Dart [Iterator] into a stream, batching elements into chunks of
  /// [chunkSize].
  static Rill<O> fromIterator<O>(Iterator<O> it, {int chunkSize = 64}) =>
      fromRIterator(RIterator.fromDart(it), chunkSize: chunkSize);

  /// Emits the value inside [option], or produces an empty stream for [none].
  static Rill<O> fromOption<E extends Object, O>(Option<O> option) =>
      option.fold(() => Rill.empty(), (o) => Rill.emit(o));

  /// Consumes [queue] indefinitely, emitting each dequeued value.
  ///
  /// The stream never terminates on its own; cancel it externally. The optional
  /// [limit] caps the maximum number of elements batched per chunk.
  static Rill<O> fromQueueUnterminated<O>(
    Queue<O> queue, {
    int? limit,
  }) {
    final lim = limit ?? Integer.maxValue;

    if (lim > 1) {
      // First, try non-blocking batch dequeue.
      // Only if the result is an empty list, semantically block to get one element,
      // then attempt 2nd tryTakeN to get any other elements that are immediately available.

      final osf = queue
          .tryTakeN(Some(lim))
          .flatMap((os) {
            if (os.isEmpty) {
              return (
                queue.take(),
                queue.tryTakeN(Some(lim - 1)),
              ).mapN((elem, elems) => elems.prepended(elem));
            } else {
              return IO.pure(os);
            }
          })
          .map((l) => Chunk.from(l));

      return Rill.eval(osf).flatMap(Rill.chunk).repeat();
    } else {
      return Rill.repeatEval(queue.take());
    }
  }

  /// Like [fromQueueUnterminated] but reads pre-chunked values from [queue].
  static Rill<O> fromQueueUnterminatedChunk<O>(
    Queue<Chunk<O>> queue, {
    int? limit,
  }) => _fromQueueNoneUnterminatedChunk(
    queue.take().map((chunk) => Some(chunk)),
    queue.tryTake().map((chunkOpt) => chunkOpt.map((chunk) => Some(chunk))),
    limit: limit,
  );

  /// Consumes [queue] until a [none] sentinel is dequeued, then terminates.
  static Rill<O> fromQueueNoneUnterminated<O>(
    Queue<Option<O>> queue, {
    int? limit,
  }) => _awaitNoneTerminated(queue, limit ?? Integer.maxValue);

  /// Like [fromQueueNoneUnterminated] but reads pre-chunked values.
  static Rill<O> fromQueueNoneUnterminatedChunk<O>(
    Queue<Option<Chunk<O>>> queue, {
    int? limit,
  }) => _fromQueueNoneUnterminatedChunk(queue.take(), queue.tryTake(), limit: limit);

  static Rill<O> _fromQueueNoneUnterminatedChunk<O>(
    IO<Option<Chunk<O>>> take,
    IO<Option<Option<Chunk<O>>>> tryTake, {
    int? limit,
  }) => _awaitNoneTerminatedChunk(take, tryTake, limit ?? Integer.maxValue);

  static Rill<O> _awaitNoneTerminated<O>(Queue<Option<O>> queue, int limit) {
    return Rill.eval(queue.take()).flatMap((opt) {
      return opt.fold(
        () => Rill.empty(),
        (elem) => _pumpNoneTerminated(queue, 1, <O>[elem], limit),
      );
    });
  }

  static Rill<O> _pumpNoneTerminated<O>(
    Queue<Option<O>> queue,
    int currSize,
    List<O> acc,
    int limit,
  ) {
    if (currSize == limit) {
      return Rill.emits(acc);
    } else {
      return Rill.eval(queue.tryTake()).flatMap((opt) {
        return opt.fold(
          () => Rill.emits(acc).append(() => _awaitNoneTerminated(queue, limit)),
          (elemOpt) => elemOpt.fold(
            () => Rill.emits(acc),
            (elem) => _pumpNoneTerminated(queue, currSize + 1, acc..add(elem), limit),
          ),
        );
      });
    }
  }

  static Rill<O> _awaitNoneTerminatedChunk<O>(
    IO<Option<Chunk<O>>> take,
    IO<Option<Option<Chunk<O>>>> tryTake,
    int limit,
  ) {
    return Rill.eval(take).flatMap((opt) {
      return opt.fold(
        () => Rill.empty(),
        (elem) => _pumpNoneTerminatedChunk(take, tryTake, elem, limit),
      );
    });
  }

  static Rill<O> _pumpNoneTerminatedChunk<O>(
    IO<Option<Chunk<O>>> take,
    IO<Option<Option<Chunk<O>>>> tryTake,
    Chunk<O> acc,
    int limit,
  ) {
    final sz = acc.size;

    if (sz > limit) {
      final (pfx, sfx) = acc.splitAt(limit);
      return Rill.chunk(pfx).append(() => _pumpNoneTerminatedChunk(take, tryTake, sfx, limit));
    } else {
      return Rill.eval(tryTake).flatMap((opt) {
        return opt.fold(
          () => Rill.chunk(acc).append(() => _awaitNoneTerminatedChunk(take, tryTake, limit)),
          (elemOpt) => elemOpt.fold(
            () => Rill.chunk(acc),
            (elem) => _pumpNoneTerminatedChunk(take, tryTake, acc.concat(elem), limit),
          ),
        );
      });
    }
  }

  /// Drains an [RIterator] into a stream, batching elements into chunks of
  /// [chunkSize].
  static Rill<O> fromRIterator<O>(RIterator<O> it, {int chunkSize = 64}) {
    assert(chunkSize > 0, 'Rill.fromRIterator: chunkSize must be positive');
    IO<Option<(Chunk<O>, RIterator<O>)>> getNextChunk(RIterator<O> i) {
      return IO.delay(() {
        final bldr = <O>[];
        int cnt = 0;

        while (cnt < chunkSize && i.hasNext) {
          bldr.add(i.next());
          cnt += 1;
        }

        return cnt == 0 ? const None() : Some((Chunk.fromList(bldr), i));
      });
    }

    return Rill.unfoldChunkEval(it, getNextChunk);
  }

  /// Bridges a Dart [Stream] into a [Rill].
  ///
  /// Events are buffered according to [strategy] (default: drop oldest, buffer
  /// size 100). The subscription is cancelled when the [Rill]'s scope closes.
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

  /// Infinite stream starting at [start] and applying [f] to produce each
  /// subsequent element, emitting [chunkSize] elements per chunk.
  static Rill<O> iterate<O>(
    O start,
    Function1<O, O> f, {
    int chunkSize = 64,
  }) {
    if (chunkSize <= 0) throw ArgumentError('Rill.iterate: chunkSize must be positive.');

    Pull<O, Unit> loop(O current) {
      final elements = <O>[];
      O nextVal = current;

      for (var i = 0; i < chunkSize; i++) {
        elements.add(nextVal);
        nextVal = f(nextVal);
      }

      return Pull.output(Chunk.fromList(elements)).append(() => loop(nextVal));
    }

    return loop(start).rillNoScope;
  }

  /// Like [iterate] but [f] returns an [IO] evaluated for each step.
  static Rill<O> iterateEval<O>(O start, Function1<O, IO<O>> f) =>
      Rill.emit(start).append(() => Rill.eval(f(start)).flatMap((o) => iterateEval(o, f)));

  /// A stream that never emits and never terminates.
  static final Rill<Never> never = Rill.eval(IO.never());

  /// Emits a single [value] without introducing a new scope. Alias for [emit].
  static Rill<O> pure<O>(O value) => Rill._noScope(Pull.output1(value));

  /// A stream that immediately fails with [error].
  static Rill<O> raiseError<O>(Object error, [StackTrace? stackTrace]) =>
      Pull.raiseError(error, stackTrace).rillNoScope;

  /// Emits integers from [start] (inclusive) to [stopExclusive] (exclusive)
  /// with a configurable [step] (may be negative) and [chunkSize].
  static Rill<int> range(
    int start,
    int stopExclusive, {
    int step = 1,
    int chunkSize = 64,
  }) {
    assert(chunkSize > 0, 'chunkSize must be positive');
    if (step == 0) {
      return Rill.empty();
    } else {
      Pull<int, Unit> loop(int current) {
        // Termination check (direction is constant across iterations)
        if (step > 0 && current >= stopExclusive) {
          return Pull.done;
        } else if (step < 0 && current <= stopExclusive) {
          return Pull.done;
        } else {
          // Compute exact count for this chunk
          final available =
              step > 0
                  ? (stopExclusive - current + step - 1) ~/ step
                  : (current - stopExclusive + (-step) - 1) ~/ (-step);

          final count = available < chunkSize ? available : chunkSize;

          return Pull.output(
            Chunk.tabulate(count, (j) => current + j * step),
          ).append(() => loop(current + count * step));
        }
      }

      return loop(start).rillNoScope;
    }
  }

  /// Evaluates [fo] repeatedly and emits each result, running forever.
  static Rill<O> repeatEval<O>(IO<O> fo) => Rill.eval(fo).repeat();

  /// Runs a [Resource] as a single-element stream.
  ///
  /// The resource is acquired when the stream starts and released when the
  /// stream's scope closes.
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

  /// Retries [fo] up to [maxAttempts] times with exponentially-growing delays.
  ///
  /// [nextDelay] maps the current delay to the next one. An optional [retriable]
  /// predicate determines which errors should trigger a retry (defaults to all).
  /// Raises the last error if all attempts are exhausted.
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

  /// Emits [Unit] after [duration] has elapsed.
  static Rill<Unit> sleep(Duration duration) => Rill.eval(IO.sleep(duration));

  /// Waits [duration] and emits no elements (useful for delaying concatenated streams).
  static Rill<O> sleep_<O>(Duration duration) => Rill.exec(IO.sleep(duration));

  /// Starts [fo] as a background fiber and emits the resulting [IOFiber].
  ///
  /// The fiber is cancelled when the stream's scope closes.
  static Rill<IOFiber<O>> supervise<O>(IO<O> fo) =>
      Rill.bracket(fo.start(), (fiber) => fiber.cancel());

  /// Defers construction of the stream until it is first run.
  static Rill<O> suspend<O>(Function0<Rill<O>> f) => Pull.suspend(() => f().underlying).rillNoScope;

  /// Generates a stream by repeatedly applying [f] to a state [s].
  ///
  /// [f] returns [Some((element, nextState))] to continue or [none] to end the
  /// stream. Elements are batched into chunks of [chunkSize].
  static Rill<O> unfold<S, O>(
    S s,
    Function1<S, Option<(O, S)>> f, {
    int chunkSize = 64,
  }) {
    if (chunkSize <= 0) throw ArgumentError('Rill.unfold: chunkSize must be positive.');

    Pull<O, Unit> loop(S currentState) {
      final elements = <O>[];
      S nextState = currentState;
      bool isDone = false;

      for (int i = 0; i < chunkSize; i++) {
        final result = f(nextState);

        result.foldN(
          () => isDone = true,
          (elem, newState) {
            elements.add(elem);
            nextState = newState;
          },
        );

        if (isDone) break;
      }

      if (elements.isEmpty) {
        return Pull.done;
      } else if (isDone) {
        return Pull.output(Chunk.fromList(elements));
      } else {
        return Pull.output(Chunk.fromList(elements)).append(() => loop(nextState));
      }
    }

    return loop(s).rillNoScope;
  }

  /// Like [unfold] but [f] returns a whole [Chunk] per step rather than a
  /// single element.
  static Rill<O> unfoldChunk<S, O>(
    S s,
    Function1<S, Option<(Chunk<O>, S)>> f, {
    int chunkSize = 64,
  }) => unfold(s, f, chunkSize: chunkSize).flatMap(Rill.chunk);

  /// Like [unfold] but each step evaluates an [IO] for the next state and element.
  static Rill<O> unfoldEval<S, O>(S s, Function1<S, IO<Option<(O, S)>>> f) {
    Pull<O, Unit> loop(S currentState) {
      return Pull.eval(f(currentState)).flatMap((opt) {
        return opt.foldN(
          () => Pull.done,
          (elem, nextState) => Pull.output1(elem).append(() => loop(nextState)),
        );
      });
    }

    return loop(s).rillNoScope;
  }

  /// Like [unfoldEval] but each step produces a [Chunk].
  static Rill<O> unfoldChunkEval<S, O>(S s, Function1<S, IO<Option<(Chunk<O>, S)>>> f) {
    Pull<O, Unit> loop(S currentState) {
      return Pull.eval(f(currentState)).flatMap((opt) {
        return opt.foldN(
          () => Pull.done,
          (elems, nextState) => Pull.output(elems).append(() => loop(nextState)),
        );
      });
    }

    return loop(s).rillNoScope;
  }

  /// A pre-allocated single-element stream emitting [Unit].
  static final Rill<Unit> unit = Pull.outUnit.rillNoScope;

  /// Concatenates this stream with [other]. Alias for [append].
  Rill<O> operator +(Rill<O> other) => underlying.flatMap((_) => other.underlying).rillNoScope;

  /// Appends a [sleep_] of [duration] after this stream ends, then terminates.
  Rill<O> andWait(Duration duration) => append(() => Rill.sleep_<O>(duration));

  /// Runs this stream to completion, then runs [s2].
  Rill<O> append(Function0<Rill<O>> s2) => underlying.append(() => s2().underlying).rillNoScope;

  /// Replaces every element with [o2].
  Rill<O2> as<O2>(O2 o2) => map((_) => o2);

  /// Wraps each element in [Right] and errors in [Left], so errors become
  /// values and the stream never fails.
  Rill<Either<Object, O>> attempt() =>
      map((o) => o.asRight<Object>()).handleErrorWith((err) => Rill.emit(Left<Object, O>(err)));

  /// Like [attempt] but retries on failure using the delays from [delays].
  Rill<Either<Object, O>> attempts(Rill<Duration> delays) => attempt().append(
    () => delays.flatMap((delay) => Rill.sleep(delay).flatMap((_) => attempt())),
  );

  /// Fans this stream out to all [pipes] simultaneously and merges their outputs.
  ///
  /// Each pipe receives every element. The stream is buffered through a [Topic]
  /// so all subscribers start at the same element.
  Rill<O2> broadcastThrough<O2>(IList<Pipe<O, O2>> pipes) {
    final rillF = (
      Topic.create<Chunk<O>>(),
      CountDownLatch.create(pipes.size),
    ).mapN((topic, allReady) {
      final checkIn = allReady.release().productR(allReady.await());

      Rill<O2> dump(Pipe<O, O2> pipe) {
        return Rill.resource(topic.subscribeAwait(1)).flatMap((sub) {
          return Rill.exec<O2>(checkIn).append(() => pipe(sub.unchunks));
        });
      }

      final dumpAll = Rill.emits(pipes.toList()).map(dump).parJoinUnbounded();

      final pump = Rill.exec<Never>(allReady.await()).append(() => topic.publish(chunks()));

      return dumpAll.concurrently(pump);
    });

    return Rill.force(rillF);
  }

  /// Re-chunks the stream so each chunk has at most [n] elements.
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

  /// Emits only elements that differ from the previous element (using `==`
  /// by default, or a custom [eq]).
  Rill<O> changes({Function2<O, O, bool>? eq}) => filterWithPrevious(eq ?? (a, b) => a != b);

  /// Like [changes] but compares by a key extracted with [f].
  Rill<O> changesBy<O2>(Function1<O, O2> f) => filterWithPrevious((a, b) => f(a) != f(b));

  /// Like [changes] but uses a custom two-argument predicate [f] to decide
  /// whether consecutive elements differ.
  Rill<O> changesWith(Function2<O, O, bool> f) => filterWithPrevious((a, b) => f(a, b));

  /// Collects the entire stream into a single emitted [Chunk].
  Rill<Chunk<O>> chunkAll() {
    Pull<Chunk<O>, Unit> loop(Rill<O> s, Chunk<O> acc) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.output1(acc),
          (hd, tl) => loop(tl, acc.concat(hd)),
        );
      });
    }

    return loop(this, Chunk.empty()).rillNoScope;
  }

  /// Re-emits this stream as a stream of its underlying [Chunk]s.
  Rill<Chunk<O>> chunks() => underlying.unconsFlatMap(Pull.output1).rillNoScope;

  /// Splits any chunk larger than [n] elements into chunks of at most [n].
  Rill<Chunk<O>> chunkLimit(int n) {
    Pull<Chunk<O>, Unit> breakup(Chunk<O> ch) {
      if (ch.size <= n) {
        return Pull.output1(ch);
      } else {
        final (pre, rest) = ch.splitAt(n);
        return Pull.output1(pre).append(() => breakup(rest));
      }
    }

    return underlying.unconsFlatMap(breakup).rillNoScope;
  }

  /// Merges consecutive chunks until the accumulated size is at least [n].
  ///
  /// If the stream ends before [n] elements are available and
  /// [allowFewerTotal] is `true`, the partial chunk is emitted.
  Rill<Chunk<O>> chunkMin(int n, {bool allowFewerTotal = true}) => repeatPull((p) {
    return p.unconsMin(n, allowFewerTotal: allowFewerTotal).flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(none()),
        (hd, tl) => Pull.output1(hd).as(Some(tl)),
      );
    });
  });

  /// Groups elements into chunks of exactly [n] elements.
  ///
  /// If [allowFewer] is `true` (default), the last chunk may be smaller when
  /// the stream ends.
  Rill<Chunk<O>> chunkN(int n, {bool allowFewer = true}) {
    assert(n > 0, 'n must be positive');
    return repeatPull((tp) {
      return tp.unconsN(n, allowFewer: allowFewer).flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.pure(none()),
          (hd, tl) => Pull.output1(hd).as(Some(tl)),
        );
      });
    });
  }

  /// Runs [that] concurrently as a background stream.
  ///
  /// Elements of [that] are discarded; it is run only for its side effects.
  /// When this foreground stream ends, [that] is cancelled. If [that] fails,
  /// the foreground stream is interrupted with the error.
  Rill<O> concurrently<O2>(Rill<O2> that) {
    return _concurrentlyAux(that).flatMapN((startBack, fore) => startBack.flatMap((_) => fore));
  }

  Rill<(Rill<IOFiber<Unit>>, Rill<O>)> _concurrentlyAux<O2>(Rill<O2> that) {
    final frill = Deferred.of<Unit>().flatMap((interrupt) {
      return Deferred.of<Either<Object, Unit>>().map((backResult) {
        Rill<A> watch<A>(Rill<A> rill) => rill.interruptWhen(interrupt.value().attempt());

        final compileBack =
            watch(that).compile.drain.guaranteeCase((outcome) {
              return outcome.fold(
                () => backResult.complete(Unit().asRight()).voided(),
                // Pass the result of backstream completion in the backResult deferred.
                // IF result of back-stream was failed, interrupt fore. Otherwise, let it be
                (error, _) => backResult
                    .complete(error.asLeft())
                    .productR(interrupt.complete(Unit()).voided()),
                (_) => backResult.complete(Unit().asRight()).voided(),
              );
            }).voidError();

        // stop background process but await for it to finalise with a result
        // We use F.fromEither to bring errors from the back into the fore
        // val stopBack: F2[Unit] = interrupt.complete(()) >> backResult.get.flatMap(F.fromEither)
        final stopBack = interrupt
            .complete(Unit())
            .productR(backResult.value().flatMap(IO.fromEither));

        return (Rill.bracket(compileBack.start(), (_) => stopBack), watch(this));
      });
    });

    return Rill.eval(frill);
  }

  /// Prepends [c] to this stream.
  Rill<O> cons(Chunk<O> c) => c.isEmpty ? this : Rill.chunk(c).append(() => this);

  /// Prepends a single element [o] to this stream.
  Rill<O> cons1(O o) => Rill.emit(o).append(() => this);

  /// Applies [f] to each element, emitting only the [Some] results.
  Rill<O2> collect<O2>(Function1<O, Option<O2>> f) => mapChunks((c) => c.collect(f));

  /// Emits only the first [Some] result of [f].
  Rill<O2> collectFirst<O2>(Function1<O, Option<O2>> f) => collect(f).take(1);

  /// Emits [Some] results of [f] until [f] returns [none], then terminates.
  Rill<O2> collectWhile<O2>(Function1<O, Option<O2>> f) =>
      map(f).takeWhile((b) => b.isDefined).unNone;

  /// Emits only the latest element after the stream has been quiet for [d].
  ///
  /// Intermediate elements that arrive within [d] of each other are dropped.
  Rill<O> debounce(Duration d) {
    final rillF = Channel.bounded<O>(1).flatMap((chan) {
      return IO.ref(none<O>()).map((ref) {
        final sendLatest = ref.getAndSet(const None()).flatMap((opt) => opt.traverseIO_(chan.send));

        IO<Unit> sendItem(O o) => ref.getAndSet(Some(o)).flatMap((prev) {
          if (prev.isEmpty) {
            return IO.sleep(d).productR(sendLatest).start().voided();
          } else {
            return IO.unit;
          }
        });

        Pull<Never, Unit> go(Pull<O, Unit> pull) {
          return pull.uncons.flatMap((hdtl) {
            return hdtl.foldN(
              () => Pull.eval(sendLatest.productR(chan.close()).voided()),
              (hd, tl) => Pull.eval(sendItem(hd.last)).append(() => go(tl)),
            );
          });
        }

        final debouncedSend = go(underlying).rillNoScope;

        return chan.rill.concurrently(debouncedSend);
      });
    });

    return Rill.force(rillF);
  }

  /// Delays the start of this stream by [duration].
  Rill<O> delayBy(Duration duration) => Rill.sleep_<O>(duration).append(() => this);

  /// Removes the first element for which [p] returns `true`.
  Rill<O> delete(Function1<O, bool> p) =>
      pull
          .takeWhile((o) => !p(o))
          .flatMap((r) => r.fold(() => Pull.done, (s) => s.drop(1).pull.echo))
          .rillNoScope;

  /// WARN: For long streams and/or large elements, this can be a memory hog.
  ///   Use with caution;
  Rill<O> get distinct {
    return scanChunksOpt(ISet.empty<O>(), (seen) {
      return Some((chunk) {
        return (seen.concat(chunk), chunk);
      });
    });
  }

  /// Consumes all elements for their side effects and emits nothing.
  Rill<Never> drain() => underlying.unconsFlatMap((_) => Pull.done).rillNoScope;

  /// Skips the first [n] elements and emits the rest.
  Rill<O> drop(int n) =>
      pull
          .drop(n)
          .flatMap((opt) => opt.fold(() => Pull.done, (rest) => rest.pull.echo))
          .rillNoScope;

  /// Removes the last element from the stream.
  Rill<O> get dropLast => dropLastIf((_) => true);

  /// Removes the last element if [p] returns `true` for it; otherwise
  /// the stream is unchanged.
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
    }).rillNoScope;
  }

  /// Removes the last [n] elements from the stream, buffering as needed.
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

      return go(Chunk.empty(), this).rillNoScope;
    }
  }

  /// Drops elements while [p] is true and also drops the first element for
  /// which [p] is false.
  Rill<O> dropThrough(Function1<O, bool> p) =>
      pull
          .dropThrough(p)
          .flatMap((tl) => tl.map((tl) => tl.pull.echo).getOrElse(() => Pull.done))
          .rillNoScope;

  /// Drops elements while [p] is true, then emits the rest.
  Rill<O> dropWhile(Function1<O, bool> p) =>
      pull
          .dropWhile(p)
          .flatMap((tl) => tl.map((tl) => tl.pull.echo).getOrElse(() => Pull.done))
          .rillNoScope;

  /// Merges this stream and [that] concurrently, wrapping elements in [Left]
  /// and [Right] respectively.
  Rill<Either<O, O2>> either<O2>(Rill<O2> that) =>
      map((o) => o.asLeft<O2>()).merge(that.map((o2) => o2.asRight<O>()));

  /// Keeps only elements for which the effectful predicate [p] returns `true`.
  Rill<O> evalFilter(Function1<O, IO<bool>> p) =>
      underlying
          .flatMapOutput(
            (o) => Pull.eval(p(o)).flatMap((pass) => pass ? Pull.output1(o) : Pull.done),
          )
          .rillNoScope;

  /// Removes elements for which the effectful predicate [p] returns `true`.
  Rill<O> evalFilterNot(Function1<O, IO<bool>> p) =>
      flatMap((o) => Rill.eval(p(o)).ifM(() => Rill.empty(), () => Rill.emit(o)));

  /// Effectful fold: runs [f] for each element and emits the final accumulator.
  Rill<O2> evalFold<O2>(O2 z, Function2<O2, O, IO<O2>> f) {
    Pull<O2, Unit> go(O2 z, Rill<O> r) {
      return r.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.output1(z),
          (hd, tl) => Pull.eval(f(z, hd)).flatMap((ns) => go(ns, tl)),
        );
      });
    }

    return go(z, this).rillNoScope;
  }

  /// Transforms each element by evaluating the effectful function [f].
  Rill<O2> evalMap<O2>(Function1<O, IO<O2>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o)).flatMap(Pull.output1)).rillNoScope;

  /// Effectful filter-map: evaluates [f] and emits [Some] results, dropping [none].
  Rill<O> evalMapFilter(Function1<O, IO<Option<O>>> f) =>
      underlying
          .flatMapOutput((o) => Pull.eval(f(o)).flatMap((opt) => Pull.outputOption1(opt)))
          .rillNoScope;

  /// Like [scan] but the accumulation function [f] returns an [IO].
  Rill<O2> evalScan<O2>(O2 z, Function2<O2, O, IO<O2>> f) {
    Pull<O2, Unit> go(O2 z, Rill<O> s) {
      return s.pull.uncons1.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) => Pull.eval(f(z, hd)).flatMap((o) => Pull.output1(o).append(() => go(o, tl))),
        );
      });
    }

    return Pull.output1(z).append(() => go(z, this)).rillNoScope;
  }

  /// Evaluates [f] for its side effect on each element, re-emitting the
  /// original element unchanged.
  Rill<O> evalTap<O2>(Function1<O, IO<O2>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o)).flatMap((_) => Pull.output1(o))).rillNoScope;

  /// Emits `true` if any element satisfies [p], otherwise emits `false`.
  Rill<bool> exists(Function1<O, bool> p) =>
      pull.forall((o) => !p(o)).flatMap((r) => Pull.output1(!r)).rillNoScope;

  /// Emits only elements for which [p] returns `true`.
  Rill<O> filter(Function1<O, bool> p) => mapChunks((c) => c.filter(p));

  /// Emits only elements for which [p] returns `false`.
  Rill<O> filterNot(Function1<O, bool> p) => mapChunks((c) => c.filterNot(p));

  /// Emits an element only if [p] returns `true` for the previous and current
  /// element. The very first element is always emitted.
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
    }).rillNoScope;
  }

  /// Maps each element to a stream via [f] and concatenates the results.
  Rill<O2> flatMap<O2>(Function1<O, Rill<O2>> f) =>
      underlying.flatMapOutput((o) => f(o).underlying).rillNoScope;

  /// Folds the stream into a single value, emitting it when the stream ends.
  Rill<O2> fold<O2>(O2 z, Function2<O2, O, O2> f) =>
      pull.fold(z, f).flatMap(Pull.output1).rillNoScope;

  /// Like [fold] but uses the first element as the initial accumulator.
  Rill<O> fold1(Function2<O, O, O> f) =>
      pull.fold1(f).flatMap((opt) => opt.map(Pull.output1).getOrElse(() => Pull.done)).rillNoScope;

  /// Emits `true` if all elements satisfy [p], otherwise emits `false`.
  Rill<bool> forall(Function1<O, bool> p) =>
      pull.forall(p).flatMap((res) => Pull.output1(res)).rillNoScope;

  /// Evaluates [f] for each element as a side effect and emits nothing.
  Rill<Never> foreach(Function1<O, IO<Unit>> f) =>
      underlying.flatMapOutput((o) => Pull.eval(f(o))).rillNoScope;

  /// Groups consecutive elements that share the same key (returned by [f])
  /// into `(key, chunk)` pairs, emitting one pair per run of equal keys.
  Rill<(O2, Chunk<O>)> groupAdjacentBy<O2>(Function1<O, O2> f) =>
      groupAdjacentByLimit(Integer.maxValue, f);

  /// Like [groupAdjacentBy] but caps each group at [limit] elements.
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

    return go(none(), this).rillNoScope;
  }

  /// Accumulates elements into chunks, emitting whenever [chunkSize] is reached
  /// or [timeout] has elapsed since the first buffered element — whichever
  /// comes first.
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

  /// Recovers from any error by switching to the stream returned by [f].
  Rill<O> handleErrorWith(Function1<Object, Rill<O>> f) =>
      underlying.handleErrorWith((err) => f(err).underlying).rillNoScope;

  /// Emits at most the first element, then terminates.
  Rill<O> get head => take(1);

  /// Creates a [Signal] that holds the latest element emitted by this stream.
  ///
  /// The signal starts with [initial] and is updated in the background. The
  /// [Resource] ensures the background fiber is cancelled on release.
  Resource<Signal<O>> holdResource(O initial) => Resource.eval(
    SignallingRef.of(initial),
  ).flatTap((sig) => foreach((n) => sig.setValue(n)).compile.drain.background());

  /// Runs [fallback] if this stream emits no elements.
  Rill<O> ifEmpty(Function0<Rill<O>> fallback) =>
      pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => fallback().underlying,
          (hd, tl) => Pull.output(hd).append(() => tl.underlying),
        );
      }).rillNoScope;

  /// Emits the value produced by [o] if this stream is empty.
  Rill<O> ifEmptyEmit(Function0<O> o) => ifEmpty(() => Rill.emit(o()));

  /// Alternates elements from this stream and [that], stopping when either ends.
  Rill<O> interleave(Rill<O> that) => zip(that).flatMap((t) => Rill.emits([t.$1, t.$2]));

  /// Like [interleave] but continues with the longer stream after the shorter ends,
  /// treating missing elements as absent.
  Rill<O> interleaveAll(Rill<O> that) => map(
    (o) => Option(o),
  ).zipAll<Option<O>>(that.map((o) => Option(o)), none(), none()).flatMap((t) {
    final (thisOpt, thatOpt) = t;
    return Rill.chunk(Chunk.from(thisOpt)).append(() => Rill.chunk(Chunk.from(thatOpt)));
  });

  /// Inserts [separator] between every pair of adjacent elements.
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
    }).rillNoScope;
  }

  /// Cancels the stream after [duration] has elapsed. Alias for
  /// `interruptWhen(IO.sleep(duration))`.
  Rill<O> interruptAfter(Duration duration) => interruptWhen(IO.sleep(duration));

  /// Cancels this stream when [signal] completes (regardless of its result).
  Rill<O> interruptWhen<B>(IO<B> signal) {
    return Rill.eval(IO.deferred<Unit>()).flatMap((stopEvent) {
      final startSignalFiber = signal.attempt().flatMap((_) => stopEvent.complete(Unit())).start();

      return Rill.eval(startSignalFiber).flatMap((fiber) {
        final haltWhen = stopEvent.value().as(Unit().asRight<Object>());
        return Pull.interruptWhen(underlying, haltWhen).rillNoScope.onFinalize(fiber.cancel());
      });
    });
  }

  /// Cancels this stream when [signal]'s value becomes `true`.
  Rill<O> interruptWhenSignaled(Signal<bool> signal) => interruptWhenTrue(signal.discrete);

  /// Cancels this stream when [haltWhenTrue] emits `true`.
  Rill<O> interruptWhenTrue(Rill<bool> haltWhenTrue) {
    final rillF = (
      IO.deferred<Unit>(),
      IO.deferred<Unit>(),
      IO.deferred<Either<Object, Unit>>(),
    ).mapN((
      interruptL,
      interruptR,
      backResult,
    ) {
      final watch =
          haltWhenTrue.exists((x) => x).interruptWhen(interruptR.value().attempt()).compile.drain;

      final wakeWatch =
          watch.guaranteeCase((oc) {
            final Either<Object, Unit> r = oc.fold(
              () => Unit().asRight(),
              (err, _) => err.asLeft(),
              (_) => Unit().asRight(),
            );

            return backResult.complete(r).productR(interruptL.complete(Unit()).voided());
          }).voidError();

      final stopWatch = interruptR
          .complete(Unit())
          .productR(backResult.value().flatMap(IO.fromEither));

      final backWatch = Rill.bracket(wakeWatch.start(), (_) => stopWatch);

      return backWatch.flatMap((_) => interruptWhen(interruptL.value().attempt()));
    });

    return Rill.force(rillF);
  }

  /// Emits a [heartbeat] value whenever no element has been received for
  /// [maxIdle], keeping the consumer from timing out.
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
      ).flatMap((_) => consumeLoop().rillNoScope);
    });
  }

  /// Emits the last element wrapped in [Some], or [none] if the stream is empty.
  Rill<Option<O>> get last => pull.last.flatMap(Pull.output1).rillNoScope;

  /// Emits the last element, or the value from [fallback] if the stream is empty.
  Rill<O> lastOr(Function0<O> fallback) =>
      pull.last
          .flatMap((o) => o.fold(() => Pull.output1(fallback()), (o) => Pull.output1(o)))
          .rillNoScope;

  /// Transforms each element by applying [f].
  Rill<O2> map<O2>(Function1<O, O2> f) =>
      pull.echo.unconsFlatMap((hd) => Pull.output(hd.map(f))).rillNoScope;

  /// Stateful map: threads a state [S] through the stream, emitting `(state, output)`
  /// pairs.
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

  /// Transforms each underlying [Chunk] directly.
  ///
  /// More efficient than [map] when [f] can be applied to an entire chunk at
  /// once (e.g. [Chunk.map] or [Chunk.filter]).
  Rill<O2> mapChunks<O2>(Function1<Chunk<O>, Chunk<O2>> f) =>
      underlying.unconsFlatMap((hd) => Pull.output(f(hd))).rillNoScope;

  /// Suppresses all errors, turning a failed stream into an empty one.
  Rill<O> get mask => handleErrorWith((_) => Rill.empty());

  /// Merges this stream and [that] concurrently, emitting elements from
  /// whichever side produces first.
  ///
  /// The merged stream terminates when both sides have completed.
  Rill<O> merge(Rill<O> that) => _merge(that, (s, fin) => Rill.exec<O>(fin).append(() => s));

  /// Like [merge] but waits for the downstream consumer to finish processing
  /// each chunk before releasing resources.
  Rill<O> mergeAndAwaitDownstream(Rill<O> that) => _merge(that, (s, fin) => s.onFinalize(fin));

  Rill<O> _merge(
    Rill<O> that,
    Function2<Rill<O>, IO<Unit>, Rill<O>> f,
  ) {
    final rillF = SignallingRef.of<(MergeState, MergeState)>((none(), none())).flatMap((
      bothStates,
    ) {
      return Channel.synchronous<Rill<O>>().flatMap((output) {
        return IO.deferred<Unit>().map((stopDef) {
          final signalStop = stopDef.complete(Unit()).voided();
          final stop = stopDef.value().as(Unit().asRight<Object>());

          IO<Unit> complete(Either<Object, Unit> result) {
            return bothStates.update((current) {
              return switch (current) {
                (None(), None()) => (Some(result), none()),
                (Some(:final value), None()) => (Option(value), Option(result)),
                _ => throw StateError('Rill.merge_: impossible'),
              };
            });
          }

          Option<Either<Object, Unit>> bothStopped((MergeState, MergeState) state) {
            return switch (state) {
              (Some(value: final r1), Some(value: final r2)) => Some(
                CompositeFailure.fromResults(r1, r2),
              ),
              _ => none(),
            };
          }

          IO<Unit> run(Rill<O> s) {
            return Semaphore.permits(1).flatMap((guard) {
              IO<Unit> sendChunk(Chunk<O> chunk) =>
                  output.send(f(Rill.chunk(chunk), guard.release())).productR(guard.acquire());

              return Rill.exec<Unit>(guard.acquire())
                  .append(() => s.chunks().foreach(sendChunk))
                  .interruptWhen(stop)
                  .compile
                  .drain
                  .attempt()
                  .flatMap((r) {
                    return r.fold(
                      (_) => complete(r).productR(signalStop),
                      (_) => complete(r),
                    );
                  });
            });
          }

          final waitForBoth = bothStates.discrete
              .collect(bothStopped)
              .head
              .rethrowError
              .compile
              .drain
              .guarantee(output.close().voided());

          final setup = run(
            this,
          ).start().productR(run(that).start()).productR(waitForBoth.start());

          return Rill.bracket(
            setup,
            (wfb) => signalStop.productR(wfb.joinWithUnit()),
          ).flatMap((_) {
            return output.rill.flatten().interruptWhen(stop);
          });
        });
      });
    });

    return Rill.force(rillF);
  }

  /// Merges this stream and [that], terminating as soon as either side ends.
  Rill<O> mergeHaltBoth(Rill<O> that) =>
      noneTerminate().merge(that.noneTerminate()).unNoneTerminate;

  /// Merges this stream and [that], terminating when this (left) stream ends.
  Rill<O> mergeHaltL(Rill<O> that) =>
      noneTerminate().merge(that.map((o) => Option(o))).unNoneTerminate;

  /// Merges this stream and [that], terminating when [that] (right) stream ends.
  Rill<O> mergeHaltR(Rill<O> that) => that.mergeHaltL(this);

  /// Throttles this stream to emit at most one element per [rate].
  Rill<O> metered(Duration rate) => Rill.fixedRate(rate).zipRight(this);

  /// Like [metered] but emits the first element immediately.
  Rill<O> meteredStartImmediately(Duration rate) =>
      Rill.fixedRateStartImmediately(rate).zipRight(this);

  /// Wraps each element in [Some] and appends a terminal [none] sentinel.
  Rill<Option<O>> noneTerminate() => map((o) => Option(o)).append(() => Rill.emit(none()));

  /// Runs [s2] after this stream ends, whether it succeeded or errored.
  Rill<O> onComplete(Function0<Rill<O>> s2) =>
      handleErrorWith((e) => s2().append(() => Pull.fail(e).rillNoScope)).append(() => s2());

  /// Runs [finalizer] when this stream's scope closes (success, error, or cancel).
  Rill<O> onFinalize(IO<Unit> finalizer) => onFinalizeCase((_) => finalizer);

  /// Like [onFinalize] but [finalizer] receives the [ExitCase].
  Rill<O> onFinalizeCase(Function1<ExitCase, IO<Unit>> finalizer) =>
      Rill.bracketCase(IO.unit, (_, ec) => finalizer(ec)).flatMap((_) => this);

  /// Maps elements concurrently via [f], preserving output order.
  ///
  /// At most [maxConcurrent] evaluations run simultaneously. Use
  /// [parEvalMapUnordered] if order does not matter.
  Rill<O2> parEvalMap<O2>(int maxConcurrent, Function1<O, IO<O2>> f) {
    if (maxConcurrent == 1) {
      return evalMap(f);
    } else {
      assert(maxConcurrent > 0, 'maxConcurrent must be > 0, was: $maxConcurrent');

      // One is taken by inner stream read.
      final concurrency = maxConcurrent == Integer.maxValue ? Integer.maxValue : maxConcurrent + 1;
      final channelF = Channel.bounded<IO<Either<Object, O2>>>(concurrency);

      return _parEvalMapImpl(concurrency, channelF, true, f);
    }
  }

  /// Like [parEvalMap] with no concurrency limit (unbounded parallelism).
  Rill<O2> parEvalMapUnbounded<O2>(Function1<O, IO<O2>> f) =>
      _parEvalMapImpl(Integer.maxValue, Channel.unbounded(), true, f);

  /// Like [parEvalMap] but emits results as soon as they are ready, without
  /// preserving input order.
  Rill<O2> parEvalMapUnordered<O2>(int maxConcurrent, Function1<O, IO<O2>> f) {
    if (maxConcurrent == 1) {
      return evalMap(f);
    } else {
      assert(maxConcurrent > 0, 'maxConcurrent must be > 0, was: $maxConcurrent');

      // One is taken by inner stream read.
      final concurrency = maxConcurrent == Integer.maxValue ? Integer.maxValue : maxConcurrent + 1;
      final channelF = Channel.bounded<IO<Either<Object, O2>>>(concurrency);

      return _parEvalMapImpl(concurrency, channelF, false, f);
    }
  }

  /// Like [parEvalMapUnordered] with no concurrency limit.
  Rill<O2> parEvalMapUnorderedUnbounded<O2>(Function1<O, IO<O2>> f) =>
      _parEvalMapImpl(Integer.maxValue, Channel.unbounded(), false, f);

  Rill<O2> _parEvalMapImpl<O2>(
    int concurrency,
    IO<Channel<IO<Either<Object, O2>>>> channel,
    bool isOrdered,
    Function1<O, IO<O2>> f,
  ) {
    final action = Semaphore.permits(concurrency).flatMap((semaphore) {
      return channel.flatMap((channel) {
        return Deferred.of<Unit>().flatMap((stop) {
          return Deferred.of<Unit>().map((end) {
            IO<Function1<Either<Object, O2>, IO<Unit>>> initFork(IO<Unit> release) {
              IO<Function1<Either<Object, O2>, IO<Unit>>> ordered() {
                Function1<Either<Object, O2>, IO<Unit>> send(Deferred<Either<Object, O2>> v) =>
                    (el) => v.complete(el).voided();

                return Deferred.of<Either<Object, O2>>()
                    .flatTap((value) => channel.send(release.productR(value.value())))
                    .map(send);
              }

              Function1<Either<Object, O2>, IO<Unit>> unordered() {
                return (el) => channel.send(IO.pure(el)).productR(release);
              }

              return isOrdered ? ordered() : IO.pure(unordered());
            }

            final releaseAndCheckCompletion = semaphore.release().productR(
              semaphore.available().flatMap((available) {
                if (available == concurrency) {
                  return channel.close().productR(end.complete(Unit()).voided());
                } else {
                  return IO.unit;
                }
              }),
            );

            IO<Unit> forkOnElem(O el) {
              return IO.uncancelable((poll) {
                return poll(semaphore.acquire()).productL(
                  Deferred.of<Unit>().flatMap((pushed) {
                    final init = initFork(pushed.complete(Unit()).voided());

                    return poll(init).onCancel(releaseAndCheckCompletion).flatMap((send) {
                      final action = IO
                          .catchNonError(() => f(el))
                          .flatten()
                          .attempt()
                          .flatMap(send)
                          .productR(pushed.value());

                      if (isOrdered) {
                        return IO
                            .race(stop.value(), action)
                            .start()
                            .productR(releaseAndCheckCompletion);
                      } else {
                        return IO
                            .race(stop.value(), action)
                            .guarantee(releaseAndCheckCompletion)
                            .start()
                            .voided();
                      }
                    });
                  }),
                );
              });
            }

            final background = Rill.exec<Unit>(semaphore.acquire()).append(() {
              return interruptWhen(
                stop.value().map((u) => u.asRight<Object>()),
              ).foreach(forkOnElem).onFinalizeCase((exitCase) {
                return exitCase.fold(
                  () => stop.complete(Unit()).productR(releaseAndCheckCompletion),
                  (_, _) => stop.complete(Unit()).productR(releaseAndCheckCompletion),
                  () => releaseAndCheckCompletion,
                );
              });
            });

            final foreground = channel.rill.evalMap((x) => x.rethrowError());

            return foreground
                .onFinalize(stop.complete(Unit()).productR(end.value()))
                .concurrently(background);
          });
        });
      });
    });

    return Rill.force(action);
  }

  /// Pauses emission whenever [pauseWhenTrue] emits `true` and resumes when
  /// it emits `false`.
  Rill<O> pauseWhen(Rill<bool> pauseWhenTrue) {
    return Rill.eval(SignallingRef.of(false)).flatMap((pauseSignal) {
      return pauseWhenSignal(
        pauseSignal,
      ).mergeHaltBoth(pauseWhenTrue.foreach(pauseSignal.setValue));
    });
  }

  /// Like [pauseWhen] but driven by a [Signal] rather than a [Rill].
  Rill<O> pauseWhenSignal(Signal<bool> pauseWhneTrue) {
    final waitToResume = pauseWhneTrue.waitUntil((x) => !x);
    final pauseIfNeeded = Rill.exec<O>(
      pauseWhneTrue.value().flatMap((paused) => waitToResume.whenA(paused)),
    );

    return pauseIfNeeded.append(
      () => chunks().flatMap((chunk) {
        return Rill.chunk(chunk).append(() => pauseIfNeeded);
      }),
    );
  }

  /// Access the Pull API for this Rill.
  ToPull<O> get pull => ToPull(this);

  /// Randomly re-sizes chunks by a factor between [minFactor] and [maxFactor].
  ///
  /// Useful for testing that consumers handle arbitrary chunk boundaries.
  Rill<O> rechunkRandomly({double minFactor = 0.1, double maxFactor = 2.0, int? seed}) {
    if (minFactor <= 0 || maxFactor < minFactor) {
      throw ArgumentError('Invalid rechunk factors. Ensure 0 < minFactor <= maxFactor');
    }

    return Rill.suspend(() {
      final rng = math.Random(seed);

      Pull<O, Unit> loop(Chunk<O> acc, Rill<O> s) {
        return s.pull.uncons.flatMap((hdtl) {
          return hdtl.foldN(
            () => acc.isEmpty ? Pull.done : Pull.output(acc),
            (hd, tl) {
              final newSize =
                  math
                      .max(
                        1.0,
                        (acc.size + hd.size) *
                            (minFactor + (maxFactor - minFactor) * rng.nextDouble()),
                      )
                      .toInt();
              final newAcc = acc.concat(hd);

              if (newAcc.size < newSize) {
                return loop(newAcc, tl);
              } else {
                final (toEmit, rest) = newAcc.splitAt(newSize);
                return Pull.output(toEmit).append(() => loop(rest, tl));
              }
            },
          );
        });
      }

      return loop(Chunk.empty<O>(), this).rillNoScope;
    });
  }

  /// Alias for [fold1].
  Rill<O> reduce(Function2<O, O, O> f) => fold1(f);

  /// Repeats this stream indefinitely.
  Rill<O> repeat() => append(repeat);

  /// Repeats this stream [n] additional times (total = original + n copies).
  Rill<O> repeatN(int n) => n > 0 ? append(() => repeatN(n - 1)) : Rill.empty();

  /// Low-level combinator: calls [f] with a [ToPull] handle and repeats until
  /// [f] returns [none].
  Rill<O2> repeatPull<O2>(Function1<ToPull<O>, Pull<O2, Option<Rill<O>>>> f) {
    Pull<O2, Unit> go(ToPull<O> tp) {
      return f(tp).flatMap((tail) {
        return tail.fold(() => Pull.done, (tail) => go(tail.pull));
      });
    }

    return go(pull).rillNoScope;
  }

  /// Emits [z] followed by each running accumulation of [f] applied to
  /// consecutive elements (i.e. a running fold).
  Rill<O2> scan<O2>(O2 z, Function2<O2, O, O2> f) =>
      Pull.output1(z).append(() => _scan(z, f)).rillNoScope;

  /// Like [scan] but uses the first element as the initial accumulator (no
  /// seed value emitted).
  Rill<O> scan1(Function2<O, O, O> f) =>
      pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            final (pre, post) = hd.splitAt(1);
            return Pull.output(pre).append(() => tl.cons(post)._scan(pre[0], f));
          },
        );
      }).rillNoScope;

  Pull<O2, Unit> _scan<O2>(O2 z, Function2<O2, O, O2> f) => pull.uncons.flatMap((hdtl) {
    return hdtl.foldN(
      () => Pull.done,
      (hd, tl) {
        final (out, carry) = hd.scanLeftCarry(z, f);
        return Pull.output(out).append(() => tl._scan(carry, f));
      },
    );
  });

  /// Chunk-level [scan]: threads state through each chunk, emitting transformed
  /// chunks.
  Rill<O2> scanChunks<S, O2>(S initial, Function2<S, Chunk<O>, (S, Chunk<O2>)> f) =>
      scanChunksOpt(initial, (s) => Some((c) => f(s, c)));

  /// Like [scanChunks] but allows early termination: returning [none] from [f]
  /// stops the scan.
  Rill<O2> scanChunksOpt<S, O2>(
    S initial,
    Function1<S, Option<Function1<Chunk<O>, (S, Chunk<O2>)>>> f,
  ) => pull.scanChunksOpt(initial, f).voided.rillNoScope;

  /// Wraps this stream in a new resource [Scope].
  ///
  /// Resources acquired inside the stream are released when the scope closes.
  Rill<O> get scope => Pull.scope(underlying).rillNoScope;

  /// Emits overlapping windows of [size] elements, advancing [step] elements
  /// between windows.
  Rill<Chunk<O>> sliding(int size, {int step = 1}) {
    assert(size > 0 && step > 0, 'size and step must be positive');
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
          .rillNoScope;
    } else {
      return stepNotSmallerThanSize(this, Chunk.empty()).rillNoScope;
    }
  }

  /// Zips this stream against a fixed-delay ticker so elements are emitted
  /// at most once per [delay].
  ///
  /// When [startImmediately] is `true` (default), the first element is emitted
  /// without waiting.
  Rill<O> spaced(Duration delay, {bool startImmediately = true}) {
    final start = startImmediately ? Rill.unit : Rill.empty<Unit>();
    return start.append(() => Rill.fixedDelay(delay)).zipRight(this);
  }

  /// Splits the stream into sub-chunks at elements for which [p] is true;
  /// delimiter elements are dropped.
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

    return go(Chunk.empty(), this).rillNoScope;
  }

  /// Maps each element to a stream via [f], cancelling the previous inner stream
  /// when a new element arrives.
  ///
  /// Only the inner stream corresponding to the latest element runs at any
  /// given time.
  Rill<O2> switchMap<O2>(Function1<O, Rill<O2>> f) {
    final IO<Rill<O2>> rillF = Semaphore.permits(1).flatMap((guard) {
      return IO.ref(none<Deferred<Unit>>()).map((haltRef) {
        Rill<O2> runInner(O o, Deferred<Unit> halt) {
          return Rill.bracketFull(
            (poll) => poll(guard.acquire()), // guard against simultaneously running rills
            (_, ec) {
              return ec.fold(
                () => guard.release(),
                (_, _) => IO.unit, // on error don't start next stream
                () => guard.release(),
              );
            },
          ).flatMap((_) => f(o).interruptWhen(halt.value().attempt()));
        }

        IO<Rill<O2>> haltedF(O o) {
          return IO.deferred<Unit>().flatMap((halt) {
            return haltRef.getAndSet(halt.some).flatMap((prev) {
              return prev
                  .fold(() => IO.unit, (prev) => prev.complete(Unit()))
                  .map((_) => runInner(o, halt));
            });
          });
        }

        return evalMap(haltedF).parJoin(2);
      });
    });

    return Rill.force(rillF);
  }

  /// Drops the first element and emits the rest.
  Rill<O> get tail => drop(1);

  /// Emits at most the first [n] elements, then terminates.
  Rill<O> take(int n) => pull.take(n).voided.rillNoScope;

  /// Emits only the last [n] elements, buffering the full stream first.
  Rill<O> takeRight(int n) => pull.takeRight(n).flatMap(Pull.output).rillNoScope;

  /// Takes elements while [p] is true and also takes the first failing element.
  Rill<O> takeThrough(Function1<O, bool> p) => pull.takeThrough(p).voided.rillNoScope;

  /// Takes elements while [p] is true.
  ///
  /// When [takeFailure] is `true`, also emits the first element for which [p]
  /// is false (equivalent to [takeThrough]).
  Rill<O> takeWhile(Function1<O, bool> p, {bool takeFailure = false}) =>
      pull.takeWhile(p, takeFailure: takeFailure).voided.rillNoScope;

  /// Applies a [Pipe] to this stream. Equivalent to `f(this)`.
  Rill<O2> through<O2>(Pipe<O, O2> f) => f(this);

  /// Alias for `interruptWhen(IO.sleep(timeout))`.
  Rill<O> timeout(Duration timeout) => interruptWhen(IO.sleep(timeout));

  /// Pairs elements from this stream and [that] in lock-step, stopping when
  /// either ends.
  Rill<(O, O2)> zip<O2>(Rill<O2> that) => zipWith(that, (o, o2) => (o, o2));

  /// Zips with [other] and keeps only this stream's elements.
  Rill<O> zipLeft<O2>(Rill<O2> other) => zipWith(other, (a, _) => a);

  /// Zips with [other] and keeps only [other]'s elements.
  Rill<O2> zipRight<O2>(Rill<O2> other) => zipWith(other, (_, b) => b);

  /// Zips with [that], combining pairs via [f], stopping when either stream ends.
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
                  final len = math.min(hd1.size, hd2.size);

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

  /// Zips with [that], padding the shorter stream with [padLeft] or [padRight].
  Rill<(O, O2)> zipAll<O2>(Rill<O2> that, O padLeft, O2 padRight) =>
      zipAllWith(that, padLeft, padRight, (o, o2) => (o, o2));

  /// Like [zipAll] but combines pairs via [f].
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
                  final len = math.min(hd1.size, hd2.size);

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

  /// Emits the latest pair `(thisValue, thatValue)` whenever either stream
  /// produces a new element.
  Rill<(O, O2)> zipLatest<O2>(Rill<O2> that) => zipLatestWith(that, (o, o2) => (o, o2));

  /// Like [zipLatest] but combines the latest pair via [f].
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
            (o) => refLeft.setValue(Some(o)).productL(tryEmit()),
          ).compile.drain.handleErrorWith((err) => queue.offer(Left(err)));

          IO<Unit> runRight() => that
              .evalMap((o2) => refRight.setValue(Some(o2)).productL(tryEmit()))
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

  /// Pairs each element with its zero-based index.
  Rill<(O, int)> zipWithIndex() => scanChunks(0, (index, c) {
    var idx = index;

    final out = c.map((o) {
      final r = (o, idx);
      idx += 1;
      return r;
    });

    return (idx, out);
  });

  /// Pairs each element with the next one. The last element is paired with [none].
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
    }).rillNoScope;
  }

  /// Pairs each element with the previous one. The first element is paired with [none].
  Rill<(Option<O>, O)> zipWithPrevious() =>
      mapAccumulate(none<O>(), (prev, next) => (Option(next), (prev, next))).map((x) => x.$2);

  /// Pairs each element with both its predecessor and successor.
  Rill<(Option<O>, O, Option<O>)> zipWithPreviousAndNext() =>
      zipWithPrevious().zipWithNext().map((tuple) {
        final ((prev, curr), next) = tuple;

        return next.foldN(
          () => (prev, curr, const None()),
          (_, next) => (prev, curr, Some(next)),
        );
      });

  /// Pairs each element with the accumulated state *before* applying [f] to it.
  Rill<(O, O2)> zipWithScan<O2>(O2 z, Function2<O2, O, O2> f) => mapAccumulate(
    z,
    (s, o) => (f(s, o), (o, s)),
  ).mapN((_, v) => v);

  /// Pairs each element with the accumulated state *after* applying [f] to it.
  Rill<(O, O2)> zipWithScan1<O2>(O2 z, Function2<O2, O, O2> f) => mapAccumulate(
    z,
    (s, o) {
      final s2 = f(s, o);
      return (s2, (o, s2));
    },
  ).mapN((_, v) => v);

  /// Access the compile API to run this stream and aggregate its output.
  RillCompile<O> get compile => RillCompile(underlying);

  Rill<O2> _mapNoScope<O2>(Function1<O, O2> f) => Pull.mapOutputNoScope(this, f).rillNoScope;
}

/// Operations only available on a [Rill] that emits no elements — [Rill<Never>].
extension RillNeverOps on Rill<Never> {
  /// Widens this [Rill<Never>] to [Rill<O2>].
  ///
  /// Useful when an API expects [Rill<O2>] and you have a [Rill<Never>] that
  /// produces no elements (e.g. after [Rill.drain] or [Rill.foreach]).
  ///
  /// **Why this is type-safe**: the ideal signature would use a lower type bound:
  /// ```dart
  /// Rill<O2> widen<O2 super O>()
  /// ```
  /// where `O2 super O` means "O2 is a supertype of O". Dart does not support
  /// lower type bounds, so restricting the receiver to [Rill<Never>] encodes
  /// the same constraint at the type level. [Never] is the bottom type —
  /// [Never] <: [O2] for every [O2] — so the cast
  /// `Pull<Never, Unit> as Pull<O2, Unit>` always succeeds at runtime.
  ///
  /// See also [Rill.append] for the type-preserving concatenation variant.
  Rill<O2> widen<O2>() => (underlying as Pull<O2, Unit>).rillNoScope;
}

/// Controls how a [Rill.fromStream] buffer behaves when it is full.
sealed class OverflowStrategy {
  const OverflowStrategy();

  /// Drop the oldest buffered element to make room for the new one.
  factory OverflowStrategy.dropOldest(int bufferSize) => _DropOldest(bufferSize);

  /// Drop the incoming element when the buffer is full.
  factory OverflowStrategy.dropNewest(int bufferSize) => _DropNewest(bufferSize);

  /// Never drop elements; the buffer grows without bound.
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

typedef MergeState = Option<Either<Object, Unit>>;
