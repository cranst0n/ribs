import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/legacy/ilist.dart' as legacy;
import 'package:ribs_core/src/ilist.dart' as fic;

const n = 2000;

final legacyList = legacy.IList.tabulate(n, id);
final ficList = fic.IList.tabulate(n, id);

class SimpleBenchmark extends BenchmarkBase {
  final Function0<void> f;

  SimpleBenchmark(this.f) : super('');

  @override
  void run() => f();
}

final sep = '  |  ';

void main(List<String> args) async {
  print(
      (' ' * 15) + sep + 'legacy'.padLeft(10) + sep + 'fic'.padLeft(10) + sep);

  print('-' * 48);

  await compare(
    'append',
    SimpleBenchmark(() => legacyList.append(0)),
    SimpleBenchmark(() => ficList.append(0)),
  );

  await compare(
    'concat',
    SimpleBenchmark(() => legacyList.concat(legacyList)),
    SimpleBenchmark(() => ficList.concat(ficList)),
  );

  await compare(
    'drop',
    SimpleBenchmark(() => legacyList.drop(n ~/ 2)),
    SimpleBenchmark(() => ficList.drop(n ~/ 2)),
  );

  await compare(
    'dropRight',
    SimpleBenchmark(() => legacyList.dropRight(n ~/ 2)),
    SimpleBenchmark(() => ficList.dropRight(n ~/ 2)),
  );

  await compare(
    'filter',
    SimpleBenchmark(() => legacyList.filter((x) => x < n / 2)),
    SimpleBenchmark(() => ficList.filter((x) => x < n / 2)),
  );

  await compare(
    'findLast',
    SimpleBenchmark(() => legacyList.findLast((x) => x < n / 2)),
    SimpleBenchmark(() => ficList.findLast((x) => x < n / 2)),
  );

  await compare(
    'flatMap',
    SimpleBenchmark(
        () => legacyList.flatMap((x) => legacy.IList.of([x - 1, x, x + 1]))),
    SimpleBenchmark(
        () => ficList.flatMap((x) => fic.IList.of([x - 1, x, x + 1]))),
  );

  await compare(
    'init',
    SimpleBenchmark(() => legacyList.init()),
    SimpleBenchmark(() => ficList.init()),
  );

  await compare(
    'map',
    SimpleBenchmark(() => legacyList.map((x) => x + 1)),
    SimpleBenchmark(() => ficList.map((x) => x + 1)),
  );

  await compare(
    'partition',
    SimpleBenchmark(() => legacyList.partition((x) => x.isEven)),
    SimpleBenchmark(() => ficList.partition((x) => x.isEven)),
  );

  await compare(
    'prepend',
    SimpleBenchmark(() => legacyList.prepend(0)),
    SimpleBenchmark(() => ficList.prepend(0)),
  );

  await compare(
    'replace',
    SimpleBenchmark(() => legacyList.replace(n ~/ 2, 0)),
    SimpleBenchmark(() => ficList.replace(n ~/ 2, 0)),
  );

  await compare(
    'reverse',
    SimpleBenchmark(() => legacyList.reverse()),
    SimpleBenchmark(() => ficList.reverse()),
  );

  await compare(
    'sliding',
    SimpleBenchmark(() => legacyList.sliding(3, 2)),
    SimpleBenchmark(() => ficList.sliding(3, 2)),
  );

  await compare(
    'tabulate',
    SimpleBenchmark(() => legacy.IList.tabulate(n, id)),
    SimpleBenchmark(() => fic.IList.tabulate(n, id)),
  );

  await compare(
    'zipWithIndex',
    SimpleBenchmark(() => legacyList.zipWithIndex()),
    SimpleBenchmark(() => ficList.zipWithIndex()),
  );
}

Future<void> compare(
  String label,
  BenchmarkBase pure,
  BenchmarkBase fic,
) async {
  final pureMs = await pure.measure();
  final ficMs = await fic.measure();

  final pureStr = pureMs < ficMs
      ? '\x1B[32;1m${pureMs.round().toString().padLeft(8)}µs\x1B[0m'
      : '\x1B[31;1m${pureMs.round().toString().padLeft(8)}µs\x1B[0m';

  final ficStr = ficMs < pureMs
      ? '\x1B[32;1m${ficMs.round().toString().padLeft(8)}µs\x1B[0m'
      : '\x1B[31;1m${ficMs.round().toString().padLeft(8)}µs\x1B[0m';

  print(label.padRight(15) + '$sep${pureStr}$sep${ficStr}$sep');
}

Future<double> attemptBenchmark(AsyncBenchmarkBase b) {
  final c = Completer<double>();

  Zone.current.runGuarded(() async {
    try {
      final result = await b.measure();
      c.complete(result);
    } catch (_) {
      c.complete(-1);
    }
  });

  return c.future;
}
