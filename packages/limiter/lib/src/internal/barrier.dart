import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Barrier {
  static IO<Barrier> create(int initialLimit) {
    return IO
        .raiseError<Barrier>(limitViolation)
        .whenA(initialLimit <= 0)
        .productR(Ref.of(State(0, initialLimit, none())).map(BarrierImpl.new));
  }

  IO<int> get limit;

  IO<Unit> setLimit(int n);

  IO<Unit> updateLimit(Function1<int, int> f);

  IO<Unit> enter();

  IO<Unit> exit();
}

class BarrierImpl extends Barrier {
  final Ref<State> state;

  BarrierImpl(this.state);

  @override
  IO<Unit> enter() {
    return IO.uncancelable((poll) {
      return IO.deferred<Unit>().flatMap((wait) {
        final waitForChanges = poll(
          wait.value(),
        ).onCancel(state.update((s) => State(s.running, s.limit, none())));

        return state.modify((st) {
          if (st.waiting.isDefined) {
            return (st, IO.raiseError<Unit>(singleEnterViolation));
          } else if (st.running < st.limit) {
            return (State(st.running + 1, st.limit, none()), IO.unit);
          } else {
            return (
              State(st.running, st.limit, Some(wait)),
              waitForChanges.productR(enter()),
            );
          }
        }).flatten();
      });
    });
  }

  @override
  IO<Unit> exit() {
    return IO.uncancelable((_) {
      return state.modify((st) {
        final runningNow = st.running - 1;

        if (runningNow < 0) {
          return (st, IO.raiseError<Unit>(runningViolation));
        } else if (runningNow < st.limit) {
          return (State(runningNow, st.limit, none()), wakeUp(st.waiting));
        } else {
          return (State(runningNow, st.limit, st.waiting), IO.unit);
        }
      }).flatten();
    });
  }

  @override
  IO<int> get limit => state.value().map((st) => st.limit);

  @override
  IO<Unit> setLimit(int n) => updateLimit((_) => n);

  @override
  IO<Unit> updateLimit(Function1<int, int> f) {
    return IO.uncancelable((_) {
      return state.modify((st) {
        final newLimit = f(st.limit);

        if (newLimit <= 0) {
          return (st, IO.raiseError<Unit>(limitViolation));
        } else if (st.running < newLimit) {
          return (State(st.running, newLimit, none()), wakeUp(st.waiting));
        } else {
          return (State(st.running, newLimit, st.waiting), IO.unit);
        }
      }).flatten();
    });
  }

  IO<Unit> wakeUp(Option<Deferred<Unit>> waiting) => waiting.traverseIO_((w) => w.complete(Unit()));
}

final class State {
  final int running;
  final int limit;
  final Option<Deferred<Unit>> waiting;

  const State(this.running, this.limit, this.waiting);
}

Exception get singleEnterViolation =>
    Exception('Only one fiber can block on the barrier at a time');

Exception get runningViolation =>
    Exception('The number of fibers in the barrier can never go below zero.');

Exception get limitViolation =>
    Exception('The number of fibers in the barrier can never go below zero.');
