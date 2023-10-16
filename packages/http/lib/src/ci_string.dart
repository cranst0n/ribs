import 'package:ribs_core/ribs_core.dart';

final class CIString {
  final String value;

  const CIString(this.value);

  bool get isEmpty => value.isEmpty;

  bool get nonEmpty => !isEmpty;

  CIString transform(Function1<String, String> f) => CIString(f(value));

  CIString trim() => transform((a) => a.trim());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CIString && value.toLowerCase() == other.value.toLowerCase());

  @override
  int get hashCode => value.toLowerCase().hashCode;

  @override
  String toString() => value;
}
