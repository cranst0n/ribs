import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/rill/ref.dart';

class Scope {
  final Option<Scope> parent;
  final ScopeId id;
  final Ref<ScopeState> state; // TODO: Is Ref necessary?

  const Scope(this.parent, this.id, this.state);

  static Scope get root =>
      Scope(none(), ScopeId(), Ref.of(ScopeState.open(IO.unit, IList.empty())));

  IO<Scope> open(IO<Unit> finalizer) {
    return state.modify((state) {
      return state.fold(
        (open) {
          final sub = Scope(Some(this), ScopeId(),
              Ref.of(ScopeState.open(finalizer, IList.empty())));

          return Tuple2(
            ScopeState.open(open.finalizer, open.subScopes.append(sub)),
            IO.pure(sub),
          );
        },
        () {
          final next = parent.fold(
            () => IO.raiseError<Scope>(StateError('root scope already closed')),
            (p) => p.open(finalizer),
          );

          return Tuple2(ScopeState.closed, next);
        },
      );
    }).flatten;
  }

  IO<Unit> get close {
    return state.modify((state) {
      return state.fold(
        (open) {
          final finalizers =
              open.subScopes.reverse.map((a) => a.close).append(open.finalizer);

          // Ensure all finalizers are called, regardless of failures
          IO<Unit> go(IList<IO<Unit>> rem, Option<IOError> error) {
            return rem.uncons((hd, tl) {
              return hd.fold(() {
                return error.fold(
                  () => IO.unit,
                  (e) => IO.raiseError(e),
                );
              }, (hd) {
                return hd.attempt().flatMap(
                    (res) => go(tl, error.orElse(() => res.swap.toOption)));
              });
            });
          }

          return Tuple2(ScopeState.closed, go(finalizers, none()));
        },
        () => Tuple2(ScopeState.closed, IO.unit),
      );
    }).flatten;
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
