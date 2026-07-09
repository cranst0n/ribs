import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A hold on a [Scope] that defers its closure until the lease is released.
///
/// Acquire via [Scope.lease]; release via [cancel] when the hold is no longer
/// needed. When all outstanding leases on a closed scope are released, the
/// scope's finalizers run.
class Lease {
  /// Releases this lease.
  ///
  /// If this was the last outstanding lease and the scope has already been
  /// closed, the scope's finalizers run immediately. Returns [Right] on
  /// success or [Left] with an aggregated error if any finalizer failed.
  final IO<Either<Object, Unit>> cancel;

  /// Creates a [Lease] whose [cancel] action releases the hold on the scope.
  const Lease(this.cancel);
}

final class _ScopeState {
  final IList<Function1<ExitCase, IO<Unit>>> finalizers;
  final bool closed;
  final int leaseCount;
  final Option<ExitCase> pendingClose;

  const _ScopeState(this.finalizers, this.closed, this.leaseCount, this.pendingClose);

  static _ScopeState initial() =>
      _ScopeState(nil<Function1<ExitCase, IO<Unit>>>(), false, 0, none<ExitCase>());

  /// The terminal state after finalizers have been claimed by a closer.
  static _ScopeState done() =>
      _ScopeState(nil<Function1<ExitCase, IO<Unit>>>(), true, 0, none<ExitCase>());

  _ScopeState withFinalizers(IList<Function1<ExitCase, IO<Unit>>> finalizers) =>
      _ScopeState(finalizers, closed, leaseCount, pendingClose);

  _ScopeState withLeaseCount(int leaseCount) =>
      _ScopeState(finalizers, closed, leaseCount, pendingClose);

  _ScopeState closedPendingLeases(ExitCase ec) =>
      _ScopeState(finalizers, true, leaseCount, Some(ec));
}

/// Tracks resource finalizers for a subtree of a [Pull] computation.
///
/// Scopes form a parent-child tree. Resources acquired inside a child scope
/// are released (in LIFO order) when that scope closes. If a parent scope
/// closes, it propagates closure to all of its children first. Errors from
/// multiple finalizers are aggregated via [CompositeFailure].
class Scope {
  static int _idCounter = 0;

  /// Unique numeric identifier for this scope, assigned at creation time.
  final int id;

  /// The parent scope, or `null` if this is the root scope.
  final Scope? parent;

  /// All scope state lives in a single [Ref] so every transition (register,
  /// lease, release, close) is one atomic `flatModify`. This guarantees
  /// exactly one path — the closer, or the last lease release — claims the
  /// finalizers, regardless of how concurrent operations interleave.
  final Ref<_ScopeState> _state;

  Scope._(this.parent, this._state) : id = _idCounter++;

  /// Creates a new scope, optionally nested under [parent].
  ///
  /// A child scope automatically registers a finalizer in [parent] so it is
  /// closed when the parent closes.
  static IO<Scope> create([Scope? parent]) {
    return IO.ref(_ScopeState.initial()).flatMap((state) {
      final newScope = Scope._(parent, state);

      if (parent != null) {
        return parent
            .register((ec) {
              return newScope.close(ec).flatMap((closeResult) {
                return closeResult.fold(
                  (err) => IO.raiseError(err),
                  (_) => IO.unit,
                );
              });
            })
            .as(newScope);
      } else {
        return IO.pure(newScope);
      }
    });
  }

  /// Returns `true` if this scope has no parent.
  bool get isRoot => parent == null;

  /// Registers [finalizer] to run when this scope is closed.
  ///
  /// If the scope is already closed, [finalizer] is invoked immediately with
  /// [ExitCase.canceled].
  IO<Unit> register(Function1<ExitCase, IO<Unit>> finalizer) {
    return _state.flatModify((st) {
      if (st.closed) {
        return (st, finalizer(ExitCase.canceled()));
      } else {
        return (st.withFinalizers(st.finalizers.prepended(finalizer)), IO.unit);
      }
    });
  }

  /// Acquires a [Lease] that prevents this scope from running its finalizers
  /// until the lease is released.
  ///
  /// Throws [StateError] if the scope is already closed.
  IO<Lease> lease() {
    return _state.flatModify((st) {
      if (st.closed) {
        return (st, IO.raiseError<Lease>(StateError('Scope is already closed')));
      } else {
        return (st.withLeaseCount(st.leaseCount + 1), IO.pure(Lease(_releaseLease())));
      }
    });
  }

  IO<Either<Object, Unit>> _releaseLease() {
    return _state.flatModify((st) {
      final remaining = st.leaseCount - 1;

      return st.pendingClose.fold(
        () => (st.withLeaseCount(remaining), IO.pure(Unit().asRight<Object>())),
        (ec) {
          if (remaining <= 0) {
            return (_ScopeState.done(), _runFinalizers(st.finalizers, ec));
          } else {
            return (st.withLeaseCount(remaining), IO.pure(Unit().asRight<Object>()));
          }
        },
      );
    });
  }

  /// Closes this scope with exit case [ec], running all registered finalizers.
  ///
  /// Idempotent: returns [Right] immediately if already closed. If outstanding
  /// leases exist, finalizers are deferred until all are released. Errors from
  /// multiple finalizers are aggregated into a [CompositeFailure].
  IO<Either<Object, Unit>> close(ExitCase ec) {
    return _state.flatModify((st) {
      if (st.closed) {
        return (st, IO.pure(Unit().asRight<Object>()));
      } else if (st.leaseCount > 0) {
        return (st.closedPendingLeases(ec), IO.pure(Unit().asRight<Object>()));
      } else {
        return (_ScopeState.done(), _runFinalizers(st.finalizers, ec));
      }
    });
  }

  IO<Either<Object, Unit>> _runFinalizers(
    IList<Function1<ExitCase, IO<Unit>>> fins,
    ExitCase ec,
  ) {
    return fins
        .foldLeft(
          IO.pure(nil<Object>()),
          (accIO, fin) => accIO.flatMap(
            (acc) => fin(ec).attempt().map((either) {
              return either.fold((err) => acc.appended(err), (_) => acc);
            }),
          ),
        )
        .map(
          (allErrors) => CompositeFailure.fromList(allErrors).fold(
            () => Unit().asRight(),
            (err) => err.asLeft(),
          ),
        );
  }
}
