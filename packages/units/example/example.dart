// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

void main() {
  // Basic Creation and Extension methods
  final d1 = 100.meters;
  final d2 = 2.kilometers;

  print('Distance 1: $d1');
  print('Distance 2: $d2');

  // Unit conversion and Comparison
  final d1InKm = d1.to(Length.kilometers);
  print('Distance 1 in Km: $d1InKm');

  if (d2 > d1) {
    print('$d2 is further than $d1');
  }

  // Dimensional Arithmetic (Length * Length = Area)
  final area = 10.meters * 5.meters;
  print('\nArea: $area');
  print('Area in square centimeters: ${area.toSquareCentimeters}');

  // Information
  final fileSize = 1.5.gigabytes;
  print('\nFile Size: $fileSize');
  print('File Size in Megabytes: ${fileSize.toMegabytes}');

  // Temperature (Note the spelling in the library: celcius)
  final boilingPoint = 100.celcius;
  print('\nBoiling point: $boilingPoint');
  print('In Fahrenheit: ${boilingPoint.toFahrenheit}');
  print('In Kelvin: ${boilingPoint.toKelvin}');

  // Time and Duration integration
  // Explicitly use Time.milliseconds to avoid clash with core Duration extension
  final rDelay = Time.milliseconds(500);
  final dartDuration = rDelay.toDuration;
  print('\nconverted to Dart Duration: $dartDuration');

  // fromDuration is an instance method on Time
  final fromDart = Time.seconds(0).fromDuration(const Duration(minutes: 1));
  print('Back from Dart duration: $fromDart');

  // Parsing from strings
  final parsedLength = Length.parse('15.5 km');
  final parsedInfo = Information.parse('1024 MiB');

  (parsedLength, parsedInfo).mapN((l, i) {
    print('\nParsed Length: $l');
    print('Parsed Info: $i');
  });
}
