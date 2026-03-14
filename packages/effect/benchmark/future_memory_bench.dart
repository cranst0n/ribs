// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

// Why use Completer?
// It represents a pending async operation with an associated handle,
// in a similar way to IOFiber.
void main() {
  const n = 100000;
  final completers = <Completer<void>>[];

  // Warm up
  for (var i = 0; i < 1000; i++) {
    completers.add(Completer<void>());
  }

  completers.clear();

  final before = ProcessInfo.currentRss;

  for (var i = 0; i < n; i++) {
    completers.add(Completer<void>());
  }

  final after = ProcessInfo.currentRss;
  final bytesPerFuture = (after - before) / n;

  print(
    'RSS per Completer+Future: ${bytesPerFuture.toStringAsFixed(1)} bytes  '
    '(${completers.length} futures)',
  );
}
