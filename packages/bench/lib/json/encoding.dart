import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
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

// ─── Small: encode a single object ────────────────────────────────────────────

/// Encode a single Dart object to a Json value.
class JsonEncodeSmallBenchmark extends BenchmarkBase {
  JsonEncodeSmallBenchmark() : super('json-encode-small');

  static const _person = _Person(1, 'Alice', 98.6);

  @override
  void run() => _personCodec.encode(_person);
}

// ─── Large: encode an IList of 100 objects ────────────────────────────────────

final _listEncoder = Encoder.ilist<_Person>(_personCodec);

/// Encode an IList of 100 objects to a Json array.
class JsonEncodeLargeBenchmark extends BenchmarkBase {
  JsonEncodeLargeBenchmark() : super('json-encode-large');

  late IList<_Person> _people;

  @override
  void setup() {
    _people = IList.fromDart(
      List.generate(100, (int i) => _Person(i, 'user$i', i * 0.5)),
    );
  }

  @override
  void run() => _listEncoder.encode(_people);
}

// ─── Dart stdlib comparisons ──────────────────────────────────────────────────
//
// Measures building a Map<String, dynamic> from a typed value,
// the native equivalent of Codec.encode(value).

Map<String, dynamic> _personToMap(_Person p) => {
  'id': p.id,
  'name': p.name,
  'score': p.score,
};

/// Encode a single Dart object to a Map using manual field assignment.
class DartEncodeSmallBenchmark extends BenchmarkBase {
  DartEncodeSmallBenchmark() : super('dart-json-encode-small');

  static const _person = _Person(1, 'Alice', 98.6);

  @override
  void run() => _personToMap(_person);
}

/// Encode a List of 100 objects to a List of Maps using manual field assignment.
class DartEncodeLargeBenchmark extends BenchmarkBase {
  DartEncodeLargeBenchmark() : super('dart-json-encode-large');

  late List<_Person> _people;

  @override
  void setup() {
    _people = List.generate(100, (int i) => _Person(i, 'user$i', i * 0.5));
  }

  @override
  void run() => _people.map(_personToMap).toList();
}
