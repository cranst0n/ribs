import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class Each extends Quantity<Each> {
  Each(super.value, super.unit);

  Each operator +(Each that) => Each(value + that.to(unit), unit);
  Each operator -(Each that) => Each(value - that.to(unit), unit);

  Each get toEach => to(each).each;
  Each get toDozen => to(dozen).dozen;
  Each get toScore => to(score).score;
  Each get toGross => to(gross).gross;
  Each get toGreatGross => to(greatGross).greatGross;

  static const EachUnit each = Eaches._();
  static const EachUnit dozen = Dozens._();
  static const EachUnit score = Scores._();
  static const EachUnit gross = Gross._();
  static const EachUnit greatGross = GreatGross._();

  static const units = {
    each,
    dozen,
    score,
    gross,
    greatGross,
  };

  static Option<Each> parse(String s) => Quantity.parse(s, units);
}

abstract class EachUnit extends BaseUnit<Each> {
  const EachUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  Each call(num value) => Each(value.toDouble(), this);
}

final class Eaches extends EachUnit {
  const Eaches._() : super('each', 'ea', 1.0);
}

final class Dozens extends EachUnit {
  const Dozens._() : super('dozen', 'dz', 12.0);
}

final class Scores extends EachUnit {
  const Scores._() : super('score', 'score', 20.0);
}

final class Gross extends EachUnit {
  const Gross._() : super('gross', 'gr', 144.0);
}

final class GreatGross extends EachUnit {
  const GreatGross._() : super('great gross', 'gg', 1728.0);
}

extension EachOps on num {
  Each get each => Each.each(this);
  Each get dozen => Each.dozen(this);
  Each get score => Each.score(this);
  Each get gross => Each.gross(this);
  Each get greatGross => Each.greatGross(this);
}
