import 'package:ribs_core/ribs_core.dart';

final class Scope {
  final Option<Scope> parent;
  final ScopeId id;
  final Ref<ScopeState> state;

  const Scope(this.parent, this.id, this.state);

  static IO<Scope> root() => Ref.of(ScopeState.open(IO.unit, IList.empty()))
      .map((state) => Scope(none(), ScopeId(), state));

  IO<Scope> open(IO<Unit> finalizer) {
    return state.modify((state) {
      final next = state.fold(
        (openState) {
          final sub = Scope(Some(this), ScopeId(),
              Ref.unsafe(ScopeState.open(finalizer, IList.empty())));

          return (
            ScopeState.open(
                openState.finalizer, openState.subScopes.append(sub)),
            IO.pure(sub),
          );
        },
        () {
          final nextScope = parent.fold(
            () => IO.raiseError<Scope>(IOError('root scope already closed')),
            (p) => p.open(finalizer),
          );

          return (ScopeState.closed, nextScope);
        },
      );

      return next;
    }).flatten();
  }

  IO<Unit> get close => state.modify((state) {
        final next = state.fold(
          (open) {
            final finalizers = open.subScopes
                .reverse()
                .map((a) => a.close)
                .append(open.finalizer);

            // Ensure all finalizers are called, regardless of failures
            IO<Unit> go(IList<IO<Unit>> rem, Option<IOError> error) =>
                rem.uncons(
                  (a) {
                    return a.fold(
                      () => error.fold(
                        () => IO.unit,
                        (err) => IO.raiseError(err),
                      ),
                      (a) {
                        final (hd, tl) = a;
                        return hd.attempt().flatMap((res) =>
                            go(tl, error.orElse(() => res.swap().toOption())));
                      },
                    );
                  },
                );

            return (ScopeState.closed, go(finalizers, none()));
          },
          () => (ScopeState.closed, IO.unit),
        );

        return next;
      }).flatten();

  IO<Option<Scope>> findScope(ScopeId target) {
    return findThisOrSubScope(target).flatMap((scope) {
      return scope.fold(
        () => parent.fold(
          () => IO.pure(none()),
          (p) => p.findScope(target),
        ),
        (s) => IO.pure(Some(s)),
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
              return rem.uncons(
                (a) => a.fold(
                  () => IO.pure(none()),
                  (a) {
                    final (hd, tl) = a;
                    return hd.findThisOrSubScope(target).flatMap((scope) {
                      return scope.fold(
                        () => go(tl),
                        (scope) => IO.pure(Some(scope)),
                      );
                    });
                  },
                ),
              );
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

sealed class ScopeState {
  const ScopeState();

  static ScopeState open(IO<Unit> finalizer, IList<Scope> subScopes) =>
      Open(finalizer, subScopes);

  static ScopeState get closed => Closed();

  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed);
}

final class Open extends ScopeState {
  final IO<Unit> finalizer;
  final IList<Scope> subScopes;

  const Open(this.finalizer, this.subScopes);

  @override
  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed) => ifOpen(this);
}

final class Closed extends ScopeState {
  @override
  B fold<B>(Function1<Open, B> ifOpen, Function0<B> ifClosed) => ifClosed();
}
