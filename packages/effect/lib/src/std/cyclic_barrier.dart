import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A reusable synchronization barrier for a fixed number of fibers.
///
/// A [CyclicBarrier] is initialized with a [capacity]. Fibers calling [await]
/// block (semantically) until exactly [capacity] fibers have arrived at the
/// barrier, at which point all are released simultaneously. The barrier then
/// resets automatically for the next cycle.
///
/// This is useful for phased computations where a group of fibers must all
/// complete one step before any can proceed to the next.
final class CyclicBarrier {
  /// The number of fibers that must call [await] before the barrier is
  /// released.
  final int capacity;
  final Ref<_State> _state;

  /// Creates a [CyclicBarrier] with the given [capacity].
  ///
  /// Throws an [ArgumentError] if [capacity] is less than 1.
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

  /// Blocks (semantically) until [capacity] fibers have arrived at the
  /// barrier.
  ///
  /// Once all fibers have arrived, all are released and the barrier resets
  /// for the next cycle. If this fiber await is canceled while waiting, the
  /// arrival count is incremented so the barrier remains correct.
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
  }) => _State(
    awaiting ?? this.awaiting,
    epoch ?? this.epoch,
    unblock ?? this.unblock,
  );
}
