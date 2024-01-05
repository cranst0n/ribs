import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/src/unit_of_measure.dart';

abstract class Quantity<A extends Quantity<A>> {
  final double value;
  final UnitOfMeasure<A> unit;

  Quantity(this.value, this.unit);

  double to(UnitOfMeasure<A> uom) =>
      uom == unit ? value : uom.convertTo(unit.convertFrom(value));

  bool equivalentTo(Quantity<A> other) => other.to(unit) == value;

  @override
  String toString() => '$value ${unit.symbol}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quantity<A> && other.value == value && other.unit == unit);

  @override
  int get hashCode => Object.hash(value, unit);

  static Option<A> parse<A extends Quantity<A>>(
    String s,
    Set<UnitOfMeasure<A>> units,
  ) =>
      Option(_unitsRegex(units).firstMatch(s)).flatMap(
        (match) => (
          Option(match.group(1)).flatMap((str) => Option(num.tryParse(str))),
          Option(match.group(2)).flatMap((str) => IList.fromDart(units.toList())
              .find((a) => a.symbol == str.trim())),
        ).mapN((value, unit) => unit(value)),
      );

  static RegExp _unitsRegex<A extends Quantity<A>>(
    Set<UnitOfMeasure<A>> units,
  ) {
    final unitsStr = units.map((u) => u.symbol).reduce((a, b) => '$a|$b');
    final regStr =
        '^([-+]?[0-9]*\\.?[0-9]+(?:[eE][-+]?[0-9]+)?) *($unitsStr)\$';

    return RegExp(regStr);
  }
}
