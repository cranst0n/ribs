// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

final nElements = Integer.MaxValue;

// dart compile exe -o /tmp/rill_stack_overflow packages/bench/lib/rill/basic/rill.dart
void main(List<String> args) async {
  final rill = Rill.range(0, nElements).map((x) => x * 2).filter((x) => x % 3 == 0).take(50000000);
  await rill.compile.last.unsafeRunFuture();
}
