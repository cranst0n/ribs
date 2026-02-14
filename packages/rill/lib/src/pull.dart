part of 'rill.dart';

/// A `Pull` describes a process that can emit outputs of type [O], evaluate
/// effects of type `IO`, and eventually return a result of type [R].
sealed class Pull<O, R> {
  static Pull<Never, R> acquire<R>(
    IO<R> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => _Acquire(acquire, Fn2(release), cancelable: false);

  static Pull<Never, R> acquireCancelable<R>(
    Function1<Poll, IO<R>> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) => _Acquire(IO.uncancelable(acquire), Fn2(release), cancelable: true);

  static Pull<O, Unit> done<O>() => _Done();
  // static final Pull<Never, Unit> done = unit;

  static Pull<Never, R> eval<R>(IO<R> io) => _Eval(io);

  static Pull<Never, Never> fail(Object err, [StackTrace? stackTrace]) => _Fail(err, stackTrace);

  static Pull<Never, Scope> getScope = const _GetScope();

  static Pull<O, Unit> output<O>(Chunk<O> chunk) => _Output(chunk);

  static Pull<O, Unit> output1<O>(O value) => _Output(chunk([value]));

  static Pull<O, Unit> outputOption1<O>(Option<O> opt) =>
      opt.map(output1).getOrElse(() => Pull.done());

  static final Pull<Unit, Unit> outUnit = _Output(Chunk.unit);

  static Pull<Never, R> pure<R>(R r) => _Pure(r);

  static Pull<Never, Never> raiseError(Object err, [StackTrace? stackTrace]) =>
      _Fail(err, stackTrace);

  static Pull<O, Unit> scope<O>(Pull<O, Unit> pull) => _OpenScope<O>().flatMap((newScope) {
    return _RunInScope<O, Unit>(pull, newScope).flatMap((_) {
      return _CloseScope<O>(newScope, ExitCase.succeeded()).handleErrorWith(
        (err) => _CloseScope<O>(
          newScope,
          ExitCase.errored(err),
        ).append(() => Pull.raiseError(err)),
      );
    });
  });

  static Pull<O, R> suspend<O, R>(Function0<Pull<O, R>> f) => Pull.unit.flatMap((_) => f());

  static final Pull<Never, Unit> unit = _Pure(Unit());

  const Pull();

  Pull<O, R2> append<R2>(Function0<Pull<O, R2>> next) => flatMap((_) => next());

  Pull<O, R2> as<R2>(R2 s) => map((_) => s);

  /// Runs this pull, then uses the result to determine the next pull.
  ///
  /// [f] is a function that receives the result of this pull and returns the next step.
  ///
  /// ### Type Safety Warning:
  ///
  /// This method performs an unsafe cast (`this as Pull<O2, R>`) to allow type widening.
  ///
  /// **The original type [O] ***MUST*** be a subtype of the new output type [O2].**
  ///
  /// * **Safe (Widening):** `Pull<Never, int>` to `Pull<String, int>` (Pure effect)
  /// * **Safe (Upcasting):** `Pull<String, Unit>` to `Pull<Object, Unit>`
  /// * **Unsafe (Downcasting):** `Pull<Object, Unit>` to `Pull<String, Unit>`
  ///
  /// If [O] is not a subtype of [O2], this function will throw a [TypeError].
  ///
  /// If Dart implements [Lower Type Bounds][https://github.com/dart-lang/language/issues/1674],
  /// this could be used to make this function compile-time safe.
  Pull<O2, R2> flatMap<O2, R2>(Function1<R, Pull<O2, R2>> f) => _Bind(this as Pull<O2, R>, Fn1(f));

  /// Maps the result type.
  Pull<O, R2> map<R2>(Function1<R, R2> f) => flatMap((r) => Pull.pure(f(r)));

  /// Handles errors raised in this Pull.
  Pull<O, R> handleErrorWith(Function1<Object, Pull<O, R>> f) => _Handle(this, Fn1(f));

  Pull<O, Unit> get voided => as(Unit());
}

extension PullFlattenOps<O, R> on Pull<O, Pull<O, R>> {
  Pull<O, R> flatten() => flatMap(identity);
}

/// Operations available ONLY when the result type is [Unit].
/// This ensures we can only inspect a "streaming" pull, not a calculated result.
extension PullOps<O> on Pull<O, Unit> {
  Rill<O> get rill => Rill._scoped(this);

  Rill<O> get rillNoScope => Rill._noScope(this);

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
                return Pull.done();
              } else {
                return f(chunk.head).flatMap((_) => runChunk(chunk.tail));
              }
            }

            return runChunk(head).flatMap((_) => next.flatMapOutput(f));
          case final _StepError<dynamic, dynamic> s:
            return Pull.raiseError(s.error);
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

  Pull<O2, Unit> unconsFlatMap<O2>(Function1<Chunk<O>, Pull<O2, Unit>> f) {
    return uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done(),
        (hd, tl) => f(hd).append(() => tl.unconsFlatMap(f)),
      );
    });
  }
}

class _Done<O, R> extends Pull<O, R> {}

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
  return IO.defer(() {
    return switch (pull) {
      final _Pure<R> _ => IO.pure(_StepDone(pull.value)),
      final _Fail _ => IO.pure(_StepError(pull.error)), // IO.raiseError(pull.error),
      final _Output<O> p => IO.pure(_StepOut(p.chunk, Pull.pure(Unit() as R))),
      final _Eval<R> _ => pull.action.redeem((err) => _StepError(err), (r) => _StepDone(r)),
      final _Bind<O, dynamic, R> _ => _stepBind(pull, scope),
      final _Handle<O, R> _ => _stepHandle(pull, scope),
      final _Acquire<R> _ => _stepAcquire(pull, scope),
      final _GetScope<O> _ => IO.pure(_StepDone(scope as R)),
      final _OpenScope<O> _ => Scope.create(scope).map((s) => _StepDone(s as R)),
      final _CloseScope<O> p => _stepCloseScope(p),
      final _RunInScope<O, R> _ => _stepRunInScope(pull),
      final _Done<O, R> _ => IO.pure(_StepDone(Unit() as R)),
      _ => IO.raiseError('Pull.stepPull: Unknown Pull type: $pull'),
    };
  });
}

IO<_Step<O, R>> _stepBind<O, X, R>(_Bind<O, X, R> bind, Scope scope) {
  final foo = _stepPull(bind.source, scope).flatMap((step) {
    return switch (step) {
      final _StepDone<O, X> _ => _stepPull(bind.k(step.result), scope),
      final _StepOut<O, X> _ => IO.pure(_StepOut(step.head, step.next.flatMap((x) => bind.k(x)))),
      final _StepError<O, X> step => IO.pure(_StepError<O, R>(step.error)),
    };
  });

  // final bar = stepPull(bind.source, scope).flatMap((step) {
  //   switch (step) {
  //     case final _StepDone<O, X> done:
  //       try {
  //         final nextPull = bind.k(done.result);
  //         return IO.defer(() => stepPull(nextPull, scope));
  //       } catch (e, st) {
  //         return IO.pure(_StepError<O, R>(e, st));
  //       }
  //     case _StepOut<O, X> _:
  //       return IO.pure(_StepOut(step.head, step.next.flatMap((x) => bind.k(x))));
  //     case final _StepError<O, X> err:
  //       return IO.pure(_StepError<O, R>(e, err.stackTrace));
  //   }
  // });

  return foo;
  // return IO.defer(() => foo);
  // throw UnimplementedError();
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
              _StepOut(step.head, step.next.handleErrorWith((e) => pull.handler(e))),
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

// _Bind<O, X, R> _rotateBinds<O, X, R>(_Bind<O, X, R> res) {
//   var current = res;

//   while (true) {
//     // rotate left nested binds to right nested for stack safety
//     // note this will not work with _Binds that don't match the type parameters
//     if (current is _Bind<O, dynamic, R>) {
//       final bind = current;

//       if (bind.source is _Bind) {
//         final sourceBind = bind.source as _Bind;

//         final s = sourceBind.source;
//         final f = sourceBind.k;
//         final g = bind.k;

//         current = _Bind(s, Fn1((x) => f(x).flatMap((y) => g.call(y as X))));

//         continue;
//       }
//     }

//     return current;
//   }
// }
