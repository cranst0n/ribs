import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Time extends Quantity<Time> {
  Time(super.value, super.unit);

  Time get toNanoseconds => to(nanoseconds).nanoseconds;
  Time get toMicroseconds => to(microseconds).microseconds;
  Time get toMilliseconds => to(milliseconds).milliseconds;
  Time get toSeconds => to(seconds).seconds;
  Time get toMinutes => to(minutes).minutes;
  Time get toHours => to(hours).hours;

  static const nanoseconds = Nanoseconds._();
  static const microseconds = Microseconds._();
  static const milliseconds = Milliseconds._();
  static const seconds = Seconds._();
  static const minutes = Minutes._();
  static const hours = Hours._();

  static const units = {
    nanoseconds,
    microseconds,
    milliseconds,
    seconds,
    minutes,
    hours,
  };

  Time fromDuration(Duration d) => microseconds(d.inMicroseconds);
  Duration get toDuration =>
      Duration(microseconds: toMicroseconds.value.toInt());

  static Option<Time> parse(String s) => Quantity.parse(s, units);
}

abstract class TimeUnit extends BaseUnit<Time> {
  const TimeUnit(super.symbol, super.conversionFactor);

  @override
  Time call(num value) => Time(value.toDouble(), this);
}

final class Nanoseconds extends TimeUnit {
  const Nanoseconds._() : super('ns', 1 / Duration.microsecondsPerSecond);
}

final class Microseconds extends TimeUnit {
  const Microseconds._() : super('µs', 1 / Duration.millisecondsPerSecond);
}

final class Milliseconds extends TimeUnit {
  const Milliseconds._() : super('ms', 1);
}

final class Seconds extends TimeUnit {
  const Seconds._() : super('s', 1.0 * Duration.millisecondsPerSecond);
}

final class Minutes extends TimeUnit {
  const Minutes._()
      : super('min',
            1.0 * Duration.millisecondsPerSecond * Duration.secondsPerMinute);
}

final class Hours extends TimeUnit {
  const Hours._()
      : super(
            'h',
            1.0 *
                Duration.millisecondsPerSecond *
                Duration.secondsPerMinute *
                Duration.minutesPerHour);
}

final class Days extends TimeUnit {
  const Days._()
      : super(
            'd',
            1.0 *
                Duration.millisecondsPerSecond *
                Duration.secondsPerMinute *
                Duration.minutesPerHour *
                Duration.hoursPerDay);
}

extension TimeOps on num {
  Time get nanoseconds => Time.nanoseconds(this);
  Time get microseconds => Time.microseconds(this);
  Time get milliseconds => Time.milliseconds(this);
  Time get seconds => Time.seconds(this);
  Time get minutes => Time.minutes(this);
  Time get hours => Time.hours(this);
}
