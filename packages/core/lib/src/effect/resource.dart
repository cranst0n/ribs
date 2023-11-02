import 'package:ribs_core/ribs_core.dart';

typedef Finalizer = Function1<ExitCase, IO<Unit>>;
typedef Update = Function1<Function1<Finalizer, Finalizer>, IO<Unit>>;

/// Resource is a type that encodes the idea of performing some kind of action
/// or allocation which in turn, requires a finalizer of some kind that must
/// be run to clean up the allocation.
///
/// A common example is opening a file to read/write to it, which requires
/// closing the file after, or else risking a leak.
sealed class Resource<A> extends Monad<A> {
  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result and the finalizer.
  static Resource<A> apply<A>(IO<(A, IO<Unit>)> resource) =>
      applyCase(resource.map((tup) => tup(
            (a, release) => (a, (_) => release),
          )));

  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result and the finalizer,
  /// which can discriminate the [ExitCase] of the evaluation.
  static Resource<A> applyCase<A>(
    IO<(A, Function1<ExitCase, IO<Unit>>)> resource,
  ) =>
      applyFull((_) => resource);

  /// Creates a resource from an allocating effect.
  ///
  /// The provided [resource] will supply both the result, which accepts a
  /// [Poll] that can be used for canelable resource acquisitions, and the
  /// finalizer, which can discriminate the [ExitCase] of the evaluation.
  static Resource<A> applyFull<A>(
    Function1<Poll, IO<(A, Function1<ExitCase, IO<Unit>>)>> resource,
  ) =>
      _Allocate(resource);

  /// Allocated both resources asynchronously, and combines the result from
  /// each into a tuple.
  static Resource<(A, B)> both<A, B>(Resource<A> ra, Resource<B> rb) {
    IO<C> allocate<C>(Resource<C> r, Update storeFinalizer) {
      return r._fold(
        IO.pure,
        (release, _) => storeFinalizer(
          (fin) =>
              (ec) => IO.unit.productR(() => fin(ec).guarantee(release(ec))),
        ),
      );
    }

    Finalizer noop() => (_) => IO.unit;
    final bothFinalizers = Ref.of((noop(), noop()));

    return Resource.makeCase(bothFinalizers, (finalizers, ec) {
      return finalizers.value().flatMap((a) {
        final (aFin, bFin) = a;
        return IO.both(aFin(ec), bFin(ec)).voided();
      });
    }).evalMap((store) {
      return IO.both(
        allocate(ra, (f) => store.update((a) => a.bimap(f, id))),
        allocate(rb, (f) => store.update((a) => a.bimap(id, f))),
      );
    });
  }

  /// Creates a Resource that is immediately canceled.
  static Resource<Unit> get canceled => Resource.eval(IO.canceled);

  /// Introduces an asynchronous boundary in the Resource/IO runtime loop that
  /// can be used for cancelation checking and fairness, among other things.
  static Resource<Unit> get cede => Resource.eval(IO.cede);

  /// Lifts the given [IO] [a] into a Resource, providing no finalizer.
  static Resource<A> eval<A>(IO<A> a) => _Eval(a);

  /// Creates a Resource using the allocation [acquire] and the finalizer
  /// [release].
  static Resource<A> make<A>(IO<A> acquire, Function1<A, IO<Unit>> release) =>
      apply(acquire.map((a) => (a, release(a))));

  /// Creates a Resource using the allocation [acquire] and the finalizer
  /// [release], which can take different actions depending on the [ExitCase].
  static Resource<A> makeCase<A>(
    IO<A> acquire,
    Function2<A, ExitCase, IO<Unit>> release,
  ) =>
      applyCase(acquire.map((a) => (a, (ec) => release(a, ec))));

  static Resource<A> makeFull<A>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<Unit>> release,
  ) =>
      applyFull((poll) => acquire(poll).map((a) => (a, (_) => release(a))));

  /// Returns a non-terminating Resource. An alias for
  /// `Resource.eval(IO.never())`.
  static Resource<A> never<A>() => Resource.eval(IO.never());

  /// Lifts the pure value [a] into [Resource].
  static Resource<A> pure<A>(A a) => _Pure(a);

  /// Creates a Resource that will inject the given error into the evaluation.
  static Resource<A> raiseError<A>(RuntimeException err) =>
      Resource.eval(IO.raiseError(err));

  /// Creates a new [Ref] with an initial value of [a], lifted into a
  /// [Resource].
  static Resource<Ref<A>> ref<A>(A a) => Resource.eval(Ref.of(a));

  /// Alias for `Resource.pure(Unit())`.
  static Resource<Unit> get unit => Resource.pure(Unit());

  /// Replaces the result of this [Resource] with the given value [b].
  Resource<B> as<B>(B b) => map((_) => b);

  /// Extracts any exceptions encountered during evaluation into an [Either]
  /// value.
  Resource<Either<RuntimeException, A>> attempt() => switch (this) {
        final _Allocate<A> a => Resource.applyFull(
            (poll) => a.resource(poll).attempt().map(
                  (att) => att.fold(
                    (err) => (err.asLeft(), (_) => IO.unit),
                    (a) => a((a, release) => (a.asRight(), release)),
                  ),
                ),
          ),
        final _Bind<dynamic, A> b => Resource.unit
            .flatMap((_) => b.source.attempt())
            .flatMap((att) => att.fold(
                  (err) => Resource.pure(err.asLeft()),
                  (s) => b.fs(s).attempt(),
                )),
        final _Pure<A> p => Resource.pure(p.a.asRight()),
        final _Eval<A> e => Resource.eval(e.fa.attempt()),
        _ => throw StateError('Unhandled Resource.attempt: $this')
      };

  /// Applies the side-effecting function [f] to the value generated by this
  /// resource, returning it's value.
  Resource<B> evalMap<B>(Function1<A, IO<B>> f) =>
      flatMap((a) => Resource.eval(f(a)));

  /// Performs the side-effect encoded in [f] using the value created by this
  /// Resource, then returning the original value.
  Resource<A> evalTap<B>(Function1<A, IO<B>> f) =>
      flatMap((a) => Resource.eval(f(a)).as(a));

  @override
  Resource<B> flatMap<B>(covariant Function1<A, Resource<B>> f) =>
      _Bind(this, Fn1.of(f));

  /// Intercepts any upstream errors, sequencing in the [Resource] generated
  /// by [f].
  Resource<A> handleErrorWith(Function1<RuntimeException, Resource<A>> f) =>
      attempt()
          .flatMap((att) => att.fold((err) => f(err), (a) => Resource.pure(a)));

  @override
  Resource<B> map<B>(Function1<A, B> f) => flatMap((a) => Resource.pure(f(a)));

  /// Runs [precede] prior to the allocation of this resource.
  Resource<A> preAllocate(IO<Unit> precede) =>
      Resource.eval(precede).flatMap((_) => this);

  /// Allocates this resource, runs [fb] and then closes this resource when
  /// [fb] finishes, regardless of the outcome.
  IO<B> surround<B>(IO<B> fb) => use((_) => fb);

  /// Allocates this resource and provides it to the given function [f]. When
  /// [f] completes, regardless of the outcome, the finalizer for this
  /// Resource will be invoked.
  IO<B> use<B>(Function1<A, IO<B>> f) => _fold(f, (a, b) => a(b));

  /// Like [use] but allocates the resource and then immediately releases it.
  IO<Unit> use_() => use((_) => IO.unit);

  /// Allocates this resource and supplies a function that will never
  /// finish, meaning the resource finalizer will not be invoked.
  IO<Never> useForever() => use((_) => IO.never());

  // Interpreter
  IO<B> _fold<B>(
    Function1<A, IO<B>> onOutput,
    Function2<Function1<ExitCase, IO<Unit>>, ExitCase, IO<Unit>> onRelease,
  ) {
    // TODO: Not stack safe.
    IO<B> loop(Resource<dynamic> current, _ResourceStack<dynamic> stack) {
      switch (current) {
        case final _Allocate<dynamic> a:
          return IO.bracketFull(
            a.resource,
            (tuple) {
              final (a, _) = tuple;

              return switch (stack) {
                _Nil<dynamic> _ => onOutput(a as A),
                final _StackFrame<dynamic, dynamic> f =>
                  loop(f.head(a), f.tail),
              };
            },
            (a, oc) {
              final (_, release) = a;

              return onRelease(release, ExitCase.fromOutcome(oc));
            },
          );

        case final _Bind<dynamic, dynamic> b:
          return loop(b.source, _StackFrame(b.fs.call, stack));
        case final _Pure<dynamic> p:
          return switch (stack) {
            _Nil<dynamic> _ => onOutput(p.a as A),
            final _StackFrame<dynamic, dynamic> f => loop(f.head(p.a), f.tail),
          };
        case final _Eval<dynamic> ev:
          return ev.fa.flatMap((a) => loop(Resource.pure(a), stack));
      }
    }

    return loop(this, _Nil<A>());
  }
}

extension ResourceIOOps<A> on Resource<IO<A>> {
  IO<A> useEval() => use(id);
}

sealed class _ResourceStack<A> {}

final class _Nil<A> extends _ResourceStack<A> {}

final class _StackFrame<AA, BB> extends _ResourceStack<AA> {
  final Function1<AA, Resource<BB>> head;
  final _ResourceStack<BB> tail;

  _StackFrame(this.head, this.tail);
}

final class _Allocate<A> extends Resource<A> {
  final Function1<Poll, IO<(A, Function1<ExitCase, IO<Unit>>)>> resource;

  _Allocate(this.resource);
}

final class _Bind<S, A> extends Resource<A> {
  final Resource<S> source;
  final Fn1<S, Resource<A>> fs;

  _Bind(this.source, this.fs);
}

final class _Pure<A> extends Resource<A> {
  final A a;

  _Pure(this.a);
}

final class _Eval<A> extends Resource<A> {
  final IO<A> fa;

  _Eval(this.fa);
}
