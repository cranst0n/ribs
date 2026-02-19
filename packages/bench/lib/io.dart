// ignore_for_file: avoid_print

import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'package:dartz/dartz.dart' as dartz;
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// If you're reading this, beware because these comparisons may not be fair.
// I made an effort to get as close to similar functionality as possible.
// Some libraries don't have precise equivalents like ribs `IO` vs. fpdart `Task`.
//
// Also, these operations are rarely representative of what you'd build in
// the wild.
//
// Take anything derived from this file with a big grain of salt.

// A higher end will result in deeper maps/flatmaps which seems to benefit
// ribs. Likely due to the run loop behavior.
const n = 1000;

// map

class DartzMapBenchmark extends AsyncBenchmarkBase {
  late dartz.Task<int> task;

  DartzMapBenchmark() : super('') {
    task = dartz.Task.value(0);
    for (int i = 0; i < n; i++) {
      task = task.map((a) => a + 1);
    }
  }

  @override
  Future<void> run() => task.run();
}

class FpdartMapBenchmark extends AsyncBenchmarkBase {
  late fpdart.Task<int> task;

  FpdartMapBenchmark() : super('') {
    task = fpdart.Task.of(0);
    for (int i = 0; i < n; i++) {
      task = task.map((a) => a + 1);
    }
  }

  @override
  Future<void> run() => task.run();
}

class FutureMapBenchmark extends AsyncBenchmarkBase {
  FutureMapBenchmark() : super('');

  @override
  Future<void> run() {
    Future<int> fut = Future.value(0);
    for (int i = 0; i < n; i++) {
      fut = fut.then((a) => a + 1);
    }

    return fut;
  }
}

class RibsMapBenchmark extends AsyncBenchmarkBase {
  late IO<int> io;

  RibsMapBenchmark() : super('') {
    io = IO.pure(0);
    for (int i = 0; i < n; i++) {
      io = io.map((a) => a + 1);
    }
  }

  @override
  Future<void> run() => io.unsafeRunFuture();
}

// flatMap

class DartzFlatmapBenchmark extends AsyncBenchmarkBase {
  final task = dartz.Task.value(0).replicate_(n);

  DartzFlatmapBenchmark() : super('');

  @override
  Future<void> run() => task.run();
}

class FpdartFlatmapBenchmark extends AsyncBenchmarkBase {
  final task = fpdart.Task.of(0).replicate_(n);

  FpdartFlatmapBenchmark() : super('');

  @override
  Future<void> run() => task.run();
}

class FutureFlatmapBenchmark extends AsyncBenchmarkBase {
  FutureFlatmapBenchmark() : super('');

  @override
  Future<void> run() => Future.value(0).replicate_(n);
}

class RibsFlatmapBenchmark extends AsyncBenchmarkBase {
  final io = IO.pure(0).replicate_(n);

  RibsFlatmapBenchmark() : super('');

  @override
  Future<void> run() => io.unsafeRunFuture();
}

// attempt happy

class DartzAttemptHappyBenchmark extends AsyncBenchmarkBase {
  final task = dartz.Task(() async => 0).attempt().replicate_(n);

  DartzAttemptHappyBenchmark() : super('');

  @override
  Future<void> run() => task.run();
}

class FpdartAttemptHappyBenchmark extends AsyncBenchmarkBase {
  final task = fpdart.TaskEither(() async => const fpdart.Right<String, int>(0)).replicate_(n);

  FpdartAttemptHappyBenchmark() : super('');

  @override
  Future<void> run() => task.run();
}

class FutureAttemptHappyBenchmark extends AsyncBenchmarkBase {
  FutureAttemptHappyBenchmark() : super('');

  @override
  Future<void> run() =>
      Future(() => 0).catchError((error, stackTrace) => Future.value(0)).replicate_(n);
}

class RibsAttemptHappyBenchmark extends AsyncBenchmarkBase {
  final io = IO.pure(0).attempt().replicate_(n);

  RibsAttemptHappyBenchmark() : super('');

  @override
  Future<void> run() => io.unsafeRunFuture();
}

// attempt sad

class DartzAttemptSadBenchmark extends AsyncBenchmarkBase {
  late dartz.Task<dartz.Either<Object, int>> task;

  DartzAttemptSadBenchmark() : super('') {
    dartz.Task<int> x = dartz.Task.value(0);
    for (int i = 0; i < n; i++) {
      x = x.flatMap(
        (a) =>
            (i == n ~/ 2)
                ? dartz.Task.delay(() => throw Exception('boom'))
                : dartz.Task.value(a + 1),
      );
    }

    task = x.attempt();
  }

  @override
  Future<void> run() => task.run();
}

class FpdartAttemptSadBenchmark extends AsyncBenchmarkBase {
  late fpdart.TaskEither<Object, int> task;

  FpdartAttemptSadBenchmark() : super('') {
    fpdart.TaskEither<Object, int> x = fpdart.TaskEither.of(0);
    for (int i = 0; i < n; i++) {
      x = x.flatMap(
        (a) => (i == n ~/ 2) ? fpdart.TaskEither.left('boom') : fpdart.TaskEither.of(a + 1),
      );
    }

    task = x;
  }

  @override
  Future<void> run() => task.run();
}

class FutureAttemptSadBenchmark extends AsyncBenchmarkBase {
  FutureAttemptSadBenchmark() : super('');

  @override
  Future<void> run() {
    Future<int> x = Future.value(0);
    for (int i = 0; i < n; i++) {
      x = x.then((a) => (i == n ~/ 2) ? Future.error('boom') : Future.value(a + 1));
    }

    return x.catchError((error, stackTrace) => Future.value(0));
  }
}

class RibsAttemptSadBenchmark extends AsyncBenchmarkBase {
  late IO<Either<Object, int>> io;

  RibsAttemptSadBenchmark() : super('') {
    IO<int> x = IO.pure(0);
    for (int i = 0; i < n; i++) {
      x = x.flatMap(
        (a) => (i == n ~/ 2) ? IO.raiseError('boom') : IO.pure(a + 1),
      );
    }

    io = x.attempt();
  }

  @override
  Future<void> run() => io.unsafeRunFuture();
}

// ping pong

class DartzPingPongBenchmark extends AsyncBenchmarkBase {
  DartzPingPongBenchmark() : super('');

  @override
  Future<void> run() => _pingPong(n).run();

  dartz.Task<void> _pingPong(int n) {
    if (n <= 0) {
      return dartz.Task.unit;
    } else {
      return dartz.Task<void>(() async => await Future(() {})).andThen(_pingPong(n - 1));
    }
  }
}

class FpdartPingPongBenchmark extends AsyncBenchmarkBase {
  FpdartPingPongBenchmark() : super('');

  @override
  Future<fpdart.Unit> run() => _pingPong(n).run();

  fpdart.Task<fpdart.Unit> _pingPong(int n) {
    if (n <= 0) {
      return fpdart.Task.of(fpdart.unit);
    } else {
      return fpdart.Task(() async => await Future(() {})).andThen(() => _pingPong(n - 1));
    }
  }
}

class FuturePingPongBenchmark extends AsyncBenchmarkBase {
  FuturePingPongBenchmark() : super('');

  @override
  Future<void> run() async => await _pingPong(n);

  Future<void> _pingPong(int n) async {
    if (n <= 0) {
      return;
    } else {
      await Future(() {});
      return _pingPong(n - 1);
    }
  }
}

class RibsPingPongBenchmark extends AsyncBenchmarkBase {
  RibsPingPongBenchmark() : super('');

  @override
  Future<void> run() async => await _pingPong(n).unsafeRunFuture();

  IO<Unit> _pingPong(int n) {
    if (n <= 0) {
      return IO.unit;
    } else {
      return IO.cede.productR(() => _pingPong(n - 1));
    }
  }
}

const sep = '  |  ';

void main(List<String> args) async {
  print(
    (' ' * 20) +
        sep +
        'dartz'.padLeft(10) +
        sep +
        'fpdart'.padLeft(10) +
        sep +
        'future'.padLeft(10) +
        sep +
        'ribs'.padLeft(10) +
        sep,
  );

  print('-' * 83);

  final dartzMap = await attemptBenchmark(DartzMapBenchmark());
  final fpdartMap = await attemptBenchmark(FpdartMapBenchmark());
  final futureMap = await attemptBenchmark(FutureMapBenchmark());
  final ribsMap = await attemptBenchmark(RibsMapBenchmark());
  reportMeasurements('map', dartzMap, fpdartMap, futureMap, ribsMap);

  final dartzFlatMap = await attemptBenchmark(DartzFlatmapBenchmark());
  final fpdartFlatMap = await attemptBenchmark(FpdartFlatmapBenchmark());
  final futureFlatMap = await attemptBenchmark(FutureFlatmapBenchmark());
  final ribsFlatMap = await attemptBenchmark(RibsFlatmapBenchmark());
  reportMeasurements('flatMap', dartzFlatMap, fpdartFlatMap, futureFlatMap, ribsFlatMap);

  final dartzAttempt = await attemptBenchmark(DartzAttemptHappyBenchmark());
  final fpdartAttempt = await attemptBenchmark(FpdartAttemptHappyBenchmark());
  final futureAttempt = await attemptBenchmark(FutureAttemptHappyBenchmark());
  final ribsAttempt = await attemptBenchmark(RibsAttemptHappyBenchmark());
  reportMeasurements('attempt (happy)', dartzAttempt, fpdartAttempt, futureAttempt, ribsAttempt);

  final dartzAttemptSad = await attemptBenchmark(DartzAttemptSadBenchmark());
  final fpdartAttemptSad = await attemptBenchmark(FpdartAttemptSadBenchmark());
  final futureAttemptSad = await attemptBenchmark(FutureAttemptSadBenchmark());
  final ribsAttemptSad = await attemptBenchmark(RibsAttemptSadBenchmark());
  reportMeasurements(
    'attempt (sad)',
    dartzAttemptSad,
    fpdartAttemptSad,
    futureAttemptSad,
    ribsAttemptSad,
  );

  final dartzPingPong = await attemptBenchmark(DartzPingPongBenchmark());
  final fpdartPingPong = await attemptBenchmark(FpdartPingPongBenchmark());
  final futurePingPong = await attemptBenchmark(FuturePingPongBenchmark());
  final ribsPingPong = await attemptBenchmark(RibsPingPongBenchmark());
  reportMeasurements('ping pong', dartzPingPong, fpdartPingPong, futurePingPong, ribsPingPong);
}

Future<double> attemptBenchmark(AsyncBenchmarkBase b) {
  final c = Completer<double>();

  Zone.current.runGuarded(() async {
    try {
      final result = await b.measure();
      c.complete(result);
    } catch (_) {
      c.complete(-1);
    }
  });

  return c.future;
}

void reportMeasurements(
  String label,
  double dartz,
  double fpdart,
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
    } else if ([dartz, fpdart, future, ribs].where((t) => t > 0).all((t) => mu <= t)) {
      return green('${mu.round().toString().padLeft(8)}µs') + sep;
    } else if ([dartz, fpdart, future, ribs].where((t) => t > 0).all((t) => mu >= t)) {
      return red('${mu.round().toString().padLeft(8)}µs') + sep;
    } else {
      return '${mu.round().toString().padLeft(8)}µs$sep';
    }
  }

  print('- ${label.padRight(18)}$sep${mus(dartz)}${mus(fpdart)}${mus(future)}${mus(ribs)}');
}

extension DartzTaskOps<A> on dartz.Task<A> {
  dartz.Task<Unit> replicate_(int n) =>
      n <= 0 ? dartz.Task(() async => Unit()) : flatMap((_) => replicate_(n - 1));
}

extension FpdartTaskOps<A> on fpdart.Task<A> {
  fpdart.Task<Unit> replicate_(int n) =>
      n <= 0 ? fpdart.Task.of(Unit()) : flatMap((_) => replicate_(n - 1));
}

extension FpdartTaskEitherOps<A, B> on fpdart.TaskEither<A, B> {
  fpdart.TaskEither<A, Unit> replicate_(int n) =>
      n <= 0
          ? fpdart.TaskEither(() async => fpdart.Either.right(Unit()))
          : flatMap((_) => replicate_(n - 1));
}

extension FutureOps<A> on Future<A> {
  Future<Unit> replicate_(int n) => n <= 0 ? Future.value(Unit()) : then((_) => replicate_(n - 1));
}
