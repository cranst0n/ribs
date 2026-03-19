import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Pressure extends Quantity<Pressure> {
  Pressure(super.value, super.unit);

  Pressure operator +(Pressure that) => Pressure(value + that.to(unit), unit);
  Pressure operator -(Pressure that) => Pressure(value - that.to(unit), unit);

  Pressure get toPascals => to(pascals).pascals;
  Pressure get toKilopascals => to(kilopascals).kilopascals;
  Pressure get toMegapascals => to(megapascals).megapascals;
  Pressure get toGigapascals => to(gigapascals).gigapascals;
  Pressure get toBars => to(bars).bars;
  Pressure get toMillibars => to(millibars).millibars;
  Pressure get toPoundsPerSquareInch => to(poundsPerSquareInch).poundsPerSquareInch;
  Pressure get toAtmospheres => to(atmospheres).atmospheres;
  Pressure get toTorr => to(torr).torr;

  static const PressureUnit pascals = Pascals._();
  static const PressureUnit kilopascals = Kilopascals._();
  static const PressureUnit megapascals = Megapascals._();
  static const PressureUnit gigapascals = Gigapascals._();
  static const PressureUnit bars = Bars._();
  static const PressureUnit millibars = Millibars._();
  static const PressureUnit poundsPerSquareInch = PoundsPerSquareInch._();
  static const PressureUnit atmospheres = Atmospheres._();
  static const PressureUnit torr = Torr._();

  static const units = {
    pascals,
    kilopascals,
    megapascals,
    gigapascals,
    bars,
    millibars,
    poundsPerSquareInch,
    atmospheres,
    torr,
  };

  static Option<Pressure> parse(String s) => Quantity.parse(s, units);
}

abstract class PressureUnit extends BaseUnit<Pressure> {
  const PressureUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Pressure call(num value) => Pressure(value.toDouble(), this);
}

final class Pascals extends PressureUnit {
  const Pascals._() : super('pascal', 'Pa', 1.0);
}

final class Kilopascals extends PressureUnit {
  const Kilopascals._() : super('kilopascal', 'kPa', MetricSystem.Kilo);
}

final class Megapascals extends PressureUnit {
  const Megapascals._() : super('megapascal', 'MPa', MetricSystem.Mega);
}

final class Gigapascals extends PressureUnit {
  const Gigapascals._() : super('gigapascal', 'GPa', MetricSystem.Giga);
}

final class Bars extends PressureUnit {
  const Bars._() : super('bar', 'bar', 1e5);
}

final class Millibars extends PressureUnit {
  const Millibars._() : super('millibar', 'mbar', 100.0);
}

final class PoundsPerSquareInch extends PressureUnit {
  const PoundsPerSquareInch._() : super('pound/square inch', 'psi', 6894.757293168361);
}

final class Atmospheres extends PressureUnit {
  const Atmospheres._() : super('atmosphere', 'atm', 101325.0);
}

final class Torr extends PressureUnit {
  const Torr._() : super('torr', 'Torr', 133.32236842105263);
}

extension PressureOps on num {
  Pressure get pascals => Pressure.pascals(this);
  Pressure get kilopascals => Pressure.kilopascals(this);
  Pressure get megapascals => Pressure.megapascals(this);
  Pressure get gigapascals => Pressure.gigapascals(this);
  Pressure get bars => Pressure.bars(this);
  Pressure get millibars => Pressure.millibars(this);
  Pressure get poundsPerSquareInch => Pressure.poundsPerSquareInch(this);
  Pressure get atmospheres => Pressure.atmospheres(this);
  Pressure get torr => Pressure.torr(this);
}
