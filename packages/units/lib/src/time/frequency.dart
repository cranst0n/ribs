import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing frequency (cycles or events per unit time).
final class Frequency extends Quantity<Frequency> {
  Frequency(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Frequency].
  Frequency operator +(Frequency that) => Frequency(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Frequency].
  Frequency operator -(Frequency that) => Frequency(value - that.to(unit), unit);

  /// Converts this to hertz (Hz).
  Frequency get toHertz => to(hertz).hertz;

  /// Converts this to kilohertz (kHz).
  Frequency get toKilohertz => to(kilohertz).kilohertz;

  /// Converts this to megahertz (MHz).
  Frequency get toMegahertz => to(megahertz).megahertz;

  /// Converts this to gigahertz (GHz).
  Frequency get toGigahertz => to(gigahertz).gigahertz;

  /// Converts this to terahertz (THz).
  Frequency get toTerahertz => to(terahertz).terahertz;

  /// Converts this to revolutions per minute (rpm).
  Frequency get toRevolutionsPerMinute => to(revolutionsPerMinute).revolutionsPerMinute;

  /// Unit for hertz (Hz).
  static const hertz = Hertz._();

  /// Unit for kilohertz (kHz).
  static const kilohertz = Kilohertz._();

  /// Unit for megahertz (MHz).
  static const megahertz = Megahertz._();

  /// Unit for gigahertz (GHz).
  static const gigahertz = Gigahertz._();

  /// Unit for terahertz (THz).
  static const terahertz = Terahertz._();

  /// Unit for revolutions per minute (rpm).
  static const revolutionsPerMinute = RevolutionsPerMinute._();

  /// All supported [Frequency] units.
  static const units = {
    hertz,
    kilohertz,
    megahertz,
    gigahertz,
    terahertz,
    revolutionsPerMinute,
  };

  /// Parses [s] into a [Frequency], returning [None] if parsing fails.
  static Option<Frequency> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Frequency] units.
abstract class FrequencyUnit extends BaseUnit<Frequency> {
  const FrequencyUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Frequency call(num value) => Frequency(value.toDouble(), this);
}

/// Hertz (Hz) — the SI unit of frequency.
final class Hertz extends FrequencyUnit {
  const Hertz._() : super('hertz', 'Hz', 1);
}

/// Kilohertz (kHz).
final class Kilohertz extends FrequencyUnit {
  const Kilohertz._() : super('kilohertz', 'kHz', MetricSystem.Kilo);
}

/// Megahertz (MHz).
final class Megahertz extends FrequencyUnit {
  const Megahertz._() : super('megahertz', 'MHz', MetricSystem.Mega);
}

/// Gigahertz (GHz).
final class Gigahertz extends FrequencyUnit {
  const Gigahertz._() : super('gigahertz', 'GHz', MetricSystem.Giga);
}

/// Terahertz (THz).
final class Terahertz extends FrequencyUnit {
  const Terahertz._() : super('terrahertz', 'THz', MetricSystem.Tera);
}

/// Revolutions per minute (rpm).
final class RevolutionsPerMinute extends FrequencyUnit {
  const RevolutionsPerMinute._() : super('revolutions/minute', 'rpm', 1.0 / 60.0);
}

/// Extension methods for constructing [Frequency] values from [num].
extension FrequencyOps on num {
  /// Creates a [Frequency] of this value in hertz.
  Frequency get hertz => Frequency.hertz(this);

  /// Creates a [Frequency] of this value in kilohertz.
  Frequency get kilohertz => Frequency.kilohertz(this);

  /// Creates a [Frequency] of this value in megahertz.
  Frequency get megahertz => Frequency.megahertz(this);

  /// Creates a [Frequency] of this value in gigahertz.
  Frequency get gigahertz => Frequency.gigahertz(this);

  /// Creates a [Frequency] of this value in terahertz.
  Frequency get terahertz => Frequency.terahertz(this);

  /// Creates a [Frequency] of this value in revolutions per minute.
  Frequency get revolutionsPerMinute => Frequency.revolutionsPerMinute(this);
}
