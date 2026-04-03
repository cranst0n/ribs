import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A dynamically adjustable sleep timer used by the limiter to enforce
/// minimum intervals between job dispatches.
///
/// The [interval] can be changed at any time; an in-flight [sleep] will
/// react to the updated duration.
abstract class Timer {
  /// Creates a [Timer] with the given [initialDuration].
  static IO<Timer> create(Duration initialDuration) =>
      SignallingRef.of(initialDuration).map(TimerImpl.new);

  /// The current interval duration.
  IO<Duration> get interval;

  /// Sets the interval to [t].
  IO<Unit> setInterval(Duration t);

  /// Atomically updates the interval by applying [f].
  IO<Unit> updateInterval(Function1<Duration, Duration> f);

  /// Sleeps for the current [interval], adjusting dynamically if the
  /// interval changes while sleeping.
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
