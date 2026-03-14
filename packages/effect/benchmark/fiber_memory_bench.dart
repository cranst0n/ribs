// ignore_for_file: avoid_print

import 'dart:io';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

void main() {
  const n = 100000;
  final fibers = <IOFiber<Unit>>[];

  // Warm up
  for (var i = 0; i < 1000; i++) {
    fibers.add(IOFiber(IO.unit));
  }

  fibers.clear();

  final before = ProcessInfo.currentRss;

  for (var i = 0; i < n; i++) {
    fibers.add(IOFiber(IO.unit));
  }

  final after = ProcessInfo.currentRss;
  final bytesPerFiber = (after - before) / n;

  print(
    'RSS per fiber: ${bytesPerFiber.toStringAsFixed(1)} bytes  '
    '(${fibers.length} fibers)',
  );
}
