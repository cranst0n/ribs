# ribs_units

`ribs_units` is a type-safe library for working with dimensional quantities and units of measure in Dart. Heavily inspired by [Squants](http://www.squants.com/), it provides an expressive API for handling physical and digital quantities while preventing common "unit mismatch" bugs.

## Features

- **Extensive Unit Support**: Includes core domains like Space (Length, Area, Volume, Angle), Time (Time, Frequency), Information (Data Storage, Data Rate), Mass, Thermal (Temperature), and Motion (Velocity).
- **Clean DSL**: Uses Dart extension methods to allow intuitive syntax like `10.meters` or `5.megabytes`.
- **Type Safety**: Prevents mixing different quantities (e.g., adding meters to seconds) at compile time.
- **Unit Conversions**: Effortlessly convert between units within the same quantity.
- **String Parsing**: Robust parsing of quantity strings (e.g., `"1.5 km"`, `"1024 MiB"`).

## Why ribs_units?

1. **Self-Documenting Code**: Instead of `double timeoutSeconds`, use `Time timeout`.
2. **Precision & Safety**: Avoid off-by-one errors or unit conversion mistakes (e.g., milliseconds vs. seconds).
3. **Immutability**: All quantities are immutable, making them safe for concurrent or complex logic.
4. **Integration**: Built to work as part of the larger `ribs` ecosystem.

## Quick Examples

### Creating Quantities

```dart
final length = 10.kilometers;
final duration = 15.minutes;
```

### Conversions

```dart
// Convert to a base value in specific units
final distanceInMeters = length.to(Length.meters); 
print(distanceInMeters); // 10000.0

final temp = 32.fahrenheit;
print(temp.toCelsius); // 0.0 °C
```

### Dimensional Arithmetic

Some quantities support dimensional operations where appropriate:
```dart
final area = 10.meters * 5.meters; // Returns Area
final volume = area * 2.meters;    // Returns Volume
```

### String Parsing

```dart
final parsed = Information.parse("1.5 GiB").getOrElse(() => throw "Invalid input");
print(parsed.toMegabytes);
```