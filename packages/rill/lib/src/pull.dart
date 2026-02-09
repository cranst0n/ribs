part of 'rill.dart';

/// A `Pull` describes a process that can emit outputs of type [O], evaluate
/// effects of type `IO`, and eventually return a result of type [R].
sealed class Pull<O, R> {
  static final Pull<Never, Unit> done = unit;

  static Pull<Never, R> eval<R>(IO<R> io) => _Eval(io);

  static Pull<Never, Never> fail(Object err, [StackTrace? stackTrace]) => _Fail(err, stackTrace);

  static Pull<O, Unit> output<O>(Chunk<O> chunk) => _Output(chunk);

  static Pull<O, Unit> output1<O>(O value) => _Output(chunk([value]));

  static Pull<O, Unit> outputOption1<O>(Option<O> opt) =>
      opt.map(output1).getOrElse(() => Pull.done);

  static final Pull<Unit, Unit> outUnit = _Output(Chunk.unit);

  static Pull<Never, R> pure<R>(R r) => _Pure(r);

  static Pull<Never, Never> raiseError(Object err, [StackTrace? stackTrace]) =>
      _Fail(err, stackTrace);

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

  /// Registers a finalizer to run when this Pull completes, fails, or is cancelled.
  Pull<O, R> onFinalize(IO<Unit> finalizer) => onFinalizeCase((_) => finalizer);

  Pull<O, R> onFinalizeCase(Function1<ExitCase, IO<Unit>> finalizer) =>
      _Ensure(this, Fn1((ec) => finalizer(ec)));

  /// Handles errors raised in this Pull.
  Pull<O, R> handleErrorWith(Function1<Object, Pull<O, R>> f) => _Handle(this, Fn1(f));

  /// Converts this Pull into a Rill (discards result R).
  Rill<O> get rill => Rill(map((_) => Unit()));

  Pull<O, Unit> get voided => as(Unit());
}

extension PullFlattenOps<O, R> on Pull<O, Pull<O, R>> {
  Pull<O, R> flatten() => flatMap(identity);
}

/// Adds [uncons] ONLY when the result type is [Unit].
/// This ensures we can only inspect a "streaming" pull, not a calculated result.
extension PullOps<O> on Pull<O, Unit> {
  Rill<O> get rill => Rill(this);

  Pull<O2, Unit> flatMapOutput<O2>(Function1<O, Pull<O2, Unit>> f) {
    return Pull.eval(stepPull(this)).flatMap((step) {
      if (step is _StepDone<O, Unit>) {
        final x = Pull.pure<Unit>(step.result);
        return x;
      } else if (step is _StepOut<O, Unit>) {
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
      } else {
        return Pull.raiseError('Unexpected step state during flatmap output');
      }
    });
  }

  /// Peels off the next chunk of the current pull.
  ///
  /// Returns a Pull that emits nothing, but evaluates to an Option containing:
  /// - The next chunk [IList<O>]
  /// - The remainder of the pull [Pull<O, Unit>]
  Pull<Never, Option<(Chunk<O>, Pull<O, Unit>)>> get uncons {
    return Pull.eval(stepPull(this)).map((step) {
      if (step is _StepDone) {
        return none();
      } else if (step is _StepOut<O, Unit>) {
        return Some((step.head, step.next));
      } else {
        // Safe cast: Extension ensures R is Unit.
        throw 'Unexpected Step State during uncons';
      }
    });
  }

  Pull<O2, Unit> unconsFlatMap<O2>(Function1<Chunk<O>, Pull<O2, Unit>> f) {
    return uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.done,
        (hd, tl) => f(hd).append(() => tl.unconsFlatMap(f)),
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

class _Ensure<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Fn1<ExitCase, IO<Unit>> finalizer;
  const _Ensure(this.source, this.finalizer);
}

class _Handle<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Fn1<Object, Pull<O, R>> handler;

  const _Handle(this.source, this.handler);
}

sealed class _Step<O, R> {}

class _StepDone<O, R> extends _Step<O, R> {
  final R result;
  _StepDone(this.result);
}

class _StepOut<O, R> extends _Step<O, R> {
  final Chunk<O> head;
  final Pull<O, R> next;
  _StepOut(this.head, this.next);
}

IO<_Step<O, R>> stepPull<O, R>(Pull<O, R> pull) {
  return IO.defer(() {
    return switch (pull) {
      final _Pure<R> _ => IO.pure(_StepDone(pull.value)),
      final _Fail _ => IO.raiseError(pull.error),
      final _Output<O> p => IO.pure(_StepOut(p.chunk, Pull.pure(Unit() as R))),
      final _Eval<R> _ => pull.action.map((r) => _StepDone(r)),
      final _Bind<O, dynamic, R> _ => _stepBind(pull),
      final _Ensure<O, R> _ => _stepEnsure(pull),
      final _Handle<O, R> _ => _stepHandle(pull),
      _ => IO.raiseError('stepPull: Unknown Pull type: $pull'),
    };
  });
}

IO<_Step<O, R>> _stepBind<O, X, R>(_Bind<O, X, R> bind) {
  return stepPull(bind.source).flatMap((step) {
    return switch (step) {
      final _StepDone<O, X> _ => stepPull(bind.k(step.result)),
      final _StepOut<O, X> _ => IO.pure(_StepOut(step.head, step.next.flatMap((x) => bind.k(x)))),
    };
  });
}

IO<_Step<O, R>> _stepEnsure<O, R>(_Ensure<O, R> ensure) {
  return IO.uncancelable((poll) {
    return poll(stepPull(ensure.source))
        .onCancel(ensure.finalizer(ExitCase.canceled()))
        .flatMap<_Step<O, R>>((
          step,
        ) {
          return switch (step) {
            final _StepDone<O, R> _ => ensure.finalizer(ExitCase.succeeded()).as(step),
            final _StepOut<O, R> _ => IO.pure(
              _StepOut(step.head, _Ensure(step.next, ensure.finalizer)),
            ),
          };
        })
        .handleErrorWith(
          (err) => ensure.finalizer(ExitCase.errored(err)).flatMap((_) => IO.raiseError(err)),
        );
  });
}

IO<_Step<O, R>> _stepHandle<O, R>(_Handle<O, R> handle) {
  return stepPull(handle.source).attempt().flatMap((either) {
    return either.fold(
      (error) => stepPull(handle.handler(error)),
      (step) {
        return switch (step) {
          final _StepDone<O, R> _ => IO.pure(step),
          final _StepOut<O, R> _ => IO.pure(
            _StepOut(step.head, step.next.handleErrorWith((e) => handle.handler(e))),
          ),
        };
      },
    );
  });
}
