import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_json/ribs_json.dart';

// ─── Small: flat object with 3 fields ─────────────────────────────────────────

const _smallInput = '{"id":1,"name":"Alice","score":98.6}';

/// Parse a compact, flat JSON object.
class JsonParseSmallBenchmark extends BenchmarkBase {
  JsonParseSmallBenchmark() : super('json-parse-small');

  @override
  void run() => Json.parse(_smallInput);
}

// ─── Medium: nested object with an array ──────────────────────────────────────

const _mediumInput =
    '{"user":{"id":1,"name":"Bob","score":85.5},'
    '"tags":["dart","ribs","json","benchmark"],'
    '"meta":{"version":2,"active":true,"label":"test-run"}}';

/// Parse a moderately nested JSON object containing an array.
class JsonParseMediumBenchmark extends BenchmarkBase {
  JsonParseMediumBenchmark() : super('json-parse-medium');

  @override
  void run() => Json.parse(_mediumInput);
}

// ─── Large: array of 100 objects ──────────────────────────────────────────────

/// Parse a JSON array of 100 flat objects.
class JsonParseLargeBenchmark extends BenchmarkBase {
  JsonParseLargeBenchmark() : super('json-parse-large');

  late String _input;

  @override
  void setup() {
    final buf = StringBuffer('[');
    for (var i = 0; i < 100; i++) {
      if (i > 0) buf.write(',');
      buf.write('{"id":$i,"name":"user$i","score":${i * 0.5}}');
    }
    buf.write(']');
    _input = buf.toString();
  }

  @override
  void run() => Json.parse(_input);
}

// ─── Dart stdlib comparisons ──────────────────────────────────────────────────

/// Parse a small flat JSON object using dart:convert.
class DartParseSmallBenchmark extends BenchmarkBase {
  DartParseSmallBenchmark() : super('dart-json-parse-small');

  @override
  void run() => jsonDecode(_smallInput);
}

/// Parse a moderately nested JSON object using dart:convert.
class DartParseMediumBenchmark extends BenchmarkBase {
  DartParseMediumBenchmark() : super('dart-json-parse-medium');

  @override
  void run() => jsonDecode(_mediumInput);
}

/// Parse a JSON array of 100 flat objects using dart:convert.
class DartParseLargeBenchmark extends BenchmarkBase {
  DartParseLargeBenchmark() : super('dart-json-parse-large');

  late String _input;

  @override
  void setup() {
    final buf = StringBuffer('[');
    for (var i = 0; i < 100; i++) {
      if (i > 0) buf.write(',');
      buf.write('{"id":$i,"name":"user$i","score":${i * 0.5}}');
    }
    buf.write(']');
    _input = buf.toString();
  }

  @override
  void run() => jsonDecode(_input);
}
