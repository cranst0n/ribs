import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Manages the lifecycle of fibers within a scope.
///
/// All fibers started via [supervise] are bound to the [Supervisor]'s
/// lifecycle. When the [Supervisor] is finalized, active fibers are either
/// awaited or canceled depending on the [waitForAll] parameter.
abstract class Supervisor {
  /// Starts [fa] as a fiber whose lifecycle is bound to this supervisor.
  ///
  /// Returns a handle to the started fiber. If this supervisor has already
  /// been finalized, raises an error.
  IO<IOFiber<A>> supervise<A>(IO<A> fa);

  /// Creates a [Supervisor] as a [Resource].
  ///
  /// If [waitForAll] is true, finalization waits for all supervised fibers to
  /// complete naturally. If false (the default), all active fibers are
  /// canceled during finalization.
  static Resource<Supervisor> create({bool waitForAll = false}) {
    return Resource.eval(IO.ref<_State>(_Active())).flatMap(
      (Ref<_State> stateRef) {
        return Resource.make(
          IO.pure<Supervisor>(_SupervisorImpl(stateRef)),
          (Supervisor _) => stateRef.getAndSet(_Finalized()).flatMap((_State old) {
            return switch (old) {
              _Finalized() => IO.unit,
              _Active(:final fibers) when waitForAll => fibers.values.fold<IO<Unit>>(
                IO.unit,
                (IO<Unit> acc, IOFiber<dynamic> f) => acc.flatMap((_) => f.join().voided()),
              ),
              _Active(:final fibers) => fibers.values.fold<IO<Unit>>(
                IO.unit,
                (IO<Unit> acc, IOFiber<dynamic> f) => IO.both(acc, f.cancel()).voided(),
              ),
            };
          }),
        );
      },
    );
  }
}

sealed class _State {}

final class _Active extends _State {
  final Map<int, IOFiber<dynamic>> fibers;
  final int nextId;

  _Active({this.fibers = const {}, this.nextId = 0});

  _Active reserveId() => _Active(fibers: fibers, nextId: nextId + 1);

  _Active withFiber(int id, IOFiber<dynamic> f) =>
      _Active(fibers: {...fibers, id: f}, nextId: nextId);

  _Active withoutFiber(int id) {
    final m = Map<int, IOFiber<dynamic>>.of(fibers);
    m.remove(id);
    return _Active(fibers: m, nextId: nextId);
  }
}

final class _Finalized extends _State {}

class _SupervisorImpl extends Supervisor {
  final Ref<_State> _stateRef;

  _SupervisorImpl(this._stateRef);

  @override
  IO<IOFiber<A>> supervise<A>(IO<A> fa) {
    return IO.uncancelable((poll) {
      // Atomically check state and reserve an ID. The resulting IO is
      // flattened to run after the state update.
      return _stateRef.modify<IO<IOFiber<A>>>((state) {
        return switch (state) {
          _Finalized() => (state, IO.raiseError('Supervisor already finalized')),
          _Active() => (state.reserveId(), _startAndTrack(poll, fa, state.nextId)),
        };
      }).flatten();
    });
  }

  IO<IOFiber<A>> _startAndTrack<A>(Poll poll, IO<A> fa, int id) {
    // fiber start is cancelable within the uncancelable region.
    return poll(fa.start()).flatTap((fiber) {
      // Register the fiber in the tracking map.
      final register = _stateRef.update((state) {
        return switch (state) {
          _Active() => state.withFiber(id, fiber),
          _Finalized() => state,
        };
      });

      // Start a background fiber to remove the tracked fiber once it completes.
      final cleanup =
          fiber
              .join()
              .flatMap(
                (_) => _stateRef.update(
                  (state) => switch (state) {
                    _Active() => state.withoutFiber(id),
                    _Finalized() => state,
                  },
                ),
              )
              .start()
              .voided();

      return register.productR(() => cleanup);
    });
  }
}
