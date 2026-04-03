import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing mass flow rate (mass per unit time).
final class MassFlow extends Quantity<MassFlow> {
  MassFlow(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [MassFlow].
  MassFlow operator +(MassFlow that) => MassFlow(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [MassFlow].
  MassFlow operator -(MassFlow that) => MassFlow(value - that.to(unit), unit);

  /// Converts this to kilograms per second (kg/s).
  MassFlow get toKilogramsPerSecond => to(kilogramsPerSecond).kilogramsPerSecond;

  /// Converts this to kilograms per minute (kg/min).
  MassFlow get toKilogramsPerMinute => to(kilogramsPerMinute).kilogramsPerMinute;

  /// Converts this to kilograms per hour (kg/h).
  MassFlow get toKilogramsPerHour => to(kilogramsPerHour).kilogramsPerHour;

  /// Converts this to grams per second (g/s).
  MassFlow get toGramsPerSecond => to(gramsPerSecond).gramsPerSecond;

  /// Converts this to pounds per second (lb/s).
  MassFlow get toPoundsPerSecond => to(poundsPerSecond).poundsPerSecond;

  /// Converts this to pounds per minute (lb/min).
  MassFlow get toPoundsPerMinute => to(poundsPerMinute).poundsPerMinute;

  /// Converts this to pounds per hour (lb/h).
  MassFlow get toPoundsPerHour => to(poundsPerHour).poundsPerHour;

  /// Converts this to kilopounds per hour (klb/h).
  MassFlow get toKilopoundsPerHour => to(kilopoundsPerHour).kilopoundsPerHour;

  /// Converts this to megapounds per hour (Mlb/h).
  MassFlow get toMegapoundsPerHour => to(megapoundsPerHour).megapoundsPerHour;

  /// Unit for kilograms per second (kg/s) — the SI unit of mass flow.
  static const MassFlowUnit kilogramsPerSecond = KilogramsPerSecond._();

  /// Unit for kilograms per minute (kg/min).
  static const MassFlowUnit kilogramsPerMinute = KilogramsPerMinute._();

  /// Unit for kilograms per hour (kg/h).
  static const MassFlowUnit kilogramsPerHour = KilogramsPerHour._();

  /// Unit for grams per second (g/s).
  static const MassFlowUnit gramsPerSecond = GramsPerSecond._();

  /// Unit for pounds per second (lb/s).
  static const MassFlowUnit poundsPerSecond = PoundsPerSecond._();

  /// Unit for pounds per minute (lb/min).
  static const MassFlowUnit poundsPerMinute = PoundsPerMinute._();

  /// Unit for pounds per hour (lb/h).
  static const MassFlowUnit poundsPerHour = PoundsPerHour._();

  /// Unit for kilopounds per hour (klb/h).
  static const MassFlowUnit kilopoundsPerHour = KilopoundsPerHour._();

  /// Unit for megapounds per hour (Mlb/h).
  static const MassFlowUnit megapoundsPerHour = MegapoundsPerHour._();

  /// All supported [MassFlow] units.
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

  /// Parses [s] into a [MassFlow], returning [None] if parsing fails.
  static Option<MassFlow> parse(String s) => Quantity.parse(s, units);
}

const _PoundKgFactor = 0.45359237;

/// Base class for all [MassFlow] units.
abstract class MassFlowUnit extends BaseUnit<MassFlow> {
  const MassFlowUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  MassFlow call(num value) => MassFlow(value.toDouble(), this);
}

/// Kilograms per second (kg/s).
final class KilogramsPerSecond extends MassFlowUnit {
  const KilogramsPerSecond._() : super('kilogram/second', 'kg/s', 1.0);
}

/// Kilograms per minute (kg/min).
final class KilogramsPerMinute extends MassFlowUnit {
  const KilogramsPerMinute._() : super('kilogram/minute', 'kg/min', 1.0 / 60.0);
}

/// Kilograms per hour (kg/h).
final class KilogramsPerHour extends MassFlowUnit {
  const KilogramsPerHour._() : super('kilogram/hour', 'kg/h', 1.0 / 3600.0);
}

/// Grams per second (g/s).
final class GramsPerSecond extends MassFlowUnit {
  const GramsPerSecond._() : super('gram/second', 'g/s', MetricSystem.Milli);
}

/// Pounds per second (lb/s).
final class PoundsPerSecond extends MassFlowUnit {
  const PoundsPerSecond._() : super('pound/second', 'lb/s', _PoundKgFactor);
}

/// Pounds per minute (lb/min).
final class PoundsPerMinute extends MassFlowUnit {
  const PoundsPerMinute._() : super('pound/minute', 'lb/min', _PoundKgFactor / 60.0);
}

/// Pounds per hour (lb/h).
final class PoundsPerHour extends MassFlowUnit {
  const PoundsPerHour._() : super('pound/hour', 'lb/h', _PoundKgFactor / 3600.0);
}

/// Kilopounds per hour (klb/h).
final class KilopoundsPerHour extends MassFlowUnit {
  const KilopoundsPerHour._()
    : super('kilopound/hour', 'klb/h', _PoundKgFactor * MetricSystem.Kilo / 3600.0);
}

/// Megapounds per hour (Mlb/h).
final class MegapoundsPerHour extends MassFlowUnit {
  const MegapoundsPerHour._()
    : super('megapound/hour', 'Mlb/h', _PoundKgFactor * MetricSystem.Mega / 3600.0);
}

/// Extension methods for constructing [MassFlow] values from [num].
extension MassFlowOps on num {
  /// Creates a [MassFlow] of this value in kilograms per second.
  MassFlow get kilogramsPerSecond => MassFlow.kilogramsPerSecond(this);

  /// Creates a [MassFlow] of this value in kilograms per minute.
  MassFlow get kilogramsPerMinute => MassFlow.kilogramsPerMinute(this);

  /// Creates a [MassFlow] of this value in kilograms per hour.
  MassFlow get kilogramsPerHour => MassFlow.kilogramsPerHour(this);

  /// Creates a [MassFlow] of this value in grams per second.
  MassFlow get gramsPerSecond => MassFlow.gramsPerSecond(this);

  /// Creates a [MassFlow] of this value in pounds per second.
  MassFlow get poundsPerSecond => MassFlow.poundsPerSecond(this);

  /// Creates a [MassFlow] of this value in pounds per minute.
  MassFlow get poundsPerMinute => MassFlow.poundsPerMinute(this);

  /// Creates a [MassFlow] of this value in pounds per hour.
  MassFlow get poundsPerHour => MassFlow.poundsPerHour(this);

  /// Creates a [MassFlow] of this value in kilopounds per hour.
  MassFlow get kilopoundsPerHour => MassFlow.kilopoundsPerHour(this);

  /// Creates a [MassFlow] of this value in megapounds per hour.
  MassFlow get megapoundsPerHour => MassFlow.megapoundsPerHour(this);
}
