import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_limiter/src/internal/timer.dart';
import 'package:test/test.dart';

void main() {
  Resource<IO<Duration>> timedSleep(Timer timer) => timer.sleep.timed().background().map(
    (io) => io.flatMap((oc) => oc.embedNever()).map((t) => t.$1),
  );

  test('behaves like a normal clock if never reset', () {
    final test = Timer.create(1.second).flatMap((t) => timedSleep(t).use(identity));
    expect(test.ticked, succeeds(1.second));
  });

  test('sequential resets', () {
    final test = Timer.create(1.second).flatMap((timer) {
      return (
        timedSleep(timer).use(identity),
        timer.updateInterval((i) => i + 1.second),
        timedSleep(timer).use(identity),
      ).mapN((x, _, y) => (x, y));
    });

    expect(test.ticked, succeeds((1.second, 2.seconds)));
  });

  test('reset while sleeping, interval increased', () {
    final test = Timer.create(2.seconds).flatMap((timer) {
      return timedSleep(timer).use((getResult) {
        return IO.sleep(1.second).productR(timer.setInterval(3.seconds)).productR(getResult);
      });
    });

    expect(test.ticked, succeeds(3.seconds));
  });

  test('reset while sleeping, interval decreased but still in the future', () {
    final test = Timer.create(5.seconds).flatMap((timer) {
      return timedSleep(timer).use((getResult) {
        return IO.sleep(1.second).productR(timer.setInterval(3.seconds)).productR(getResult);
      });
    });

    expect(test.ticked, succeeds(3.seconds));
  });

  test('reset while sleeping, interval decreased and has already elapsed', () {
    final test = Timer.create(5.seconds).flatMap((timer) {
      return timedSleep(timer).use((getResult) {
        return IO.sleep(2.seconds).productR(timer.setInterval(1.seconds)).productR(getResult);
      });
    });

    expect(test.ticked, succeeds(2.seconds));
  });

  test('multiple resets while sleeping, latest wins', () {
    final test = Timer.create(5.seconds).flatMap((timer) {
      return timedSleep(timer).use((getResult) {
        return IO
            .sleep(1.second)
            .productR(timer.setInterval(15.seconds))
            .productR(IO.sleep(3.seconds))
            .productR(timer.setInterval(8.seconds))
            .productR(IO.sleep(2.seconds))
            .productR(timer.setInterval(4.seconds))
            .productR(getResult);
      });
    });

    expect(test.ticked, succeeds(6.seconds));
  });
}
