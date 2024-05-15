extension DurationOps on int {
  Duration get microsecond => Duration(microseconds: this);
  Duration get microseconds => Duration(microseconds: this);
  Duration get millisecond => Duration(milliseconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get second => Duration(seconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minute => Duration(minutes: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hour => Duration(hours: this);
  Duration get hours => Duration(hours: this);
  Duration get day => Duration(days: this);
  Duration get days => Duration(days: this);
}
