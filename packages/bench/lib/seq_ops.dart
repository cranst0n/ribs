// ignore_for_file: avoid_print

import 'dart:io';

import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/comparative_benchmark.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) {
  int tabulateFn(int x) => x;

  List<int> genDartList(int n) => List.generate(n, tabulateFn);

  ribs.IChain<int> genRibsIChain(int n) => ribs.IChain.from(ribs.IList.tabulate(n, tabulateFn));

  ribs.IList<int> genRibsIList(int n) => ribs.IList.tabulate(n, tabulateFn);

  ribs.IVector<int> genRibsIVector(int n) => ribs.IVector.tabulate(n, tabulateFn);

  ribs.ListBuffer<int> genRibsListBuffer(int n) =>
      ribs.ListBuffer<int>().addAll(ribs.IList.tabulate(n, tabulateFn));

  fic.IList<int> genFicList(int n) => fic.IList(fic.IList.tabulate(n, tabulateFn));

  dartz.IList<int> genDartzList(int n) => dartz.IList.generate(n, tabulateFn);

  built_list.BuiltList<int> genBuiltList(int n) =>
      built_list.BuiltList(Iterable<int>.generate(n, tabulateFn));

  kt.KtList<int> genKtList(int n) => kt.KtList.from(Iterable<int>.generate(n, tabulateFn));

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
      // apply
      ComparativeBenchmark(
          'Dart List', 'apply', () => genDartList(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark(
          'Built List', 'apply', () => genBuiltList(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark(
          'FIC IList', 'apply', () => genFicList(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark(
          'Kt List', 'apply', () => genKtList(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'apply', () => genRibsIChain(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'apply', () => genRibsIList(n), (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('Ribs IVector', 'apply', () => genRibsIVector(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('Ribs ListBuffer', 'apply', () => genRibsListBuffer(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),

      // head
      ComparativeBenchmark(
          'Dart List', 'head', () => genDartList(n), (l) => tap(l, (l) => l.first), emitter),
      ComparativeBenchmark(
          'Built List', 'head', () => genBuiltList(n), (l) => tap(l, (l) => l.first), emitter),
      ComparativeBenchmark(
          'FIC IList', 'head', () => genFicList(n), (l) => tap(l, (l) => l.first), emitter),
      ComparativeBenchmark(
          'Kt List', 'head', () => genKtList(n), (l) => tap(l, (l) => l[0]), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'head', () => genRibsIChain(n), (l) => tap(l, (l) => l.head), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'head', () => genRibsIList(n), (l) => tap(l, (l) => l.head), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'head', () => genRibsIVector(n), (l) => tap(l, (l) => l.head), emitter),
      ComparativeBenchmark('Ribs ListBuffer', 'head', () => genRibsListBuffer(n),
          (l) => tap(l, (l) => l.head), emitter),

      // append
      ComparativeBenchmark('Dart List', 'append', () => genDartList(n), (l) => l..add(0), emitter),
      ComparativeBenchmark('Built List', 'append', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.add(0)), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'append', () => genDartzList(n), (l) => l.appendElement(0), emitter),
      ComparativeBenchmark('FIC IList', 'append', () => genFicList(n), (l) => l.add(0), emitter),
      ComparativeBenchmark(
          'Kt List', 'append', () => genKtList(n), (l) => l.plusElement(0), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'append', () => genRibsIChain(n), (l) => l.appended(0), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'append', () => genRibsIList(n), (l) => l.appended(0), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'append', () => genRibsIVector(n), (l) => l.appended(0), emitter),
      ComparativeBenchmark(
          'Ribs ListBuffer', 'append', () => genRibsListBuffer(n), (l) => l.append(0), emitter),

      // prepend
      ComparativeBenchmark('Dart List', 'prepend', () => genDartList(n), (l) => l..add(0), emitter),
      ComparativeBenchmark('Built List', 'prepend', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.insert(0, 0)), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'prepend', () => genDartzList(n), (l) => l.prependElement(0), emitter),
      ComparativeBenchmark(
          'FIC IList', 'prepend', () => genFicList(n), (l) => l.insert(0, 0), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'prepend', () => genRibsIChain(n), (l) => l.prepended(0), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'prepend', () => genRibsIList(n), (l) => l.prepended(0), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'prepend', () => genRibsIVector(n), (l) => l.prepended(0), emitter),
      ComparativeBenchmark(
          'Ribs ListBuffer', 'prepend', () => genRibsListBuffer(n), (l) => l.prepend(0), emitter),

      // updated
      ComparativeBenchmark('Dart List', 'update', () => genDartList(n),
          (l) => tap(l, (l) => l[n ~/ 2] = 1), emitter),
      ComparativeBenchmark('Built List', 'update', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0[n ~/ 2] = 1), emitter),
      ComparativeBenchmark(
          'FIC IList', 'update', () => genFicList(n), (l) => l.replace(n ~/ 2, 1), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'update', () => genRibsIList(n), (l) => l.updated(n ~/ 2, 1), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'update', () => genRibsIVector(n), (l) => l.updated(n ~/ 2, 1), emitter),
      ComparativeBenchmark('Ribs ListBuffer', 'update', () => genRibsListBuffer(n),
          (l) => l..update(n ~/ 2, 1), emitter),

      // map
      ComparativeBenchmark(
          'Dart List', 'map', () => genDartList(n), (l) => l.map((e) => e + 1).toList(), emitter),
      ComparativeBenchmark('Built List', 'map', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.map((x) => x + 1)), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'map', () => genDartzList(n), (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark(
          'FIC IList', 'map', () => genFicList(n), (l) => fic.IList(l.map((x) => x + 1)), emitter),
      ComparativeBenchmark(
          'Kt List', 'map', () => genKtList(n), (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'map', () => genRibsIChain(n), (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'map', () => genRibsIList(n), (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'map', () => genRibsIVector(n), (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark('Ribs ListBuffer', 'map', () => genRibsListBuffer(n),
          (l) => l.mapInPlace((x) => x + 1), emitter),

      // filter
      ComparativeBenchmark('Dart List', 'filter', () => genDartList(n),
          (l) => l.where((e) => e.isOdd).toList(), emitter),
      ComparativeBenchmark('Built List', 'filter', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.where((x) => x.isOdd)), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'filter', () => genDartzList(n), (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('FIC IList', 'filter', () => genFicList(n),
          (l) => fic.IList(l.where((x) => x.isOdd)), emitter),
      ComparativeBenchmark(
          'Kt List', 'filter', () => genKtList(n), (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('Ribs IChain', 'filter', () => genRibsIChain(n),
          (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'filter', () => genRibsIList(n), (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('Ribs IVector', 'filter', () => genRibsIVector(n),
          (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('Ribs ListBuffer', 'filter', () => genRibsListBuffer(n),
          (l) => l.filterInPlace((x) => x.isOdd), emitter),

      // init
      ComparativeBenchmark(
          'Dart List', 'tail', () => genDartList(n), (l) => l.getRange(0, n - 1).toList(), emitter),
      ComparativeBenchmark('Built List', 'init', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.take(n - 1)), emitter),
      ComparativeBenchmark(
          'FIC IList', 'init', () => genFicList(n), (l) => fic.IList(l.init), emitter),
      ComparativeBenchmark('Kt List', 'init', () => genKtList(n), (l) => l.dropLast(1), emitter),
      ComparativeBenchmark('Ribs IChain', 'init', () => genRibsIChain(n), (l) => l.init(), emitter),
      ComparativeBenchmark('Ribs IList', 'init', () => genRibsIList(n), (l) => l.init(), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'init', () => genRibsIVector(n), (l) => l.init(), emitter),

      // tail
      ComparativeBenchmark(
          'Dart List', 'tail', () => genDartList(n), (l) => l.skip(1).toList(), emitter),
      ComparativeBenchmark('Built List', 'tail', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.skip(1)), emitter),
      ComparativeBenchmark('Dartz IList', 'tail', () => genDartzList(n),
          (l) => l.tailOption.getOrElse(() => throw ''), emitter),
      ComparativeBenchmark(
          'FIC IList', 'tail', () => genFicList(n), (l) => fic.IList(l.tail), emitter),
      ComparativeBenchmark('Kt List', 'tail', () => genKtList(n), (l) => l.drop(1), emitter),
      ComparativeBenchmark('Ribs IChain', 'tail', () => genRibsIChain(n), (l) => l.tail(), emitter),
      ComparativeBenchmark('Ribs IList', 'tail', () => genRibsIList(n), (l) => l.tail(), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'tail', () => genRibsIVector(n), (l) => l.tail(), emitter),

      // drop
      ComparativeBenchmark(
          'Dart List', 'drop', () => genDartList(n), (l) => l.skip(n ~/ 2).toList(), emitter),
      ComparativeBenchmark('Built List', 'drop', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.skip(n ~/ 2)), emitter),
      ComparativeBenchmark(
          'FIC IList', 'drop', () => genFicList(n), (l) => fic.IList(l.skip(n ~/ 2)), emitter),
      ComparativeBenchmark('Kt List', 'drop', () => genKtList(n), (l) => l.drop(n ~/ 2), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'drop', () => genRibsIList(n), (l) => l.drop(n ~/ 2), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'drop', () => genRibsIVector(n), (l) => l.drop(n ~/ 2), emitter),

      // take
      ComparativeBenchmark(
          'Dart List', 'take', () => genDartList(n), (l) => l.take(n ~/ 2).toList(), emitter),
      ComparativeBenchmark('Built List', 'take', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.take(n ~/ 2)), emitter),
      ComparativeBenchmark(
          'FIC IList', 'take', () => genFicList(n), (l) => fic.IList(l.take(n ~/ 2)), emitter),
      ComparativeBenchmark('Kt List', 'take', () => genKtList(n), (l) => l.take(n ~/ 2), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'take', () => genRibsIList(n), (l) => l.take(n ~/ 2), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'take', () => genRibsIVector(n), (l) => l.take(n ~/ 2), emitter),

      // fold
      ComparativeBenchmark('Dart List', 'fold', () => genDartList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Built List', 'fold', () => genBuiltList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Dartz IList', 'fold', () => genDartzList(n),
          (l) => tap(l, (l) => l.foldLeft(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('FIC IList', 'fold', () => genFicList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Kt List', 'fold', () => genKtList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Ribs IChain', 'fold', () => genRibsIChain(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Ribs IList', 'fold', () => genRibsIList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Ribs IVector', 'fold', () => genRibsIVector(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),

      // reverse
      ComparativeBenchmark(
          'Dart List', 'reverse', () => genDartList(n), (l) => l.reversed.toList(), emitter),
      ComparativeBenchmark('Built List', 'reverse', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.reverse()), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'reverse', () => genDartzList(n), (l) => l.reverse(), emitter),
      ComparativeBenchmark('FIC IList', 'reverse', () => genFicList(n), (l) => l.reversed, emitter),
      ComparativeBenchmark('Kt List', 'reverse', () => genKtList(n), (l) => l.reversed(), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'reverse', () => genRibsIChain(n), (l) => l.reverse(), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'reverse', () => genRibsIList(n), (l) => l.reverse(), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'reverse', () => genRibsIVector(n), (l) => l.reverse(), emitter),

      // contains
      ComparativeBenchmark('Dart List', 'contains', () => genDartList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Built List', 'contains', () => genBuiltList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Dartz IList', 'contains', () => genDartzList(n),
          (l) => tap(l, (l) => l.find((x) => x == n ~/ 2)), emitter),
      ComparativeBenchmark('FIC IList', 'contains', () => genFicList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Kt List', 'contains', () => genKtList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs IList', 'contains', () => genRibsIList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs IVector', 'contains', () => genRibsIVector(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),

      // concat
      ComparativeBenchmark(
          'Dart List', 'concat', () => genDartList(n), (l) => l.concat(l), emitter),
      ComparativeBenchmark('Built List', 'concat', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.addAll(l)), emitter),
      ComparativeBenchmark(
          'Dartz IList', 'concat', () => genDartzList(n), (l) => l.plus(l), emitter),
      ComparativeBenchmark('FIC IList', 'concat', () => genFicList(n), (l) => l.addAll(l), emitter),
      ComparativeBenchmark('Kt List', 'concat', () => genKtList(n), (l) => l.plus(l), emitter),
      ComparativeBenchmark(
          'Ribs IChain', 'concat', () => genRibsIChain(n), (l) => l.concat(l), emitter),
      ComparativeBenchmark(
          'Ribs IList', 'concat', () => genRibsIList(n), (l) => l.concat(l), emitter),
      ComparativeBenchmark(
          'Ribs IVector', 'concat', () => genRibsIVector(n), (l) => l.concat(l), emitter),
    ];

    benchmarks.forEach((b) => b.report());

    print(emitter.renderCliTable());

    if (args.isNotEmpty) {
      final outputDir = args[0];
      final markdownFile = File('$outputDir/seq-benchmark-$n.md');
      markdownFile.writeAsStringSync(emitter.renderMarkdownTable());
    }
  });
}
