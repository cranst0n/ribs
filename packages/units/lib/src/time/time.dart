import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing a duration of time.
final class Time extends Quantity<Time> {
  Time(super.value, super.unit);

  /// Creates a [Time] from a Dart [Duration], using microseconds as the
  /// intermediate representation.
  factory Time.fromDuration(Duration d) => microseconds(d.inMicroseconds);

  /// Returns the sum of this and [that] in the units of this [Time].
  Time operator +(Time that) => Time(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Time].
  Time operator -(Time that) => Time(value - that.to(unit), unit);

  /// Converts this to nanoseconds.
  Time get toNanoseconds => to(nanoseconds).nanoseconds;

  /// Converts this to microseconds.
  Time get toMicroseconds => to(microseconds).microseconds;

  /// Converts this to milliseconds.
  Time get toMilliseconds => to(milliseconds).milliseconds;

  /// Converts this to seconds.
  Time get toSeconds => to(seconds).seconds;

  /// Converts this to minutes.
  Time get toMinutes => to(minutes).minutes;

  /// Converts this to hours.
  Time get toHours => to(hours).hours;

  /// Converts this to days.
  Time get toDays => to(days).days;

  /// Unit for nanoseconds (ns).
  static const nanoseconds = Nanoseconds._();

  /// Unit for microseconds (µs).
  static const microseconds = Microseconds._();

  /// Unit for milliseconds (ms).
  static const milliseconds = Milliseconds._();

  /// Unit for seconds (s).
  static const seconds = Seconds._();

  /// Unit for minutes (min).
  static const minutes = Minutes._();

  /// Unit for hours (h).
  static const hours = Hours._();

  /// Unit for days (d).
  static const days = Days._();

  /// All supported [Time] units.
  static const units = {
    nanoseconds,
    microseconds,
    milliseconds,
    seconds,
    minutes,
    hours,
    days,
  };

  /// Converts this [Time] to a Dart [Duration] (via microseconds).
  Duration get toDuration => Duration(microseconds: toMicroseconds.value.toInt());

  /// Parses [s] into a [Time], returning [None] if parsing fails.
  static Option<Time> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Time] units.
abstract class TimeUnit extends BaseUnit<Time> {
  const TimeUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Time call(num value) => Time(value.toDouble(), this);
}

/// Nanoseconds (ns).
final class Nanoseconds extends TimeUnit {
  const Nanoseconds._() : super('nanosecond', 'ns', 1 / Duration.microsecondsPerSecond);
}

/// Microseconds (µs).
final class Microseconds extends TimeUnit {
  const Microseconds._() : super('microsecond', 'µs', 1 / Duration.millisecondsPerSecond);
}

/// Milliseconds (ms) — the internal base unit for [Time].
final class Milliseconds extends TimeUnit {
  const Milliseconds._() : super('millisecond', 'ms', 1);
}

/// Seconds (s).
final class Seconds extends TimeUnit {
  const Seconds._() : super('second', 's', 1.0 * Duration.millisecondsPerSecond);
}

/// Minutes (min).
final class Minutes extends TimeUnit {
  const Minutes._()
    : super('minute', 'min', 1.0 * Duration.millisecondsPerSecond * Duration.secondsPerMinute);
}

/// Hours (h).
final class Hours extends TimeUnit {
  const Hours._()
    : super(
        'hour',
        'h',
        1.0 * Duration.millisecondsPerSecond * Duration.secondsPerMinute * Duration.minutesPerHour,
      );
}

/// Days (d).
final class Days extends TimeUnit {
  const Days._()
    : super(
        'day',
        'd',
        1.0 *
            Duration.millisecondsPerSecond *
            Duration.secondsPerMinute *
            Duration.minutesPerHour *
            Duration.hoursPerDay,
      );
}

/// Extension methods for constructing [Time] values from [num].
extension TimeOps on num {
  /// Creates a [Time] of this value in nanoseconds.
  Time get nanoseconds => Time.nanoseconds(this);

  /// Creates a [Time] of this value in microseconds.
  Time get microseconds => Time.microseconds(this);

  /// Creates a [Time] of this value in milliseconds.
  Time get milliseconds => Time.milliseconds(this);

  /// Creates a [Time] of this value in seconds.
  Time get seconds => Time.seconds(this);

  /// Creates a [Time] of this value in minutes.
  Time get minutes => Time.minutes(this);

  /// Creates a [Time] of this value in hours.
  Time get hours => Time.hours(this);

  /// Creates a [Time] of this value in days.
  Time get days => Time.days(this);
}
