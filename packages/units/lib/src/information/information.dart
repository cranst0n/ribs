import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing digital information — measured in bytes or bits,
/// with both metric (SI) and binary (IEC) prefix variants.
///
/// Metric prefixes (kilo, mega, giga, …) use powers of 10 (10³, 10⁶, 10⁹, …).
/// Binary prefixes (kibi, mebi, gibi, …) use powers of 2 (2¹⁰, 2²⁰, 2³⁰, …).
///
/// The internal base unit is bytes (B). Bit-based units use a conversion
/// factor of [BitsConversionFactor] (0.125 = 1/8).
final class Information extends Quantity<Information> {
  Information(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [Information].
  Information operator +(Information that) => Information(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [Information].
  Information operator -(Information that) => Information(value - that.to(unit), unit);

  /// Converts this to bytes (B).
  Information get toBytes => to(bytes).bytes;

  /// Converts this to octets (o) — equivalent to bytes.
  Information get toOctets => to(octets).octets;

  /// Converts this to kilobytes (KB) — 10³ bytes.
  Information get toKilobytes => to(kilobytes).kilobytes;

  /// Converts this to kibibytes (KiB) — 2¹⁰ bytes.
  Information get toKibibytes => to(kibibytes).kibibytes;

  /// Converts this to megabytes (MB) — 10⁶ bytes.
  Information get toMegabytes => to(megabytes).megabytes;

  /// Converts this to mebibytes (MiB) — 2²⁰ bytes.
  Information get toMebibytes => to(mebibytes).mebibytes;

  /// Converts this to gigabytes (GB) — 10⁹ bytes.
  Information get toGigabytes => to(gigabytes).gigabytes;

  /// Converts this to gibibytes (GiB) — 2³⁰ bytes.
  Information get toGibibytes => to(gibibytes).gibibytes;

  /// Converts this to terabytes (TB) — 10¹² bytes.
  Information get toTerabytes => to(terabytes).terabytes;

  /// Converts this to tebibytes (TiB) — 2⁴⁰ bytes.
  Information get toTebibytes => to(tebibytes).tebibytes;

  /// Converts this to petabytes (PB) — 10¹⁵ bytes.
  Information get toPetabytes => to(petabytes).petabytes;

  /// Converts this to pebibytes (PiB) — 2⁵⁰ bytes.
  Information get toPebibytes => to(pebibytes).pebibytes;

  /// Converts this to exabytes (EB) — 10¹⁸ bytes.
  Information get toExabytes => to(exabytes).exabytes;

  /// Converts this to exbibytes (EiB) — 2⁶⁰ bytes.
  Information get toExbibytes => to(exbibytes).exbibytes;

  /// Converts this to zettabytes (ZB) — 10²¹ bytes.
  Information get toZettabytes => to(zettabytes).zettabytes;

  /// Converts this to zebibytes (ZiB) — 2⁷⁰ bytes.
  Information get toZebibytes => to(zebibytes).zebibytes;

  /// Converts this to yottabytes (YB) — 10²⁴ bytes.
  Information get toYottabytes => to(yottabytes).yottabytes;

  /// Converts this to yobibytes (YiB) — 2⁸⁰ bytes.
  Information get toYobibytes => to(yobibytes).yobibytes;

  /// Converts this to bits (bit).
  Information get toBits => to(bits).bits;

  /// Converts this to kilobits (Kbit) — 10³ bits.
  Information get toKilobits => to(kilobits).kilobits;

  /// Converts this to kibibits (Kibit) — 2¹⁰ bits.
  Information get toKibibits => to(kibibits).kibibits;

  /// Converts this to megabits (Mbit) — 10⁶ bits.
  Information get toMegabits => to(megabits).megabits;

  /// Converts this to mebibits (Mibit) — 2²⁰ bits.
  Information get toMebibits => to(mebibits).mebibits;

  /// Converts this to gigabits (Gbit) — 10⁹ bits.
  Information get toGigabits => to(gigabits).gigabits;

  /// Converts this to gibibits (Gibit) — 2³⁰ bits.
  Information get toGibibits => to(gibibits).gibibits;

  /// Converts this to terabits (Tbit) — 10¹² bits.
  Information get toTerabits => to(terabits).terabits;

  /// Converts this to tebibits (Tibit) — 2⁴⁰ bits.
  Information get toTebibits => to(tebibits).tebibits;

  /// Converts this to petabits (Pbit) — 10¹⁵ bits.
  Information get toPetabits => to(petabits).petabits;

  /// Converts this to pebibits (Pibit) — 2⁵⁰ bits.
  Information get toPebibits => to(pebibits).pebibits;

  /// Converts this to exabits (Ebit) — 10¹⁸ bits.
  Information get toExabits => to(exabits).exabits;

  /// Converts this to exbibits (Eibit) — 2⁶⁰ bits.
  Information get toExbibits => to(exbibits).exbibits;

  /// Converts this to zettabits (Zbit) — 10²¹ bits.
  Information get toZettabits => to(zettabits).zettabits;

  /// Converts this to zebibits (Zibit) — 2⁷⁰ bits.
  Information get toZebibits => to(zebibits).zebibits;

  /// Converts this to yottabits (Ybit) — 10²⁴ bits.
  Information get toYottabits => to(yottabits).yottabits;

  /// Converts this to yobibits (Yibit) — 2⁸⁰ bits.
  Information get toYobibits => to(yobibits).yobibits;

  /// Returns this value expressed in the coarsest (most human-readable) unit
  /// within the same prefix family as the current unit.
  ///
  /// Starting from the current unit, this repeatedly divides the value by 1 000
  /// (for metric) or 1 024 (for binary) and moves up to the next larger unit
  /// as long as the result is ≥ 1. The four prefix families are kept separate:
  /// metric bytes, binary bytes, metric bits, and binary bits. A value already
  /// in the largest unit of its family ([yottabytes], [yobibytes], [yottabits],
  /// or [yobibits]) is returned unchanged.
  ///
  /// Example:
  /// ```dart
  /// print(1_500_000.bytes.toCoarsest()); // 1.5 MB
  /// print(1_048_576.bytes.toCoarsest()); // 1.0 MB  (metric — not MiB)
  /// ```
  // TODO: Go from bits to bytes if modulo 8 == 0?
  Information toCoarsest() {
    Information loop(double value, UnitOfMeasure<Information> unit) {
      Information coarserOrThis(
        UnitOfMeasure<Information> coarser,
        int divider,
      ) {
        if (value / divider >= 1) {
          return loop(value / divider, coarser);
        } else if (unit == this.unit) {
          return this;
        } else {
          return Information(value, unit);
        }
      }

      return switch (unit) {
        // Metric Bytes
        yottabytes => Information(value, unit),
        zettabytes => coarserOrThis(yottabytes, MetricSystem.Kilo.toInt()),
        exabytes => coarserOrThis(zettabytes, MetricSystem.Kilo.toInt()),
        petabytes => coarserOrThis(exabytes, MetricSystem.Kilo.toInt()),
        terabytes => coarserOrThis(petabytes, MetricSystem.Kilo.toInt()),
        gigabytes => coarserOrThis(terabytes, MetricSystem.Kilo.toInt()),
        megabytes => coarserOrThis(gigabytes, MetricSystem.Kilo.toInt()),
        kilobytes => coarserOrThis(megabytes, MetricSystem.Kilo.toInt()),
        bytes => coarserOrThis(kilobytes, MetricSystem.Kilo.toInt()),
        // Binary Bytes
        yobibytes => Information(value, unit),
        zebibytes => coarserOrThis(yobibytes, BinarySystem.Kilo.toInt()),
        exbibytes => coarserOrThis(zebibytes, BinarySystem.Kilo.toInt()),
        pebibytes => coarserOrThis(exbibytes, BinarySystem.Kilo.toInt()),
        tebibytes => coarserOrThis(pebibytes, BinarySystem.Kilo.toInt()),
        gibibytes => coarserOrThis(tebibytes, BinarySystem.Kilo.toInt()),
        mebibytes => coarserOrThis(gibibytes, BinarySystem.Kilo.toInt()),
        kibibytes => coarserOrThis(mebibytes, BinarySystem.Kilo.toInt()),
        // Metric Bits
        yottabits => Information(value, unit),
        zettabits => coarserOrThis(yottabits, MetricSystem.Kilo.toInt()),
        exabits => coarserOrThis(zettabits, MetricSystem.Kilo.toInt()),
        petabits => coarserOrThis(exabits, MetricSystem.Kilo.toInt()),
        terabits => coarserOrThis(petabits, MetricSystem.Kilo.toInt()),
        gigabits => coarserOrThis(terabits, MetricSystem.Kilo.toInt()),
        megabits => coarserOrThis(gigabits, MetricSystem.Kilo.toInt()),
        kilobits => coarserOrThis(megabits, MetricSystem.Kilo.toInt()),
        bits => coarserOrThis(kilobits, MetricSystem.Kilo.toInt()),
        // Binary Bits
        yobibits => Information(value, unit),
        zebibits => coarserOrThis(yobibits, BinarySystem.Kilo.toInt()),
        exbibits => coarserOrThis(zebibits, BinarySystem.Kilo.toInt()),
        pebibits => coarserOrThis(exbibits, BinarySystem.Kilo.toInt()),
        tebibits => coarserOrThis(pebibits, BinarySystem.Kilo.toInt()),
        gibibits => coarserOrThis(tebibits, BinarySystem.Kilo.toInt()),
        mebibits => coarserOrThis(gibibits, BinarySystem.Kilo.toInt()),
        kibibits => coarserOrThis(mebibits, BinarySystem.Kilo.toInt()),
        _ => this,
      };
    }

    return unit == yottabytes || unit == yobibytes || unit == yottabits || unit == yobibits
        ? this
        : loop(value, unit);
  }

  /// Conversion factor from bytes to bits: 1 byte = 8 bits, so 1 bit = 0.125 bytes.
  static const BitsConversionFactor = 0.125;

  /// Unit for bytes (B) — the SI base unit of information.
  static const bytes = Bytes._();

  /// Unit for octets (o) — equivalent to bytes; common in networking contexts.
  static const octets = Octets._();

  /// Unit for kilobytes (KB) — 10³ bytes.
  static const kilobytes = Kilobytes._();

  /// Unit for kibibytes (KiB) — 2¹⁰ = 1 024 bytes.
  static const kibibytes = Kibibytes._();

  /// Unit for megabytes (MB) — 10⁶ bytes.
  static const megabytes = Megabytes._();

  /// Unit for mebibytes (MiB) — 2²⁰ = 1 048 576 bytes.
  static const mebibytes = Mebibytes._();

  /// Unit for gigabytes (GB) — 10⁹ bytes.
  static const gigabytes = Gigabytes._();

  /// Unit for gibibytes (GiB) — 2³⁰ bytes.
  static const gibibytes = Gibibytes._();

  /// Unit for terabytes (TB) — 10¹² bytes.
  static const terabytes = Terabytes._();

  /// Unit for tebibytes (TiB) — 2⁴⁰ bytes.
  static const tebibytes = Tebibytes._();

  /// Unit for petabytes (PB) — 10¹⁵ bytes.
  static const petabytes = Petabytes._();

  /// Unit for pebibytes (PiB) — 2⁵⁰ bytes.
  static const pebibytes = Pebibytes._();

  /// Unit for exabytes (EB) — 10¹⁸ bytes.
  static const exabytes = Exabytes._();

  /// Unit for exbibytes (EiB) — 2⁶⁰ bytes.
  static const exbibytes = Exbibytes._();

  /// Unit for zettabytes (ZB) — 10²¹ bytes.
  static const zettabytes = Zettabytes._();

  /// Unit for zebibytes (ZiB) — 2⁷⁰ bytes.
  static const zebibytes = Zebibytes._();

  /// Unit for yottabytes (YB) — 10²⁴ bytes.
  static const yottabytes = Yottabytes._();

  /// Unit for yobibytes (YiB) — 2⁸⁰ bytes.
  static const yobibytes = Yobibytes._();

  /// Unit for bits (bit) — 1/8 of a byte.
  static const bits = Bits._();

  /// Unit for kilobits (Kbit) — 10³ bits.
  static const kilobits = Kilobits._();

  /// Unit for kibibits (Kibit) — 2¹⁰ bits.
  static const kibibits = Kibibits._();

  /// Unit for megabits (Mbit) — 10⁶ bits.
  static const megabits = Megabits._();

  /// Unit for mebibits (Mibit) — 2²⁰ bits.
  static const mebibits = Mebibits._();

  /// Unit for gigabits (Gbit) — 10⁹ bits.
  static const gigabits = Gigabits._();

  /// Unit for gibibits (Gibit) — 2³⁰ bits.
  static const gibibits = Gibibits._();

  /// Unit for terabits (Tbit) — 10¹² bits.
  static const terabits = Terabits._();

  /// Unit for tebibits (Tibit) — 2⁴⁰ bits.
  static const tebibits = Tebibits._();

  /// Unit for petabits (Pbit) — 10¹⁵ bits.
  static const petabits = Petabits._();

  /// Unit for pebibits (Pibit) — 2⁵⁰ bits.
  static const pebibits = Pebibits._();

  /// Unit for exabits (Ebit) — 10¹⁸ bits.
  static const exabits = Exabits._();

  /// Unit for exbibits (Eibit) — 2⁶⁰ bits.
  static const exbibits = Exbibits._();

  /// Unit for zettabits (Zbit) — 10²¹ bits.
  static const zettabits = Zettabits._();

  /// Unit for zebibits (Zibit) — 2⁷⁰ bits.
  static const zebibits = Zebibits._();

  /// Unit for yottabits (Ybit) — 10²⁴ bits.
  static const yottabits = Yottabits._();

  /// Unit for yobibits (Yibit) — 2⁸⁰ bits.
  static const yobibits = Yobibits._();

  /// All supported [Information] units.
  static final units = {
    bytes,
    octets,
    kilobytes,
    kibibytes,
    megabytes,
    mebibytes,
    gigabytes,
    gibibytes,
    terabytes,
    tebibytes,
    petabytes,
    pebibytes,
    exabytes,
    exbibytes,
    zettabytes,
    zebibytes,
    yottabytes,
    yobibytes,
    bits,
    kilobits,
    kibibits,
    megabits,
    mebibits,
    gigabits,
    gibibits,
    terabits,
    tebibits,
    petabits,
    pebibits,
    exabits,
    exbibits,
    zettabits,
    zebibits,
    yottabits,
    yobibits,
  };

  /// Parses [s] into an [Information], returning [None] if parsing fails.
  static Option<Information> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [Information] units.
abstract class InformationUnit extends BaseUnit<Information> {
  const InformationUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Information call(num value) => Information(value.toDouble(), this);
}

/// Bytes (B) — the SI base unit of information.
final class Bytes extends InformationUnit {
  const Bytes._() : super('byte', 'B', 1);
}

/// Octets (o) — equivalent to bytes; used in networking standards.
final class Octets extends InformationUnit {
  const Octets._() : super('octet', 'o', 1);
}

/// Kilobytes (KB) — 10³ bytes.
final class Kilobytes extends InformationUnit {
  const Kilobytes._() : super('kilobyte', 'KB', MetricSystem.Kilo);
}

/// Kibibytes (KiB) — 2¹⁰ = 1 024 bytes (IEC binary prefix).
final class Kibibytes extends InformationUnit {
  const Kibibytes._() : super('kibibyte', 'KiB', BinarySystem.Kilo);
}

/// Megabytes (MB) — 10⁶ bytes.
final class Megabytes extends InformationUnit {
  const Megabytes._() : super('megabyte', 'MB', MetricSystem.Mega);
}

/// Mebibytes (MiB) — 2²⁰ bytes (IEC binary prefix).
final class Mebibytes extends InformationUnit {
  const Mebibytes._() : super('mebibyte', 'MiB', BinarySystem.Mega);
}

/// Gigabytes (GB) — 10⁹ bytes.
final class Gigabytes extends InformationUnit {
  const Gigabytes._() : super('gigabyte', 'GB', MetricSystem.Giga);
}

/// Gibibytes (GiB) — 2³⁰ bytes (IEC binary prefix).
final class Gibibytes extends InformationUnit {
  const Gibibytes._() : super('gibibyte', 'GiB', BinarySystem.Giga);
}

/// Terabytes (TB) — 10¹² bytes.
final class Terabytes extends InformationUnit {
  const Terabytes._() : super('terabyte', 'TB', MetricSystem.Tera);
}

/// Tebibytes (TiB) — 2⁴⁰ bytes (IEC binary prefix).
final class Tebibytes extends InformationUnit {
  const Tebibytes._() : super('tebibyte', 'TiB', BinarySystem.Tera);
}

/// Petabytes (PB) — 10¹⁵ bytes.
final class Petabytes extends InformationUnit {
  const Petabytes._() : super('petabyte', 'PB', MetricSystem.Peta);
}

/// Pebibytes (PiB) — 2⁵⁰ bytes (IEC binary prefix).
final class Pebibytes extends InformationUnit {
  const Pebibytes._() : super('pebibyte', 'PiB', BinarySystem.Peta);
}

/// Exabytes (EB) — 10¹⁸ bytes.
final class Exabytes extends InformationUnit {
  const Exabytes._() : super('exabyte', 'EB', MetricSystem.Exa);
}

/// Exbibytes (EiB) — 2⁶⁰ bytes (IEC binary prefix).
final class Exbibytes extends InformationUnit {
  const Exbibytes._() : super('exbibyte', 'EiB', BinarySystem.Exa);
}

/// Zettabytes (ZB) — 10²¹ bytes.
final class Zettabytes extends InformationUnit {
  const Zettabytes._() : super('zettabyte', 'ZB', MetricSystem.Zetta);
}

/// Zebibytes (ZiB) — 2⁷⁰ bytes (IEC binary prefix).
final class Zebibytes extends InformationUnit {
  const Zebibytes._() : super('zebibyte', 'ZiB', BinarySystem.Zetta);
}

/// Yottabytes (YB) — 10²⁴ bytes.
final class Yottabytes extends InformationUnit {
  const Yottabytes._() : super('yottabyte', 'YB', MetricSystem.Yotta);
}

/// Yobibytes (YiB) — 2⁸⁰ bytes (IEC binary prefix).
final class Yobibytes extends InformationUnit {
  const Yobibytes._() : super('yobibyte', 'YiB', BinarySystem.Yotta);
}

/// Bits (bit) — 1/8 of a byte; the smallest unit of information.
final class Bits extends InformationUnit {
  const Bits._() : super('bit', 'bit', 0.125);
}

/// Kilobits (Kbit) — 10³ bits.
final class Kilobits extends InformationUnit {
  const Kilobits._()
    : super('kilobit', 'Kbit', Information.BitsConversionFactor * MetricSystem.Kilo);
}

/// Kibibits (Kibit) — 2¹⁰ bits (IEC binary prefix).
final class Kibibits extends InformationUnit {
  const Kibibits._()
    : super('kibibit', 'Kibit', Information.BitsConversionFactor * BinarySystem.Kilo);
}

/// Megabits (Mbit) — 10⁶ bits.
final class Megabits extends InformationUnit {
  const Megabits._()
    : super('megabit', 'Mbit', Information.BitsConversionFactor * MetricSystem.Mega);
}

/// Mebibits (Mibit) — 2²⁰ bits (IEC binary prefix).
final class Mebibits extends InformationUnit {
  const Mebibits._()
    : super('mebibit', 'Mibit', Information.BitsConversionFactor * BinarySystem.Mega);
}

/// Gigabits (Gbit) — 10⁹ bits.
final class Gigabits extends InformationUnit {
  const Gigabits._()
    : super('gigabit', 'Gbit', Information.BitsConversionFactor * MetricSystem.Giga);
}

/// Gibibits (Gibit) — 2³⁰ bits (IEC binary prefix).
final class Gibibits extends InformationUnit {
  const Gibibits._()
    : super('gibibit', 'Gibit', Information.BitsConversionFactor * BinarySystem.Giga);
}

/// Terabits (Tbit) — 10¹² bits.
final class Terabits extends InformationUnit {
  const Terabits._()
    : super('terabit', 'Tbit', Information.BitsConversionFactor * MetricSystem.Tera);
}

/// Tebibits (Tibit) — 2⁴⁰ bits (IEC binary prefix).
final class Tebibits extends InformationUnit {
  const Tebibits._()
    : super('tebibit', 'Tibit', Information.BitsConversionFactor * BinarySystem.Tera);
}

/// Petabits (Pbit) — 10¹⁵ bits.
final class Petabits extends InformationUnit {
  const Petabits._()
    : super('petabit', 'Pbit', Information.BitsConversionFactor * MetricSystem.Peta);
}

/// Pebibits (Pibit) — 2⁵⁰ bits (IEC binary prefix).
final class Pebibits extends InformationUnit {
  const Pebibits._()
    : super('pebibit', 'Pibit', Information.BitsConversionFactor * BinarySystem.Peta);
}

/// Exabits (Ebit) — 10¹⁸ bits.
final class Exabits extends InformationUnit {
  const Exabits._() : super('exabit', 'Ebit', Information.BitsConversionFactor * MetricSystem.Exa);
}

/// Exbibits (Eibit) — 2⁶⁰ bits (IEC binary prefix).
final class Exbibits extends InformationUnit {
  const Exbibits._()
    : super('exbibit', 'Eibit', Information.BitsConversionFactor * BinarySystem.Exa);
}

/// Zettabits (Zbit) — 10²¹ bits.
final class Zettabits extends InformationUnit {
  const Zettabits._()
    : super('zettabit', 'Zbit', Information.BitsConversionFactor * MetricSystem.Zetta);
}

/// Zebibits (Zibit) — 2⁷⁰ bits (IEC binary prefix).
final class Zebibits extends InformationUnit {
  const Zebibits._()
    : super('zebibit', 'Zibit', Information.BitsConversionFactor * BinarySystem.Zetta);
}

/// Yottabits (Ybit) — 10²⁴ bits.
final class Yottabits extends InformationUnit {
  const Yottabits._()
    : super('yottabit', 'Ybit', Information.BitsConversionFactor * MetricSystem.Yotta);
}

/// Yobibits (Yibit) — 2⁸⁰ bits (IEC binary prefix).
final class Yobibits extends InformationUnit {
  const Yobibits._()
    : super('yobibit', 'Yibit', Information.BitsConversionFactor * BinarySystem.Yotta);
}

/// Extension methods for constructing [Information] values from [num].
extension InformationOps on num {
  /// Creates an [Information] of this value in bytes.
  Information get bytes => Information.bytes(this);

  /// Creates an [Information] of this value in octets.
  Information get octets => Information.octets(this);

  /// Creates an [Information] of this value in kilobytes (10³ bytes).
  Information get kilobytes => Information.kilobytes(this);

  /// Creates an [Information] of this value in kibibytes (2¹⁰ bytes).
  Information get kibibytes => Information.kibibytes(this);

  /// Creates an [Information] of this value in megabytes (10⁶ bytes).
  Information get megabytes => Information.megabytes(this);

  /// Creates an [Information] of this value in mebibytes (2²⁰ bytes).
  Information get mebibytes => Information.mebibytes(this);

  /// Creates an [Information] of this value in gigabytes (10⁹ bytes).
  Information get gigabytes => Information.gigabytes(this);

  /// Creates an [Information] of this value in gibibytes (2³⁰ bytes).
  Information get gibibytes => Information.gibibytes(this);

  /// Creates an [Information] of this value in terabytes (10¹² bytes).
  Information get terabytes => Information.terabytes(this);

  /// Creates an [Information] of this value in tebibytes (2⁴⁰ bytes).
  Information get tebibytes => Information.tebibytes(this);

  /// Creates an [Information] of this value in petabytes (10¹⁵ bytes).
  Information get petabytes => Information.petabytes(this);

  /// Creates an [Information] of this value in pebibytes (2⁵⁰ bytes).
  Information get pebibytes => Information.pebibytes(this);

  /// Creates an [Information] of this value in exabytes (10¹⁸ bytes).
  Information get exabytes => Information.exabytes(this);

  /// Creates an [Information] of this value in exbibytes (2⁶⁰ bytes).
  Information get exbibytes => Information.exbibytes(this);

  /// Creates an [Information] of this value in zettabytes (10²¹ bytes).
  Information get zettabytes => Information.zettabytes(this);

  /// Creates an [Information] of this value in zebibytes (2⁷⁰ bytes).
  Information get zebibytes => Information.zebibytes(this);

  /// Creates an [Information] of this value in yottabytes (10²⁴ bytes).
  Information get yottabytes => Information.yottabytes(this);

  /// Creates an [Information] of this value in yobibytes (2⁸⁰ bytes).
  Information get yobibytes => Information.yobibytes(this);

  /// Creates an [Information] of this value in bits.
  Information get bits => Information.bits(this);

  /// Creates an [Information] of this value in kilobits (10³ bits).
  Information get kilobits => Information.kilobits(this);

  /// Creates an [Information] of this value in kibibits (2¹⁰ bits).
  Information get kibibits => Information.kibibits(this);

  /// Creates an [Information] of this value in megabits (10⁶ bits).
  Information get megabits => Information.megabits(this);

  /// Creates an [Information] of this value in mebibits (2²⁰ bits).
  Information get mebibits => Information.mebibits(this);

  /// Creates an [Information] of this value in gigabits (10⁹ bits).
  Information get gigabits => Information.gigabits(this);

  /// Creates an [Information] of this value in gibibits (2³⁰ bits).
  Information get gibibits => Information.gibibits(this);

  /// Creates an [Information] of this value in terabits (10¹² bits).
  Information get terabits => Information.terabits(this);

  /// Creates an [Information] of this value in tebibits (2⁴⁰ bits).
  Information get tebibits => Information.tebibits(this);

  /// Creates an [Information] of this value in petabits (10¹⁵ bits).
  Information get petabits => Information.petabits(this);

  /// Creates an [Information] of this value in pebibits (2⁵⁰ bits).
  Information get pebibits => Information.pebibits(this);

  /// Creates an [Information] of this value in exabits (10¹⁸ bits).
  Information get exabits => Information.exabits(this);

  /// Creates an [Information] of this value in exbibits (2⁶⁰ bits).
  Information get exbibits => Information.exbibits(this);

  /// Creates an [Information] of this value in zettabits (10²¹ bits).
  Information get zettabits => Information.zettabits(this);

  /// Creates an [Information] of this value in zebibits (2⁷⁰ bits).
  Information get zebibits => Information.zebibits(this);

  /// Creates an [Information] of this value in yottabits (10²⁴ bits).
  Information get yottabits => Information.yottabits(this);

  /// Creates an [Information] of this value in yobibits (2⁸⁰ bits).
  Information get yobibits => Information.yobibits(this);
}
