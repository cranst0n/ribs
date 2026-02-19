// ignore_for_file: avoid_print

import 'package:ribs_rill/ribs_rill.dart';

const nElements = 10000000;

void main(List<String> args) async {
  final rill = Rill.range(0, nElements).map((x) => x * 2).filter((x) => x % 4 == 0);
  await rill.compile.last.unsafeRunFuture();
}
