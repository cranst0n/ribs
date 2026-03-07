import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_json/ribs_json.dart';

// ─── Shared fixtures ──────────────────────────────────────────────────────────

Json _buildSmallJson() => Json.obj([
  ('id', Json.number(1)),
  ('name', Json.str('Alice')),
  ('score', Json.number(98.6)),
]);

Json _buildLargeJson() => Json.arr(
  List.generate(
    100,
    (int i) => Json.obj([
      ('id', Json.number(i)),
      ('name', Json.str('user$i')),
      ('score', Json.number(i * 0.5)),
    ]),
  ),
);

// ─── noSpaces ─────────────────────────────────────────────────────────────────

/// Print a small Json object with no whitespace.
class JsonPrintNoSpacesSmallBenchmark extends BenchmarkBase {
  JsonPrintNoSpacesSmallBenchmark() : super('json-print-nospaces-small');

  late Json _json;

  @override
  void setup() => _json = _buildSmallJson();

  @override
  void run() => Printer.noSpaces.print(_json);
}

/// Print a large Json array with no whitespace.
class JsonPrintNoSpacesLargeBenchmark extends BenchmarkBase {
  JsonPrintNoSpacesLargeBenchmark() : super('json-print-nospaces-large');

  late Json _json;

  @override
  void setup() => _json = _buildLargeJson();

  @override
  void run() => Printer.noSpaces.print(_json);
}

// ─── spaces2 (indented) ───────────────────────────────────────────────────────

/// Print a small Json object with 2-space indentation.
class JsonPrintSpaces2SmallBenchmark extends BenchmarkBase {
  JsonPrintSpaces2SmallBenchmark() : super('json-print-spaces2-small');

  late Json _json;

  @override
  void setup() => _json = _buildSmallJson();

  @override
  void run() => Printer.spaces2.print(_json);
}

/// Print a large Json array with 2-space indentation.
class JsonPrintSpaces2LargeBenchmark extends BenchmarkBase {
  JsonPrintSpaces2LargeBenchmark() : super('json-print-spaces2-large');

  late Json _json;

  @override
  void setup() => _json = _buildLargeJson();

  @override
  void run() => Printer.spaces2.print(_json);
}

// ─── Dart stdlib comparisons ──────────────────────────────────────────────────
//
// Measures jsonEncode(Map/List), the native equivalent of Printer.print(Json).

Map<String, dynamic> _buildSmallMap() => {
  'id': 1,
  'name': 'Alice',
  'score': 98.6,
};

List<Map<String, dynamic>> _buildLargeList() => List.generate(
  100,
  (int i) => {'id': i, 'name': 'user$i', 'score': i * 0.5},
);

/// Serialize a small Map to a JSON string using dart:convert.
class DartPrintSmallBenchmark extends BenchmarkBase {
  DartPrintSmallBenchmark() : super('dart-json-print-small');

  late Map<String, dynamic> _map;

  @override
  void setup() => _map = _buildSmallMap();

  @override
  void run() => jsonEncode(_map);
}

/// Serialize a List of 100 Maps to a JSON string using dart:convert.
class DartPrintLargeBenchmark extends BenchmarkBase {
  DartPrintLargeBenchmark() : super('dart-json-print-large');

  late List<Map<String, dynamic>> _list;

  @override
  void setup() => _list = _buildLargeList();

  @override
  void run() => jsonEncode(_list);
}
