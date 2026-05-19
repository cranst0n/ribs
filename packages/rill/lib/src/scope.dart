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
  final Ref<IList<Function1<ExitCase, IO<Unit>>>> _finalizers;
  final Ref<bool> _closed;
  final Ref<int> _leaseCount;
  final Ref<Option<ExitCase>> _pendingClose;

  Scope._(
    this.parent,
    this._finalizers,
    this._closed,
    this._leaseCount,
    this._pendingClose,
  ) : id = _idCounter++;

  /// Creates a new scope, optionally nested under [parent].
  ///
  /// A child scope automatically registers a finalizer in [parent] so it is
  /// closed when the parent closes.
  static IO<Scope> create([Scope? parent]) {
    return (
      IO.ref(nil<Function1<ExitCase, IO<Unit>>>()),
      IO.ref(false),
      IO.ref(0),
      IO.ref(none<ExitCase>()),
    ).flatMapN((fins, closed, leaseCount, pendingClose) {
      final newScope = Scope._(parent, fins, closed, leaseCount, pendingClose);

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
    return _closed.value().flatMap((isClosed) {
      if (isClosed) {
        return finalizer(ExitCase.canceled());
      } else {
        return _finalizers.update((fins) => fins.prepended(finalizer));
      }
    });
  }

  /// Acquires a [Lease] that prevents this scope from running its finalizers
  /// until the lease is released.
  ///
  /// Throws [StateError] if the scope is already closed.
  IO<Lease> lease() {
    return _closed.value().flatMap((isClosed) {
      if (isClosed) {
        return IO.raiseError(StateError('Scope is already closed'));
      } else {
        return _leaseCount.update((n) => n + 1).as(Lease(_releaseLease()));
      }
    });
  }

  IO<Either<Object, Unit>> _releaseLease() {
    return _leaseCount.updateAndGet((n) => n - 1).flatMap((remaining) {
      if (remaining == 0) {
        return _pendingClose.value().flatMap((pendingOpt) {
          return pendingOpt.fold(
            () => IO.pure(Unit().asRight<Object>()),
            (ec) => _runFinalizers(ec),
          );
        });
      } else {
        return IO.pure(Unit().asRight<Object>());
      }
    });
  }

  /// Closes this scope with exit case [ec], running all registered finalizers.
  ///
  /// Idempotent: returns [Right] immediately if already closed. If outstanding
  /// leases exist, finalizers are deferred until all are released. Errors from
  /// multiple finalizers are aggregated into a [CompositeFailure].
  IO<Either<Object, Unit>> close(ExitCase ec) {
    return _closed.getAndSet(true).flatMap((wasClosed) {
      if (wasClosed) {
        return IO.pure(Unit().asRight());
      } else {
        return _leaseCount.value().flatMap((leases) {
          if (leases > 0) {
            return _pendingClose.setValue(Some(ec)).as(Unit().asRight<Object>());
          } else {
            return _runFinalizers(ec);
          }
        });
      }
    });
  }

  IO<Either<Object, Unit>> _runFinalizers(ExitCase ec) {
    return _finalizers.value().flatMap((fins) {
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
    });
  }
}
