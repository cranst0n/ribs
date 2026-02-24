# Quick usage

```
dart pub global activate benchmark_harness
dart pub global run benchmark_harness:bench

dart run benchmark_harness:bench --flavor aot --target packages/bench/lib/io.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/lib/rill.dart
```

# Example execution time / memory quick look

```
dart compile exe -o /tmp/io_merge_sort packages/bench/lib/programs/merge_sort/io.dart
dart compile exe -o /tmp/future_merge_sort packages/bench/lib/programs/merge_sort/future.dart

/usr/bin/time --format="%E real, %U user, %K amem, %M mmem" /tmp/future_merge_sort
/usr/bin/time --format="%E real, %U user, %K amem, %M mmem" /tmp/io_merge_sort
```

# Using DevTools

```
dart run --observe --pause-isolates-on-start packages/bench/lib/programs/merge_sort/io.dart
```
