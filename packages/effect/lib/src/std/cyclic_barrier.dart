import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

final class CyclicBarrier {
  final int capacity;
  final Ref<_State> _state;

  static IO<CyclicBarrier> withCapacity(int capacity) {
    if (capacity < 1) {
      throw ArgumentError('Cyclic barrier constructed with capacity $capacity. Must be > 0');
    }

    return IO
        .deferred<Unit>()
        .map((unblock) => _State(capacity, 0, unblock))
        .flatMap(Ref.of)
        .map((state) => CyclicBarrier._(capacity, state));
  }

  CyclicBarrier._(this.capacity, this._state);

  IO<Unit> await() {
    return IO.deferred<Unit>().flatMap((gate) {
      return _state.flatModifyFull((tuple) {
        final (poll, prev) = tuple;

        final awaitingNow = prev.awaiting - 1;

        if (awaitingNow == 0) {
          return (_State(capacity, prev.epoch + 1, gate), prev.unblock.complete(Unit()).voided());
        } else {
          final newState = _State(awaitingNow, prev.epoch, prev.unblock);

          // reincrement count if this await gets canceled,
          // but only if the barrier hasn't reset in the meantime
          final cleanup = _state.update((s) {
            if (s.epoch == prev.epoch) {
              return s.copy(awaiting: s.awaiting + 1);
            } else {
              return s;
            }
          });

          return (newState, poll(prev.unblock.value()).onCancel(cleanup));
        }
      });
    });
  }
}

final class _State {
  final int awaiting;
  final int epoch;
  final Deferred<Unit> unblock;

  const _State(this.awaiting, this.epoch, this.unblock);

  _State copy({
    int? awaiting,
    int? epoch,
    Deferred<Unit>? unblock,
  }) =>
      _State(
        awaiting ?? this.awaiting,
        epoch ?? this.epoch,
        unblock ?? this.unblock,
      );
}
