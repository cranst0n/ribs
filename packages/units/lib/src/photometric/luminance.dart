import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Luminance extends Quantity<Luminance> {
  Luminance(super.value, super.unit);

  Luminance operator +(Luminance that) => Luminance(value + that.to(unit), unit);
  Luminance operator -(Luminance that) => Luminance(value - that.to(unit), unit);

  Luminance get toNits => to(nits).nits;
  Luminance get toStilbs => to(stilbs).stilbs;
  Luminance get toFootlamberts => to(footlamberts).footlamberts;
  Luminance get toLamberts => to(lamberts).lamberts;

  static const LuminanceUnit nits = Nits._();
  static const LuminanceUnit stilbs = Stilbs._();
  static const LuminanceUnit footlamberts = Footlamberts._();
  static const LuminanceUnit lamberts = Lamberts._();

  static const units = {
    nits,
    stilbs,
    footlamberts,
    lamberts,
  };

  static Option<Luminance> parse(String s) => Quantity.parse(s, units);
}

abstract class LuminanceUnit extends BaseUnit<Luminance> {
  const LuminanceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Luminance call(num value) => Luminance(value.toDouble(), this);
}

final class Nits extends LuminanceUnit {
  const Nits._() : super('nit', 'cd/m²', 1.0);
}

final class Stilbs extends LuminanceUnit {
  const Stilbs._() : super('stilb', 'sb', 1e4);
}

final class Footlamberts extends LuminanceUnit {
  const Footlamberts._() : super('footlambert', 'fL', 3.42625909963539);
}

final class Lamberts extends LuminanceUnit {
  const Lamberts._() : super('lambert', 'L', 3183.09886183791);
}

extension LuminanceOps on num {
  Luminance get nits => Luminance.nits(this);
  Luminance get stilbs => Luminance.stilbs(this);
  Luminance get footlamberts => Luminance.footlamberts(this);
  Luminance get lamberts => Luminance.lamberts(this);
}
