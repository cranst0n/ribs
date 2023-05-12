// ignore_for_file: avoid_print, implementation_imports

import 'package:benchmark_harness/benchmark_harness.dart';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/legacy/ilist.dart' as legacy;

const n = 2000;

final legacyList = legacy.IList.tabulate(n, id);
final ficList = IList.tabulate(n, id);

class SimpleBenchmark extends BenchmarkBase {
  final Function0<void> f;

  SimpleBenchmark(this.f) : super('');

  @override
  void run() => f();
}

const sep = '  |  ';

void main(List<String> args) async {
  print(
      (' ' * 15) + sep + 'legacy'.padLeft(10) + sep + 'fic'.padLeft(10) + sep);

  print('-' * 48);

  compare(
    'append',
    SimpleBenchmark(() => legacyList.append(0)),
    SimpleBenchmark(() => ficList.append(0)),
  );

  compare(
    'concat',
    SimpleBenchmark(() => legacyList.concat(legacyList)),
    SimpleBenchmark(() => ficList.concat(ficList)),
  );

  compare(
    'drop',
    SimpleBenchmark(() => legacyList.drop(n ~/ 2)),
    SimpleBenchmark(() => ficList.drop(n ~/ 2)),
  );

  compare(
    'dropRight',
    SimpleBenchmark(() => legacyList.dropRight(n ~/ 2)),
    SimpleBenchmark(() => ficList.dropRight(n ~/ 2)),
  );

  compare(
    'filter',
    SimpleBenchmark(() => legacyList.filter((x) => x < n / 2)),
    SimpleBenchmark(() => ficList.filter((x) => x < n / 2)),
  );

  compare(
    'findLast',
    SimpleBenchmark(() => legacyList.findLast((x) => x < n / 2)),
    SimpleBenchmark(() => ficList.findLast((x) => x < n / 2)),
  );

  compare(
    'flatMap',
    SimpleBenchmark(
        () => legacyList.flatMap((x) => legacy.IList.of([x - 1, x, x + 1]))),
    SimpleBenchmark(() => ficList.flatMap((x) => IList.of([x - 1, x, x + 1]))),
  );

  compare(
    'init',
    SimpleBenchmark(() => legacyList.init()),
    SimpleBenchmark(() => ficList.init()),
  );

  compare(
    'map',
    SimpleBenchmark(() => legacyList.map((x) => x + 1)),
    SimpleBenchmark(() => ficList.map((x) => x + 1)),
  );

  compare(
    'partition',
    SimpleBenchmark(() => legacyList.partition((x) => x.isEven)),
    SimpleBenchmark(() => ficList.partition((x) => x.isEven)),
  );

  compare(
    'prepend',
    SimpleBenchmark(() => legacyList.prepend(0)),
    SimpleBenchmark(() => ficList.prepend(0)),
  );

  compare(
    'replace',
    SimpleBenchmark(() => legacyList.replace(n ~/ 2, 0)),
    SimpleBenchmark(() => ficList.replace(n ~/ 2, 0)),
  );

  compare(
    'reverse',
    SimpleBenchmark(() => legacyList.reverse()),
    SimpleBenchmark(() => ficList.reverse()),
  );

  compare(
    'sliding',
    SimpleBenchmark(() => legacyList.sliding(3, 2)),
    SimpleBenchmark(() => ficList.sliding(3, 2)),
  );

  compare(
    'tabulate',
    SimpleBenchmark(() => legacy.IList.tabulate(n, id)),
    SimpleBenchmark(() => IList.tabulate(n, id)),
  );

  compare(
    'zipWithIndex',
    SimpleBenchmark(() => legacyList.zipWithIndex()),
    SimpleBenchmark(() => ficList.zipWithIndex()),
  );
}

void compare(
  String label,
  BenchmarkBase pure,
  BenchmarkBase fic,
) {
  final pureMs = pure.measure();
  final ficMs = fic.measure();

  final pureStr = pureMs < ficMs
      ? '\x1B[32;1m${pureMs.round().toString().padLeft(8)}µs\x1B[0m'
      : '\x1B[31;1m${pureMs.round().toString().padLeft(8)}µs\x1B[0m';

  final ficStr = ficMs < pureMs
      ? '\x1B[32;1m${ficMs.round().toString().padLeft(8)}µs\x1B[0m'
      : '\x1B[31;1m${ficMs.round().toString().padLeft(8)}µs\x1B[0m';

  print('${label.padRight(15)}$sep$pureStr$sep$ficStr$sep');
}
