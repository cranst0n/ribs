import 'package:ribs_core/ribs_core.dart';

final class Port extends Ordered<Port> {
  static const MinValue = 0;
  static const MaxValue = 65535;

  final int value;

  const Port._(this.value);

  static Option<Port> fromInt(int value) =>
      Option.when(() => MinValue <= value && value <= MaxValue, () => Port._(value));

  static Option<Port> fromString(String value) => Option(int.tryParse(value)).flatMap(fromInt);

  @override
  int compareTo(Port other) => value.compareTo(other.value);

  @override
  bool operator ==(Object that) => switch (that) {
    final Port that => value == that.value,
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll([value, 'Port'.hashCode]);

  @override
  String toString() => value.toString();
}
