import 'package:ribs_core/ribs_core.dart';

class Scope {
  final Option<Scope> parent;
  final ScopeId id;
  final Ref<ScopeState> state;

  const Scope(this.parent, this.id, this.state);

  static Scope get root =>
      Scope(none(), ScopeId(), Ref(ScopeState.open(IO.unit, IList.empty())));

  IO<Scope> open(IO<Unit> finalizer) {
    return state.modify((state) {
      return state.fold(
        (openState) {
          final sub = Scope(Some(this), ScopeId(),
              Ref(ScopeState.open(finalizer, IList.empty())));

          return Tuple2(
            ScopeState.open(
                openState.finalizer, openState.subScopes.append(sub)),
            IO.pure(sub),
          );
        },
        () {
          final nextScope = parent.fold(
            () => IO.raiseError<Scope>(StateError('root scope already closed')),
            (p) => p.open(finalizer),
          );

          return Tuple2(ScopeState.closed, nextScope);
        },
      );
    }).flatten();
  }

  IO<Unit> get close => state.modify((state) {
        return state.fold(
          (open) {
            final finalizers = open.subScopes
                .reverse()
                .map((a) => a.close)
                .append(open.finalizer);

            // Ensure all finalizers are called, regardless of failures
            IO<Unit> go(IList<IO<Unit>> rem, Option<IOError> error) =>
                rem.uncons(
                  (hd, tl) => hd.fold(
                    () => error.fold(
                      () => IO.unit,
                      (err) => IO.raiseError(err),
                    ),
                    (hd) => hd.attempt().flatMap((res) =>
                        go(tl, error.orElse(() => res.swap().toOption()))),
                  ),
                );

            return Tuple2(ScopeState.closed, go(finalizers, none()));
          },
          () => Tuple2(ScopeState.closed, IO.unit),
        );
      }).flatten();

  IO<Option<Scope>> findScope(ScopeId target) {
    return findThisOrSubScope(target).flatMap((scope) {
      return scope.fold(
        () => parent.fold(
          () => IO.pure(none()),
          (p) => p.findScope(target),
        ),
        (s) => IO.pure(s.some),
      );
    });
  }

  IO<Option<Scope>> findThisOrSubScope(ScopeId target) {
    if (id == target) {
      return IO.pure(Some(this));
    } else {
      return state.value().flatMap((state) {
        return state.fold(
          (open) {
            IO<Option<Scope>> go(IList<Scope> rem) {
              return rem.uncons((hd, tl) {
                return hd.fold(
                  () => IO.pure(none()),
                  (hd) {
                    return hd.findThisOrSubScope(target).flatMap((scope) {
                      return scope.fold(
                        () => go(tl),
                        (scope) => IO.pure(scope.some),
                      );
                    });
                  },
                );
              });
            }

            return go(open.subScopes);
          },
          () => IO.pure(none()),
        );
      });
    }
  }
}

class ScopeId {}

abstract class ScopeState {
  const ScopeState();

  static ScopeState open(IO<Unit> finalizer, IList<Scope> subScopes) =>
      Open(finalizer, subScopes);

  static ScopeState get closed => Closed();

  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed);
}

class Open extends ScopeState {
  final IO<Unit> finalizer;
  final IList<Scope> subScopes;

  const Open(this.finalizer, this.subScopes);

  @override
  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed) => ifOpen(this);
}

class Closed extends ScopeState {
  @override
  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed) => ifClosed();
}
