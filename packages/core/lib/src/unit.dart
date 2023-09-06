/// Unit is analogous to Dart's void type. There exists only one value of type
/// [Unit].
///
/// See also: https://medium.com/flutter-community/the-curious-case-of-void-in-dart-f0535705e529
final class Unit {
  static final Unit _singleton = Unit._();

  factory Unit() => _singleton;

  Unit._();

  @override
  String toString() => '()';
}
