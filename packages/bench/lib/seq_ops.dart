// ignore_for_file: avoid_print

import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:chalkdart/chalk.dart';
import 'package:cli_table/cli_table.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_core/ribs_collection.dart' as ribs_col;
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) {
  int tabulateFn(int x) => x;

  List<int> genSdkList(int n) => List.generate(n, tabulateFn);

  ribs_col.IList<int> genRibsIList(int n) =>
      ribs_col.IList.tabulate(n, tabulateFn);

  ribs_col.IVector<int> genRibsIVector(int n) =>
      ribs_col.IVector.tabulate(n, tabulateFn);

  fic.IList<int> genFicList(int n) =>
      fic.IList(fic.IList.tabulate(n, tabulateFn));

  dartz.IList<int> genDartzList(int n) => dartz.IList.generate(n, tabulateFn);

  built_list.BuiltList<int> genBuiltList(int n) =>
      built_list.BuiltList(Iterable<int>.generate(n, tabulateFn));

  kt.KtList<int> genKtList(int n) =>
      kt.KtList.from(Iterable<int>.generate(n, tabulateFn));

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
      ComparativeBenchmark('SDK List', 'apply', () => genSdkList(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('Ribs IList', 'apply', () => genRibsIList(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('Ribs IVector', 'apply', () => genRibsIVector(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('FIC IList', 'apply', () => genFicList(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('BuiltList', 'apply', () => genBuiltList(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),
      ComparativeBenchmark('KtList', 'apply', () => genKtList(n),
          (l) => tap(l, (l) => l[n ~/ 2]), emitter),

      // append
      ComparativeBenchmark(
          'SDK List', 'append', () => genSdkList(n), (l) => l..add(0), emitter),
      ComparativeBenchmark('Ribs IList', 'append', () => genRibsIList(n),
          (l) => l.appended(0), emitter),
      ComparativeBenchmark('Ribs IVector', 'append', () => genRibsIVector(n),
          (l) => l.appended(0), emitter),
      ComparativeBenchmark(
          'FIC IList', 'append', () => genFicList(n), (l) => l.add(0), emitter),
      ComparativeBenchmark('Dartz IList', 'append', () => genDartzList(n),
          (l) => l.appendElement(0), emitter),
      ComparativeBenchmark('BuiltList', 'append', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.add(0)), emitter),
      ComparativeBenchmark('KtList', 'append', () => genKtList(n),
          (l) => l.plusElement(0), emitter),

      // prepend
      ComparativeBenchmark('SDK List', 'prepend', () => genSdkList(n),
          (l) => l..add(0), emitter),
      ComparativeBenchmark('Ribs IList', 'prepend', () => genRibsIList(n),
          (l) => l.prepended(0), emitter),
      ComparativeBenchmark('Ribs IVector', 'prepend', () => genRibsIVector(n),
          (l) => l.prepended(0), emitter),
      ComparativeBenchmark('FIC IList', 'prepend', () => genFicList(n),
          (l) => l.insert(0, 0), emitter),
      ComparativeBenchmark('Dartz IList', 'prepend', () => genDartzList(n),
          (l) => l.prependElement(0), emitter),
      ComparativeBenchmark('BuiltList', 'prepend', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.insert(0, 0)), emitter),

      // updated
      ComparativeBenchmark('SDK List', 'update', () => genSdkList(n),
          (l) => tap(l, (l) => l[n ~/ 2] = 1), emitter),
      ComparativeBenchmark('Ribs IList', 'update', () => genRibsIList(n),
          (l) => l.updated(n ~/ 2, 1), emitter),
      ComparativeBenchmark('Ribs IVector', 'update', () => genRibsIVector(n),
          (l) => l.updated(n ~/ 2, 1), emitter),
      ComparativeBenchmark('FIC IList', 'update', () => genFicList(n),
          (l) => l.replace(n ~/ 2, 1), emitter),
      ComparativeBenchmark('BuiltList', 'update', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0[n ~/ 2] = 1), emitter),

      // map
      ComparativeBenchmark('SDK List', 'map', () => genSdkList(n),
          (l) => l.map((e) => e + 1).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'map', () => genRibsIList(n),
          (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark('Ribs IVector', 'map', () => genRibsIVector(n),
          (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark('FIC IList', 'map', () => genFicList(n),
          (l) => fic.IList(l.map((x) => x + 1)), emitter),
      ComparativeBenchmark('Dartz IList', 'map', () => genDartzList(n),
          (l) => l.map((x) => x + 1), emitter),
      ComparativeBenchmark('BuiltList', 'map', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.map((x) => x + 1)), emitter),
      ComparativeBenchmark('KtList', 'map', () => genKtList(n),
          (l) => l.map((x) => x + 1), emitter),

      // filter
      ComparativeBenchmark('SDK List', 'filter', () => genSdkList(n),
          (l) => l.where((e) => e.isOdd).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'filter', () => genRibsIList(n),
          (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('Ribs IVector', 'filter', () => genRibsIVector(n),
          (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('FIC IList', 'filter', () => genFicList(n),
          (l) => fic.IList(l.where((x) => x.isOdd)), emitter),
      ComparativeBenchmark('Dartz IList', 'filter', () => genDartzList(n),
          (l) => l.filter((x) => x.isOdd), emitter),
      ComparativeBenchmark('BuiltList', 'filter', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.where((x) => x.isOdd)), emitter),
      ComparativeBenchmark('KtList', 'filter', () => genKtList(n),
          (l) => l.filter((x) => x.isOdd), emitter),

      // init
      ComparativeBenchmark('SDK List', 'tail', () => genSdkList(n),
          (l) => l.getRange(0, n - 1).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'init', () => genRibsIList(n),
          (l) => l.init(), emitter),
      ComparativeBenchmark('Ribs IVector', 'init', () => genRibsIVector(n),
          (l) => l.init(), emitter),
      ComparativeBenchmark('FIC IList', 'init', () => genFicList(n),
          (l) => fic.IList(l.init), emitter),
      ComparativeBenchmark('BuiltList', 'init', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.take(n - 1)), emitter),
      ComparativeBenchmark(
          'KtList', 'init', () => genKtList(n), (l) => l.dropLast(1), emitter),

      // tail
      ComparativeBenchmark('SDK List', 'tail', () => genSdkList(n),
          (l) => l.skip(1).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'tail', () => genRibsIList(n),
          (l) => l.tail(), emitter),
      ComparativeBenchmark('Ribs IVector', 'tail', () => genRibsIVector(n),
          (l) => l.tail(), emitter),
      ComparativeBenchmark('FIC IList', 'tail', () => genFicList(n),
          (l) => fic.IList(l.tail), emitter),
      ComparativeBenchmark('Dartz IList', 'tail', () => genDartzList(n),
          (l) => l.tailOption.getOrElse(() => throw ''), emitter),
      ComparativeBenchmark('BuiltList', 'tail', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.skip(1)), emitter),
      ComparativeBenchmark(
          'KtList', 'tail', () => genKtList(n), (l) => l.drop(1), emitter),

      // drop
      ComparativeBenchmark('SDK List', 'drop', () => genSdkList(n),
          (l) => l.skip(n ~/ 2).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'drop', () => genRibsIList(n),
          (l) => l.drop(n ~/ 2), emitter),
      ComparativeBenchmark('Ribs IVector', 'drop', () => genRibsIVector(n),
          (l) => l.drop(n ~/ 2), emitter),
      ComparativeBenchmark('FIC IList', 'drop', () => genFicList(n),
          (l) => fic.IList(l.skip(n ~/ 2)), emitter),
      ComparativeBenchmark('BuiltList', 'drop', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.skip(n ~/ 2)), emitter),
      ComparativeBenchmark(
          'KtList', 'drop', () => genKtList(n), (l) => l.drop(n ~/ 2), emitter),

      // take
      ComparativeBenchmark('SDK List', 'take', () => genSdkList(n),
          (l) => l.take(n ~/ 2).toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'take', () => genRibsIList(n),
          (l) => l.take(n ~/ 2), emitter),
      ComparativeBenchmark('Ribs IVector', 'take', () => genRibsIVector(n),
          (l) => l.take(n ~/ 2), emitter),
      ComparativeBenchmark('FIC IList', 'take', () => genFicList(n),
          (l) => fic.IList(l.take(n ~/ 2)), emitter),
      ComparativeBenchmark('BuiltList', 'take', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.take(n ~/ 2)), emitter),
      ComparativeBenchmark(
          'KtList', 'take', () => genKtList(n), (l) => l.take(n ~/ 2), emitter),

      // fold
      ComparativeBenchmark('SDK List', 'fold', () => genSdkList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Ribs IList', 'fold', () => genRibsIList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Ribs IVector', 'fold', () => genRibsIVector(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('FIC IList', 'fold', () => genFicList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('Dartz IList', 'fold', () => genDartzList(n),
          (l) => tap(l, (l) => l.foldLeft(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('BuiltList', 'fold', () => genBuiltList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),
      ComparativeBenchmark('KtList', 'fold', () => genKtList(n),
          (l) => tap(l, (l) => l.fold(0, (a, b) => a + b)), emitter),

      // reverse
      ComparativeBenchmark('SDK List', 'reverse', () => genSdkList(n),
          (l) => l.reversed.toList(), emitter),
      ComparativeBenchmark('Ribs IList', 'reverse', () => genRibsIList(n),
          (l) => l.reverse(), emitter),
      ComparativeBenchmark('Ribs IVector', 'reverse', () => genRibsIVector(n),
          (l) => l.reverse(), emitter),
      ComparativeBenchmark('FIC IList', 'reverse', () => genFicList(n),
          (l) => l.reversed, emitter),
      ComparativeBenchmark('Dartz IList', 'reverse', () => genDartzList(n),
          (l) => l.reverse(), emitter),
      ComparativeBenchmark('BuiltList', 'reverse', () => genBuiltList(n),
          (l) => l.rebuild((p0) => p0.reverse()), emitter),
      ComparativeBenchmark('KtList', 'reverse', () => genKtList(n),
          (l) => l.reversed(), emitter),

      // contains
      ComparativeBenchmark('SDK List', 'contains', () => genSdkList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs IList', 'contains', () => genRibsIList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Ribs IVector', 'contains', () => genRibsIVector(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('FIC IList', 'contains', () => genFicList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('Dartz IList', 'contains', () => genDartzList(n),
          (l) => tap(l, (l) => l.find((x) => x == n ~/ 2)), emitter),
      ComparativeBenchmark('BuiltList', 'contains', () => genBuiltList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
      ComparativeBenchmark('KtList', 'contains', () => genKtList(n),
          (l) => tap(l, (l) => l.contains(n ~/ 2)), emitter),
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

class ComparativeBenchmark<C> extends BenchmarkBase {
  final ribs.Function0<C> gen;
  final ribs.Function1<C, C> op;

  late C c;

  static const _Sep = '<@!@!@>';

  ComparativeBenchmark(
    String library,
    String operation,
    this.gen,
    this.op,
    ComparativeEmitter emitter,
  ) : super('$library$_Sep$operation', emitter: emitter);

  @override
  void setup() {
    c = gen();
  }

  @override
  void run() {
    op(c);
  }
}

class ComparativeEmitter implements ScoreEmitter {
  final String title;
  final Map<(String, String), double> values = {};

  ComparativeEmitter(this.title);

  @override
  void emit(String testName, double value) {
    final [lib, op] = testName.split(ComparativeBenchmark._Sep);

    values[(lib, op)] = value;
  }

  String renderCliTable() {
    final libs = libraries();
    final ops = operations();

    final table = Table(
      style: TableStyle.noColor(),
      header: [
        {
          'content': title,
          'colSpan': ops.size + 1,
          'hAlign': HorizontalAlign.center,
        }
      ],
      columnAlignment: [
        HorizontalAlign.left,
        ...List.filled(ops.length, HorizontalAlign.right),
      ],
    );

    table.add({'': ops.toList()});

    libs.forEach((lib) {
      final opValues = ops.map((op) {
        final bestValue =
            ribs.imap(values).filter((k, v) => k.$2 == op).values.minOption();

        return ribs.Option(values[(lib, op)]).fold(
          () => chalk.dim.grey('n/a'),
          (value) => bestValue.fold(
            () => _formatValue(value),
            (best) => value == best
                ? chalk.green(_formatValue(value))
                : _formatValue(value),
          ),
        );
      }).toList();

      table.add([lib, ...opValues]);
    });

    return table.toString();
  }

  String renderMarkdownTable() {
    final libs = libraries();
    final ops = operations();

    final buf = StringBuffer();

    buf.writeln(
      ops.prepend(title).mkString(start: '| ', sep: ' | ', end: ' |'),
    );

    buf.writeln(
      ribs.IList.tabulate(ops.size + 1, (ix) => ix == 0 ? ':---' : '---:')
          .mkString(start: '| ', sep: ' | ', end: ' |'),
    );

    libs.forEach((lib) {
      final cells = ops.map((op) {
        final bestValue =
            ribs.imap(values).filter((k, v) => k.$2 == op).values.minOption();

        return ribs.Option(values[(lib, op)]).fold(
          () => ' ',
          (value) => bestValue.fold(
            () => _formatValue(value),
            (best) => value == best
                ? '**${_formatValue(value)}**'
                : _formatValue(value),
          ),
        );
      }).prepend(lib);

      buf.writeln(
        cells.mkString(start: '| ', sep: ' | ', end: ' |'),
      );
    });

    return buf.toString();
  }

  String _formatValue(double val) => val.toStringAsFixed(2);

  ribs.IList<String> libraries() =>
      ribs.IList.of(values.mapTo((key, _) => key.$1)).distinct().sorted();

  ribs.IList<String> operations() =>
      ribs.IList.of(values.mapTo((key, _) => key.$2)).distinct().sorted();
}
