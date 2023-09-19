import 'package:ribs_core/ribs_core.dart';

typedef Finalizer = Function1<ExitCase, IO<Unit>>;
typedef Update = Function1<Function1<Finalizer, Finalizer>, IO<Unit>>;

sealed class Resource<A> extends Monad<A> {
  static Resource<A> apply<A>(IO<(A, IO<Unit>)> resource) =>
      applyCase(resource.map((tup) => tup(
            (a, release) => (a, (_) => release),
          )));

  static Resource<A> applyCase<A>(
    IO<(A, Function1<ExitCase, IO<Unit>>)> resource,
  ) =>
      applyFull((_) => resource);

  static Resource<A> applyFull<A>(
    Function1<Poll, IO<(A, Function1<ExitCase, IO<Unit>>)>> resource,
  ) =>
      _Allocate(resource);

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

  static Resource<Unit> get canceled => Resource.eval(IO.canceled);

  static Resource<Unit> get cede => Resource.eval(IO.cede);

  static Resource<A> eval<A>(IO<A> a) => _Eval(a);

  static Resource<A> make<A>(IO<A> acquire, Function1<A, IO<Unit>> release) =>
      apply(acquire.map((a) => (a, release(a))));

  static Resource<A> makeCase<A>(
    IO<A> acquire,
    Function2<A, ExitCase, IO<Unit>> release,
  ) =>
      applyCase(acquire.map((a) => (a, (ec) => release(a, ec))));

  static Resource<A> never<A>() => Resource.eval(IO.never());

  static Resource<A> pure<A>(A a) => _Pure(a);

  static Resource<A> raiseError<A>(IOError err) =>
      Resource.eval(IO.raiseError(err));

  static Resource<Ref<A>> ref<A>(A a) => Resource.eval(Ref.of(a));

  static Resource<Unit> get unit => _Pure(Unit());

  Resource<B> as<B>(B b) => map((_) => b);

  Resource<Either<IOError, A>> attempt() => switch (this) {
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
        _ => throw UnimplementedError('Unhandled Resource.attempt: $this')
      };

  Resource<B> evalMap<B>(Function1<A, IO<B>> f) =>
      flatMap((a) => Resource.eval(f(a)));

  Resource<A> evalTap<B>(Function1<A, IO<B>> f) =>
      flatMap((a) => Resource.eval(f(a)).as(a));

  @override
  Resource<B> flatMap<B>(covariant Function1<A, Resource<B>> f) =>
      _Bind(this, Fn1.of(f));

  Resource<A> handleErrorWith(Function1<IOError, Resource<A>> f) => attempt()
      .flatMap((att) => att.fold((err) => f(err), (a) => Resource.pure(a)));

  @override
  Resource<B> map<B>(Function1<A, B> f) => flatMap((a) => Resource.pure(f(a)));

  Resource<A> preAllocate(IO<Unit> precede) =>
      Resource.eval(precede).flatMap((_) => this);

  IO<B> surround<B>(IO<B> fb) => use((_) => fb);

  IO<B> use<B>(Function1<A, IO<B>> f) => _fold(f, (a, b) => a(b));

  IO<Unit> use_() => use((_) => IO.unit);

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
                Nil<dynamic> _ => onOutput(a as A),
                final StackFrame<dynamic, dynamic> f => loop(f.head(a), f.tail),
              };
            },
            (a, oc) {
              final (_, release) = a;

              return onRelease(release, ExitCase.fromOutcome(oc));
            },
          );

        case final _Bind<dynamic, dynamic> b:
          return loop(b.source, StackFrame(b.fs.call, stack));
        case final _Pure<dynamic> p:
          return switch (stack) {
            Nil<dynamic> _ => onOutput(p.a as A),
            final StackFrame<dynamic, dynamic> f => loop(f.head(p.a), f.tail),
          };
        case final _Eval<dynamic> ev:
          return ev.fa.flatMap((a) => loop(Resource.pure(a), stack));
      }
    }

    return loop(this, Nil<A>());
  }
}

extension ResourceIOOps<A> on Resource<IO<A>> {
  IO<A> useEval() => use(id);
}

sealed class _ResourceStack<A> {}

final class Nil<A> extends _ResourceStack<A> {}

final class StackFrame<AA, BB> extends _ResourceStack<AA> {
  final Function1<AA, Resource<BB>> head;
  final _ResourceStack<BB> tail;

  StackFrame(this.head, this.tail);
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
