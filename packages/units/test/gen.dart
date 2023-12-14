import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final _doubleValue = Gen.chooseDouble(1, 1000);
final _intValue = Gen.chooseInt(1, 1000);

// Electro

final electricPotentialUnit = Gen.oneOf(ElectricPotential.units);
final electricPotential = (_doubleValue, electricPotentialUnit)
    .tupled
    .map(ElectricPotential.new.tupled);

// Information

final informationUnit = Gen.oneOf(Information.units);
final information = (_intValue, informationUnit)
    .tupled
    .map((t) => Information(t.$1.toDouble(), t.$2));

final dataRateUnit = Gen.oneOf(DataRate.units);
final dataRate = (_doubleValue, dataRateUnit).tupled.map(DataRate.new.tupled);

// Mass

final massUnit = Gen.oneOf(Mass.units);
final mass = (_doubleValue, massUnit).tupled.map(Mass.new.tupled);

// Motion

final velocityUnit = Gen.oneOf(Velocity.units);
final velocity = (_doubleValue, velocityUnit).tupled.map(Velocity.new.tupled);

// Space

final angleUnit = Gen.oneOf(Angle.units);
final angle = (_doubleValue, angleUnit).tupled.map(Angle.new.tupled);

final areaUnit = Gen.oneOf(Area.units);
final area = (_doubleValue, areaUnit).tupled.map(Area.new.tupled);

final lengthUnit = Gen.oneOf(Length.units);
final length = (_doubleValue, lengthUnit).tupled.map(Length.new.tupled);

final volumeUnit = Gen.oneOf(Volume.units);
final volume = (_doubleValue, volumeUnit).tupled.map(Volume.new.tupled);

// Time

final frequencyUnit = Gen.oneOf(Frequency.units);
final frequency =
    (_doubleValue, frequencyUnit).tupled.map(Frequency.new.tupled);

final timeUnit = Gen.oneOf(Time.units);
final time = (_doubleValue, timeUnit).tupled.map(Time.new.tupled);

Gen<String> quantityString<A extends Quantity<A>>(
  Iterable<BaseUnit<A>> units,
) =>
    (Gen.positiveInt, Gen.oneOf(['', ' ']), Gen.oneOf(units))
        .tupled
        .map((tuple) => '${tuple.$1}${tuple.$2}${tuple.$3.symbol}');
