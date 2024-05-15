// ignore_for_file: unused_local_variable, unreachable_from_main

import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_core/ribs_core.dart' as ribs;

void main(List<String> args) async {
  const n = 1000;

  final a = SdkList(List.generate(n, (x) => x));
  final b = RibsIList(ribs.IList.tabulate(n, (x) => x));
  final c = RibsIVector(ribs.IVector.tabulate(n, (x) => x));
  final d = FicIList(fic.IList(fic.IList.tabulate(n, (x) => x)));
  final e = DartzIList(dartz.IList.generate(n, (x) => x));
  final f =
      BuiltIList(built_list.BuiltList(Iterable<int>.generate(n, (x) => x)));
  final g = KtIList(kt.KtList.from(Iterable<int>.generate(n, (x) => x)));

  await Future.delayed(1.day, () => 0);
}

final class SdkList {
  final List<int> l;

  const SdkList(this.l);
}

final class RibsIList {
  final ribs.IList<int> l;

  const RibsIList(this.l);
}

final class RibsIVector {
  final ribs.IVector<int> l;

  const RibsIVector(this.l);
}

final class FicIList {
  final fic.IList<int> l;

  const FicIList(this.l);
}

final class DartzIList {
  final dartz.IList<int> l;

  const DartzIList(this.l);
}

final class BuiltIList {
  final built_list.BuiltList<int> l;

  const BuiltIList(this.l);
}

final class KtIList {
  final kt.KtList<int> l;

  const KtIList(this.l);
}
