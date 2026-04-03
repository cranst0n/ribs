import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

class Lease {
  final IO<Either<Object, Unit>> cancel;

  const Lease(this.cancel);
}

class Scope {
  static int _idCounter = 0;

  final int id;
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

  bool get isRoot => parent == null;

  IO<Unit> register(Function1<ExitCase, IO<Unit>> finalizer) {
    return _closed.value().flatMap((isClosed) {
      if (isClosed) {
        return finalizer(ExitCase.canceled());
      } else {
        return _finalizers.update((fins) => fins.prepended(finalizer));
      }
    });
  }

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
