import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Momentum extends Quantity<Momentum> {
  Momentum(super.value, super.unit);

  Momentum operator +(Momentum that) => Momentum(value + that.to(unit), unit);
  Momentum operator -(Momentum that) => Momentum(value - that.to(unit), unit);

  Momentum get toNewtonSeconds => to(newtonSeconds).newtonSeconds;
  Momentum get toPoundForceSeconds => to(poundForceSeconds).poundForceSeconds;

  static const MomentumUnit newtonSeconds = NewtonSeconds._();
  static const MomentumUnit poundForceSeconds = PoundForceSeconds._();

  static const units = {
    newtonSeconds,
    poundForceSeconds,
  };

  static Option<Momentum> parse(String s) => Quantity.parse(s, units);
}

abstract class MomentumUnit extends BaseUnit<Momentum> {
  const MomentumUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Momentum call(num value) => Momentum(value.toDouble(), this);
}

final class NewtonSeconds extends MomentumUnit {
  const NewtonSeconds._() : super('newton-second', 'N·s', 1.0);
}

final class PoundForceSeconds extends MomentumUnit {
  const PoundForceSeconds._() : super('pound-force-second', 'lbf·s', 4.4482216152605);
}

extension MomentumOps on num {
  Momentum get newtonSeconds => Momentum.newtonSeconds(this);
  Momentum get poundForceSeconds => Momentum.poundForceSeconds(this);
}
