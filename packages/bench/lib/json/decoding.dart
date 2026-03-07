import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_json/ribs_json.dart';

final class _Person {
  final int id;
  final String name;
  final double score;

  const _Person(this.id, this.name, this.score);
}

final _personCodec = (
  ('id', Codec.integer),
  ('name', Codec.string),
  ('score', Codec.dubble),
).product<_Person>(
  (int id, String name, double score) => _Person(id, name, score),
  (_Person p) => (p.id, p.name, p.score),
);

// ─── Small: decode a single flat object ───────────────────────────────────────

/// Decode a pre-parsed JSON object into a typed Dart value.
class JsonDecodeSmallBenchmark extends BenchmarkBase {
  JsonDecodeSmallBenchmark() : super('json-decode-small');

  late Json _json;

  @override
  void setup() {
    _json = Json.parse('{"id":1,"name":"Alice","score":98.6}').getOrElse(
      () => throw StateError('parse failed'),
    );
  }

  @override
  void run() => _personCodec.decode(_json);
}

// ─── Large: decode a pre-parsed array of 100 objects ─────────────────────────

final _listCodec = Codec.ilist(_personCodec);

/// Decode a pre-parsed JSON array of 100 objects into an IList.
class JsonDecodeLargeBenchmark extends BenchmarkBase {
  JsonDecodeLargeBenchmark() : super('json-decode-large');

  late Json _json;

  @override
  void setup() {
    final buf = StringBuffer('[');
    for (var i = 0; i < 100; i++) {
      if (i > 0) buf.write(',');
      buf.write('{"id":$i,"name":"user$i","score":${i * 0.5}}');
    }
    buf.write(']');
    _json = Json.parse(buf.toString()).getOrElse(
      () => throw StateError('parse failed'),
    );
  }

  @override
  void run() => _listCodec.decode(_json);
}

// ─── Dart stdlib comparisons ──────────────────────────────────────────────────
//
// Measures extracting typed fields from a pre-parsed Map<String, dynamic>,
// the native equivalent of Codec.decode(Json).

_Person _personFromMap(Map<String, dynamic> m) => _Person(
  m['id'] as int,
  m['name'] as String,
  (m['score'] as num).toDouble(),
);

/// Decode a pre-parsed Map into a typed Dart value using manual field access.
class DartDecodeSmallBenchmark extends BenchmarkBase {
  DartDecodeSmallBenchmark() : super('dart-json-decode-small');

  late Map<String, dynamic> _map;

  @override
  void setup() {
    _map = jsonDecode('{"id":1,"name":"Alice","score":98.6}')
        as Map<String, dynamic>;
  }

  @override
  void run() => _personFromMap(_map);
}

/// Decode a pre-parsed List of Maps into typed Dart values using manual field access.
class DartDecodeLargeBenchmark extends BenchmarkBase {
  DartDecodeLargeBenchmark() : super('dart-json-decode-large');

  late List<Map<String, dynamic>> _list;

  @override
  void setup() {
    final buf = StringBuffer('[');
    for (var i = 0; i < 100; i++) {
      if (i > 0) buf.write(',');
      buf.write('{"id":$i,"name":"user$i","score":${i * 0.5}}');
    }
    buf.write(']');
    _list = (jsonDecode(buf.toString()) as List).cast<Map<String, dynamic>>();
  }

  @override
  void run() => _list.map(_personFromMap).toList();
}
