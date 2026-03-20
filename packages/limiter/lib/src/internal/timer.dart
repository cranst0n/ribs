import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Timer {
  IO<Duration> get interval;

  IO<Unit> setInterval(Duration t);

  IO<Unit> updateInterval(Function1<Duration, Duration> f);

  IO<Unit> get sleep;
}
