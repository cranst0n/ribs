import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

class RillRangeMapFilter extends AsyncBenchmarkBase {
  RillRangeMapFilter() : super('RillRangeMapFilter (50M)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 50000000).map((x) => x * 2).filter((x) => x % 3 == 0);
    return rill.compile.last.unsafeRunFuture();
  }
}

class RillFlatMapNested extends AsyncBenchmarkBase {
  RillFlatMapNested() : super('RillFlatMapNested (1M x 50)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 1000000).flatMap((x) => Rill.range(0, 50));
    return rill.compile.drain.unsafeRunFuture();
  }
}

class RillEvalLoop extends AsyncBenchmarkBase {
  RillEvalLoop() : super('RillEvalLoop (10M)');

  @override
  Future<void> run() {
    final rill = Rill.repeatEval(IO.pure(1)).take(10000000);
    return rill.compile.drain.unsafeRunFuture();
  }
}

class RillScopeNested extends AsyncBenchmarkBase {
  RillScopeNested() : super('RillScopeNested (1M)');

  @override
  Future<void> run() {
    final rill = Rill.range(0, 1000000).flatMap((x) => Rill.emit(x).scope);
    return rill.compile.drain.unsafeRunFuture();
  }
}

Future<void> main() async {
  await RillRangeMapFilter().report();
  await RillFlatMapNested().report();
  await RillEvalLoop().report();
  await RillScopeNested().report();
}
