import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class MassFlow extends Quantity<MassFlow> {
  MassFlow(super.value, super.unit);

  MassFlow operator +(MassFlow that) => MassFlow(value + that.to(unit), unit);
  MassFlow operator -(MassFlow that) => MassFlow(value - that.to(unit), unit);

  MassFlow get toKilogramsPerSecond => to(kilogramsPerSecond).kilogramsPerSecond;
  MassFlow get toKilogramsPerMinute => to(kilogramsPerMinute).kilogramsPerMinute;
  MassFlow get toKilogramsPerHour => to(kilogramsPerHour).kilogramsPerHour;
  MassFlow get toGramsPerSecond => to(gramsPerSecond).gramsPerSecond;
  MassFlow get toPoundsPerSecond => to(poundsPerSecond).poundsPerSecond;
  MassFlow get toPoundsPerMinute => to(poundsPerMinute).poundsPerMinute;
  MassFlow get toPoundsPerHour => to(poundsPerHour).poundsPerHour;
  MassFlow get toKilopoundsPerHour => to(kilopoundsPerHour).kilopoundsPerHour;
  MassFlow get toMegapoundsPerHour => to(megapoundsPerHour).megapoundsPerHour;

  static const MassFlowUnit kilogramsPerSecond = KilogramsPerSecond._();
  static const MassFlowUnit kilogramsPerMinute = KilogramsPerMinute._();
  static const MassFlowUnit kilogramsPerHour = KilogramsPerHour._();
  static const MassFlowUnit gramsPerSecond = GramsPerSecond._();
  static const MassFlowUnit poundsPerSecond = PoundsPerSecond._();
  static const MassFlowUnit poundsPerMinute = PoundsPerMinute._();
  static const MassFlowUnit poundsPerHour = PoundsPerHour._();
  static const MassFlowUnit kilopoundsPerHour = KilopoundsPerHour._();
  static const MassFlowUnit megapoundsPerHour = MegapoundsPerHour._();

  static const units = {
    kilogramsPerSecond,
    kilogramsPerMinute,
    kilogramsPerHour,
    gramsPerSecond,
    poundsPerSecond,
    poundsPerMinute,
    poundsPerHour,
    kilopoundsPerHour,
    megapoundsPerHour,
  };

  static Option<MassFlow> parse(String s) => Quantity.parse(s, units);
}

const _PoundKgFactor = 0.45359237;

abstract class MassFlowUnit extends BaseUnit<MassFlow> {
  const MassFlowUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MassFlow call(num value) => MassFlow(value.toDouble(), this);
}

final class KilogramsPerSecond extends MassFlowUnit {
  const KilogramsPerSecond._() : super('kilogram/second', 'kg/s', 1.0);
}

final class KilogramsPerMinute extends MassFlowUnit {
  const KilogramsPerMinute._() : super('kilogram/minute', 'kg/min', 1.0 / 60.0);
}

final class KilogramsPerHour extends MassFlowUnit {
  const KilogramsPerHour._() : super('kilogram/hour', 'kg/h', 1.0 / 3600.0);
}

final class GramsPerSecond extends MassFlowUnit {
  const GramsPerSecond._() : super('gram/second', 'g/s', MetricSystem.Milli);
}

final class PoundsPerSecond extends MassFlowUnit {
  const PoundsPerSecond._() : super('pound/second', 'lb/s', _PoundKgFactor);
}

final class PoundsPerMinute extends MassFlowUnit {
  const PoundsPerMinute._() : super('pound/minute', 'lb/min', _PoundKgFactor / 60.0);
}

final class PoundsPerHour extends MassFlowUnit {
  const PoundsPerHour._() : super('pound/hour', 'lb/h', _PoundKgFactor / 3600.0);
}

final class KilopoundsPerHour extends MassFlowUnit {
  const KilopoundsPerHour._()
    : super('kilopound/hour', 'klb/h', _PoundKgFactor * MetricSystem.Kilo / 3600.0);
}

final class MegapoundsPerHour extends MassFlowUnit {
  const MegapoundsPerHour._()
    : super('megapound/hour', 'Mlb/h', _PoundKgFactor * MetricSystem.Mega / 3600.0);
}

extension MassFlowOps on num {
  MassFlow get kilogramsPerSecond => MassFlow.kilogramsPerSecond(this);
  MassFlow get kilogramsPerMinute => MassFlow.kilogramsPerMinute(this);
  MassFlow get kilogramsPerHour => MassFlow.kilogramsPerHour(this);
  MassFlow get gramsPerSecond => MassFlow.gramsPerSecond(this);
  MassFlow get poundsPerSecond => MassFlow.poundsPerSecond(this);
  MassFlow get poundsPerMinute => MassFlow.poundsPerMinute(this);
  MassFlow get poundsPerHour => MassFlow.poundsPerHour(this);
  MassFlow get kilopoundsPerHour => MassFlow.kilopoundsPerHour(this);
  MassFlow get megapoundsPerHour => MassFlow.megapoundsPerHour(this);
}
