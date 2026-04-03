import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing illuminance — the total luminous flux incident on
/// a surface per unit area.
final class Illuminance extends Quantity<Illuminance> {
  Illuminance(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Illuminance].
  Illuminance operator +(Illuminance that) => Illuminance(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Illuminance].
  Illuminance operator -(Illuminance that) => Illuminance(value - that.to(unit), unit);

  /// Converts this to millilux (mlx).
  Illuminance get toMillilux => to(millilux).millilux;

  /// Converts this to lux (lx).
  Illuminance get toLux => to(lux).lux;

  /// Converts this to kilolux (klx).
  Illuminance get toKilolux => to(kilolux).kilolux;

  /// Converts this to footcandles (fc).
  Illuminance get toFootcandles => to(footcandles).footcandles;

  /// Unit for millilux (mlx).
  static const IlluminanceUnit millilux = Millilux._();

  /// Unit for lux (lx) — the SI unit of illuminance.
  static const IlluminanceUnit lux = Lux._();

  /// Unit for kilolux (klx).
  static const IlluminanceUnit kilolux = Kilolux._();

  /// Unit for footcandles (fc) — lumens per square foot.
  static const IlluminanceUnit footcandles = Footcandles._();

  /// All supported [Illuminance] units.
  static const units = {
    millilux,
    lux,
    kilolux,
    footcandles,
  };

  /// Parses [s] into an [Illuminance], returning [None] if parsing fails.
  static Option<Illuminance> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Illuminance] units.
abstract class IlluminanceUnit extends BaseUnit<Illuminance> {
  const IlluminanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Illuminance call(num value) => Illuminance(value.toDouble(), this);
}

/// Millilux (mlx).
final class Millilux extends IlluminanceUnit {
  const Millilux._() : super('millilux', 'mlx', MetricSystem.Milli);
}

/// Lux (lx) — the SI unit of illuminance.
final class Lux extends IlluminanceUnit {
  const Lux._() : super('lux', 'lx', 1.0);
}

/// Kilolux (klx).
final class Kilolux extends IlluminanceUnit {
  const Kilolux._() : super('kilolux', 'klx', MetricSystem.Kilo);
}

/// Footcandles (fc) — lumens per square foot.
final class Footcandles extends IlluminanceUnit {
  const Footcandles._() : super('footcandle', 'fc', 10.7639104167097);
}

/// Extension methods for constructing [Illuminance] values from [num].
extension IlluminanceOps on num {
  /// Creates an [Illuminance] of this value in millilux.
  Illuminance get millilux => Illuminance.millilux(this);

  /// Creates an [Illuminance] of this value in lux.
  Illuminance get lux => Illuminance.lux(this);

  /// Creates an [Illuminance] of this value in kilolux.
  Illuminance get kilolux => Illuminance.kilolux(this);

  /// Creates an [Illuminance] of this value in footcandles.
  Illuminance get footcandles => Illuminance.footcandles(this);
}
