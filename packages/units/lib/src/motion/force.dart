import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Force extends Quantity<Force> {
  Force(super.value, super.unit);

  Force operator +(Force that) => Force(value + that.to(unit), unit);
  Force operator -(Force that) => Force(value - that.to(unit), unit);

  Energy operator *(Length that) => Energy.joules(toNewtons.value * that.toMeters.value);
  Pressure operator /(Area that) => Pressure.pascals(toNewtons.value / that.toSquareMeters.value);

  Force get toMicronewtons => to(micronewtons).micronewtons;
  Force get toMillinewtons => to(millinewtons).millinewtons;
  Force get toNewtons => to(newtons).newtons;
  Force get toKilonewtons => to(kilonewtons).kilonewtons;
  Force get toMeganewtons => to(meganewtons).meganewtons;
  Force get toPoundsForce => to(poundsForce).poundsForce;
  Force get toKiloponds => to(kiloponds).kiloponds;
  Force get toPoundals => to(poundals).poundals;
  Force get toDynes => to(dynes).dynes;
  Force get toKips => to(kips).kips;

  static const ForceUnit micronewtons = Micronewtons._();
  static const ForceUnit millinewtons = Millinewtons._();
  static const ForceUnit newtons = Newtons._();
  static const ForceUnit kilonewtons = Kilonewtons._();
  static const ForceUnit meganewtons = Meganewtons._();
  static const ForceUnit poundsForce = PoundsForce._();
  static const ForceUnit kiloponds = Kiloponds._();
  static const ForceUnit poundals = Poundals._();
  static const ForceUnit dynes = Dynes._();
  static const ForceUnit kips = Kips._();

  static const units = {
    micronewtons,
    millinewtons,
    newtons,
    kilonewtons,
    meganewtons,
    poundsForce,
    kiloponds,
    poundals,
    dynes,
    kips,
  };

  static Option<Force> parse(String s) => Quantity.parse(s, units);
}

abstract class ForceUnit extends BaseUnit<Force> {
  const ForceUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Force call(num value) => Force(value.toDouble(), this);
}

final class Micronewtons extends ForceUnit {
  const Micronewtons._() : super('micronewton', 'µN', MetricSystem.Micro);
}

final class Millinewtons extends ForceUnit {
  const Millinewtons._() : super('millinewton', 'mN', MetricSystem.Milli);
}

final class Newtons extends ForceUnit {
  const Newtons._() : super('newton', 'N', 1.0);
}

final class Kilonewtons extends ForceUnit {
  const Kilonewtons._() : super('kilonewton', 'kN', MetricSystem.Kilo);
}

final class Meganewtons extends ForceUnit {
  const Meganewtons._() : super('meganewton', 'MN', MetricSystem.Mega);
}

final class PoundsForce extends ForceUnit {
  const PoundsForce._() : super('pound-force', 'lbf', 4.4482216152605);
}

final class Kiloponds extends ForceUnit {
  const Kiloponds._() : super('kilopond', 'kp', 9.80665);
}

final class Poundals extends ForceUnit {
  const Poundals._() : super('poundal', 'pdl', 0.138254954376);
}

final class Dynes extends ForceUnit {
  const Dynes._() : super('dyne', 'dyn', 1e-5);
}

final class Kips extends ForceUnit {
  const Kips._() : super('kip', 'kip', 4448.2216152605);
}

extension ForceOps on num {
  Force get micronewtons => Force.micronewtons(this);
  Force get millinewtons => Force.millinewtons(this);
  Force get newtons => Force.newtons(this);
  Force get kilonewtons => Force.kilonewtons(this);
  Force get meganewtons => Force.meganewtons(this);
  Force get poundsForce => Force.poundsForce(this);
  Force get kiloponds => Force.kiloponds(this);
  Force get poundals => Force.poundals(this);
  Force get dynes => Force.dynes(this);
  Force get kips => Force.kips(this);
}
