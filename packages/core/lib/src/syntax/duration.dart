/// Convenience constructors for creating [Duration] values from integer
/// literals, e.g. `5.seconds`, `200.milliseconds`.
extension DurationOps on int {
  /// A [Duration] of this many microseconds.
  Duration get microsecond => Duration(microseconds: this);

  /// A [Duration] of this many microseconds.
  Duration get microseconds => Duration(microseconds: this);

  /// A [Duration] of this many milliseconds.
  Duration get millisecond => Duration(milliseconds: this);

  /// A [Duration] of this many milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// A [Duration] of this many seconds.
  Duration get second => Duration(seconds: this);

  /// A [Duration] of this many seconds.
  Duration get seconds => Duration(seconds: this);

  /// A [Duration] of this many minutes.
  Duration get minute => Duration(minutes: this);

  /// A [Duration] of this many minutes.
  Duration get minutes => Duration(minutes: this);

  /// A [Duration] of this many hours.
  Duration get hour => Duration(hours: this);

  /// A [Duration] of this many hours.
  Duration get hours => Duration(hours: this);

  /// A [Duration] of this many days.
  Duration get day => Duration(days: this);

  /// A [Duration] of this many days.
  Duration get days => Duration(days: this);
}
