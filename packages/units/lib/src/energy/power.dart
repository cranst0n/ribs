import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing power (energy per unit time).
final class Power extends Quantity<Power> {
  Power(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Power].
  Power operator +(Power that) => Power(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Power].
  Power operator -(Power that) => Power(value - that.to(unit), unit);

  /// Multiplies this power by [that] time to produce [Energy] in joules.
  Energy operator *(Time that) => Energy.joules(toWatts.value * that.toSeconds.value);

  /// Converts this to milliwatts (mW).
  Power get toMilliwatts => to(milliwatts).milliwatts;

  /// Converts this to watts (W).
  Power get toWatts => to(watts).watts;

  /// Converts this to kilowatts (kW).
  Power get toKilowatts => to(kilowatts).kilowatts;

  /// Converts this to megawatts (MW).
  Power get toMegawatts => to(megawatts).megawatts;

  /// Converts this to gigawatts (GW).
  Power get toGigawatts => to(gigawatts).gigawatts;

  /// Converts this to terawatts (TW).
  Power get toTerawatts => to(terawatts).terawatts;

  /// Converts this to BTU per hour (BTU/hr).
  Power get toBtuPerHour => to(btuPerHour).btuPerHour;

  /// Converts this to ergs per second (erg/s).
  Power get toErgsPerSecond => to(ergsPerSecond).ergsPerSecond;

  /// Converts this to mechanical horsepower (hp).
  Power get toHorsepower => to(horsepower).horsepower;

  /// Converts this to solar luminosities (L☉).
  Power get toSolarLuminosities => to(solarLuminosities).solarLuminosities;

  /// Unit for milliwatts (mW).
  static const PowerUnit milliwatts = Milliwatts._();

  /// Unit for watts (W) — the SI unit of power.
  static const PowerUnit watts = Watts._();

  /// Unit for kilowatts (kW).
  static const PowerUnit kilowatts = Kilowatts._();

  /// Unit for megawatts (MW).
  static const PowerUnit megawatts = Megawatts._();

  /// Unit for gigawatts (GW).
  static const PowerUnit gigawatts = Gigawatts._();

  /// Unit for terawatts (TW).
  static const PowerUnit terawatts = Terawatts._();

  /// Unit for BTU per hour (BTU/hr).
  static const PowerUnit btuPerHour = BtuPerHour._();

  /// Unit for ergs per second (erg/s) — the CGS unit of power.
  static const PowerUnit ergsPerSecond = ErgsPerSecond._();

  /// Unit for mechanical horsepower (hp ≈ 745.7 W).
  static const PowerUnit horsepower = Horsepower._();

  /// Unit for solar luminosities (L☉ ≈ 3.828 × 10²⁶ W).
  static const PowerUnit solarLuminosities = SolarLuminosities._();

  /// All supported [Power] units.
  static const units = {
    milliwatts,
    watts,
    kilowatts,
    megawatts,
    gigawatts,
    terawatts,
    btuPerHour,
    ergsPerSecond,
    horsepower,
    solarLuminosities,
  };

  /// Parses [s] into a [Power], returning [None] if parsing fails.
  static Option<Power> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Power] units.
abstract class PowerUnit extends BaseUnit<Power> {
  const PowerUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Power call(num value) => Power(value.toDouble(), this);
}

/// Milliwatts (mW).
final class Milliwatts extends PowerUnit {
  const Milliwatts._() : super('milliwatt', 'mW', MetricSystem.Milli);
}

/// Watts (W) — the SI unit of power.
final class Watts extends PowerUnit {
  const Watts._() : super('watt', 'W', 1.0);
}

/// Kilowatts (kW).
final class Kilowatts extends PowerUnit {
  const Kilowatts._() : super('kilowatt', 'kW', MetricSystem.Kilo);
}

/// Megawatts (MW).
final class Megawatts extends PowerUnit {
  const Megawatts._() : super('megawatt', 'MW', MetricSystem.Mega);
}

/// Gigawatts (GW).
final class Gigawatts extends PowerUnit {
  const Gigawatts._() : super('gigawatt', 'GW', MetricSystem.Giga);
}

/// Terawatts (TW).
final class Terawatts extends PowerUnit {
  const Terawatts._() : super('terawatt', 'TW', MetricSystem.Tera);
}

/// BTU per hour (BTU/hr).
final class BtuPerHour extends PowerUnit {
  const BtuPerHour._() : super('BTU/hour', 'BTU/hr', 1055.05585262 / 3600.0);
}

/// Ergs per second (erg/s) — the CGS unit of power (10⁻⁷ W).
final class ErgsPerSecond extends PowerUnit {
  const ErgsPerSecond._() : super('erg/second', 'erg/s', 1e-7);
}

/// Mechanical horsepower (hp ≈ 745.7 W).
final class Horsepower extends PowerUnit {
  const Horsepower._() : super('horsepower', 'hp', 745.69987158227022);
}

/// Solar luminosities (L☉ ≈ 3.828 × 10²⁶ W).
final class SolarLuminosities extends PowerUnit {
  const SolarLuminosities._() : super('solar luminosity', 'L☉', 3.828e26);
}

/// Extension methods for constructing [Power] values from [num].
extension PowerOps on num {
  /// Creates a [Power] of this value in milliwatts.
  Power get milliwatts => Power.milliwatts(this);

  /// Creates a [Power] of this value in watts.
  Power get watts => Power.watts(this);

  /// Creates a [Power] of this value in kilowatts.
  Power get kilowatts => Power.kilowatts(this);

  /// Creates a [Power] of this value in megawatts.
  Power get megawatts => Power.megawatts(this);

  /// Creates a [Power] of this value in gigawatts.
  Power get gigawatts => Power.gigawatts(this);

  /// Creates a [Power] of this value in terawatts.
  Power get terawatts => Power.terawatts(this);

  /// Creates a [Power] of this value in BTU per hour.
  Power get btuPerHour => Power.btuPerHour(this);

  /// Creates a [Power] of this value in ergs per second.
  Power get ergsPerSecond => Power.ergsPerSecond(this);

  /// Creates a [Power] of this value in mechanical horsepower.
  Power get horsepower => Power.horsepower(this);

  /// Creates a [Power] of this value in solar luminosities.
  Power get solarLuminosities => Power.solarLuminosities(this);
}
