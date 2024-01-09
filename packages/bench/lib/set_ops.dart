// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:ribs_bench/comparative_benchmark.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) {
  int tabulateFn(int x) => x;

  Set<int> genDartSet(int n) => List.generate(n, tabulateFn).toSet();

  fic.ISet<int> genFicISet(int n) =>
      fic.ISet(fic.IList.tabulate(n, tabulateFn));

  ribs.ISet<int> genRibsISet(int n) =>
      ribs.IList.tabulate(n, tabulateFn).toISet();

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

      // addAll
      ComparativeBenchmark('Dart Set', 'addAll', () => genDartSet(n),
          (s) => s..addAll(s), emitter),
      ComparativeBenchmark('FIC ISet', 'addAll', () => genFicISet(n),
          (s) => s.addAll(s), emitter),
      ComparativeBenchmark('Ribs ISet', 'addAll', () => genRibsISet(n),
          (s) => s.concat(s), emitter),

      // remove
      ComparativeBenchmark('Dart Set', 'remove', () => genDartSet(n),
          (s) => s..remove(n ~/ 2), emitter),
      ComparativeBenchmark('FIC ISet', 'remove', () => genFicISet(n),
          (s) => s.remove(n ~/ 2), emitter),
      ComparativeBenchmark('Ribs ISet', 'remove', () => genRibsISet(n),
          (s) => s.excl(n ~/ 2), emitter),

      // contains
      ComparativeBenchmark('Dart Set', 'contains', () => genDartSet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('FIC ISet', 'contains', () => genFicISet(n),
          (s) => tap(s, (s) => s.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs ISet', 'contains', () => genRibsISet(n),
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