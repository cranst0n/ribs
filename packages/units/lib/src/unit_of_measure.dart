import 'package:ribs_units/src/quantity.dart';

abstract class UnitOfMeasure<A extends Quantity<A>> {
  const UnitOfMeasure();

  A call(num value);

  String get unit;

  String get symbol;

  double converterFrom(double value);

  double converterTo(double value);

  double convertTo(num value) => converterTo(value.toDouble());

  double convertFrom(num value) => converterFrom(value.toDouble());
}

abstract class UnitConverter<A extends Quantity<A>> extends UnitOfMeasure<A> {
  const UnitConverter();

  double get conversionFactor;

  @override
  double converterFrom(double value) => value * conversionFactor;

  @override
  double converterTo(double value) => value / conversionFactor;
}

abstract class BaseUnit<A extends Quantity<A>> extends UnitConverter<A> {
  @override
  final String unit;

  @override
  final String symbol;

  @override
  final double conversionFactor;

  const BaseUnit(this.unit, this.symbol, this.conversionFactor);

  @override
  A call(num value);
}
