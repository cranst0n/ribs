import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Power extends Quantity<Power> {
  Power(super.value, super.unit);

  Power operator +(Power that) => Power(value + that.to(unit), unit);
  Power operator -(Power that) => Power(value - that.to(unit), unit);

  Energy operator *(Time that) => Energy.joules(toWatts.value * that.toSeconds.value);

  Power get toMilliwatts => to(milliwatts).milliwatts;
  Power get toWatts => to(watts).watts;
  Power get toKilowatts => to(kilowatts).kilowatts;
  Power get toMegawatts => to(megawatts).megawatts;
  Power get toGigawatts => to(gigawatts).gigawatts;
  Power get toTerawatts => to(terawatts).terawatts;
  Power get toBtuPerHour => to(btuPerHour).btuPerHour;
  Power get toErgsPerSecond => to(ergsPerSecond).ergsPerSecond;
  Power get toHorsepower => to(horsepower).horsepower;
  Power get toSolarLuminosities => to(solarLuminosities).solarLuminosities;

  static const PowerUnit milliwatts = Milliwatts._();
  static const PowerUnit watts = Watts._();
  static const PowerUnit kilowatts = Kilowatts._();
  static const PowerUnit megawatts = Megawatts._();
  static const PowerUnit gigawatts = Gigawatts._();
  static const PowerUnit terawatts = Terawatts._();
  static const PowerUnit btuPerHour = BtuPerHour._();
  static const PowerUnit ergsPerSecond = ErgsPerSecond._();
  static const PowerUnit horsepower = Horsepower._();
  static const PowerUnit solarLuminosities = SolarLuminosities._();

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

  static Option<Power> parse(String s) => Quantity.parse(s, units);
}

abstract class PowerUnit extends BaseUnit<Power> {
  const PowerUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Power call(num value) => Power(value.toDouble(), this);
}

final class Milliwatts extends PowerUnit {
  const Milliwatts._() : super('milliwatt', 'mW', MetricSystem.Milli);
}

final class Watts extends PowerUnit {
  const Watts._() : super('watt', 'W', 1.0);
}

final class Kilowatts extends PowerUnit {
  const Kilowatts._() : super('kilowatt', 'kW', MetricSystem.Kilo);
}

final class Megawatts extends PowerUnit {
  const Megawatts._() : super('megawatt', 'MW', MetricSystem.Mega);
}

final class Gigawatts extends PowerUnit {
  const Gigawatts._() : super('gigawatt', 'GW', MetricSystem.Giga);
}

final class Terawatts extends PowerUnit {
  const Terawatts._() : super('terawatt', 'TW', MetricSystem.Tera);
}

final class BtuPerHour extends PowerUnit {
  const BtuPerHour._() : super('BTU/hour', 'BTU/hr', 1055.05585262 / 3600.0);
}

final class ErgsPerSecond extends PowerUnit {
  const ErgsPerSecond._() : super('erg/second', 'erg/s', 1e-7);
}

final class Horsepower extends PowerUnit {
  const Horsepower._() : super('horsepower', 'hp', 745.69987158227022);
}

final class SolarLuminosities extends PowerUnit {
  const SolarLuminosities._() : super('solar luminosity', 'L☉', 3.828e26);
}

extension PowerOps on num {
  Power get milliwatts => Power.milliwatts(this);
  Power get watts => Power.watts(this);
  Power get kilowatts => Power.kilowatts(this);
  Power get megawatts => Power.megawatts(this);
  Power get gigawatts => Power.gigawatts(this);
  Power get terawatts => Power.terawatts(this);
  Power get btuPerHour => Power.btuPerHour(this);
  Power get ergsPerSecond => Power.ergsPerSecond(this);
  Power get horsepower => Power.horsepower(this);
  Power get solarLuminosities => Power.solarLuminosities(this);
}
