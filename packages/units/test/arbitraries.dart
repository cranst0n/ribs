import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final _doubleValue = Gen.chooseDouble(1, 1000);
final _intValue = Gen.chooseInt(1, 1000);

// Dimensionless

final eachUnit = Gen.oneOf<UnitOfMeasure<Each>>(Each.units);
final each = (_doubleValue, eachUnit).tupled.map(Each.new.tupled);

// Electro

final capacitanceUnit = Gen.oneOf<UnitOfMeasure<Capacitance>>(Capacitance.units);
final capacitance = (_doubleValue, capacitanceUnit).tupled.map(Capacitance.new.tupled);

final electricChargeUnit = Gen.oneOf<UnitOfMeasure<ElectricCharge>>(ElectricCharge.units);
final electricCharge = (_doubleValue, electricChargeUnit).tupled.map(ElectricCharge.new.tupled);

final electricConductanceUnit = Gen.oneOf<UnitOfMeasure<ElectricConductance>>(
  ElectricConductance.units,
);
final electricConductance = (
  _doubleValue,
  electricConductanceUnit,
).tupled.map(ElectricConductance.new.tupled);

final electricCurrentUnit = Gen.oneOf<UnitOfMeasure<ElectricCurrent>>(ElectricCurrent.units);
final electricCurrent = (_doubleValue, electricCurrentUnit).tupled.map(ElectricCurrent.new.tupled);

final electricPotentialUnit = Gen.oneOf<UnitOfMeasure<ElectricPotential>>(ElectricPotential.units);
final electricPotential = (
  _doubleValue,
  electricPotentialUnit,
).tupled.map(ElectricPotential.new.tupled);

final electricResistanceUnit = Gen.oneOf<UnitOfMeasure<ElectricResistance>>(
  ElectricResistance.units,
);
final electricResistance = (
  _doubleValue,
  electricResistanceUnit,
).tupled.map(ElectricResistance.new.tupled);

final inductanceUnit = Gen.oneOf<UnitOfMeasure<Inductance>>(Inductance.units);
final inductance = (_doubleValue, inductanceUnit).tupled.map(Inductance.new.tupled);

final magneticFluxUnit = Gen.oneOf<UnitOfMeasure<MagneticFlux>>(MagneticFlux.units);
final magneticFlux = (_doubleValue, magneticFluxUnit).tupled.map(MagneticFlux.new.tupled);

final magneticFluxDensityUnit = Gen.oneOf<UnitOfMeasure<MagneticFluxDensity>>(
  MagneticFluxDensity.units,
);
final magneticFluxDensity = (
  _doubleValue,
  magneticFluxDensityUnit,
).tupled.map(MagneticFluxDensity.new.tupled);

// Energy

final energyUnit = Gen.oneOf<UnitOfMeasure<Energy>>(Energy.units);
final energy = (_doubleValue, energyUnit).tupled.map(Energy.new.tupled);

final powerUnit = Gen.oneOf<UnitOfMeasure<Power>>(Power.units);
final power = (_doubleValue, powerUnit).tupled.map(Power.new.tupled);

// Information

final informationUnit = Gen.oneOf<UnitOfMeasure<Information>>(Information.units);
final information = (
  _intValue,
  informationUnit,
).tupled.map((t) => Information(t.$1.toDouble(), t.$2));

final dataRateUnit = Gen.oneOf<UnitOfMeasure<DataRate>>(DataRate.units);
final dataRate = (_doubleValue, dataRateUnit).tupled.map(DataRate.new.tupled);

// Mass

final areaDensityUnit = Gen.oneOf<UnitOfMeasure<AreaDensity>>(AreaDensity.units);
final areaDensity = (_doubleValue, areaDensityUnit).tupled.map(AreaDensity.new.tupled);

final chemicalAmountUnit = Gen.oneOf<UnitOfMeasure<ChemicalAmount>>(ChemicalAmount.units);
final chemicalAmount = (_doubleValue, chemicalAmountUnit).tupled.map(ChemicalAmount.new.tupled);

final densityUnit = Gen.oneOf<UnitOfMeasure<Density>>(Density.units);
final density = (_doubleValue, densityUnit).tupled.map(Density.new.tupled);

final massUnit = Gen.oneOf<UnitOfMeasure<Mass>>(Mass.units);
final mass = (_doubleValue, massUnit).tupled.map(Mass.new.tupled);

// Motion

final accelerationUnit = Gen.oneOf<UnitOfMeasure<Acceleration>>(Acceleration.units);
final acceleration = (_doubleValue, accelerationUnit).tupled.map(Acceleration.new.tupled);

final angularVelocityUnit = Gen.oneOf<UnitOfMeasure<AngularVelocity>>(AngularVelocity.units);
final angularVelocity = (_doubleValue, angularVelocityUnit).tupled.map(AngularVelocity.new.tupled);

final forceUnit = Gen.oneOf<UnitOfMeasure<Force>>(Force.units);
final force = (_doubleValue, forceUnit).tupled.map(Force.new.tupled);

final massFlowUnit = Gen.oneOf<UnitOfMeasure<MassFlow>>(MassFlow.units);
final massFlow = (_doubleValue, massFlowUnit).tupled.map(MassFlow.new.tupled);

final momentumUnit = Gen.oneOf<UnitOfMeasure<Momentum>>(Momentum.units);
final momentum = (_doubleValue, momentumUnit).tupled.map(Momentum.new.tupled);

final pressureUnit = Gen.oneOf<UnitOfMeasure<Pressure>>(Pressure.units);
final pressure = (_doubleValue, pressureUnit).tupled.map(Pressure.new.tupled);

final velocityUnit = Gen.oneOf<UnitOfMeasure<Velocity>>(Velocity.units);
final velocity = (_doubleValue, velocityUnit).tupled.map(Velocity.new.tupled);

final volumeFlowUnit = Gen.oneOf<UnitOfMeasure<VolumeFlow>>(VolumeFlow.units);
final volumeFlow = (_doubleValue, volumeFlowUnit).tupled.map(VolumeFlow.new.tupled);

// Photometric

final illuminanceUnit = Gen.oneOf<UnitOfMeasure<Illuminance>>(Illuminance.units);
final illuminance = (_doubleValue, illuminanceUnit).tupled.map(Illuminance.new.tupled);

final luminanceUnit = Gen.oneOf<UnitOfMeasure<Luminance>>(Luminance.units);
final luminance = (_doubleValue, luminanceUnit).tupled.map(Luminance.new.tupled);

final luminousFluxUnit = Gen.oneOf<UnitOfMeasure<LuminousFlux>>(LuminousFlux.units);
final luminousFlux = (_doubleValue, luminousFluxUnit).tupled.map(LuminousFlux.new.tupled);

final luminousIntensityUnit = Gen.oneOf<UnitOfMeasure<LuminousIntensity>>(LuminousIntensity.units);
final luminousIntensity = (
  _doubleValue,
  luminousIntensityUnit,
).tupled.map(LuminousIntensity.new.tupled);

// Radiometric

final irradianceUnit = Gen.oneOf<UnitOfMeasure<Irradiance>>(Irradiance.units);
final irradiance = (_doubleValue, irradianceUnit).tupled.map(Irradiance.new.tupled);

final radianceUnit = Gen.oneOf<UnitOfMeasure<Radiance>>(Radiance.units);
final radiance = (_doubleValue, radianceUnit).tupled.map(Radiance.new.tupled);

final radiantIntensityUnit = Gen.oneOf<UnitOfMeasure<RadiantIntensity>>(RadiantIntensity.units);
final radiantIntensity = (
  _doubleValue,
  radiantIntensityUnit,
).tupled.map(RadiantIntensity.new.tupled);

final spectralIntensityUnit = Gen.oneOf<UnitOfMeasure<SpectralIntensity>>(SpectralIntensity.units);
final spectralIntensity = (
  _doubleValue,
  spectralIntensityUnit,
).tupled.map(SpectralIntensity.new.tupled);

final spectralPowerUnit = Gen.oneOf<UnitOfMeasure<SpectralPower>>(SpectralPower.units);
final spectralPower = (_doubleValue, spectralPowerUnit).tupled.map(SpectralPower.new.tupled);

// Space

final angleUnit = Gen.oneOf<UnitOfMeasure<Angle>>(Angle.units);
final angle = (_doubleValue, angleUnit).tupled.map(Angle.new.tupled);

final areaUnit = Gen.oneOf<UnitOfMeasure<Area>>(Area.units);
final area = (_doubleValue, areaUnit).tupled.map(Area.new.tupled);

final lengthUnit = Gen.oneOf<UnitOfMeasure<Length>>(Length.units);
final length = (_doubleValue, lengthUnit).tupled.map(Length.new.tupled);

final solidAngleUnit = Gen.oneOf<UnitOfMeasure<SolidAngle>>(SolidAngle.units);
final solidAngle = (_doubleValue, solidAngleUnit).tupled.map(SolidAngle.new.tupled);

final volumeUnit = Gen.oneOf<UnitOfMeasure<Volume>>(Volume.units);
final volume = (_doubleValue, volumeUnit).tupled.map(Volume.new.tupled);

// Thermal

final temperatureUnit = Gen.oneOf<UnitOfMeasure<Temperature>>(Temperature.units);
final temperature = (_doubleValue, temperatureUnit).tupled.map(Temperature.new.tupled);

final thermalCapacityUnit = Gen.oneOf<UnitOfMeasure<ThermalCapacity>>(ThermalCapacity.units);
final thermalCapacity = (_doubleValue, thermalCapacityUnit).tupled.map(ThermalCapacity.new.tupled);

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
