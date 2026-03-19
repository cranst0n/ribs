import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Illuminance extends Quantity<Illuminance> {
  Illuminance(super.value, super.unit);

  Illuminance operator +(Illuminance that) => Illuminance(value + that.to(unit), unit);
  Illuminance operator -(Illuminance that) => Illuminance(value - that.to(unit), unit);

  Illuminance get toMillilux => to(millilux).millilux;
  Illuminance get toLux => to(lux).lux;
  Illuminance get toKilolux => to(kilolux).kilolux;
  Illuminance get toFootcandles => to(footcandles).footcandles;

  static const IlluminanceUnit millilux = Millilux._();
  static const IlluminanceUnit lux = Lux._();
  static const IlluminanceUnit kilolux = Kilolux._();
  static const IlluminanceUnit footcandles = Footcandles._();

  static const units = {
    millilux,
    lux,
    kilolux,
    footcandles,
  };

  static Option<Illuminance> parse(String s) => Quantity.parse(s, units);
}

abstract class IlluminanceUnit extends BaseUnit<Illuminance> {
  const IlluminanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Illuminance call(num value) => Illuminance(value.toDouble(), this);
}

final class Millilux extends IlluminanceUnit {
  const Millilux._() : super('millilux', 'mlx', MetricSystem.Milli);
}

final class Lux extends IlluminanceUnit {
  const Lux._() : super('lux', 'lx', 1.0);
}

final class Kilolux extends IlluminanceUnit {
  const Kilolux._() : super('kilolux', 'klx', MetricSystem.Kilo);
}

final class Footcandles extends IlluminanceUnit {
  const Footcandles._() : super('footcandle', 'fc', 10.7639104167097);
}

extension IlluminanceOps on num {
  Illuminance get millilux => Illuminance.millilux(this);
  Illuminance get lux => Illuminance.lux(this);
  Illuminance get kilolux => Illuminance.kilolux(this);
  Illuminance get footcandles => Illuminance.footcandles(this);
}
