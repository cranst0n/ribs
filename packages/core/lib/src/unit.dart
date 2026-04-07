/// Unit is analogous to Dart's void type. There exists only one value of type
/// [Unit].
///
/// See also: https://medium.com/flutter-community/the-curious-case-of-void-in-dart-f0535705e529
final class Unit {
  /// The singleton [Unit] value.
  static const Unit instance = Unit._();

  /// Returns the singleton [Unit] instance.
  factory Unit() => instance;

  const Unit._();

  @override
  String toString() => '()';
}
