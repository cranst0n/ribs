// ignore_for_file: unused_local_variable, avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

// #region motivation-raw-problem
// With plain doubles there is nothing to prevent mixing incompatible values.
// The compiler cannot catch either mistake:
void rawProblem() {
  const speedMph = 60.0; // miles per hour
  const speedKph = 100.0; // kilometers per hour
  const combined = speedMph + speedKph; // wrong — silently adds apples to oranges

  const distanceMeters = 1000.0;
  const distanceKilometers = 5.0;
  // Forgot that units differ — off by a factor of 1000
  const total = distanceMeters + distanceKilometers;
}
// #endregion motivation-raw-problem

// #region motivation-typed-solution
// ribs_units makes the unit part of the type.
// Mixing incompatible quantities is a compile-time error,
// and conversions are explicit and readable.
void typedSolution() {
  final speedA = 60.usMilesPerHour;
  final speedB = 100.kilometersPerHour;

  // Convert to a common unit before combining — always explicit.
  final combined = speedA + speedB.toUsMilesPerHour;

  final distanceM = 1000.meters;
  final distanceKm = 5.kilometers;

  // No silent unit mismatch — both are Length, conversions happen inside.
  final total = distanceM + distanceKm; // 6000 meters
}
// #endregion motivation-typed-solution

// #region motivation-conversions
void conversions() {
  final distance = 10.kilometers;

  // Convert with .to(unit) — returns a plain double.
  final inMeters = distance.to(Length.meters); // 10000.0

  // Or use a typed convenience getter that returns the same quantity type.
  final inMiles = distance.toUsMiles; // Length in US miles

  // Comparisons work across units automatically.
  final a = 5280.feet;
  final b = 1.usMiles;
  print(a.equivalentTo(b)); // true
  print(a >= b); // true
}
// #endregion motivation-conversions

// #region motivation-arithmetic
void arithmetic() {
  // Length × Length → Area (dimensional arithmetic is type-checked)
  final width = 10.meters;
  final height = 5.meters;
  final area = width * height; // Area(50, squareMeters)

  // Area × Length → Volume
  final depth = 2.meters;
  final volume = area * depth; // Volume(100, cubicMeters)

  // Area / Length → Length
  final side = area / height; // Length(10, meters)
}
// #endregion motivation-arithmetic

// #region motivation-information
void information() {
  final fileSize = 1500.megabytes;

  // toCoarsest finds the most readable unit automatically.
  print(fileSize.toCoarsest); // 1.5 gigabytes

  // Metric (1000-based) vs binary (1024-based) are distinct unit families.
  final memoryUsed = 1.0.gibibytes; // exactly 1 GiB
  final inMB = memoryUsed.toMegabytes; // ~1073.74 MB (metric megabytes)
}
// #endregion motivation-information

// #region motivation-temperature
void temperature() {
  // Scale conversions (Celsius ↔ Fahrenheit ↔ Kelvin) account for zero-point offsets.
  final boiling = 100.celcius;
  print(boiling.toFahrenheit); // Temperature(212.0, fahrenheit)
  print(boiling.toKelvin); // Temperature(373.15, kelvin)

  // Degree conversions (deltas) omit the zero-point offset.
  // A 10 °C increase is an 18 °F increase, not 50 °F.
  final delta = 10.celcius;
  print(delta.toCelsiusDegrees); // Temperature(10.0, celcius)  — no offset
  print(delta.toFahrenheitDegrees); // Temperature(18.0, fahrenheit) — 10 × 9/5
}
// #endregion motivation-temperature

// #region motivation-parsing
void parsing() {
  // Parse quantities from user input or configuration files.
  final len = Length.parse('15.5 km');
  final info = Information.parse('1024 MiB');

  // Returns Option<A> — absence is explicit, not a thrown exception.
  len.fold(
    () => print('invalid'),
    (l) => print(l.to(Length.meters)), // 15500.0
  );

  // Use getOrElse for a sensible default.
  final size = Information.parse('bad input').getOrElse(() => 0.bytes);
}
// #endregion motivation-parsing
