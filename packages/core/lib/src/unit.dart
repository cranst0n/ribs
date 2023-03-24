class Unit {
  static final Unit _singleton = Unit._internal();

  factory Unit() {
    return _singleton;
  }

  Unit._internal();

  @override
  String toString() => '()';
}
