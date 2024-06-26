import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class DataRate extends Quantity<DataRate> {
  DataRate(super.value, super.unit);

  DataRate get toBytesPerSecond => to(bytesPerSecond).bytesPerSecond;
  DataRate get toKilobytesPerSecond =>
      to(kilobytesPerSecond).kilobytesPerSecond;
  DataRate get toKibibytesPerSecond =>
      to(kibibytesPerSecond).kibibytesPerSecond;
  DataRate get toMegabytesPerSecond =>
      to(megabytesPerSecond).megabytesPerSecond;
  DataRate get toMebibytesPerSecond =>
      to(mebibytesPerSecond).mebibytesPerSecond;
  DataRate get toGigabytesPerSecond =>
      to(gigabytesPerSecond).gigabytesPerSecond;
  DataRate get toGibibytesPerSecond =>
      to(gibibytesPerSecond).gibibytesPerSecond;
  DataRate get toTerabytesPerSecond =>
      to(terabytesPerSecond).terabytesPerSecond;
  DataRate get toTebibytesPerSecond =>
      to(tebibytesPerSecond).tebibytesPerSecond;
  DataRate get toPetabytesPerSecond =>
      to(petabytesPerSecond).petabytesPerSecond;
  DataRate get toPebibytesPerSecond =>
      to(pebibytesPerSecond).pebibytesPerSecond;
  DataRate get toExabytesPerSecond => to(exabytesPerSecond).exabytesPerSecond;
  DataRate get toExbibytesPerSecond =>
      to(exbibytesPerSecond).exbibytesPerSecond;
  DataRate get toZettabytesPerSecond =>
      to(zettabytesPerSecond).zettabytesPerSecond;
  DataRate get toZebibytesPerSecond =>
      to(zebibytesPerSecond).zebibytesPerSecond;
  DataRate get toYottabytesPerSecond =>
      to(yottabytesPerSecond).yottabytesPerSecond;
  DataRate get toYobibytesPerSecond =>
      to(yobibytesPerSecond).yobibytesPerSecond;
  DataRate get toBitsPerSecond => to(bitsPerSecond).bitsPerSecond;
  DataRate get toKilobitsPerSecond => to(kilobitsPerSecond).kilobitsPerSecond;
  DataRate get toKibibitsPerSecond => to(kibibitsPerSecond).kibibitsPerSecond;
  DataRate get toMegabitsPerSecond => to(megabitsPerSecond).megabitsPerSecond;
  DataRate get toMebibitsPerSecond => to(mebibitsPerSecond).mebibitsPerSecond;
  DataRate get toGigabitsPerSecond => to(gigabitsPerSecond).gigabitsPerSecond;
  DataRate get toGibibitsPerSecond => to(gibibitsPerSecond).gibibitsPerSecond;
  DataRate get toTerabitsPerSecond => to(terabitsPerSecond).terabitsPerSecond;
  DataRate get toTebibitsPerSecond => to(tebibitsPerSecond).tebibitsPerSecond;
  DataRate get toPetabitsPerSecond => to(petabitsPerSecond).petabitsPerSecond;
  DataRate get toPebibitsPerSecond => to(pebibitsPerSecond).pebibitsPerSecond;
  DataRate get toExabitsPerSecond => to(exabitsPerSecond).exabitsPerSecond;
  DataRate get toExbibitsPerSecond => to(exbibitsPerSecond).exbibitsPerSecond;
  DataRate get toZettabitsPerSecond =>
      to(zettabitsPerSecond).zettabitsPerSecond;
  DataRate get toZebibitsPerSecond => to(zebibitsPerSecond).zebibitsPerSecond;
  DataRate get toYottabitsPerSecond =>
      to(yottabitsPerSecond).yottabitsPerSecond;
  DataRate get toYobibitsPerSecond => to(yobibitsPerSecond).yobibitsPerSecond;

  static const bytesPerSecond = BytesPerSecond._();
  static const kilobytesPerSecond = KilobytesPerSecond._();
  static const kibibytesPerSecond = KibibytesPerSecond._();
  static const megabytesPerSecond = MegabytesPerSecond._();
  static const mebibytesPerSecond = MebibytesPerSecond._();
  static const gigabytesPerSecond = GigabytesPerSecond._();
  static const gibibytesPerSecond = GibibytesPerSecond._();
  static const terabytesPerSecond = TerabytesPerSecond._();
  static const tebibytesPerSecond = TebibytesPerSecond._();
  static const petabytesPerSecond = PetabytesPerSecond._();
  static const pebibytesPerSecond = PebibytesPerSecond._();
  static const exabytesPerSecond = ExabytesPerSecond._();
  static const exbibytesPerSecond = ExbibytesPerSecond._();
  static const zettabytesPerSecond = ZettabytesPerSecond._();
  static const zebibytesPerSecond = ZebibytesPerSecond._();
  static const yottabytesPerSecond = YottabytesPerSecond._();
  static const yobibytesPerSecond = YobibytesPerSecond._();
  static const bitsPerSecond = BitsPerSecond._();
  static const kilobitsPerSecond = KilobitsPerSecond._();
  static const kibibitsPerSecond = KibibitsPerSecond._();
  static const megabitsPerSecond = MegabitsPerSecond._();
  static const mebibitsPerSecond = MebibitsPerSecond._();
  static const gigabitsPerSecond = GigabitsPerSecond._();
  static const gibibitsPerSecond = GibibitsPerSecond._();
  static const terabitsPerSecond = TerabitsPerSecond._();
  static const tebibitsPerSecond = TebibitsPerSecond._();
  static const petabitsPerSecond = PetabitsPerSecond._();
  static const pebibitsPerSecond = PebibitsPerSecond._();
  static const exabitsPerSecond = ExabitsPerSecond._();
  static const exbibitsPerSecond = ExbibitsPerSecond._();
  static const zettabitsPerSecond = ZettabitsPerSecond._();
  static const zebibitsPerSecond = ZebibitsPerSecond._();
  static const yottabitsPerSecond = YottabitsPerSecond._();
  static const yobibitsPerSecond = YobibitsPerSecond._();

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

  static Option<DataRate> parse(String s) => Quantity.parse(s, units);
}

abstract class DataRateUnit extends BaseUnit<DataRate> {
  const DataRateUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  DataRate call(num value) => DataRate(value.toDouble(), this);
}

final class BytesPerSecond extends DataRateUnit {
  const BytesPerSecond._() : super('bytes/second', 'B/s', 1);
}

final class KilobytesPerSecond extends DataRateUnit {
  const KilobytesPerSecond._()
      : super('kilobytes/second', 'KB/s', MetricSystem.Kilo);
}

final class KibibytesPerSecond extends DataRateUnit {
  const KibibytesPerSecond._()
      : super('kibibytes/second', 'KiB/s', BinarySystem.Kilo);
}

final class MegabytesPerSecond extends DataRateUnit {
  const MegabytesPerSecond._()
      : super('megabytes/second', 'MB/s', MetricSystem.Mega);
}

final class MebibytesPerSecond extends DataRateUnit {
  const MebibytesPerSecond._()
      : super('mebibytes/second', 'MiB/s', BinarySystem.Mega);
}

final class GigabytesPerSecond extends DataRateUnit {
  const GigabytesPerSecond._()
      : super('gigabytes/second', 'GB/s', MetricSystem.Giga);
}

final class GibibytesPerSecond extends DataRateUnit {
  const GibibytesPerSecond._()
      : super('gibibytes/second', 'GiB/s', BinarySystem.Giga);
}

final class TerabytesPerSecond extends DataRateUnit {
  const TerabytesPerSecond._()
      : super('terabytes/second', 'TB/s', MetricSystem.Tera);
}

final class TebibytesPerSecond extends DataRateUnit {
  const TebibytesPerSecond._()
      : super('tebibytes/second', 'TiB/s', BinarySystem.Tera);
}

final class PetabytesPerSecond extends DataRateUnit {
  const PetabytesPerSecond._()
      : super('petabytes/second', 'PB/s', MetricSystem.Peta);
}

final class PebibytesPerSecond extends DataRateUnit {
  const PebibytesPerSecond._()
      : super('pebibytes/second', 'PiB/s', BinarySystem.Peta);
}

final class ExabytesPerSecond extends DataRateUnit {
  const ExabytesPerSecond._()
      : super('exabytes/second', 'EB/s', MetricSystem.Exa);
}

final class ExbibytesPerSecond extends DataRateUnit {
  const ExbibytesPerSecond._()
      : super('exbibytes/second', 'EiB/s', BinarySystem.Exa);
}

final class ZettabytesPerSecond extends DataRateUnit {
  const ZettabytesPerSecond._()
      : super('zettabytes/second', 'ZB/s', MetricSystem.Zetta);
}

final class ZebibytesPerSecond extends DataRateUnit {
  const ZebibytesPerSecond._()
      : super('zebibytes/second', 'ZiB/s', BinarySystem.Zetta);
}

final class YottabytesPerSecond extends DataRateUnit {
  const YottabytesPerSecond._()
      : super('yottabytes/second', 'YB/s', MetricSystem.Yotta);
}

final class YobibytesPerSecond extends DataRateUnit {
  const YobibytesPerSecond._()
      : super('yobibytes/second', 'YiB/s', BinarySystem.Yotta);
}

final class BitsPerSecond extends DataRateUnit {
  const BitsPerSecond._()
      : super('bits/second', 'bps', Information.BitsConversionFactor);
}

final class KilobitsPerSecond extends DataRateUnit {
  const KilobitsPerSecond._()
      : super('kilobits/second', 'Kbps',
            Information.BitsConversionFactor * MetricSystem.Kilo);
}

final class KibibitsPerSecond extends DataRateUnit {
  const KibibitsPerSecond._()
      : super('kibibits/second', 'Kibps',
            Information.BitsConversionFactor * BinarySystem.Kilo);
}

final class MegabitsPerSecond extends DataRateUnit {
  const MegabitsPerSecond._()
      : super('megabits/second', 'Mbps',
            Information.BitsConversionFactor * MetricSystem.Giga);
}

final class MebibitsPerSecond extends DataRateUnit {
  const MebibitsPerSecond._()
      : super('mebibits/second', 'Mibps',
            Information.BitsConversionFactor * BinarySystem.Mega);
}

final class GigabitsPerSecond extends DataRateUnit {
  const GigabitsPerSecond._()
      : super('gigabits/second', 'Gbps',
            Information.BitsConversionFactor * MetricSystem.Giga);
}

final class GibibitsPerSecond extends DataRateUnit {
  const GibibitsPerSecond._()
      : super('gibibits/second', 'Gibps',
            Information.BitsConversionFactor * BinarySystem.Giga);
}

final class TerabitsPerSecond extends DataRateUnit {
  const TerabitsPerSecond._()
      : super('terabits/second', 'Tbps',
            Information.BitsConversionFactor * MetricSystem.Tera);
}

final class TebibitsPerSecond extends DataRateUnit {
  const TebibitsPerSecond._()
      : super('tebibits/second', 'Tibps',
            Information.BitsConversionFactor * BinarySystem.Tera);
}

final class PetabitsPerSecond extends DataRateUnit {
  const PetabitsPerSecond._()
      : super('petabits/second', 'Pbps',
            Information.BitsConversionFactor * MetricSystem.Peta);
}

final class PebibitsPerSecond extends DataRateUnit {
  const PebibitsPerSecond._()
      : super('pebibits/second', 'Pibps',
            Information.BitsConversionFactor * BinarySystem.Peta);
}

final class ExabitsPerSecond extends DataRateUnit {
  const ExabitsPerSecond._()
      : super('exabits/second', 'Ebps',
            Information.BitsConversionFactor * MetricSystem.Exa);
}

final class ExbibitsPerSecond extends DataRateUnit {
  const ExbibitsPerSecond._()
      : super('exbibits/second', 'Eibps',
            Information.BitsConversionFactor * BinarySystem.Exa);
}

final class ZettabitsPerSecond extends DataRateUnit {
  const ZettabitsPerSecond._()
      : super('zettabits/second', 'Zbps',
            Information.BitsConversionFactor * MetricSystem.Zetta);
}

final class ZebibitsPerSecond extends DataRateUnit {
  const ZebibitsPerSecond._()
      : super('zebibits/second', 'Zibps',
            Information.BitsConversionFactor * BinarySystem.Zetta);
}

final class YottabitsPerSecond extends DataRateUnit {
  const YottabitsPerSecond._()
      : super('yottabits/second', 'Ybps',
            Information.BitsConversionFactor * MetricSystem.Yotta);
}

final class YobibitsPerSecond extends DataRateUnit {
  const YobibitsPerSecond._()
      : super('yobibits/second', 'Yibps',
            Information.BitsConversionFactor * BinarySystem.Yotta);
}

extension DataRateOps on num {
  DataRate get bytesPerSecond => DataRate.bytesPerSecond(this);
  DataRate get kilobytesPerSecond => DataRate.kilobytesPerSecond(this);
  DataRate get kibibytesPerSecond => DataRate.kibibytesPerSecond(this);
  DataRate get megabytesPerSecond => DataRate.megabytesPerSecond(this);
  DataRate get mebibytesPerSecond => DataRate.mebibytesPerSecond(this);
  DataRate get gigabytesPerSecond => DataRate.gigabytesPerSecond(this);
  DataRate get gibibytesPerSecond => DataRate.gibibytesPerSecond(this);
  DataRate get terabytesPerSecond => DataRate.terabytesPerSecond(this);
  DataRate get tebibytesPerSecond => DataRate.tebibytesPerSecond(this);
  DataRate get petabytesPerSecond => DataRate.petabytesPerSecond(this);
  DataRate get pebibytesPerSecond => DataRate.pebibytesPerSecond(this);
  DataRate get exabytesPerSecond => DataRate.exabytesPerSecond(this);
  DataRate get exbibytesPerSecond => DataRate.exbibytesPerSecond(this);
  DataRate get zettabytesPerSecond => DataRate.zettabytesPerSecond(this);
  DataRate get zebibytesPerSecond => DataRate.zebibytesPerSecond(this);
  DataRate get yottabytesPerSecond => DataRate.yottabytesPerSecond(this);
  DataRate get yobibytesPerSecond => DataRate.yobibytesPerSecond(this);
  DataRate get bitsPerSecond => DataRate.bitsPerSecond(this);
  DataRate get kilobitsPerSecond => DataRate.kilobitsPerSecond(this);
  DataRate get kibibitsPerSecond => DataRate.kibibitsPerSecond(this);
  DataRate get megabitsPerSecond => DataRate.megabitsPerSecond(this);
  DataRate get mebibitsPerSecond => DataRate.mebibitsPerSecond(this);
  DataRate get gigabitsPerSecond => DataRate.gigabitsPerSecond(this);
  DataRate get gibibitsPerSecond => DataRate.gibibitsPerSecond(this);
  DataRate get terabitsPerSecond => DataRate.terabitsPerSecond(this);
  DataRate get tebibitsPerSecond => DataRate.tebibitsPerSecond(this);
  DataRate get petabitsPerSecond => DataRate.petabitsPerSecond(this);
  DataRate get pebibitsPerSecond => DataRate.pebibitsPerSecond(this);
  DataRate get exabitsPerSecond => DataRate.exabitsPerSecond(this);
  DataRate get exbibitsPerSecond => DataRate.exbibitsPerSecond(this);
  DataRate get zettabitsPerSecond => DataRate.zettabitsPerSecond(this);
  DataRate get zebibitsPerSecond => DataRate.zebibitsPerSecond(this);
  DataRate get yottabitsPerSecond => DataRate.yottabitsPerSecond(this);
  DataRate get yobibitsPerSecond => DataRate.yobibitsPerSecond(this);
}
