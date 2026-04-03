import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

/// A quantity representing data rate (throughput) — the amount of digital
/// information transferred per second.
///
/// Units are available in both metric (SI) and binary (IEC) prefix variants,
/// and in bytes per second or bits per second. The internal base unit is
/// bytes per second (B/s). Bit-based units use [Information.BitsConversionFactor]
/// (0.125 = 1/8) as their conversion factor.
final class DataRate extends Quantity<DataRate> {
  DataRate(super.value, super.unit);

  /// Returns the sum of this and [that] in the units of this [DataRate].
  DataRate operator +(DataRate that) => DataRate(value + that.to(unit), unit);

  /// Returns the difference between this and [that] in the units of this [DataRate].
  DataRate operator -(DataRate that) => DataRate(value - that.to(unit), unit);

  /// Converts this to bytes per second (B/s).
  DataRate get toBytesPerSecond => to(bytesPerSecond).bytesPerSecond;

  /// Converts this to kilobytes per second (KB/s) — 10³ B/s.
  DataRate get toKilobytesPerSecond => to(kilobytesPerSecond).kilobytesPerSecond;

  /// Converts this to kibibytes per second (KiB/s) — 2¹⁰ B/s.
  DataRate get toKibibytesPerSecond => to(kibibytesPerSecond).kibibytesPerSecond;

  /// Converts this to megabytes per second (MB/s) — 10⁶ B/s.
  DataRate get toMegabytesPerSecond => to(megabytesPerSecond).megabytesPerSecond;

  /// Converts this to mebibytes per second (MiB/s) — 2²⁰ B/s.
  DataRate get toMebibytesPerSecond => to(mebibytesPerSecond).mebibytesPerSecond;

  /// Converts this to gigabytes per second (GB/s) — 10⁹ B/s.
  DataRate get toGigabytesPerSecond => to(gigabytesPerSecond).gigabytesPerSecond;

  /// Converts this to gibibytes per second (GiB/s) — 2³⁰ B/s.
  DataRate get toGibibytesPerSecond => to(gibibytesPerSecond).gibibytesPerSecond;

  /// Converts this to terabytes per second (TB/s) — 10¹² B/s.
  DataRate get toTerabytesPerSecond => to(terabytesPerSecond).terabytesPerSecond;

  /// Converts this to tebibytes per second (TiB/s) — 2⁴⁰ B/s.
  DataRate get toTebibytesPerSecond => to(tebibytesPerSecond).tebibytesPerSecond;

  /// Converts this to petabytes per second (PB/s) — 10¹⁵ B/s.
  DataRate get toPetabytesPerSecond => to(petabytesPerSecond).petabytesPerSecond;

  /// Converts this to pebibytes per second (PiB/s) — 2⁵⁰ B/s.
  DataRate get toPebibytesPerSecond => to(pebibytesPerSecond).pebibytesPerSecond;

  /// Converts this to exabytes per second (EB/s) — 10¹⁸ B/s.
  DataRate get toExabytesPerSecond => to(exabytesPerSecond).exabytesPerSecond;

  /// Converts this to exbibytes per second (EiB/s) — 2⁶⁰ B/s.
  DataRate get toExbibytesPerSecond => to(exbibytesPerSecond).exbibytesPerSecond;

  /// Converts this to zettabytes per second (ZB/s) — 10²¹ B/s.
  DataRate get toZettabytesPerSecond => to(zettabytesPerSecond).zettabytesPerSecond;

  /// Converts this to zebibytes per second (ZiB/s) — 2⁷⁰ B/s.
  DataRate get toZebibytesPerSecond => to(zebibytesPerSecond).zebibytesPerSecond;

  /// Converts this to yottabytes per second (YB/s) — 10²⁴ B/s.
  DataRate get toYottabytesPerSecond => to(yottabytesPerSecond).yottabytesPerSecond;

  /// Converts this to yobibytes per second (YiB/s) — 2⁸⁰ B/s.
  DataRate get toYobibytesPerSecond => to(yobibytesPerSecond).yobibytesPerSecond;

  /// Converts this to bits per second (bps).
  DataRate get toBitsPerSecond => to(bitsPerSecond).bitsPerSecond;

  /// Converts this to kilobits per second (Kbps) — 10³ bps.
  DataRate get toKilobitsPerSecond => to(kilobitsPerSecond).kilobitsPerSecond;

  /// Converts this to kibibits per second (Kibps) — 2¹⁰ bps.
  DataRate get toKibibitsPerSecond => to(kibibitsPerSecond).kibibitsPerSecond;

  /// Converts this to megabits per second (Mbps) — 10⁶ bps.
  DataRate get toMegabitsPerSecond => to(megabitsPerSecond).megabitsPerSecond;

  /// Converts this to mebibits per second (Mibps) — 2²⁰ bps.
  DataRate get toMebibitsPerSecond => to(mebibitsPerSecond).mebibitsPerSecond;

  /// Converts this to gigabits per second (Gbps) — 10⁹ bps.
  DataRate get toGigabitsPerSecond => to(gigabitsPerSecond).gigabitsPerSecond;

  /// Converts this to gibibits per second (Gibps) — 2³⁰ bps.
  DataRate get toGibibitsPerSecond => to(gibibitsPerSecond).gibibitsPerSecond;

  /// Converts this to terabits per second (Tbps) — 10¹² bps.
  DataRate get toTerabitsPerSecond => to(terabitsPerSecond).terabitsPerSecond;

  /// Converts this to tebibits per second (Tibps) — 2⁴⁰ bps.
  DataRate get toTebibitsPerSecond => to(tebibitsPerSecond).tebibitsPerSecond;

  /// Converts this to petabits per second (Pbps) — 10¹⁵ bps.
  DataRate get toPetabitsPerSecond => to(petabitsPerSecond).petabitsPerSecond;

  /// Converts this to pebibits per second (Pibps) — 2⁵⁰ bps.
  DataRate get toPebibitsPerSecond => to(pebibitsPerSecond).pebibitsPerSecond;

  /// Converts this to exabits per second (Ebps) — 10¹⁸ bps.
  DataRate get toExabitsPerSecond => to(exabitsPerSecond).exabitsPerSecond;

  /// Converts this to exbibits per second (Eibps) — 2⁶⁰ bps.
  DataRate get toExbibitsPerSecond => to(exbibitsPerSecond).exbibitsPerSecond;

  /// Converts this to zettabits per second (Zbps) — 10²¹ bps.
  DataRate get toZettabitsPerSecond => to(zettabitsPerSecond).zettabitsPerSecond;

  /// Converts this to zebibits per second (Zibps) — 2⁷⁰ bps.
  DataRate get toZebibitsPerSecond => to(zebibitsPerSecond).zebibitsPerSecond;

  /// Converts this to yottabits per second (Ybps) — 10²⁴ bps.
  DataRate get toYottabitsPerSecond => to(yottabitsPerSecond).yottabitsPerSecond;

  /// Converts this to yobibits per second (Yibps) — 2⁸⁰ bps.
  DataRate get toYobibitsPerSecond => to(yobibitsPerSecond).yobibitsPerSecond;

  /// Unit for bytes per second (B/s) — the base unit of data rate.
  static const bytesPerSecond = BytesPerSecond._();

  /// Unit for kilobytes per second (KB/s) — 10³ B/s.
  static const kilobytesPerSecond = KilobytesPerSecond._();

  /// Unit for kibibytes per second (KiB/s) — 2¹⁰ B/s.
  static const kibibytesPerSecond = KibibytesPerSecond._();

  /// Unit for megabytes per second (MB/s) — 10⁶ B/s.
  static const megabytesPerSecond = MegabytesPerSecond._();

  /// Unit for mebibytes per second (MiB/s) — 2²⁰ B/s.
  static const mebibytesPerSecond = MebibytesPerSecond._();

  /// Unit for gigabytes per second (GB/s) — 10⁹ B/s.
  static const gigabytesPerSecond = GigabytesPerSecond._();

  /// Unit for gibibytes per second (GiB/s) — 2³⁰ B/s.
  static const gibibytesPerSecond = GibibytesPerSecond._();

  /// Unit for terabytes per second (TB/s) — 10¹² B/s.
  static const terabytesPerSecond = TerabytesPerSecond._();

  /// Unit for tebibytes per second (TiB/s) — 2⁴⁰ B/s.
  static const tebibytesPerSecond = TebibytesPerSecond._();

  /// Unit for petabytes per second (PB/s) — 10¹⁵ B/s.
  static const petabytesPerSecond = PetabytesPerSecond._();

  /// Unit for pebibytes per second (PiB/s) — 2⁵⁰ B/s.
  static const pebibytesPerSecond = PebibytesPerSecond._();

  /// Unit for exabytes per second (EB/s) — 10¹⁸ B/s.
  static const exabytesPerSecond = ExabytesPerSecond._();

  /// Unit for exbibytes per second (EiB/s) — 2⁶⁰ B/s.
  static const exbibytesPerSecond = ExbibytesPerSecond._();

  /// Unit for zettabytes per second (ZB/s) — 10²¹ B/s.
  static const zettabytesPerSecond = ZettabytesPerSecond._();

  /// Unit for zebibytes per second (ZiB/s) — 2⁷⁰ B/s.
  static const zebibytesPerSecond = ZebibytesPerSecond._();

  /// Unit for yottabytes per second (YB/s) — 10²⁴ B/s.
  static const yottabytesPerSecond = YottabytesPerSecond._();

  /// Unit for yobibytes per second (YiB/s) — 2⁸⁰ B/s.
  static const yobibytesPerSecond = YobibytesPerSecond._();

  /// Unit for bits per second (bps).
  static const bitsPerSecond = BitsPerSecond._();

  /// Unit for kilobits per second (Kbps) — 10³ bps.
  static const kilobitsPerSecond = KilobitsPerSecond._();

  /// Unit for kibibits per second (Kibps) — 2¹⁰ bps.
  static const kibibitsPerSecond = KibibitsPerSecond._();

  /// Unit for megabits per second (Mbps) — 10⁶ bps.
  static const megabitsPerSecond = MegabitsPerSecond._();

  /// Unit for mebibits per second (Mibps) — 2²⁰ bps.
  static const mebibitsPerSecond = MebibitsPerSecond._();

  /// Unit for gigabits per second (Gbps) — 10⁹ bps.
  static const gigabitsPerSecond = GigabitsPerSecond._();

  /// Unit for gibibits per second (Gibps) — 2³⁰ bps.
  static const gibibitsPerSecond = GibibitsPerSecond._();

  /// Unit for terabits per second (Tbps) — 10¹² bps.
  static const terabitsPerSecond = TerabitsPerSecond._();

  /// Unit for tebibits per second (Tibps) — 2⁴⁰ bps.
  static const tebibitsPerSecond = TebibitsPerSecond._();

  /// Unit for petabits per second (Pbps) — 10¹⁵ bps.
  static const petabitsPerSecond = PetabitsPerSecond._();

  /// Unit for pebibits per second (Pibps) — 2⁵⁰ bps.
  static const pebibitsPerSecond = PebibitsPerSecond._();

  /// Unit for exabits per second (Ebps) — 10¹⁸ bps.
  static const exabitsPerSecond = ExabitsPerSecond._();

  /// Unit for exbibits per second (Eibps) — 2⁶⁰ bps.
  static const exbibitsPerSecond = ExbibitsPerSecond._();

  /// Unit for zettabits per second (Zbps) — 10²¹ bps.
  static const zettabitsPerSecond = ZettabitsPerSecond._();

  /// Unit for zebibits per second (Zibps) — 2⁷⁰ bps.
  static const zebibitsPerSecond = ZebibitsPerSecond._();

  /// Unit for yottabits per second (Ybps) — 10²⁴ bps.
  static const yottabitsPerSecond = YottabitsPerSecond._();

  /// Unit for yobibits per second (Yibps) — 2⁸⁰ bps.
  static const yobibitsPerSecond = YobibitsPerSecond._();

  /// All supported [DataRate] units.
  static const units = {
    bytesPerSecond,
    kilobytesPerSecond,
    kibibytesPerSecond,
    megabytesPerSecond,
    mebibytesPerSecond,
    gigabytesPerSecond,
    gibibytesPerSecond,
    terabytesPerSecond,
    tebibytesPerSecond,
    petabytesPerSecond,
    pebibytesPerSecond,
    exabytesPerSecond,
    exbibytesPerSecond,
    zettabytesPerSecond,
    zebibytesPerSecond,
    yottabytesPerSecond,
    yobibytesPerSecond,
    bitsPerSecond,
    kilobitsPerSecond,
    kibibitsPerSecond,
    megabitsPerSecond,
    mebibitsPerSecond,
    gigabitsPerSecond,
    gibibitsPerSecond,
    terabitsPerSecond,
    tebibitsPerSecond,
    petabitsPerSecond,
    pebibitsPerSecond,
    exabitsPerSecond,
    exbibitsPerSecond,
    zettabitsPerSecond,
    zebibitsPerSecond,
    yottabitsPerSecond,
    yobibitsPerSecond,
  };

  /// Parses [s] into a [DataRate], returning [None] if parsing fails.
  static Option<DataRate> parse(String s) => Quantity.parse(s, units);
}

/// Base class for all [DataRate] units.
abstract class DataRateUnit extends BaseUnit<DataRate> {
  const DataRateUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  DataRate call(num value) => DataRate(value.toDouble(), this);
}

/// Bytes per second (B/s) — the base unit of data rate.
final class BytesPerSecond extends DataRateUnit {
  const BytesPerSecond._() : super('bytes/second', 'B/s', 1);
}

/// Kilobytes per second (KB/s) — 10³ B/s.
final class KilobytesPerSecond extends DataRateUnit {
  const KilobytesPerSecond._() : super('kilobytes/second', 'KB/s', MetricSystem.Kilo);
}

/// Kibibytes per second (KiB/s) — 2¹⁰ B/s (IEC binary prefix).
final class KibibytesPerSecond extends DataRateUnit {
  const KibibytesPerSecond._() : super('kibibytes/second', 'KiB/s', BinarySystem.Kilo);
}

/// Megabytes per second (MB/s) — 10⁶ B/s.
final class MegabytesPerSecond extends DataRateUnit {
  const MegabytesPerSecond._() : super('megabytes/second', 'MB/s', MetricSystem.Mega);
}

/// Mebibytes per second (MiB/s) — 2²⁰ B/s (IEC binary prefix).
final class MebibytesPerSecond extends DataRateUnit {
  const MebibytesPerSecond._() : super('mebibytes/second', 'MiB/s', BinarySystem.Mega);
}

/// Gigabytes per second (GB/s) — 10⁹ B/s.
final class GigabytesPerSecond extends DataRateUnit {
  const GigabytesPerSecond._() : super('gigabytes/second', 'GB/s', MetricSystem.Giga);
}

/// Gibibytes per second (GiB/s) — 2³⁰ B/s (IEC binary prefix).
final class GibibytesPerSecond extends DataRateUnit {
  const GibibytesPerSecond._() : super('gibibytes/second', 'GiB/s', BinarySystem.Giga);
}

/// Terabytes per second (TB/s) — 10¹² B/s.
final class TerabytesPerSecond extends DataRateUnit {
  const TerabytesPerSecond._() : super('terabytes/second', 'TB/s', MetricSystem.Tera);
}

/// Tebibytes per second (TiB/s) — 2⁴⁰ B/s (IEC binary prefix).
final class TebibytesPerSecond extends DataRateUnit {
  const TebibytesPerSecond._() : super('tebibytes/second', 'TiB/s', BinarySystem.Tera);
}

/// Petabytes per second (PB/s) — 10¹⁵ B/s.
final class PetabytesPerSecond extends DataRateUnit {
  const PetabytesPerSecond._() : super('petabytes/second', 'PB/s', MetricSystem.Peta);
}

/// Pebibytes per second (PiB/s) — 2⁵⁰ B/s (IEC binary prefix).
final class PebibytesPerSecond extends DataRateUnit {
  const PebibytesPerSecond._() : super('pebibytes/second', 'PiB/s', BinarySystem.Peta);
}

/// Exabytes per second (EB/s) — 10¹⁸ B/s.
final class ExabytesPerSecond extends DataRateUnit {
  const ExabytesPerSecond._() : super('exabytes/second', 'EB/s', MetricSystem.Exa);
}

/// Exbibytes per second (EiB/s) — 2⁶⁰ B/s (IEC binary prefix).
final class ExbibytesPerSecond extends DataRateUnit {
  const ExbibytesPerSecond._() : super('exbibytes/second', 'EiB/s', BinarySystem.Exa);
}

/// Zettabytes per second (ZB/s) — 10²¹ B/s.
final class ZettabytesPerSecond extends DataRateUnit {
  const ZettabytesPerSecond._() : super('zettabytes/second', 'ZB/s', MetricSystem.Zetta);
}

/// Zebibytes per second (ZiB/s) — 2⁷⁰ B/s (IEC binary prefix).
final class ZebibytesPerSecond extends DataRateUnit {
  const ZebibytesPerSecond._() : super('zebibytes/second', 'ZiB/s', BinarySystem.Zetta);
}

/// Yottabytes per second (YB/s) — 10²⁴ B/s.
final class YottabytesPerSecond extends DataRateUnit {
  const YottabytesPerSecond._() : super('yottabytes/second', 'YB/s', MetricSystem.Yotta);
}

/// Yobibytes per second (YiB/s) — 2⁸⁰ B/s (IEC binary prefix).
final class YobibytesPerSecond extends DataRateUnit {
  const YobibytesPerSecond._() : super('yobibytes/second', 'YiB/s', BinarySystem.Yotta);
}

/// Bits per second (bps).
final class BitsPerSecond extends DataRateUnit {
  const BitsPerSecond._() : super('bits/second', 'bps', Information.BitsConversionFactor);
}

/// Kilobits per second (Kbps) — 10³ bps.
final class KilobitsPerSecond extends DataRateUnit {
  const KilobitsPerSecond._()
    : super('kilobits/second', 'Kbps', Information.BitsConversionFactor * MetricSystem.Kilo);
}

/// Kibibits per second (Kibps) — 2¹⁰ bps (IEC binary prefix).
final class KibibitsPerSecond extends DataRateUnit {
  const KibibitsPerSecond._()
    : super('kibibits/second', 'Kibps', Information.BitsConversionFactor * BinarySystem.Kilo);
}

/// Megabits per second (Mbps) — 10⁶ bps.
final class MegabitsPerSecond extends DataRateUnit {
  const MegabitsPerSecond._()
    : super('megabits/second', 'Mbps', Information.BitsConversionFactor * MetricSystem.Giga);
}

/// Mebibits per second (Mibps) — 2²⁰ bps (IEC binary prefix).
final class MebibitsPerSecond extends DataRateUnit {
  const MebibitsPerSecond._()
    : super('mebibits/second', 'Mibps', Information.BitsConversionFactor * BinarySystem.Mega);
}

/// Gigabits per second (Gbps) — 10⁹ bps.
final class GigabitsPerSecond extends DataRateUnit {
  const GigabitsPerSecond._()
    : super('gigabits/second', 'Gbps', Information.BitsConversionFactor * MetricSystem.Giga);
}

/// Gibibits per second (Gibps) — 2³⁰ bps (IEC binary prefix).
final class GibibitsPerSecond extends DataRateUnit {
  const GibibitsPerSecond._()
    : super('gibibits/second', 'Gibps', Information.BitsConversionFactor * BinarySystem.Giga);
}

/// Terabits per second (Tbps) — 10¹² bps.
final class TerabitsPerSecond extends DataRateUnit {
  const TerabitsPerSecond._()
    : super('terabits/second', 'Tbps', Information.BitsConversionFactor * MetricSystem.Tera);
}

/// Tebibits per second (Tibps) — 2⁴⁰ bps (IEC binary prefix).
final class TebibitsPerSecond extends DataRateUnit {
  const TebibitsPerSecond._()
    : super('tebibits/second', 'Tibps', Information.BitsConversionFactor * BinarySystem.Tera);
}

/// Petabits per second (Pbps) — 10¹⁵ bps.
final class PetabitsPerSecond extends DataRateUnit {
  const PetabitsPerSecond._()
    : super('petabits/second', 'Pbps', Information.BitsConversionFactor * MetricSystem.Peta);
}

/// Pebibits per second (Pibps) — 2⁵⁰ bps (IEC binary prefix).
final class PebibitsPerSecond extends DataRateUnit {
  const PebibitsPerSecond._()
    : super('pebibits/second', 'Pibps', Information.BitsConversionFactor * BinarySystem.Peta);
}

/// Exabits per second (Ebps) — 10¹⁸ bps.
final class ExabitsPerSecond extends DataRateUnit {
  const ExabitsPerSecond._()
    : super('exabits/second', 'Ebps', Information.BitsConversionFactor * MetricSystem.Exa);
}

/// Exbibits per second (Eibps) — 2⁶⁰ bps (IEC binary prefix).
final class ExbibitsPerSecond extends DataRateUnit {
  const ExbibitsPerSecond._()
    : super('exbibits/second', 'Eibps', Information.BitsConversionFactor * BinarySystem.Exa);
}

/// Zettabits per second (Zbps) — 10²¹ bps.
final class ZettabitsPerSecond extends DataRateUnit {
  const ZettabitsPerSecond._()
    : super('zettabits/second', 'Zbps', Information.BitsConversionFactor * MetricSystem.Zetta);
}

/// Zebibits per second (Zibps) — 2⁷⁰ bps (IEC binary prefix).
final class ZebibitsPerSecond extends DataRateUnit {
  const ZebibitsPerSecond._()
    : super('zebibits/second', 'Zibps', Information.BitsConversionFactor * BinarySystem.Zetta);
}

/// Yottabits per second (Ybps) — 10²⁴ bps.
final class YottabitsPerSecond extends DataRateUnit {
  const YottabitsPerSecond._()
    : super('yottabits/second', 'Ybps', Information.BitsConversionFactor * MetricSystem.Yotta);
}

/// Yobibits per second (Yibps) — 2⁸⁰ bps (IEC binary prefix).
final class YobibitsPerSecond extends DataRateUnit {
  const YobibitsPerSecond._()
    : super('yobibits/second', 'Yibps', Information.BitsConversionFactor * BinarySystem.Yotta);
}

/// Extension methods for constructing [DataRate] values from [num].
extension DataRateOps on num {
  /// Creates a [DataRate] of this value in bytes per second.
  DataRate get bytesPerSecond => DataRate.bytesPerSecond(this);

  /// Creates a [DataRate] of this value in kilobytes per second (10³ B/s).
  DataRate get kilobytesPerSecond => DataRate.kilobytesPerSecond(this);

  /// Creates a [DataRate] of this value in kibibytes per second (2¹⁰ B/s).
  DataRate get kibibytesPerSecond => DataRate.kibibytesPerSecond(this);

  /// Creates a [DataRate] of this value in megabytes per second (10⁶ B/s).
  DataRate get megabytesPerSecond => DataRate.megabytesPerSecond(this);

  /// Creates a [DataRate] of this value in mebibytes per second (2²⁰ B/s).
  DataRate get mebibytesPerSecond => DataRate.mebibytesPerSecond(this);

  /// Creates a [DataRate] of this value in gigabytes per second (10⁹ B/s).
  DataRate get gigabytesPerSecond => DataRate.gigabytesPerSecond(this);

  /// Creates a [DataRate] of this value in gibibytes per second (2³⁰ B/s).
  DataRate get gibibytesPerSecond => DataRate.gibibytesPerSecond(this);

  /// Creates a [DataRate] of this value in terabytes per second (10¹² B/s).
  DataRate get terabytesPerSecond => DataRate.terabytesPerSecond(this);

  /// Creates a [DataRate] of this value in tebibytes per second (2⁴⁰ B/s).
  DataRate get tebibytesPerSecond => DataRate.tebibytesPerSecond(this);

  /// Creates a [DataRate] of this value in petabytes per second (10¹⁵ B/s).
  DataRate get petabytesPerSecond => DataRate.petabytesPerSecond(this);

  /// Creates a [DataRate] of this value in pebibytes per second (2⁵⁰ B/s).
  DataRate get pebibytesPerSecond => DataRate.pebibytesPerSecond(this);

  /// Creates a [DataRate] of this value in exabytes per second (10¹⁸ B/s).
  DataRate get exabytesPerSecond => DataRate.exabytesPerSecond(this);

  /// Creates a [DataRate] of this value in exbibytes per second (2⁶⁰ B/s).
  DataRate get exbibytesPerSecond => DataRate.exbibytesPerSecond(this);

  /// Creates a [DataRate] of this value in zettabytes per second (10²¹ B/s).
  DataRate get zettabytesPerSecond => DataRate.zettabytesPerSecond(this);

  /// Creates a [DataRate] of this value in zebibytes per second (2⁷⁰ B/s).
  DataRate get zebibytesPerSecond => DataRate.zebibytesPerSecond(this);

  /// Creates a [DataRate] of this value in yottabytes per second (10²⁴ B/s).
  DataRate get yottabytesPerSecond => DataRate.yottabytesPerSecond(this);

  /// Creates a [DataRate] of this value in yobibytes per second (2⁸⁰ B/s).
  DataRate get yobibytesPerSecond => DataRate.yobibytesPerSecond(this);

  /// Creates a [DataRate] of this value in bits per second.
  DataRate get bitsPerSecond => DataRate.bitsPerSecond(this);

  /// Creates a [DataRate] of this value in kilobits per second (10³ bps).
  DataRate get kilobitsPerSecond => DataRate.kilobitsPerSecond(this);

  /// Creates a [DataRate] of this value in kibibits per second (2¹⁰ bps).
  DataRate get kibibitsPerSecond => DataRate.kibibitsPerSecond(this);

  /// Creates a [DataRate] of this value in megabits per second (10⁶ bps).
  DataRate get megabitsPerSecond => DataRate.megabitsPerSecond(this);

  /// Creates a [DataRate] of this value in mebibits per second (2²⁰ bps).
  DataRate get mebibitsPerSecond => DataRate.mebibitsPerSecond(this);

  /// Creates a [DataRate] of this value in gigabits per second (10⁹ bps).
  DataRate get gigabitsPerSecond => DataRate.gigabitsPerSecond(this);

  /// Creates a [DataRate] of this value in gibibits per second (2³⁰ bps).
  DataRate get gibibitsPerSecond => DataRate.gibibitsPerSecond(this);

  /// Creates a [DataRate] of this value in terabits per second (10¹² bps).
  DataRate get terabitsPerSecond => DataRate.terabitsPerSecond(this);

  /// Creates a [DataRate] of this value in tebibits per second (2⁴⁰ bps).
  DataRate get tebibitsPerSecond => DataRate.tebibitsPerSecond(this);

  /// Creates a [DataRate] of this value in petabits per second (10¹⁵ bps).
  DataRate get petabitsPerSecond => DataRate.petabitsPerSecond(this);

  /// Creates a [DataRate] of this value in pebibits per second (2⁵⁰ bps).
  DataRate get pebibitsPerSecond => DataRate.pebibitsPerSecond(this);

  /// Creates a [DataRate] of this value in exabits per second (10¹⁸ bps).
  DataRate get exabitsPerSecond => DataRate.exabitsPerSecond(this);

  /// Creates a [DataRate] of this value in exbibits per second (2⁶⁰ bps).
  DataRate get exbibitsPerSecond => DataRate.exbibitsPerSecond(this);

  /// Creates a [DataRate] of this value in zettabits per second (10²¹ bps).
  DataRate get zettabitsPerSecond => DataRate.zettabitsPerSecond(this);

  /// Creates a [DataRate] of this value in zebibits per second (2⁷⁰ bps).
  DataRate get zebibitsPerSecond => DataRate.zebibitsPerSecond(this);

  /// Creates a [DataRate] of this value in yottabits per second (10²⁴ bps).
  DataRate get yottabitsPerSecond => DataRate.yottabitsPerSecond(this);

  /// Creates a [DataRate] of this value in yobibits per second (2⁸⁰ bps).
  DataRate get yobibitsPerSecond => DataRate.yobibitsPerSecond(this);
}
