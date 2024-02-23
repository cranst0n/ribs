import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class CountDownLatch {
  static IO<CountDownLatch> create(int n) {
    if (n < 1) {
      throw ArgumentError('Initialized with $n latches. Must be > 0');
    } else {
      return _State.initial(n)
          .flatMap((state) => IO.ref(state))
          .map((ref) => _CountDownLatchImpl(ref));
    }
  }

  IO<Unit> release();

  IO<Unit> await();
}

final class _CountDownLatchImpl extends CountDownLatch {
  final Ref<_State> state;

  _CountDownLatchImpl(this.state);

  @override
  IO<Unit> await() => state.value().flatMap((a) => switch (a) {
        _Awaiting(:final signal) => signal.value(),
        _Done _ => IO.unit,
      });

  @override
  IO<Unit> release() {
    return state.flatModify((s) {
      return switch (s) {
        _Awaiting(:final latches, :final signal) => latches > 1
            ? (_Awaiting(latches - 1, signal), IO.unit)
            : (_Done(), signal.complete(Unit()).voided()),
        final _Done d => (d, IO.unit),
      };
    });
  }
}

sealed class _State {
  static IO<_State> initial(int n) =>
      IO.deferred<Unit>().map((signal) => _Awaiting(n, signal));
}

final class _Awaiting extends _State {
  final int latches;
  final Deferred<Unit> signal;

  _Awaiting(this.latches, this.signal);
}

final class _Done extends _State {}
