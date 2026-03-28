import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class Timer {
  static IO<Timer> create(Duration initialDuration) =>
      SignallingRef.of(initialDuration).map(TimerImpl.new);

  IO<Duration> get interval;

  IO<Unit> setInterval(Duration t);

  IO<Unit> updateInterval(Function1<Duration, Duration> f);

  IO<Unit> get sleep;
}

class TimerImpl extends Timer {
  final SignallingRef<Duration> intervalState;

  TimerImpl(this.intervalState);

  @override
  IO<Duration> get interval => intervalState.value();

  @override
  IO<Unit> setInterval(Duration t) => intervalState.setValue(t);

  @override
  IO<Unit> updateInterval(Function1<Duration, Duration> f) => intervalState.update(f);

  @override
  IO<Unit> get sleep {
    return IO.now.flatMap((start) {
      return intervalState.discrete
          .switchMap((interval) {
            final action = IO.now.flatMap((now) {
              final elapsed = now.difference(start);
              final toSleep = interval - elapsed;

              return IO.sleep(toSleep).whenA(toSleep.inMicroseconds > 0);
            });

            return Rill.eval(action);
          })
          .take(1)
          .compile
          .drain;
    });
  }
}
