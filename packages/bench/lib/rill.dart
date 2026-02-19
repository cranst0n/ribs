// ignore_for_file: avoid_print

import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_rill/ribs_rill.dart';

const nElements = 100000;

class StreamBasicBenchmark extends AsyncBenchmarkBase {
  StreamBasicBenchmark() : super('');

  @override
  Future<void> run() async {
    final stream = Stream.fromIterable(
      Iterable.generate(nElements, (i) => i).map((x) => x * 2).where((x) => x % 3 == 0),
    );

    await for (final _ in stream) {}
  }
}

class RillBasicBenchmark extends AsyncBenchmarkBase {
  RillBasicBenchmark() : super('');

  @override
  Future<void> run() async {
    final rill = Rill.range(0, nElements).map((x) => x * 2).filter((x) => x % 3 == 0);

    await rill.compile.drain.unsafeRunFuture();
  }
}

Future<double> attemptBenchmark(AsyncBenchmarkBase b) {
  final c = Completer<double>();

  Zone.current.runGuarded(() async {
    try {
      final result = await b.measure();
      c.complete(result);
    } catch (err, st) {
      print('!' * 100);
      print(err);
      print('!' * 100);
      print(st);
      print('!' * 100);

      c.complete(-1);
    }
  });

  return c.future;
}

const sep = '  |  ';

void reportMeasurements(
  String label,
  double future,
  double ribs,
) {
  String mus(double mu) {
    String green(String s) => '\x1B[32;1m$s\x1B[0m';
    String red(String s) => '\x1B[31;1m$s\x1B[0m';

    if (mu == 0) {
      return 'n/a'.padLeft(10) + sep;
    } else if (mu < 0) {
      return red('failed'.padLeft(10)) + sep;
    } else if ([future, ribs].where((t) => t > 0).all((t) => mu <= t)) {
      return green('${mu.round().toString().padLeft(8)}µs') + sep;
    } else if ([future, ribs].where((t) => t > 0).all((t) => mu >= t)) {
      return red('${mu.round().toString().padLeft(8)}µs') + sep;
    } else {
      return '${mu.round().toString().padLeft(8)}µs$sep';
    }
  }

  print('- ${label.padRight(15)}$sep${mus(future)}${mus(ribs)}');
}

void main(List<String> args) async {
  print(
    (' ' * 17) + sep + 'stream'.padLeft(10) + sep + 'rill'.padLeft(10) + sep,
  );

  print('-' * 80);

  final streamBasic = await attemptBenchmark(StreamBasicBenchmark());
  final rillBasic = await attemptBenchmark(RillBasicBenchmark());
  reportMeasurements('basic', streamBasic, rillBasic);
}
