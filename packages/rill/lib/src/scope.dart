import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

class CompositeError {
  final IList<Object> errors;

  const CompositeError(this.errors);

  @override
  String toString() => 'CompositeError(${errors.mkString(sep: ', ')})';
}

class Scope {
  static int count = 0;

  final int id;
  final Scope? parent;
  final Ref<IList<Function1<ExitCase, IO<Unit>>>> _finalizers;
  final Ref<bool> _closed;

  Scope._(this.parent, this._finalizers, this._closed) : id = count++;

  static IO<Scope> create([Scope? parent]) {
    return IO.ref(nil<Function1<ExitCase, IO<Unit>>>()).flatMap((fins) {
      return IO.ref(false).flatMap((closed) {
        final newScope = Scope._(parent, fins, closed);

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

  IO<Either<Object, Unit>> close(ExitCase ec) {
    return _closed.getAndSet(true).flatMap((wasClosed) {
      if (wasClosed) {
        return IO.pure(Unit().asRight());
      } else {
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
              .map((allErrors) {
                if (allErrors.isEmpty) {
                  return Unit().asRight<Object>();
                } else if (allErrors.size == 1) {
                  return allErrors[0].asLeft<Unit>();
                } else {
                  return CompositeError(allErrors).asLeft<Unit>();
                }
              });
        });
      }
    });
  }
}
