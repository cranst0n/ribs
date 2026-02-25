// ignore_for_file: avoid_print

import 'package:ribs_bench/collection/seq/append.dart';
import 'package:ribs_bench/collection/seq/apply.dart';
import 'package:ribs_bench/collection/seq/concat.dart';
import 'package:ribs_bench/collection/seq/contains.dart';
import 'package:ribs_bench/collection/seq/drop.dart';
import 'package:ribs_bench/collection/seq/filter.dart';
import 'package:ribs_bench/collection/seq/fold.dart';
import 'package:ribs_bench/collection/seq/head.dart';
import 'package:ribs_bench/collection/seq/init.dart';
import 'package:ribs_bench/collection/seq/map.dart';
import 'package:ribs_bench/collection/seq/prepend.dart';
import 'package:ribs_bench/collection/seq/reverse.dart';
import 'package:ribs_bench/collection/seq/tail.dart';
import 'package:ribs_bench/collection/seq/take.dart';
import 'package:ribs_bench/collection/seq/update.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  const ns = [10, 1000, 100000];

  for (final n in ns) {
    RibsBenchmark.runAndReport([
      // This often crashes the benchmark?
      // DartListAppendBenchmark(n),
      BuiltListAppendBenchmark(n),
      DartzIListAppendBenchmark(n),
      FICIListAppendBenchmark(n),
      KtListAppendBenchmark(n),
      RibsIChainAppendBenchmark(n),
      RibsIListAppendBenchmark(n),
      RibsIVectorAppendBenchmark(n),
      RibsListBufferAppendBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListPrependBenchmark(n),
      BuiltListPrependBenchmark(n),
      DartzIListPrependBenchmark(n),
      FICIListPrependBenchmark(n),
      RibsIChainPrependBenchmark(n),
      RibsIListPrependBenchmark(n),
      RibsIVectorPrependBenchmark(n),
      RibsListBufferPrependBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListApplyBenchmark(n),
      BuiltListApplyBenchmark(n),
      FICIListApplyBenchmark(n),
      KtListApplyBenchmark(n),
      RibsIChainApplyBenchmark(n),
      RibsIListApplyBenchmark(n),
      RibsIVectorApplyBenchmark(n),
      RibsListBufferApplyBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListHeadBenchmark(n),
      BuiltListHeadBenchmark(n),
      FICIListHeadBenchmark(n),
      KtListHeadBenchmark(n),
      RibsIChainHeadBenchmark(n),
      RibsIListHeadBenchmark(n),
      RibsIVectorHeadBenchmark(n),
      RibsListBufferHeadBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListUpdateBenchmark(n),
      BuiltListUpdateBenchmark(n),
      FICIListUpdateBenchmark(n),
      RibsIListUpdateBenchmark(n),
      RibsIVectorUpdateBenchmark(n),
      RibsListBufferUpdateBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListMapBenchmark(n),
      BuiltListMapBenchmark(n),
      DartzIListMapBenchmark(n),
      FICIListMapBenchmark(n),
      KtListMapBenchmark(n),
      RibsIChainMapBenchmark(n),
      RibsIListMapBenchmark(n),
      RibsIVectorMapBenchmark(n),
      RibsListBufferMapBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListFilterBenchmark(n),
      BuiltListFilterBenchmark(n),
      DartzIListFilterBenchmark(n),
      FICIListFilterBenchmark(n),
      KtListFilterBenchmark(n),
      RibsIChainFilterBenchmark(n),
      RibsIListFilterBenchmark(n),
      RibsIVectorFilterBenchmark(n),
      RibsListBufferFilterBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListInitBenchmark(n),
      BuiltListInitBenchmark(n),
      FICIListInitBenchmark(n),
      KtListInitBenchmark(n),
      RibsIChainInitBenchmark(n),
      RibsIListInitBenchmark(n),
      RibsIVectorInitBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListTailBenchmark(n),
      BuiltListTailBenchmark(n),
      DartzIListTailBenchmark(n),
      FICIListTailBenchmark(n),
      KtListTailBenchmark(n),
      RibsIChainTailBenchmark(n),
      RibsIListTailBenchmark(n),
      RibsIVectorTailBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListDropBenchmark(n),
      BuiltListDropBenchmark(n),
      FICIListDropBenchmark(n),
      KtListDropBenchmark(n),
      RibsIListDropBenchmark(n),
      RibsIVectorDropBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListTakeBenchmark(n),
      BuiltListTakeBenchmark(n),
      FICIListTakeBenchmark(n),
      KtListTakeBenchmark(n),
      RibsIListTakeBenchmark(n),
      RibsIVectorTakeBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListFoldBenchmark(n),
      BuiltListFoldBenchmark(n),
      DartzIListFoldBenchmark(n),
      FICIListFoldBenchmark(n),
      KtListFoldBenchmark(n),
      RibsIChainFoldBenchmark(n),
      RibsIListFoldBenchmark(n),
      RibsIVectorFoldBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListReverseBenchmark(n),
      BuiltListReverseBenchmark(n),
      DartzIListReverseBenchmark(n),
      FICIListReverseBenchmark(n),
      KtListReverseBenchmark(n),
      RibsIChainReverseBenchmark(n),
      RibsIListReverseBenchmark(n),
      RibsIVectorReverseBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListContainsBenchmark(n),
      BuiltListContainsBenchmark(n),
      DartzIListContainsBenchmark(n),
      FICIListContainsBenchmark(n),
      KtListContainsBenchmark(n),
      RibsIListContainsBenchmark(n),
      RibsIVectorContainsBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartListConcatBenchmark(n),
      BuiltListConcatBenchmark(n),
      DartzIListConcatBenchmark(n),
      FICIListConcatBenchmark(n),
      KtListConcatBenchmark(n),
      RibsIChainConcatBenchmark(n),
      RibsIListConcatBenchmark(n),
      RibsIVectorConcatBenchmark(n),
    ]);
  }
}
