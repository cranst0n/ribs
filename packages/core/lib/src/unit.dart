class Unit {
  static final Unit _singleton = Unit._();

  factory Unit() => _singleton;

  Unit._();

  @override
  String toString() => '()';
}
