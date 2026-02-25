# Quick usage

```
dart pub global activate benchmark_harness
dart pub global run benchmark_harness:bench

dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/io.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/rill.dart

dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/map.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/seq.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/set.dart
```

# Manual single program execution time / memory quick look

```
dart compile exe -o /tmp/bench_program packages/bench/lib/some_program.dart
/usr/bin/time --format="%E real, %U user, %K amem, %M mmem" /tmp/bench_program
```

# Using DevTools

```
dart run --observe --pause-isolates-on-start packages/bench/bin/io.dart
```
