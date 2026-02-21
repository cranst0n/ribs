import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final _doubleValue = Gen.chooseDouble(1, 1000);
final _intValue = Gen.chooseInt(1, 1000);

// Electro

final electricPotentialUnit = Gen.oneOf<UnitOfMeasure<ElectricPotential>>(ElectricPotential.units);
final electricPotential = (
  _doubleValue,
  electricPotentialUnit,
).tupled.map(ElectricPotential.new.tupled);

// Information

final informationUnit = Gen.oneOf<UnitOfMeasure<Information>>(Information.units);
final information = (
  _intValue,
  informationUnit,
).tupled.map((t) => Information(t.$1.toDouble(), t.$2));

final dataRateUnit = Gen.oneOf<UnitOfMeasure<DataRate>>(DataRate.units);
final dataRate = (_doubleValue, dataRateUnit).tupled.map(DataRate.new.tupled);

// Mass

final massUnit = Gen.oneOf<UnitOfMeasure<Mass>>(Mass.units);
final mass = (_doubleValue, massUnit).tupled.map(Mass.new.tupled);

// Motion

final velocityUnit = Gen.oneOf<UnitOfMeasure<Velocity>>(Velocity.units);
final velocity = (_doubleValue, velocityUnit).tupled.map(Velocity.new.tupled);

// Space

final angleUnit = Gen.oneOf<UnitOfMeasure<Angle>>(Angle.units);
final angle = (_doubleValue, angleUnit).tupled.map(Angle.new.tupled);

final areaUnit = Gen.oneOf<UnitOfMeasure<Area>>(Area.units);
final area = (_doubleValue, areaUnit).tupled.map(Area.new.tupled);

final lengthUnit = Gen.oneOf<UnitOfMeasure<Length>>(Length.units);
final length = (_doubleValue, lengthUnit).tupled.map(Length.new.tupled);

final volumeUnit = Gen.oneOf<UnitOfMeasure<Volume>>(Volume.units);
final volume = (_doubleValue, volumeUnit).tupled.map(Volume.new.tupled);

// Thermal

final temperatureUnit = Gen.oneOf<UnitOfMeasure<Temperature>>(Temperature.units);
final temperature = (_doubleValue, temperatureUnit).tupled.map(Temperature.new.tupled);

// Time

final frequencyUnit = Gen.oneOf<UnitOfMeasure<Frequency>>(Frequency.units);
final frequency = (_doubleValue, frequencyUnit).tupled.map(Frequency.new.tupled);

final timeUnit = Gen.oneOf<UnitOfMeasure<Time>>(Time.units);
final time = (_doubleValue, timeUnit).tupled.map(Time.new.tupled);

Gen<String> quantityString<A extends Quantity<A>>(
  Iterable<UnitOfMeasure<A>> units,
) => (
  Gen.positiveInt,
  Gen.oneOf(['', ' ']),
  Gen.oneOf(units.expand((element) => [element.symbol, element.unit, '${element.unit}s'])),
).tupled.map((tuple) => '${tuple.$1}${tuple.$2}${tuple.$3}');
