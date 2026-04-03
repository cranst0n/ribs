import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing energy or work.
final class Energy extends Quantity<Energy> {
  Energy(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Energy].
  Energy operator +(Energy that) => Energy(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Energy].
  Energy operator -(Energy that) => Energy(value - that.to(unit), unit);

  /// Divides this energy by [that] time to produce [Power] in watts.
  Power operator /(Time that) => Power.watts(toJoules.value / that.toSeconds.value);

  /// Converts this to joules (J).
  Energy get toJoules => to(joules).joules;

  /// Converts this to millijoules (mJ).
  Energy get toMillijoules => to(millijoules).millijoules;

  /// Converts this to kilojoules (kJ).
  Energy get toKilojoules => to(kilojoules).kilojoules;

  /// Converts this to megajoules (MJ).
  Energy get toMegajoules => to(megajoules).megajoules;

  /// Converts this to gigajoules (GJ).
  Energy get toGigajoules => to(gigajoules).gigajoules;

  /// Converts this to terajoules (TJ).
  Energy get toTerajoules => to(terajoules).terajoules;

  /// Converts this to watt-hours (Wh).
  Energy get toWattHours => to(wattHours).wattHours;

  /// Converts this to kilowatt-hours (kWh).
  Energy get toKilowattHours => to(kilowattHours).kilowattHours;

  /// Converts this to megawatt-hours (MWh).
  Energy get toMegawattHours => to(megawattHours).megawattHours;

  /// Converts this to gigawatt-hours (GWh).
  Energy get toGigawattHours => to(gigawattHours).gigawattHours;

  /// Converts this to British Thermal Units (BTU).
  Energy get toBtu => to(btu).btu;

  /// Converts this to calories (cal).
  Energy get toCalories => to(calories).calories;

  /// Converts this to kilocalories (kcal).
  Energy get toKilocalories => to(kilocalories).kilocalories;

  /// Converts this to electronvolts (eV).
  Energy get toElectronvolts => to(electronvolts).electronvolts;

  /// Unit for joules (J) — the SI unit of energy.
  static const EnergyUnit joules = Joules._();

  /// Unit for millijoules (mJ).
  static const EnergyUnit millijoules = Millijoules._();

  /// Unit for kilojoules (kJ).
  static const EnergyUnit kilojoules = Kilojoules._();

  /// Unit for megajoules (MJ).
  static const EnergyUnit megajoules = Megajoules._();

  /// Unit for gigajoules (GJ).
  static const EnergyUnit gigajoules = Gigajoules._();

  /// Unit for terajoules (TJ).
  static const EnergyUnit terajoules = Terajoules._();

  /// Unit for watt-hours (Wh).
  static const EnergyUnit wattHours = WattHours._();

  /// Unit for kilowatt-hours (kWh).
  static const EnergyUnit kilowattHours = KilowattHours._();

  /// Unit for megawatt-hours (MWh).
  static const EnergyUnit megawattHours = MegawattHours._();

  /// Unit for gigawatt-hours (GWh).
  static const EnergyUnit gigawattHours = GigawattHours._();

  /// Unit for British Thermal Units (BTU).
  static const EnergyUnit btu = BritishThermalUnits._();

  /// Unit for calories (cal) — thermochemical calorie.
  static const EnergyUnit calories = Calories._();

  /// Unit for kilocalories (kcal) — food calories.
  static const EnergyUnit kilocalories = Kilocalories._();

  /// Unit for electronvolts (eV).
  static const EnergyUnit electronvolts = Electronvolts._();

  /// All supported [Energy] units.
  static const units = {
    joules,
    millijoules,
    kilojoules,
    megajoules,
    gigajoules,
    terajoules,
    wattHours,
    kilowattHours,
    megawattHours,
    gigawattHours,
    btu,
    calories,
    kilocalories,
    electronvolts,
  };

  /// Parses [s] into an [Energy], returning [None] if parsing fails.
  static Option<Energy> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Energy] units.
abstract class EnergyUnit extends BaseUnit<Energy> {
  const EnergyUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Energy call(num value) => Energy(value.toDouble(), this);
}

/// Joules (J) — the SI unit of energy.
final class Joules extends EnergyUnit {
  const Joules._() : super('joule', 'J', 1.0);
}

/// Millijoules (mJ).
final class Millijoules extends EnergyUnit {
  const Millijoules._() : super('millijoule', 'mJ', MetricSystem.Milli);
}

/// Kilojoules (kJ).
final class Kilojoules extends EnergyUnit {
  const Kilojoules._() : super('kilojoule', 'kJ', MetricSystem.Kilo);
}

/// Megajoules (MJ).
final class Megajoules extends EnergyUnit {
  const Megajoules._() : super('megajoule', 'MJ', MetricSystem.Mega);
}

/// Gigajoules (GJ).
final class Gigajoules extends EnergyUnit {
  const Gigajoules._() : super('gigajoule', 'GJ', MetricSystem.Giga);
}

/// Terajoules (TJ).
final class Terajoules extends EnergyUnit {
  const Terajoules._() : super('terajoule', 'TJ', MetricSystem.Tera);
}

/// Watt-hours (Wh).
final class WattHours extends EnergyUnit {
  const WattHours._() : super('watt-hour', 'Wh', 3600.0);
}

/// Kilowatt-hours (kWh).
final class KilowattHours extends EnergyUnit {
  const KilowattHours._() : super('kilowatt-hour', 'kWh', 3.6e6);
}

/// Megawatt-hours (MWh).
final class MegawattHours extends EnergyUnit {
  const MegawattHours._() : super('megawatt-hour', 'MWh', 3.6e9);
}

/// Gigawatt-hours (GWh).
final class GigawattHours extends EnergyUnit {
  const GigawattHours._() : super('gigawatt-hour', 'GWh', 3.6e12);
}

/// British Thermal Units (BTU).
final class BritishThermalUnits extends EnergyUnit {
  const BritishThermalUnits._() : super('BTU', 'BTU', 1055.05585262);
}

/// Thermochemical calories (cal).
final class Calories extends EnergyUnit {
  const Calories._() : super('calorie', 'cal', 4.184);
}

/// Kilocalories (kcal) — the "food calorie".
final class Kilocalories extends EnergyUnit {
  const Kilocalories._() : super('kilocalorie', 'kcal', 4184.0);
}

/// Electronvolts (eV).
final class Electronvolts extends EnergyUnit {
  const Electronvolts._() : super('electronvolt', 'eV', 1.602176634e-19);
}

/// Extension methods for constructing [Energy] values from [num].
extension EnergyOps on num {
  /// Creates an [Energy] of this value in joules.
  Energy get joules => Energy.joules(this);

  /// Creates an [Energy] of this value in millijoules.
  Energy get millijoules => Energy.millijoules(this);

  /// Creates an [Energy] of this value in kilojoules.
  Energy get kilojoules => Energy.kilojoules(this);

  /// Creates an [Energy] of this value in megajoules.
  Energy get megajoules => Energy.megajoules(this);

  /// Creates an [Energy] of this value in gigajoules.
  Energy get gigajoules => Energy.gigajoules(this);

  /// Creates an [Energy] of this value in terajoules.
  Energy get terajoules => Energy.terajoules(this);

  /// Creates an [Energy] of this value in watt-hours.
  Energy get wattHours => Energy.wattHours(this);

  /// Creates an [Energy] of this value in kilowatt-hours.
  Energy get kilowattHours => Energy.kilowattHours(this);

  /// Creates an [Energy] of this value in megawatt-hours.
  Energy get megawattHours => Energy.megawattHours(this);

  /// Creates an [Energy] of this value in gigawatt-hours.
  Energy get gigawattHours => Energy.gigawattHours(this);

  /// Creates an [Energy] of this value in BTU.
  Energy get btu => Energy.btu(this);

  /// Creates an [Energy] of this value in calories.
  Energy get calories => Energy.calories(this);

  /// Creates an [Energy] of this value in kilocalories.
  Energy get kilocalories => Energy.kilocalories(this);

  /// Creates an [Energy] of this value in electronvolts.
  Energy get electronvolts => Energy.electronvolts(this);
}
