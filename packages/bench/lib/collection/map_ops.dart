// ignore_for_file: avoid_print

import 'dart:io';

import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:kt_dart/kt.dart';
import 'package:ribs_bench/collection/comparative_benchmark.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) {
  (int, String) tabulateFn(int x) => (x, x.toString());

  Map<int, String> genDartMap(int n) =>
      Map.fromEntries(List.generate(n, tabulateFn).map((e) => MapEntry(e.$1, e.$2)));

  fic.IMap<int, String> genFicIMap(int n) => fic.IMap(genDartMap(n));

  ribs.IMap<int, String> genRibsIMap(int n) => ribs.IMap.fromDart(genDartMap(n));

  ribs.MMap<int, String> genRibsMMap(int n) => ribs.MMap.fromDart(genDartMap(n));

  dartz.IMap<int, String> genDartzIMap(int n) => dartz.IMap.fromIterables(
    List.generate(n, (x) => x),
    List.generate(n, (x) => x.toString()),
    dartz.ComparableOrder<int>(),
  );

  built_list.BuiltMap<int, String> genBuiltMap(int n) => built_list.BuiltMap.of(genDartMap(n));

  kt.KtMap<int, String> genKtMap(int n) => kt.KtMap.from(genDartMap(n));

  const ns = [
    10,
    1000,
    100000,
  ];

  ns.forEach((n) {
    final emitter = ComparativeEmitter('N = $n');

    final benchmarks = [
      // put
      ComparativeBenchmark(
        'Dart Map',
        'put',
        () => genDartMap(n),
        (m) => m..putIfAbsent(n, () => n.toString()),
        emitter,
      ),
      ComparativeBenchmark(
        'FIC IMap',
        'put',
        () => genFicIMap(n),
        (m) => m.putIfAbsent(n, () => n.toString()),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs IMap',
        'put',
        () => genRibsIMap(n),
        (m) => m.updated(n, n.toString()),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs MMap',
        'put',
        () => genRibsMMap(n),
        (m) => m..update(n, n.toString()),
        emitter,
      ),
      ComparativeBenchmark(
        'Dartz IMap',
        'put',
        () => genDartzIMap(n),
        (m) => m.put(n, n.toString()),
        emitter,
      ),
      ComparativeBenchmark(
        'Built Map',
        'put',
        () => genBuiltMap(n),
        (m) => m.rebuild((p0) => p0.putIfAbsent(n, () => n.toString())),
        emitter,
      ),
      ComparativeBenchmark(
        'Kt Map',
        'put',
        () => genKtMap(n),
        (m) => m.plus(KtHashMap.from({n: n.toString()})),
        emitter,
      ),

      // get
      ComparativeBenchmark('Dart Map', 'get', () => genDartMap(n), (m) => m..[n ~/ 2], emitter),
      ComparativeBenchmark('FIC IMap', 'get', () => genFicIMap(n), (m) => m..[n ~/ 2], emitter),
      ComparativeBenchmark('Ribs IMap', 'get', () => genRibsIMap(n), (m) => m..[n ~/ 2], emitter),
      ComparativeBenchmark('Ribs MMap', 'get', () => genRibsMMap(n), (m) => m..[n ~/ 2], emitter),
      ComparativeBenchmark(
        'Dartz IMap',
        'get',
        () => genDartzIMap(n),
        (m) => m..get(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark('Built Map', 'get', () => genBuiltMap(n), (m) => m..[n ~/ 2], emitter),
      ComparativeBenchmark('Kt Map', 'get', () => genKtMap(n), (m) => m..get(n ~/ 2), emitter),

      // remove (present)
      ComparativeBenchmark(
        'Dart Map',
        'remove (present)',
        () => genDartMap(n),
        (m) => m..remove(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark(
        'FIC IMap',
        'remove (present)',
        () => genFicIMap(n),
        (m) => m.remove(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs IMap',
        'remove (present)',
        () => genRibsIMap(n),
        (m) => m.removed(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs MMap',
        'remove (present)',
        () => genRibsMMap(n),
        (m) => m..remove(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark(
        'Dartz IMap',
        'remove (present)',
        () => genDartzIMap(n),
        (m) => m.remove(n ~/ 2),
        emitter,
      ),
      ComparativeBenchmark(
        'Built Map',
        'remove (present)',
        () => genBuiltMap(n),
        (m) => m.rebuild((p0) => p0.remove(n ~/ 2)),
        emitter,
      ),
      ComparativeBenchmark(
        'Kt Map',
        'remove (present)',
        () => genKtMap(n),
        (m) => m.minus(n ~/ 2),
        emitter,
      ),

      // remove (absent)
      ComparativeBenchmark(
        'Dart Map',
        'remove (absent)',
        () => genDartMap(n),
        (m) => m..remove(n),
        emitter,
      ),
      ComparativeBenchmark(
        'FIC IMap',
        'remove (absent)',
        () => genFicIMap(n),
        (m) => m.remove(n),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs IMap',
        'remove (absent)',
        () => genRibsIMap(n),
        (m) => m.removed(n),
        emitter,
      ),
      ComparativeBenchmark(
        'Ribs MMap',
        'remove (absent)',
        () => genRibsMMap(n),
        (m) => m..remove(n),
        emitter,
      ),
      ComparativeBenchmark(
        'Dartz IMap',
        'remove (absent)',
        () => genDartzIMap(n),
        (m) => m.remove(n),
        emitter,
      ),
      ComparativeBenchmark(
        'Built Map',
        'remove (absent)',
        () => genBuiltMap(n),
        (m) => m.rebuild((p0) => p0.remove(n)),
        emitter,
      ),
      ComparativeBenchmark(
        'Kt Map',
        'remove (absent)',
        () => genKtMap(n),
        (m) => m.minus(n),
        emitter,
      ),
    ];

    benchmarks.forEach((b) => b.report());

    print(emitter.renderCliTable());

    if (args.isNotEmpty) {
      final outputDir = args[0];
      final markdownFile = File('$outputDir/map-benchmark-$n.md');
      markdownFile.writeAsStringSync(emitter.renderMarkdownTable());
    }
  });
}
