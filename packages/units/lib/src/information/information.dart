import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Information extends Quantity<Information> {
  Information(super.value, super.unit);

  Information get toBytes => to(bytes).bytes;
  Information get toOctets => to(octets).octets;
  Information get toKilobytes => to(kilobytes).kilobytes;
  Information get toKibibytes => to(kibibytes).kibibytes;
  Information get toMegabytes => to(megabytes).megabytes;
  Information get toMebibytes => to(mebibytes).mebibytes;
  Information get toGigabytes => to(gigabytes).gigabytes;
  Information get toGibibytes => to(gibibytes).gibibytes;
  Information get toTerabytes => to(terabytes).terabytes;
  Information get toTebibytes => to(tebibytes).tebibytes;
  Information get toPetabytes => to(petabytes).petabytes;
  Information get toPebibytes => to(pebibytes).pebibytes;
  Information get toExabytes => to(exabytes).exabytes;
  Information get toExbibytes => to(exbibytes).exbibytes;
  Information get toZettabytes => to(zettabytes).zettabytes;
  Information get toZebibytes => to(zebibytes).zebibytes;
  Information get toYottabytes => to(yottabytes).yottabytes;
  Information get toYobibytes => to(yobibytes).yobibytes;
  Information get toBits => to(bits).bits;
  Information get toKilobits => to(kilobits).kilobits;
  Information get toKibibits => to(kibibits).kibibits;
  Information get toMegabits => to(megabits).megabits;
  Information get toMebibits => to(mebibits).mebibits;
  Information get toGigabits => to(gigabits).gigabits;
  Information get toGibibits => to(gibibits).gibibits;
  Information get toTerabits => to(terabits).terabits;
  Information get toTebibits => to(tebibits).tebibits;
  Information get toPetabits => to(petabits).petabits;
  Information get toPebibits => to(pebibits).pebibits;
  Information get toExabits => to(exabits).exabits;
  Information get toExbibits => to(exbibits).exbibits;
  Information get toZettabits => to(zettabits).zettabits;
  Information get toZebibits => to(zebibits).zebibits;
  Information get toYottabits => to(yottabits).yottabits;
  Information get toYobibits => to(yobibits).yobibits;

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

  static const BitsConversionFactor = 0.125;

  static const bytes = Bytes._();
  static const octets = Octets._();
  static const kilobytes = Kilobytes._();
  static const kibibytes = Kibibytes._();
  static const megabytes = Megabytes._();
  static const mebibytes = Mebibytes._();
  static const gigabytes = Gigabytes._();
  static const gibibytes = Gibibytes._();
  static const terabytes = Terabytes._();
  static const tebibytes = Tebibytes._();
  static const petabytes = Petabytes._();
  static const pebibytes = Pebibytes._();
  static const exabytes = Exabytes._();
  static const exbibytes = Exbibytes._();
  static const zettabytes = Zettabytes._();
  static const zebibytes = Zebibytes._();
  static const yottabytes = Yottabytes._();
  static const yobibytes = Yobibytes._();
  static const bits = Bits._();
  static const kilobits = Kilobits._();
  static const kibibits = Kibibits._();
  static const megabits = Megabits._();
  static const mebibits = Mebibits._();
  static const gigabits = Gigabits._();
  static const gibibits = Gibibits._();
  static const terabits = Terabits._();
  static const tebibits = Tebibits._();
  static const petabits = Petabits._();
  static const pebibits = Pebibits._();
  static const exabits = Exabits._();
  static const exbibits = Exbibits._();
  static const zettabits = Zettabits._();
  static const zebibits = Zebibits._();
  static const yottabits = Yottabits._();
  static const yobibits = Yobibits._();

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

  static Option<Information> parse(String s) => Quantity.parse(s, units);
}

abstract class InformationUnit extends BaseUnit<Information> {
  const InformationUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Information call(num value) => Information(value.toDouble(), this);
}

final class Bytes extends InformationUnit {
  const Bytes._() : super('byte', 'B', 1);
}

final class Octets extends InformationUnit {
  const Octets._() : super('octet', 'o', 1);
}

final class Kilobytes extends InformationUnit {
  const Kilobytes._() : super('kilobyte', 'KB', MetricSystem.Kilo);
}

final class Kibibytes extends InformationUnit {
  const Kibibytes._() : super('kibibyte', 'KiB', BinarySystem.Kilo);
}

final class Megabytes extends InformationUnit {
  const Megabytes._() : super('megabyte', 'MB', MetricSystem.Mega);
}

final class Mebibytes extends InformationUnit {
  const Mebibytes._() : super('mebibyte', 'MiB', BinarySystem.Mega);
}

final class Gigabytes extends InformationUnit {
  const Gigabytes._() : super('gigabyte', 'GB', MetricSystem.Giga);
}

final class Gibibytes extends InformationUnit {
  const Gibibytes._() : super('gibibyte', 'GiB', BinarySystem.Giga);
}

final class Terabytes extends InformationUnit {
  const Terabytes._() : super('terabyte', 'TB', MetricSystem.Tera);
}

final class Tebibytes extends InformationUnit {
  const Tebibytes._() : super('tebibyte', 'TiB', BinarySystem.Tera);
}

final class Petabytes extends InformationUnit {
  const Petabytes._() : super('petabyte', 'PB', MetricSystem.Peta);
}

final class Pebibytes extends InformationUnit {
  const Pebibytes._() : super('pebibyte', 'PiB', BinarySystem.Peta);
}

final class Exabytes extends InformationUnit {
  const Exabytes._() : super('exabyte', 'EB', MetricSystem.Exa);
}

final class Exbibytes extends InformationUnit {
  const Exbibytes._() : super('exbibyte', 'EiB', BinarySystem.Exa);
}

final class Zettabytes extends InformationUnit {
  const Zettabytes._() : super('zettabyte', 'ZB', MetricSystem.Zetta);
}

final class Zebibytes extends InformationUnit {
  const Zebibytes._() : super('zebibyte', 'ZiB', BinarySystem.Zetta);
}

final class Yottabytes extends InformationUnit {
  const Yottabytes._() : super('yottabyte', 'YB', MetricSystem.Yotta);
}

final class Yobibytes extends InformationUnit {
  const Yobibytes._() : super('yobibyte', 'YiB', BinarySystem.Yotta);
}

final class Bits extends InformationUnit {
  const Bits._() : super('bit', 'bit', 0.125);
}

final class Kilobits extends InformationUnit {
  const Kilobits._()
    : super('kilobit', 'Kbit', Information.BitsConversionFactor * MetricSystem.Kilo);
}

final class Kibibits extends InformationUnit {
  const Kibibits._()
    : super('kibibit', 'Kibit', Information.BitsConversionFactor * BinarySystem.Kilo);
}

final class Megabits extends InformationUnit {
  const Megabits._()
    : super('megabit', 'Mbit', Information.BitsConversionFactor * MetricSystem.Mega);
}

final class Mebibits extends InformationUnit {
  const Mebibits._()
    : super('mebibit', 'Mibit', Information.BitsConversionFactor * BinarySystem.Mega);
}

final class Gigabits extends InformationUnit {
  const Gigabits._()
    : super('gigabit', 'Gbit', Information.BitsConversionFactor * MetricSystem.Giga);
}

final class Gibibits extends InformationUnit {
  const Gibibits._()
    : super('gibibit', 'Gibit', Information.BitsConversionFactor * BinarySystem.Giga);
}

final class Terabits extends InformationUnit {
  const Terabits._()
    : super('terabit', 'Tbit', Information.BitsConversionFactor * MetricSystem.Tera);
}

final class Tebibits extends InformationUnit {
  const Tebibits._()
    : super('tebibit', 'Tibit', Information.BitsConversionFactor * BinarySystem.Tera);
}

final class Petabits extends InformationUnit {
  const Petabits._()
    : super('petabit', 'Pbit', Information.BitsConversionFactor * MetricSystem.Peta);
}

final class Pebibits extends InformationUnit {
  const Pebibits._()
    : super('pebibit', 'Pibit', Information.BitsConversionFactor * BinarySystem.Peta);
}

final class Exabits extends InformationUnit {
  const Exabits._() : super('exabit', 'Ebit', Information.BitsConversionFactor * MetricSystem.Exa);
}

final class Exbibits extends InformationUnit {
  const Exbibits._()
    : super('exbibit', 'Eibit', Information.BitsConversionFactor * BinarySystem.Exa);
}

final class Zettabits extends InformationUnit {
  const Zettabits._()
    : super('zettabit', 'Zbit', Information.BitsConversionFactor * MetricSystem.Zetta);
}

final class Zebibits extends InformationUnit {
  const Zebibits._()
    : super('zebibit', 'Zibit', Information.BitsConversionFactor * BinarySystem.Zetta);
}

final class Yottabits extends InformationUnit {
  const Yottabits._()
    : super('yottabit', 'Ybit', Information.BitsConversionFactor * MetricSystem.Yotta);
}

final class Yobibits extends InformationUnit {
  const Yobibits._()
    : super('yobibit', 'Yibit', Information.BitsConversionFactor * BinarySystem.Yotta);
}

extension InformationOps on num {
  Information get bytes => Information.bytes(this);
  Information get octets => Information.octets(this);
  Information get kilobytes => Information.kilobytes(this);
  Information get kibibytes => Information.kibibytes(this);
  Information get megabytes => Information.megabytes(this);
  Information get mebibytes => Information.mebibytes(this);
  Information get gigabytes => Information.gigabytes(this);
  Information get gibibytes => Information.gibibytes(this);
  Information get terabytes => Information.terabytes(this);
  Information get tebibytes => Information.tebibytes(this);
  Information get petabytes => Information.petabytes(this);
  Information get pebibytes => Information.pebibytes(this);
  Information get exabytes => Information.exabytes(this);
  Information get exbibytes => Information.exbibytes(this);
  Information get zettabytes => Information.zettabytes(this);
  Information get zebibytes => Information.zebibytes(this);
  Information get yottabytes => Information.yottabytes(this);
  Information get yobibytes => Information.yobibytes(this);
  Information get bits => Information.bits(this);
  Information get kilobits => Information.kilobits(this);
  Information get kibibits => Information.kibibits(this);
  Information get megabits => Information.megabits(this);
  Information get mebibits => Information.mebibits(this);
  Information get gigabits => Information.gigabits(this);
  Information get gibibits => Information.gibibits(this);
  Information get terabits => Information.terabits(this);
  Information get tebibits => Information.tebibits(this);
  Information get petabits => Information.petabits(this);
  Information get pebibits => Information.pebibits(this);
  Information get exabits => Information.exabits(this);
  Information get exbibits => Information.exbibits(this);
  Information get zettabits => Information.zettabits(this);
  Information get zebibits => Information.zebibits(this);
  Information get yottabits => Information.yottabits(this);
  Information get yobibits => Information.yobibits(this);
}
