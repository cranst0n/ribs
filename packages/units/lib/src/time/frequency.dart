import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

class Frequency extends Quantity<Frequency> {
  Frequency(super.value, super.unit);

  Frequency get toHertz => to(hertz).hertz;
  Frequency get toKilohertz => to(kilohertz).kilohertz;
  Frequency get toMegahertz => to(megahertz).megahertz;
  Frequency get toGigahertz => to(gigahertz).gigahertz;
  Frequency get toTerahertz => to(terahertz).terahertz;
  Frequency get toRevolutionsPerMinute =>
      to(revolutionsPerMinute).revolutionsPerMinute;

  static const hertz = Hertz._();
  static const kilohertz = Kilohertz._();
  static const megahertz = Megahertz._();
  static const gigahertz = Gigahertz._();
  static const terahertz = Terahertz._();
  static const revolutionsPerMinute = RevolutionsPerMinute._();

  static const units = {
    hertz,
    kilohertz,
    megahertz,
    gigahertz,
    terahertz,
    revolutionsPerMinute,
  };

  static Option<Frequency> parse(String s) => Quantity.parse(s, units);
}

abstract class FrequencyUnit extends BaseUnit<Frequency> {
  const FrequencyUnit(super.symbol, super.conversionFactor);

  @override
  Frequency call(num value) => Frequency(value.toDouble(), this);
}

class Hertz extends FrequencyUnit {
  const Hertz._() : super('Hz', 1);
}

class Kilohertz extends FrequencyUnit {
  const Kilohertz._() : super('kHz', MetricSystem.Kilo);
}

class Megahertz extends FrequencyUnit {
  const Megahertz._() : super('MHz', MetricSystem.Mega);
}

class Gigahertz extends FrequencyUnit {
  const Gigahertz._() : super('GHz', MetricSystem.Giga);
}

class Terahertz extends FrequencyUnit {
  const Terahertz._() : super('THz', MetricSystem.Tera);
}

class RevolutionsPerMinute extends FrequencyUnit {
  const RevolutionsPerMinute._() : super('rpm', 1.0 / 60.0);
}

extension TimeOps on num {
  Frequency get hertz => Frequency.hertz(this);
  Frequency get kilohertz => Frequency.kilohertz(this);
  Frequency get megahertz => Frequency.megahertz(this);
  Frequency get gigahertz => Frequency.gigahertz(this);
  Frequency get terahertz => Frequency.terahertz(this);
  Frequency get revolutionsPerMinute => Frequency.revolutionsPerMinute(this);
}
