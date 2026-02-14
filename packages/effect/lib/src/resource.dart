import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

typedef _Finalizer = Function1<ExitCase, IO<Unit>>;
typedef _Update = Function1<Function1<_Finalizer, _Finalizer>, IO<Unit>>;

/// Resource is a type that encodes the idea of performing some kind of action
/// or allocation which in turn, requires a finalizer of some kind that must
/// be run to clean up the allocation.
///
/// A common example is opening a file to read/write to it, which requires
/// closing the file after, or else risking a leak.
sealed class Resource<A> with Functor<A>, Applicative<A>, Monad<A> {
  const Resource();

  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result and the finalizer.
  static Resource<A> apply<A>(IO<(A, IO<Unit>)> resource) => applyCase(
    resource.map(
      (tup) => tup(
        (a, release) => (a, (_) => release),
      ),
    ),
  );

  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result and the finalizer,
  /// which can discriminate the [ExitCase] of the evaluation.
  static Resource<A> applyCase<A>(
    IO<(A, Function1<ExitCase, IO<Unit>>)> resource,
  ) => applyFull((_) => resource);

  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result, which accepts a
  /// [Poll] that can be used for canelable resource acquisitions, and the
  /// finalizer, which can discriminate the [ExitCase] of the evaluation.
  static Resource<A> applyFull<A>(
    Function1<Poll, IO<(A, Function1<ExitCase, IO<Unit>>)>> resource,
  ) => Allocate(Fn1(resource));

  /// Allocated both resources asynchronously, and combines the result from
  /// each into a tuple.
  static Resource<(A, B)> both<A, B>(Resource<A> ra, Resource<B> rb) {
    IO<C> allocate<C>(Resource<C> r, _Update storeFinalizer) {
      return _interpretUse(
        r,
        IO.pure,
        (release, _) => storeFinalizer(
          (fin) => (ec) => IO.unit.productR(() => fin(ec).guarantee(release(ec))),
        ),
      );
    }

    _Finalizer noop() => (_) => IO.unit;
    final bothFinalizers = Ref.of((noop(), noop()));

    return Resource.makeCase(bothFinalizers, (finalizers, ec) {
      return finalizers.value().flatMap((a) {
        final (aFin, bFin) = a;
        return IO.both(aFin(ec), bFin(ec)).voided();
      });
    }).evalMap((store) {
      return IO.both(
        allocate(ra, (f) => store.update((a) => (f(a.$1), a.$2))),
        allocate(rb, (f) => store.update((a) => (a.$1, f(a.$2)))),
      );
    });
  }

  /// Creates a Resource that is immediately canceled.
  static Resource<Unit> get canceled => Resource.eval(IO.canceled);

  /// Introduces an asynchronous boundary in the Resource/IO runtime loop that
  /// can be used for cancelation checking and fairness, among other things.
  static Resource<Unit> get cede => Resource.eval(IO.cede);

  /// Lifts the given [IO] [a] into a Resource, providing no finalizer.
  static Resource<A> eval<A>(IO<A> a) => Eval(a);

  /// Creates a Resource using the allocation [acquire] and the finalizer
  /// [release].
  static Resource<A> make<A>(IO<A> acquire, Function1<A, IO<Unit>> release) =>
      apply(acquire.map((a) => (a, release(a))));

  /// Creates a Resource using the allocation [acquire] and the finalizer
  /// [release], which can take different actions depending on the [ExitCase].
  static Resource<A> makeCase<A>(
    IO<A> acquire,
    Function2<A, ExitCase, IO<Unit>> release,
  ) => applyCase(acquire.map((a) => (a, (ec) => release(a, ec))));

  static Resource<A> makeCaseFull<A>(
    Function1<Poll, IO<A>> acquire,
    Function2<A, ExitCase, IO<Unit>> release,
  ) => applyFull((poll) => acquire(poll).map((a) => (a, (ec) => release(a, ec))));

  static Resource<A> makeFull<A>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<Unit>> release,
  ) => applyFull((poll) => acquire(poll).map((a) => (a, (_) => release(a))));

  /// Returns a non-terminating Resource. An alias for
  /// `Resource.eval(IO.never())`.
  static Resource<A> never<A>() => Resource.eval(IO.never());

  /// Lifts the pure value [a] into [Resource].
  static Resource<A> pure<A>(A a) => Pure(a);

  static Resource<Either<A, B>> race<A, B>(Resource<A> ra, Resource<B> rb) {
    return Resource.applyFull((poll) {
      IO<Unit> cancelLoser<C>(IOFiber<(C, Function1<ExitCase, IO<Unit>>)> f) {
        throw UnimplementedError();
      }

      return poll(IO.racePair(ra.allocatedCase(), rb.allocatedCase())).flatMap((either) {
        return either.fold(
          (leftTuple) {
            final (oc, f) = leftTuple;

            return oc.fold(
              () => f.cancel().productR(() => f.join()).flatMap((oc) {
                return oc.fold(
                  () => poll(IO.canceled).productR(() => IO.never()),
                  (err, _) => IO.raiseError(err),
                  (b) => IO.pure((b.$1.asRight(), b.$2)),
                );
              }),
              (err, _) => IO
                  .raiseError<(Either<A, B>, Function1<ExitCase, IO<Unit>>)>(err)
                  .guarantee(cancelLoser(f)),
              (aFin) {
                final (a, fin) = aFin;

                return cancelLoser(f).start().flatMap((f) {
                  return IO.pure((
                    a.asLeft(),
                    (ExitCase x) => fin(x).guarantee(f.join().flatMap((oc) => oc.embedNever())),
                  ));
                });
              },
            );
          },
          (rightTuple) {
            final (f, oc) = rightTuple;

            return oc.fold(
              () => f.cancel().productR(() => f.join()).flatMap((oc) {
                return oc.fold(
                  () => poll(IO.canceled).productR(() => IO.never()),
                  (err, _) => IO.raiseError(err),
                  (b) => IO.pure((b.$1.asLeft(), b.$2)),
                );
              }),
              (err, _) => IO
                  .raiseError<(Either<A, B>, Function1<ExitCase, IO<Unit>>)>(err)
                  .guarantee(cancelLoser(f)),
              (aFin) {
                final (a, fin) = aFin;

                return cancelLoser(f).start().flatMap((f) {
                  return IO.pure((
                    a.asRight(),
                    (ExitCase x) => fin(x).guarantee(f.join().flatMap((oc) => oc.embedNever())),
                  ));
                });
              },
            );
          },
        );
      });
    });
  }

  /// Creates a Resource that will inject the given error into the evaluation.
  static Resource<A> raiseError<A>(Object err) => Resource.eval(IO.raiseError(err));

  /// Creates a new [Ref] with an initial value of [a], lifted into a
  /// [Resource].
  static Resource<Ref<A>> ref<A>(A a) => Resource.eval(Ref.of(a));

  static Resource<A> suspend<A>(IO<Resource<A>> fr) => Resource.eval(fr).flatMap((r) => r);

  /// Alias for `Resource.pure(Unit())`.
  static Resource<Unit> get unit => Resource.pure(Unit());

  IO<(A, IO<Unit>)> allocated() => IO.uncancelable(
    (poll) => poll(allocatedCase()).mapN((b, fin) => (b, fin(ExitCase.succeeded()))),
  );

  /// Returns the resource and a release function that accepts an ExitCase.
  IO<(A, Function1<ExitCase, IO<Unit>>)> allocatedCase() =>
      _interpretAllocatedCase(this, (_) => IO.unit);

  /// Replaces the result of this [Resource] with the given value [b].
  Resource<B> as<B>(B b) => map((_) => b);

  /// Extracts any exceptions encountered during evaluation into an [Either]
  /// value.
  Resource<Either<Object, A>> attempt() {
    final current = _rotateBinds(this);

    return switch (current) {
      final Allocate<A> a => Resource.applyFull(
        (poll) => a
            .resource(poll)
            .attempt()
            .map(
              (att) => att.fold(
                (err) => (err.asLeft(), (_) => IO.unit),
                (a) => a((a, release) => (a.asRight(), release)),
              ),
            ),
      ),
      final Bind<dynamic, A> b => Resource.unit
          .flatMap((_) => b.source.attempt())
          .flatMap(
            (att) => att.fold(
              (err) => Resource.pure(err.asLeft()),
              (s) => b.f(s).attempt(),
            ),
          ),
      final Pure<A> p => Resource.pure(p.value.asRight()),
      final Eval<A> e => Resource.eval(e.task.attempt()),
      _ => throw UnimplementedError(),
    };
  }

  /// Applies the side-effecting function [f] to the value generated by this
  /// resource, returning it's value.
  Resource<B> evalMap<B>(Function1<A, IO<B>> f) => flatMap((a) => Resource.eval(f(a)));

  /// Performs the side-effect encoded in [f] using the value created by this
  /// Resource, then returning the original value.
  Resource<A> evalTap<B>(Function1<A, IO<B>> f) => flatMap((a) => Resource.eval(f(a)).as(a));

  @override
  Resource<B> flatMap<B>(Function1<A, Resource<B>> f) => Bind(this, Fn1(f));

  Resource<A> guaranteeCase(Function1<Outcome<A>, Resource<Unit>> fin) {
    return Resource.applyFull((poll) {
      return poll(allocatedCase()).guaranteeCase((outcome) {
        return outcome.fold(
          () => fin(Outcome.canceled()).use_(),
          (err, st) => fin(Outcome.errored(err, st)).use_().handleError((_) => Unit()),
          (ft) {
            final (a, finEC) = ft;

            return fin(Outcome.succeeded(a)).use_().handleErrorWith(
              (err) => finEC(
                ExitCase.errored(err),
              ).handleError((_) => Unit()).productR(() => IO.raiseError(err)),
            );
          },
        );
      });
    });
  }

  /// Intercepts any upstream errors, sequencing in the [Resource] generated
  /// by [f].
  Resource<A> handleErrorWith(Function1<Object, Resource<A>> f) =>
      attempt().flatMap((att) => att.fold((err) => f(err), (a) => Resource.pure(a)));

  @override
  Resource<B> map<B>(Function1<A, B> f) => flatMap((a) => Resource.pure(f(a)));

  Resource<A> onCancel(Resource<Unit> fin) =>
      Resource.applyFull((poll) => poll(allocatedCase()).onCancel(fin.use_()));

  Resource<A> onFinalize(IO<Unit> f) => onFinalizeCase((_) => f);

  Resource<A> onFinalizeCase(Function1<ExitCase, IO<Unit>> f) =>
      Resource.makeCase(IO.unit, (_, ec) => f(ec)).flatMap((_) => this);

  /// Runs [precede] prior to the allocation of this resource.
  Resource<A> preAllocate(IO<Unit> precede) => Resource.eval(precede).flatMap((_) => this);

  /// Allocates this resource, runs [fb] and then closes this resource when
  /// [fb] finishes, regardless of the outcome.
  IO<B> surround<B>(IO<B> fb) => use((_) => fb);

  /// Allocates this resource and provides it to the given function [f]. When
  /// [f] completes, regardless of the outcome, the finalizer for this
  /// Resource will be invoked.
  IO<B> use<B>(Function1<A, IO<B>> f) => _interpretUse(this, f, (a, b) => a(b));

  /// Like [use] but allocates the resource and then immediately releases it.
  IO<Unit> use_() => use((_) => IO.unit);

  /// Allocates this resource and supplies a function that will never
  /// finish, meaning the resource finalizer will not be invoked.
  IO<Never> useForever() => use((_) => IO.never());

  Resource<Unit> voided() => as(Unit());
}

extension ResourceIOOps<A> on Resource<IO<A>> {
  IO<A> useEval() => use(identity);
}

class Pure<A> extends Resource<A> {
  final A value;

  const Pure(this.value);
}

class Eval<A> extends Resource<A> {
  final IO<A> task;

  const Eval(this.task);
}

class Allocate<A> extends Resource<A> {
  final Fn1<Poll, IO<(A, Function1<ExitCase, IO<Unit>>)>> resource;

  const Allocate(this.resource);
}

class Bind<S, A> extends Resource<A> {
  final Resource<S> source;
  final Fn1<S, Resource<A>> f;

  const Bind(this.source, this.f);
}

/// Interpreter for `allocatedCase`.
/// Returns (Value, ExitCase -> [IO<Unit>]).
IO<(A, Function1<ExitCase, IO<Unit>>)> _interpretAllocatedCase<A>(
  Resource<A> res,
  Function1<ExitCase, IO<Unit>> release,
) {
  final current = _rotateBinds(res);

  return switch (current) {
    // 1. Pure: Release does nothing.
    Pure(value: final v) => IO.pure((v, release)),

    // 2. Eval: Release does nothing.
    Eval(task: final task) => task.map((a) => (a, release)),

    // 3. AllocateCase: Uses the provided release logic directly.
    Allocate(:final resource) => IO.uncancelable((poll) {
      return resource(poll).map((tuple) {
        final (b, rel) = tuple;

        return (
          b,
          (ec) => rel(ec).guarantee(IO.unit.productR(() => release(ec))),
        );
      });
    }),

    // 4. Bind: Composition logic.
    Bind<dynamic, dynamic>(:final source, :final f) => _interpretAllocatedCase(
      source,
      release,
    ).flatMap(
      (tupleS) {
        final (s, releaseS) = tupleS;

        Resource<A> nextRes;

        try {
          nextRes = f(s) as Resource<A>;
        } catch (e) {
          // If `f` throws, we must release S with the error.
          return releaseS(ExitCase.errored(e)).flatMap((_) => IO.raiseError(e));
        }

        return _interpretAllocatedCase(nextRes, release)
            .onError((e) {
              // If acquiring A fails (error/cancel), release S with that error.
              return releaseS(ExitCase.errored(e));
            })
            .map((tupleA) {
              final a = tupleA.$1;
              final releaseA = tupleA.$2; // (ExitCase) -> IO<Unit>

              // Combined Release Function.
              // When the user eventually calls this with an ExitCase (e.g. Cancelled):
              // 1. We release A with Cancelled.
              // 2. We release S with Cancelled.
              IO<Unit> combinedRelease(ExitCase ec) => releaseA(ec).guarantee(releaseS(ec));

              return (a, combinedRelease);
            });
      },
    ),
  };
}

/// Interpreter for `use`.
///
/// This compiles the Resource ADT into a single IO that guarantees
/// correct acquisition and release order using `bracket` and `bracketCase`.
IO<B> _interpretUse<A, B>(
  Resource<A> res,
  Function1<A, IO<B>> useFn,
  Function2<Function1<ExitCase, IO<Unit>>, ExitCase, IO<Unit>> onRelease,
) {
  final current = _rotateBinds(res);

  return switch (current) {
    // 1. Pure: Just run the function.
    Pure(:final value) => useFn(value),

    // 2. Eval: Run the effect, then the function.
    Eval(:final task) => task.flatMap(useFn),

    // 3. AllocateCase: Use bracketCase.
    // This provides the ExitCase (Success, Error, Canceled) to the release function.
    Allocate(:final resource) => IO.bracketFull(
      resource.call,
      (tuple) => useFn(tuple.$1),
      (a, oc) {
        final (_, release) = a;
        return onRelease(release, ExitCase.fromOutcome(oc));
      },
    ),

    // 4. Bind: Recursive composition.
    // We interpret the 'source' resource first.
    // Its "usage" block becomes the interpretation of the 'next' resource.
    Bind<dynamic, dynamic>(:final source, :final f) => _interpretUse(source, (s) {
      Resource<A> nextRes;

      try {
        nextRes = f(s) as Resource<A>;
      } catch (e) {
        // If the bind function throws, we must fail immediately.
        // Because we are inside the 'usage' block of 'source',
        // 'source' will automatically be released by its own bracket.
        return IO.raiseError(e);
      }

      // Now interpret the next resource, passing the original useFn down.
      return _interpretUse(nextRes, useFn, onRelease);
    }, onRelease),
  };
  // }
}

Resource<A> _rotateBinds<A>(Resource<A> res) {
  var current = res;

  while (true) {
    // rotate left nested binds to right nested for stack safety
    // note this will not work with _Binds that don't match the type parameters
    if (current is Bind<dynamic, A>) {
      final bind = current;

      if (bind.source is Bind) {
        final sourceBind = bind.source as Bind;

        final s = sourceBind.source;
        final f = sourceBind.f;
        final g = bind.f;

        current = Bind(s, Fn1((x) => f(x).flatMap(g.call)));

        continue;
      }
    }

    return current;
  }
}
