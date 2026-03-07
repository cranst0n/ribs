// ignore_for_file: avoid_print

import 'package:ribs_bench/json/decoding.dart';
import 'package:ribs_bench/json/encoding.dart';
import 'package:ribs_bench/json/parsing.dart';
import 'package:ribs_bench/json/printing.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  print('=== JSON / Parsing / small ===\n');
  RibsBenchmark.runAndReport([
    JsonParseSmallBenchmark(),
    DartParseSmallBenchmark(),
  ]);

  print('=== JSON / Parsing / medium ===\n');
  RibsBenchmark.runAndReport([
    JsonParseMediumBenchmark(),
    DartParseMediumBenchmark(),
  ]);

  print('=== JSON / Parsing / large (100 objects) ===\n');
  RibsBenchmark.runAndReport([
    JsonParseLargeBenchmark(),
    DartParseLargeBenchmark(),
  ]);

  print('=== JSON / Decoding / small ===\n');
  RibsBenchmark.runAndReport([
    JsonDecodeSmallBenchmark(),
    DartDecodeSmallBenchmark(),
  ]);

  print('=== JSON / Decoding / large (100 objects) ===\n');
  RibsBenchmark.runAndReport([
    JsonDecodeLargeBenchmark(),
    DartDecodeLargeBenchmark(),
  ]);

  print('=== JSON / Encoding / small ===\n');
  RibsBenchmark.runAndReport([
    JsonEncodeSmallBenchmark(),
    DartEncodeSmallBenchmark(),
  ]);

  print('=== JSON / Encoding / large (100 objects) ===\n');
  RibsBenchmark.runAndReport([
    JsonEncodeLargeBenchmark(),
    DartEncodeLargeBenchmark(),
  ]);

  print('=== JSON / Printing / small ===\n');
  RibsBenchmark.runAndReport([
    JsonPrintNoSpacesSmallBenchmark(),
    JsonPrintSpaces2SmallBenchmark(),
    DartPrintSmallBenchmark(),
  ]);

  print('=== JSON / Printing / large (100 objects) ===\n');
  RibsBenchmark.runAndReport([
    JsonPrintNoSpacesLargeBenchmark(),
    JsonPrintSpaces2LargeBenchmark(),
    DartPrintLargeBenchmark(),
  ]);
}
