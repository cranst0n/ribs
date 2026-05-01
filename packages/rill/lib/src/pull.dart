part of 'rill.dart';

/// A `Pull` describes a process that can emit outputs of type [O], evaluate
/// effects of type `IO`, and eventually return a result of type [R].
sealed class Pull<O, R> {
  /// Acquires a resource that will be released with [release] when the
  /// enclosing [Scope] closes.
  ///
  /// The acquisition itself is not cancelable. Use [acquireCancelable] if
  /// the acquisition should be interruptible.
  static Pull<Never, R> acquire<R>(
    IO<R> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => _Acquire(acquire, Fn2(release), cancelable: false);

  /// Like [acquire] but the acquisition [IO] is wrapped in [IO.uncancelable]
  /// so that a cancellation request is only honoured after the resource is
  /// fully acquired and its finalizer is registered.
  static Pull<Never, R> acquireCancelable<R>(
    Function1<Poll, IO<R>> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => _Acquire(IO.uncancelable(acquire), Fn2(release), cancelable: true);

  /// A pull that emits no elements and terminates successfully. Alias for [unit].
  static final Pull<Never, Unit> done = unit;

  /// Lifts an [IO] into a Pull that evaluates it and returns the result.
  static Pull<Never, R> eval<R>(IO<R> io) => _Eval(io);

  /// A Pull that immediately fails with [err].
  static Pull<Never, Never> fail(Object err, [StackTrace? stackTrace]) => _Fail(err, stackTrace);

  /// A Pull that returns the current [Scope] without emitting any output.
  static Pull<Never, Scope> getScope = const _GetScope();

  /// Maps the output of [s] via [f] without introducing a new [Scope].
  static Pull<P, Unit> mapOutputNoScope<O, P>(Rill<O> s, Function1<O, P> f) =>
      s.pull.echo.unconsFlatMap((hd) => Pull.output(hd.map(f)));

  /// Emits [chunk], or does nothing if [chunk] is empty.
  static Pull<O, Unit> output<O>(Chunk<O> chunk) => chunk.isEmpty ? Pull.done : _Output(chunk);

  /// Emits a single element [value].
  static Pull<O, Unit> output1<O>(O value) => _Output(chunk([value]));

  /// Emits [opt]'s value if it is [Some], otherwise emits nothing.
  static Pull<O, Unit> outputOption1<O>(Option<O> opt) =>
      opt.map(output1).getOrElse(() => Pull.done);

  /// A pre-allocated pull that emits a single [Unit] element.
  static final Pull<Unit, Unit> outUnit = _Output(Chunk.unit);

  /// A Pull that emits nothing and returns [r].
  static Pull<Never, R> pure<R>(R r) => _Pure(r);

  /// Alias for [fail].
  static Pull<Never, Never> raiseError(Object err, [StackTrace? stackTrace]) =>
      _Fail(err, stackTrace);

  /// Wraps [pull] so that it is interrupted when [haltWhen] completes.
  ///
  /// [haltWhen] is an `IO<Either<Object, Unit>>`:
  /// - `Right(Unit())` → clean interruption (scope closed with [ExitCase.canceled])
  /// - `Left(err)` → interruption with error (scope closed with [ExitCase.errored])
  ///
  /// The halt signal is checked at each output step, and the scope is closed with
  /// the correct [ExitCase] so that resource finalizers (e.g. from [Rill.bracketCase])
  /// observe the proper exit condition.
  static Pull<O, R> interruptWhen<O, R>(
    Pull<O, R> pull,
    IO<Either<Object, Unit>> haltWhen,
  ) => _InterruptWhen(pull, haltWhen);

  /// Wraps [pull] in a fresh [Scope], closing it (with the appropriate
  /// [ExitCase]) when [pull] completes, errors, or is cancelled.
  static Pull<O, Unit> scope<O>(Pull<O, Unit> pull) => _OpenScope<O>().flatMap((newScope) {
    return _RunInScope<O, Unit>(pull, newScope)
        .handleErrorWith<O>(
          (err) => _CloseScope<O>(
            newScope,
            ExitCase.errored(err),
          ).append<O, Unit>(() => Pull.raiseError(err)),
        )
        .flatMap((_) {
          return _CloseScope<O>(newScope, ExitCase.succeeded()).handleErrorWith<O>(
            (err) => _CloseScope<O>(
              newScope,
              ExitCase.errored(err),
            ).append<O, Unit>(() => Pull.raiseError(err)),
          );
        });
  });

  /// Defers construction of a [Pull] until it is stepped, preventing stack
  /// overflow for recursive definitions.
  static Pull<O, R> suspend<O, R>(Function0<Pull<O, R>> f) => Pull.unit.flatMap((_) => f());

  /// A Pull that emits nothing and returns [Unit].
  static Pull<Never, Unit> unit = _Pure(Unit());

  const Pull();

  /// **Unsafe Cast Warning**:
  ///
  /// This method performs an unsafe cast (`this as Pull<O2, R>`) to allow type widening.
  /// If [O] is not a subtype of [O2], this function will throw a [TypeError] at runtime.
  Pull<O2, R2> append<O2, R2>(Function0<Pull<O2, R2>> next) => flatMap((_) => next());

  /// Replaces the result value with [s].
  Pull<O, R2> as<R2>(R2 s) => map((_) => s);

  /// Runs this pull, then uses the result to determine the next pull.
  ///
  /// [f] is a function that receives the result of this pull and returns the next step.
  ///
  /// **Unsafe Cast Warning**:
  ///
  /// This method performs an unsafe cast (`this as Pull<O2, R>`) to allow type widening.
  /// If [O] is not a subtype of [O2], this function will throw a [TypeError] at runtime.
  Pull<O2, R2> flatMap<O2, R2>(Function1<R, Pull<O2, R2>> f) => _Bind(this as Pull<O2, R>, Fn1(f));

  /// Maps the result type.
  Pull<O, R2> map<R2>(Function1<R, R2> f) => flatMap((r) => Pull.pure(f(r)));

  /// Handles errors raised in this Pull.
  ///
  /// **Unsafe Cast Warning**:
  ///
  /// This method performs an unsafe cast (`this as Pull<O2, R>`) to allow type widening.
  /// If [O] is not a subtype of [O2], this function will throw a [TypeError] at runtime.
  Pull<O2, R> handleErrorWith<O2>(Function1<Object, Pull<O2, R>> f) =>
      _Handle(this as Pull<O2, R>, Fn1(f));

  /// Discards the result value, replacing it with [Unit].
  Pull<O, Unit> get voided => as(Unit());
}

/// Flattening operation for a [Pull] whose result is itself a [Pull].
extension PullFlattenOps<O, R> on Pull<O, Pull<O, R>> {
  /// Sequences the inner pull after the outer, merging their outputs.
  Pull<O, R> flatten() => flatMap(identity);
}

/// Operations available ONLY when the result type is [Unit].
/// This ensures we can only inspect a "streaming" pull, not a calculated result.
/// Operations available ONLY when the result type is [Unit].
/// This ensures we can only inspect a "streaming" pull, not a calculated result.
extension PullOps<O> on Pull<O, Unit> {
  /// Converts this [Pull] into a [Rill] wrapped in its own [Scope].
  Rill<O> get rill => Rill._scoped(this);

  /// Converts this [Pull] into a [Rill] without introducing a new [Scope].
  ///
  /// Use when the pull is already scoped (e.g. inside a [Rill.bracketFull]).
  Rill<O> get rillNoScope => Rill._noScope(this);

  /// Processes each output element through [f], emitting the resulting pulls
  /// in sequence and merging their outputs into the stream.
  Pull<O2, Unit> flatMapOutput<O2>(Function1<O, Pull<O2, Unit>> f) {
    return Pull.getScope.flatMap((scope) {
      return Pull.eval(_stepPull(this, scope)).flatMap((step) {
        switch (step) {
          case final _StepDone<O, Unit> _:
            return Pull.pure<Unit>(step.result);
          case _StepOut<O, Unit> _:
            final head = step.head;
            final next = step.next;

            Pull<O2, Unit> runChunk(Chunk<O> chunk) {
              if (chunk.isEmpty) {
                return Pull.done;
              } else {
                return f(chunk.head).flatMap((_) => runChunk(chunk.tail));
              }
            }

            return runChunk(head).flatMap((_) => next.flatMapOutput(f));
          case final _StepError<dynamic, dynamic> s:
            return Pull.raiseError(s.error, s.stackTrace);
        }
      });
    });
  }

  /// Peels off the next chunk of the current pull.
  ///
  /// Returns a Pull that emits nothing, but evaluates to an Option containing:
  /// - The next chunk [IList<O>]
  /// - The remainder of the pull [Pull<O, Unit>]
  Pull<Never, Option<(Chunk<O>, Pull<O, Unit>)>> get uncons {
    return Pull.getScope.flatMap((scope) {
      return Pull.eval(_stepPull(this, scope)).flatMap((step) {
        return switch (step) {
          final _StepDone<dynamic, dynamic> _ => Pull.pure(none()),
          final _StepOut<O, Unit> _ => Pull.pure(Some((step.head, step.next))),
          final _StepError<dynamic, dynamic> step => Pull.raiseError(step.error, step.stackTrace),
        };
      });
    });
  }

  /// Repeatedly peels off the next chunk and passes it to [f], concatenating
  /// the resulting pulls until the stream is exhausted.
  Pull<O2, Unit> unconsFlatMap<O2>(Function1<Chunk<O>, Pull<O2, Unit>> f) {
    return uncons.flatMap<O2, Unit>((hdtl) {
      return hdtl.foldN<Pull<O2, Unit>>(
        () => Pull.done,
        (hd, tl) => f(hd).append<O2, Unit>(() => tl.unconsFlatMap(f)),
      );
    });
  }
}

class _Pure<R> extends Pull<Never, R> {
  final R value;

  const _Pure(this.value);
}

class _Output<O> extends Pull<O, Unit> {
  final Chunk<O> chunk;

  const _Output(this.chunk);
}

class _Fail extends Pull<Never, Never> {
  final Object error;
  final StackTrace? stackTrace;

  const _Fail(this.error, this.stackTrace);
}

class _Eval<R> extends Pull<Never, R> {
  final IO<R> action;
  const _Eval(this.action);
}

class _Bind<O, X, R> extends Pull<O, R> {
  final Pull<O, X> source;
  final Fn1<X, Pull<O, R>> k;
  const _Bind(this.source, this.k);
}

class _Handle<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Fn1<Object, Pull<O, R>> handler;

  const _Handle(this.source, this.handler);
}

class _Acquire<R> extends Pull<Never, R> {
  final IO<R> acquire;
  final Fn2<R, ExitCase, IO<Unit>> release;
  final bool cancelable;

  const _Acquire(
    this.acquire,
    this.release, {
    required this.cancelable,
  });
}

class _GetScope<O> extends Pull<O, Scope> {
  const _GetScope();
}

class _OpenScope<O> extends Pull<O, Scope> {
  const _OpenScope();
}

class _CloseScope<O> extends Pull<O, Unit> {
  final Scope scope;
  final ExitCase exitCase;

  const _CloseScope(this.scope, this.exitCase);
}

class _RunInScope<O, R> extends Pull<O, R> {
  final Pull<O, R> pull;
  final Scope targetScope;

  const _RunInScope(this.pull, this.targetScope);
}

class _InterruptWhen<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final IO<Either<Object, Unit>> haltWhen;

  const _InterruptWhen(this.source, this.haltWhen);
}

sealed class _Step<O, R> {
  static _Step<O, R> done<O, R>(R r) => _StepDone(r);
}

class _StepDone<O, R> extends _Step<O, R> {
  final R result;
  _StepDone(this.result);
}

class _StepOut<O, R> extends _Step<O, R> {
  final Chunk<O> head;
  final Pull<O, R> next;

  _StepOut(this.head, this.next);
}

class _StepError<O, R> extends _Step<O, R> {
  final Object error;
  final StackTrace? stackTrace;

  _StepError(this.error, [this.stackTrace]);
}

IO<_Step<O, R>> _stepPull<O, R>(Pull<O, R> pull, Scope scope) {
  var current = pull;

  while (true) {
    switch (current) {
      case final _Pure<R> p:
        return IO.pure(_StepDone(p.value));
      case final _Fail f:
        return IO.pure(_StepError(f.error, f.stackTrace));
      case final _Output<O> p:
        return IO.pure(_StepOut(p.chunk, Pull.done as Pull<O, R>));
      case final _Eval<R> e:
        return e.action.redeem((err) => _StepError(err), (r) => _StepDone(r));
      case final _Acquire<R> a:
        return _stepAcquire(a, scope);
      case final _GetScope<O> _:
        return IO.pure(_StepDone(scope as R));
      case final _OpenScope<O> _:
        return Scope.create(scope).map((s) => _StepDone(s as R));
      case final _CloseScope<O> p:
        return _stepCloseScope(p);
      case final _Bind<O, dynamic, R> bind:
        // Re-associate left-nested binds: _Bind(_Bind(s, k1), k2) => _Bind(s, x => _Bind(k1(x), k2))
        Pull<O, dynamic> source = bind.source;
        Fn1<dynamic, Pull<O, R>> k = bind.k;

        while (source is _Bind<O, dynamic, dynamic>) {
          final inner = source;
          final outerK = k;
          final innerK = inner.k;
          k = Fn1((x) => _Bind<O, dynamic, R>(innerK(x), outerK));
          source = inner.source;
        }

        switch (source) {
          case final _Pure<dynamic> pure:
            current = k(pure.value);
            continue;
          case final _Output<O> output:
            // k expects Unit (the result type of _Output), so call it directly
            // instead of building Pull.done.flatMap(k) and stepping through it.
            return IO.pure(
              _StepOut(output.chunk, k(Unit())),
            );
          default:
            return _stepPull(source, scope).flatMap((step) {
              return switch (step) {
                final _StepDone<O, dynamic> d => _stepPull(k(d.result), scope),
                // Reuse existing k Fn1 directly rather than wrapping in a new closure.
                final _StepOut<O, dynamic> o => IO.pure(
                  _StepOut(o.head, _Bind(o.next, k)),
                ),
                final _StepError<O, dynamic> e => IO.pure(_StepError<O, R>(e.error, e.stackTrace)),
              };
            });
        }
      case final _InterruptWhen<O, R> iw:
        return _stepInterruptWhen(iw, scope);
      case final _Handle<O, R> h:
        return _stepHandle(h, scope);
      case final _RunInScope<O, R> r:
        return _stepRunInScope(r);
      default:
        return IO.raiseError('Pull.stepPull: Unknown Pull type: $current');
    }
  }
}

IO<_Step<O, R>> _stepHandle<O, R>(_Handle<O, R> pull, Scope scope) {
  return _stepPull(pull.source, scope).attempt().flatMap((either) {
    return either.fold(
      (error) => _stepPull(pull.handler(error), scope),
      (step) {
        switch (step) {
          case _StepDone<O, R> _:
            return IO.pure(step);
          case _StepOut<O, R> _:
            return IO.pure(
              _StepOut(step.head, step.next.handleErrorWith(pull.handler.f)),
            );
          case final _StepError<dynamic, dynamic> step:
            try {
              return _stepPull(pull.handler(step.error), scope);
            } catch (e, st) {
              return IO.pure(_StepError(e, st));
            }
        }
      },
    );
  });
}

IO<_Step<O, R>> _stepAcquire<O, R>(_Acquire<R> pull, Scope scope) {
  return pull.acquire.redeemWith(
    (err) => IO.pure(_StepError(err)),
    (resource) {
      final registerOp = scope.register((ec) => pull.release(resource, ec));
      return registerOp.as(_Step.done<O, R>(resource));
    },
  );
}

IO<_Step<O, R>> _stepRunInScope<O, R>(_RunInScope<O, R> pull) {
  return _stepPull(pull.pull, pull.targetScope).flatMap((step) {
    return switch (step) {
      final _StepDone<O, R> done => IO.pure(done),
      final _StepOut<O, R> out => IO.pure(
        _StepOut(out.head, _RunInScope(out.next, pull.targetScope)),
      ),
      final _StepError<O, R> error => IO.pure(error),
    };
  });
}

IO<_Step<O, R>> _stepCloseScope<O, R>(_CloseScope<O> pull) {
  return pull.scope.close(pull.exitCase).map((closeResult) {
    return closeResult.fold(
      (err) => _StepError(err),
      (_) => _StepDone(Unit() as R),
    );
  });
}

IO<_Step<O, R>> _stepInterruptWhen<O, R>(_InterruptWhen<O, R> pull, Scope scope) {
  return IO.race(pull.haltWhen, _stepPull(pull.source, scope)).flatMap((either) {
    return either.fold(
      // Halt signal won: close scope with the appropriate ExitCase so that
      // resource finalizers (bracketCase/bracketFull) observe the correct exit.
      (haltResult) => haltResult.fold(
        // Left(err) — interrupt with error
        (err) => scope
            .close(ExitCase.errored(err))
            .map(
              (closeResult) => closeResult.fold(
                (closeErr) => _StepError<O, R>(closeErr),
                (_) => _StepError<O, R>(err),
              ),
            ),
        // Right(unit) — clean cancellation
        (_) => scope
            .close(ExitCase.canceled())
            .map(
              (closeResult) => closeResult.fold(
                (closeErr) => _StepError<O, R>(closeErr),
                (_) => _StepDone<O, R>(Unit() as R),
              ),
            ),
      ),
      // Inner step won: propagate the halt signal through each output's continuation.
      (innerStep) => IO.pure(switch (innerStep) {
        final _StepDone<O, R> done => done,
        final _StepOut<O, R> out => _StepOut(
          out.head,
          _InterruptWhen(out.next, pull.haltWhen),
        ),
        final _StepError<O, R> err => err,
      }),
    );
  });
}
