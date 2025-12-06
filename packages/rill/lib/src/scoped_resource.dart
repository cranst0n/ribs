import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class ScopedResource {
  static IO<ScopedResource> create() =>
      Ref.of(_ScopedResourceState(true, none(), 0)).map((s) => _ScopedResource(s, UniqueToken()));

  UniqueToken get id;

  IO<Either<RuntimeException, Unit>> release(ExitCase ec);

  IO<Either<RuntimeException, bool>> acquired(Function1<ExitCase, IO<Unit>> finalizer);

  IO<Option<Lease>> lease();
}

typedef _Finalizer = Function1<ExitCase, IO<Either<RuntimeException, Unit>>>;

final _pru = IO.pure(Unit().asRight<RuntimeException>());

class _ScopedResource extends ScopedResource {
  final Ref<_ScopedResourceState> state;
  final UniqueToken token;

  _ScopedResource(this.state, this.token);

  @override
  IO<Either<RuntimeException, bool>> acquired(Function1<ExitCase, IO<Unit>> finalizer) =>
      state.flatModify((s) {
        if (s.isFinished) {
          return (s, finalizer(ExitCase.succeeded()).as(false).attempt());
        } else {
          return (
            s.copy(finalizer: Some((ExitCase ec) => finalizer(ec).attempt())),
            IO.pure(true.asRight<RuntimeException>()),
          );
        }
      });

  @override
  UniqueToken get id => token;

  @override
  IO<Option<Lease>> lease() => state.modify((s) {
    if (s.open) {
      return (s.copy(leases: s.leases + 1), Some(_ALease(state)));
    } else {
      return (s, none());
    }
  });

  @override
  IO<Either<RuntimeException, Unit>> release(ExitCase ec) => state
      .modify((s) {
        if (s.leases != 0) {
          return (s.copy(open: false), none<_Finalizer>());
        } else {
          return (s.copy(open: false, finalizer: none()), s.finalizer);
        }
      })
      .flatMap(
        (finalizer) => finalizer.map((ff) => ff(ec)).getOrElse(() => _pru),
      );
}

class _ScopedResourceState {
  final bool open;
  final Option<_Finalizer> finalizer;
  final int leases;

  const _ScopedResourceState(this.open, this.finalizer, this.leases);

  bool get isFinished => !open && leases == 0;

  _ScopedResourceState copy({
    bool? open,
    Option<_Finalizer>? finalizer,
    int? leases,
  }) => _ScopedResourceState(
    open ?? this.open,
    finalizer ?? this.finalizer,
    leases ?? this.leases,
  );
}

class _ALease extends Lease {
  final Ref<_ScopedResourceState> state;

  _ALease(this.state);

  @override
  IO<Either<RuntimeException, Unit>> cancel() => state
      .modify((s) {
        final now = s.copy(leases: s.leases + 1);
        return (now, now);
      })
      .flatMap((now) {
        if (now.isFinished) {
          return state.flatModify(
            (s) => (
              s.copy(finalizer: none()),
              s.finalizer.fold(() => _pru, (ff) => ff(ExitCase.succeeded())),
            ),
          );
        } else {
          return _pru;
        }
      });
}
