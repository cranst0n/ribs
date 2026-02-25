import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_core/ribs_core.dart' as ribs;

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

// Set generators
Set<int> genDartSet(int n) => List.generate(n, tabulateFn).toSet();

Set<int> genDartSet2(int n) => List.generate(n, (x) => -tabulateFn(x)).toSet();

dartz.ISet<int> genDartzSet(int n) =>
    dartz.ISet.fromIterable(dartz.ComparableOrder<int>(), genDartSet(n));

dartz.ISet<int> genDartzSet2(int n) =>
    dartz.ISet.fromIterable(dartz.ComparableOrder<int>(), genDartSet2(n));

fic.ISet<int> genFicISet(int n) => fic.ISet(fic.IList.tabulate(n, tabulateFn));

fic.ISet<int> genFicISet2(int n) => fic.ISet(fic.IList.tabulate(n, (x) => -tabulateFn(x)));

ribs.MSet<int> genRibsMSet(int n) => ribs.MSet.from(ribs.IList.tabulate(n, tabulateFn));

ribs.MSet<int> genRibsMSet2(int n) => ribs.MSet.from(ribs.IList.tabulate(n, (x) => -tabulateFn(x)));

ribs.ISet<int> genRibsISet(int n) => ribs.IList.tabulate(n, tabulateFn).toISet();

ribs.ISet<int> genRibsISet2(int n) => ribs.IList.tabulate(n, (x) => -tabulateFn(x)).toISet();

// Map generators
(int, String) tabulateMapFn(int x) => (x, x.toString());

Map<int, String> genDartMap(int n) =>
    Map.fromEntries(List.generate(n, tabulateMapFn).map((e) => MapEntry(e.$1, e.$2)));

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
