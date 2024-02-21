// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_bench/comparative_benchmark.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) {
  int tabulateFn(int x) => x;

  Set<int> genDartSet(int n) => List.generate(n, tabulateFn).toSet();

  Set<int> genDartSet2(int n) =>
      List.generate(n, (x) => -tabulateFn(x)).toSet();

  fic.ISet<int> genFicISet(int n) =>
      fic.ISet(fic.IList.tabulate(n, tabulateFn));

  fic.ISet<int> genFicISet2(int n) =>
      fic.ISet(fic.IList.tabulate(n, (x) => -tabulateFn(x)));

  ribs.MSet<int> genRibsMSet(int n) =>
      ribs.MSet.from(ribs.IList.tabulate(n, tabulateFn));

  ribs.MSet<int> genRibsMSet2(int n) =>
      ribs.MSet.from(ribs.IList.tabulate(n, (x) => -tabulateFn(x)));

  ribs.ISet<int> genRibsISet(int n) =>
      ribs.IList.tabulate(n, tabulateFn).toISet();

  ribs.ISet<int> genRibsISet2(int n) =>
      ribs.IList.tabulate(n, (x) => -tabulateFn(x)).toISet();

  A tap<A, U>(A x, U Function(A) f) {
    f(x);
    return x;
  }

  const ns = [
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
  ];

  ns.forEach((n) {
    final emitter = ComparativeEmitter('N = $n');

    final benchmarks = [
      // add
      ComparativeBenchmark(
          'Dart Set', 'add', () => genDartSet(n), (s) => s..add(n), emitter),
      ComparativeBenchmark(
          'FIC ISet', 'add', () => genFicISet(n), (s) => s.add(n), emitter),
      ComparativeBenchmark(
          'Ribs ISet', 'add', () => genRibsISet(n), (s) => s.incl(n), emitter),
      ComparativeBenchmark(
          'Ribs MSet', 'add', () => genRibsMSet(n), (s) => s..add(n), emitter),

      // addAll (same)
      ComparativeBenchmark('Dart Set', 'addAll (same)', () => genDartSet(n),
          (s) => s..addAll(s), emitter),
      ComparativeBenchmark('FIC ISet', 'addAll (same)', () => genFicISet(n),
          (s) => s.addAll(s), emitter),
      ComparativeBenchmark('Ribs ISet', 'addAll (same)', () => genRibsISet(n),
          (s) => s.concat(s), emitter),
      ComparativeBenchmark('Ribs MSet', 'addAll (same)', () => genRibsMSet(n),
          (s) => s..concat(s), emitter),

      // addAll (different)
      ComparativeBenchmark(
          'Dart Set',
          'addAll (different)',
          () => (genDartSet(n), genDartSet2(n)),
          (s) => (s.$1..addAll(s.$2), s.$1),
          emitter),
      ComparativeBenchmark(
          'FIC ISet',
          'addAll (different)',
          () => (genFicISet(n), genFicISet2(n)),
          (s) => (s.$1.addAll(s.$2), s.$1),
          emitter),
      ComparativeBenchmark(
          'Ribs ISet',
          'addAll (different)',
          () => (genRibsISet(n), genRibsISet2(n)),
          (s) => (s.$1.concat(s.$2), s.$1),
          emitter),
      ComparativeBenchmark(
          'Ribs MSet',
          'addAll (different)',
          () => (genRibsMSet(n), genRibsMSet2(n)),
          (s) => (s.$1.concat(s.$2), s.$1),
          emitter),

      // remove
      ComparativeBenchmark('Dart Set', 'remove', () => genDartSet(n),
          (s) => s..remove(n ~/ 2), emitter),
      ComparativeBenchmark('FIC ISet', 'remove', () => genFicISet(n),
          (s) => s.remove(n ~/ 2), emitter),
      ComparativeBenchmark('Ribs ISet', 'remove', () => genRibsISet(n),
          (s) => s.excl(n ~/ 2), emitter),
      ComparativeBenchmark('Ribs MSet', 'remove', () => genRibsMSet(n),
          (s) => s..remove(n ~/ 2), emitter),

      // contains
      ComparativeBenchmark('Dart Set', 'contains', () => genDartSet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('FIC ISet', 'contains', () => genFicISet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs ISet', 'contains', () => genRibsISet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs MSet', 'contains', () => genRibsMSet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
    ];

    benchmarks.forEach((b) => b.report());

    print(emitter.renderCliTable());

    if (args.isNotEmpty) {
      final outputDir = args[0];
      final markdownFile = File('$outputDir/set-benchmark-$n.md');
      markdownFile.writeAsStringSync(emitter.renderMarkdownTable());
    }
  });
}

// ┌───────────────────────────────────────────────────────────────────────────────┐
// │                                  N = 1000000                                  │
// ├───────────┬──────┬────────────────────┬───────────────┬──────────┬────────────┤
// │           │  add │ addAll (different) │ addAll (same) │ contains │     remove │
// ├───────────┼──────┼────────────────────┼───────────────┼──────────┼────────────┤
// │ Dart Set  │ 0.16 │          792868.67 │     322313.86 │     0.25 │       0.16 │
// ├───────────┼──────┼────────────────────┼───────────────┼──────────┼────────────┤
// │ FIC ISet  │ 0.41 │         5151535.00 │    1710632.50 │     0.38 │ 1582809.00 │
// ├───────────┼──────┼────────────────────┼───────────────┼──────────┼────────────┤
// │ Ribs ISet │ 2.16 │         4162617.00 │          0.56 │     1.83 │       1.71 │
// ├───────────┼──────┼────────────────────┼───────────────┼──────────┼────────────┤
// │ Ribs MSet │ 0.16 │         1310069.00 │     945554.00 │     0.33 │       0.20 │
// └───────────┴──────┴────────────────────┴───────────────┴──────────┴────────────┘