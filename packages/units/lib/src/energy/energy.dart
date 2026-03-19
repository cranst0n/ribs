import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Energy extends Quantity<Energy> {
  Energy(super.value, super.unit);

  Energy operator +(Energy that) => Energy(value + that.to(unit), unit);
  Energy operator -(Energy that) => Energy(value - that.to(unit), unit);

  Power operator /(Time that) => Power.watts(toJoules.value / that.toSeconds.value);

  Energy get toJoules => to(joules).joules;
  Energy get toMillijoules => to(millijoules).millijoules;
  Energy get toKilojoules => to(kilojoules).kilojoules;
  Energy get toMegajoules => to(megajoules).megajoules;
  Energy get toGigajoules => to(gigajoules).gigajoules;
  Energy get toTerajoules => to(terajoules).terajoules;
  Energy get toWattHours => to(wattHours).wattHours;
  Energy get toKilowattHours => to(kilowattHours).kilowattHours;
  Energy get toMegawattHours => to(megawattHours).megawattHours;
  Energy get toGigawattHours => to(gigawattHours).gigawattHours;
  Energy get toBtu => to(btu).btu;
  Energy get toCalories => to(calories).calories;
  Energy get toKilocalories => to(kilocalories).kilocalories;
  Energy get toElectronvolts => to(electronvolts).electronvolts;

  static const EnergyUnit joules = Joules._();
  static const EnergyUnit millijoules = Millijoules._();
  static const EnergyUnit kilojoules = Kilojoules._();
  static const EnergyUnit megajoules = Megajoules._();
  static const EnergyUnit gigajoules = Gigajoules._();
  static const EnergyUnit terajoules = Terajoules._();
  static const EnergyUnit wattHours = WattHours._();
  static const EnergyUnit kilowattHours = KilowattHours._();
  static const EnergyUnit megawattHours = MegawattHours._();
  static const EnergyUnit gigawattHours = GigawattHours._();
  static const EnergyUnit btu = BritishThermalUnits._();
  static const EnergyUnit calories = Calories._();
  static const EnergyUnit kilocalories = Kilocalories._();
  static const EnergyUnit electronvolts = Electronvolts._();

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

  static Option<Energy> parse(String s) => Quantity.parse(s, units);
}

abstract class EnergyUnit extends BaseUnit<Energy> {
  const EnergyUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Energy call(num value) => Energy(value.toDouble(), this);
}

final class Joules extends EnergyUnit {
  const Joules._() : super('joule', 'J', 1.0);
}

final class Millijoules extends EnergyUnit {
  const Millijoules._() : super('millijoule', 'mJ', MetricSystem.Milli);
}

final class Kilojoules extends EnergyUnit {
  const Kilojoules._() : super('kilojoule', 'kJ', MetricSystem.Kilo);
}

final class Megajoules extends EnergyUnit {
  const Megajoules._() : super('megajoule', 'MJ', MetricSystem.Mega);
}

final class Gigajoules extends EnergyUnit {
  const Gigajoules._() : super('gigajoule', 'GJ', MetricSystem.Giga);
}

final class Terajoules extends EnergyUnit {
  const Terajoules._() : super('terajoule', 'TJ', MetricSystem.Tera);
}

final class WattHours extends EnergyUnit {
  const WattHours._() : super('watt-hour', 'Wh', 3600.0);
}

final class KilowattHours extends EnergyUnit {
  const KilowattHours._() : super('kilowatt-hour', 'kWh', 3.6e6);
}

final class MegawattHours extends EnergyUnit {
  const MegawattHours._() : super('megawatt-hour', 'MWh', 3.6e9);
}

final class GigawattHours extends EnergyUnit {
  const GigawattHours._() : super('gigawatt-hour', 'GWh', 3.6e12);
}

final class BritishThermalUnits extends EnergyUnit {
  const BritishThermalUnits._() : super('BTU', 'BTU', 1055.05585262);
}

final class Calories extends EnergyUnit {
  const Calories._() : super('calorie', 'cal', 4.184);
}

final class Kilocalories extends EnergyUnit {
  const Kilocalories._() : super('kilocalorie', 'kcal', 4184.0);
}

final class Electronvolts extends EnergyUnit {
  const Electronvolts._() : super('electronvolt', 'eV', 1.602176634e-19);
}

extension EnergyOps on num {
  Energy get joules => Energy.joules(this);
  Energy get millijoules => Energy.millijoules(this);
  Energy get kilojoules => Energy.kilojoules(this);
  Energy get megajoules => Energy.megajoules(this);
  Energy get gigajoules => Energy.gigajoules(this);
  Energy get terajoules => Energy.terajoules(this);
  Energy get wattHours => Energy.wattHours(this);
  Energy get kilowattHours => Energy.kilowattHours(this);
  Energy get megawattHours => Energy.megawattHours(this);
  Energy get gigawattHours => Energy.gigawattHours(this);
  Energy get btu => Energy.btu(this);
  Energy get calories => Energy.calories(this);
  Energy get kilocalories => Energy.kilocalories(this);
  Energy get electronvolts => Energy.electronvolts(this);
}
