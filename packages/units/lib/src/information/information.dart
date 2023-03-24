import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

class Information extends Quantity<Information> {
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

      switch (unit) {
        // Metric Bytes
        case yottabytes:
          return Information(value, unit);
        case zettabytes:
          return coarserOrThis(yottabytes, MetricSystem.Kilo.toInt());
        case exabytes:
          return coarserOrThis(zettabytes, MetricSystem.Kilo.toInt());
        case petabytes:
          return coarserOrThis(exabytes, MetricSystem.Kilo.toInt());
        case terabytes:
          return coarserOrThis(petabytes, MetricSystem.Kilo.toInt());
        case gigabytes:
          return coarserOrThis(terabytes, MetricSystem.Kilo.toInt());
        case megabytes:
          return coarserOrThis(gigabytes, MetricSystem.Kilo.toInt());
        case kilobytes:
          return coarserOrThis(megabytes, MetricSystem.Kilo.toInt());
        case bytes:
          return coarserOrThis(kilobytes, MetricSystem.Kilo.toInt());
        // Binary Bytes
        case yobibytes:
          return Information(value, unit);
        case zebibytes:
          return coarserOrThis(yobibytes, BinarySystem.Kilo.toInt());
        case exbibytes:
          return coarserOrThis(zebibytes, BinarySystem.Kilo.toInt());
        case pebibytes:
          return coarserOrThis(exbibytes, BinarySystem.Kilo.toInt());
        case tebibytes:
          return coarserOrThis(pebibytes, BinarySystem.Kilo.toInt());
        case gibibytes:
          return coarserOrThis(tebibytes, BinarySystem.Kilo.toInt());
        case mebibytes:
          return coarserOrThis(gibibytes, BinarySystem.Kilo.toInt());
        case kibibytes:
          return coarserOrThis(mebibytes, BinarySystem.Kilo.toInt());
        // Metric Bits
        case yottabits:
          return Information(value, unit);
        case zettabits:
          return coarserOrThis(yottabits, MetricSystem.Kilo.toInt());
        case exabits:
          return coarserOrThis(zettabits, MetricSystem.Kilo.toInt());
        case petabits:
          return coarserOrThis(exabits, MetricSystem.Kilo.toInt());
        case terabits:
          return coarserOrThis(petabits, MetricSystem.Kilo.toInt());
        case gigabits:
          return coarserOrThis(terabits, MetricSystem.Kilo.toInt());
        case megabits:
          return coarserOrThis(gigabits, MetricSystem.Kilo.toInt());
        case kilobits:
          return coarserOrThis(megabits, MetricSystem.Kilo.toInt());
        case bits:
          return coarserOrThis(kilobits, MetricSystem.Kilo.toInt());
        // Binary Bits
        case yobibits:
          return Information(value, unit);
        case zebibits:
          return coarserOrThis(yobibits, BinarySystem.Kilo.toInt());
        case exbibits:
          return coarserOrThis(zebibits, BinarySystem.Kilo.toInt());
        case pebibits:
          return coarserOrThis(exbibits, BinarySystem.Kilo.toInt());
        case tebibits:
          return coarserOrThis(pebibits, BinarySystem.Kilo.toInt());
        case gibibits:
          return coarserOrThis(tebibits, BinarySystem.Kilo.toInt());
        case mebibits:
          return coarserOrThis(gibibits, BinarySystem.Kilo.toInt());
        case kibibits:
          return coarserOrThis(mebibits, BinarySystem.Kilo.toInt());
        default:
          return this;
      }
    }

    return unit == yottabytes ||
            unit == yobibytes ||
            unit == yottabits ||
            unit == yobibits
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
  const InformationUnit(super.symbol, super.conversionFactor);

  @override
  Information call(num value) => Information(value.toDouble(), this);
}

class Bytes extends InformationUnit {
  const Bytes._() : super('B', 1);
}

class Octets extends InformationUnit {
  const Octets._() : super('o', 1);
}

class Kilobytes extends InformationUnit {
  const Kilobytes._() : super('KB', MetricSystem.Kilo);
}

class Kibibytes extends InformationUnit {
  const Kibibytes._() : super('KiB', BinarySystem.Kilo);
}

class Megabytes extends InformationUnit {
  const Megabytes._() : super('MB', MetricSystem.Mega);
}

class Mebibytes extends InformationUnit {
  const Mebibytes._() : super('MiB', BinarySystem.Mega);
}

class Gigabytes extends InformationUnit {
  const Gigabytes._() : super('GB', MetricSystem.Giga);
}

class Gibibytes extends InformationUnit {
  const Gibibytes._() : super('GiB', BinarySystem.Giga);
}

class Terabytes extends InformationUnit {
  const Terabytes._() : super('TB', MetricSystem.Tera);
}

class Tebibytes extends InformationUnit {
  const Tebibytes._() : super('TiB', BinarySystem.Tera);
}

class Petabytes extends InformationUnit {
  const Petabytes._() : super('PB', MetricSystem.Peta);
}

class Pebibytes extends InformationUnit {
  const Pebibytes._() : super('PiB', BinarySystem.Peta);
}

class Exabytes extends InformationUnit {
  const Exabytes._() : super('EB', MetricSystem.Exa);
}

class Exbibytes extends InformationUnit {
  const Exbibytes._() : super('EiB', BinarySystem.Exa);
}

class Zettabytes extends InformationUnit {
  const Zettabytes._() : super('ZB', MetricSystem.Zetta);
}

class Zebibytes extends InformationUnit {
  const Zebibytes._() : super('ZiB', BinarySystem.Zetta);
}

class Yottabytes extends InformationUnit {
  const Yottabytes._() : super('YB', MetricSystem.Yotta);
}

class Yobibytes extends InformationUnit {
  const Yobibytes._() : super('YiB', BinarySystem.Yotta);
}

class Bits extends InformationUnit {
  const Bits._() : super('bit', 0.125);
}

class Kilobits extends InformationUnit {
  const Kilobits._()
      : super('Kbit', Information.BitsConversionFactor * MetricSystem.Kilo);
}

class Kibibits extends InformationUnit {
  const Kibibits._()
      : super('Kibit', Information.BitsConversionFactor * BinarySystem.Kilo);
}

class Megabits extends InformationUnit {
  const Megabits._()
      : super('Mbit', Information.BitsConversionFactor * MetricSystem.Mega);
}

class Mebibits extends InformationUnit {
  const Mebibits._()
      : super('Mibit', Information.BitsConversionFactor * BinarySystem.Mega);
}

class Gigabits extends InformationUnit {
  const Gigabits._()
      : super('Gbit', Information.BitsConversionFactor * MetricSystem.Giga);
}

class Gibibits extends InformationUnit {
  const Gibibits._()
      : super('Gibit', Information.BitsConversionFactor * BinarySystem.Giga);
}

class Terabits extends InformationUnit {
  const Terabits._()
      : super('Tbit', Information.BitsConversionFactor * MetricSystem.Tera);
}

class Tebibits extends InformationUnit {
  const Tebibits._()
      : super('Tibit', Information.BitsConversionFactor * BinarySystem.Tera);
}

class Petabits extends InformationUnit {
  const Petabits._()
      : super('Pbit', Information.BitsConversionFactor * MetricSystem.Peta);
}

class Pebibits extends InformationUnit {
  const Pebibits._()
      : super('Pibit', Information.BitsConversionFactor * BinarySystem.Peta);
}

class Exabits extends InformationUnit {
  const Exabits._()
      : super('Ebit', Information.BitsConversionFactor * MetricSystem.Exa);
}

class Exbibits extends InformationUnit {
  const Exbibits._()
      : super('Eibit', Information.BitsConversionFactor * BinarySystem.Exa);
}

class Zettabits extends InformationUnit {
  const Zettabits._()
      : super('Zbit', Information.BitsConversionFactor * MetricSystem.Zetta);
}

class Zebibits extends InformationUnit {
  const Zebibits._()
      : super('Zibit', Information.BitsConversionFactor * BinarySystem.Zetta);
}

class Yottabits extends InformationUnit {
  const Yottabits._()
      : super('Ybit', Information.BitsConversionFactor * MetricSystem.Yotta);
}

class Yobibits extends InformationUnit {
  const Yobibits._()
      : super('Yibit', Information.BitsConversionFactor * BinarySystem.Yotta);
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
