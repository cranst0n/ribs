# Benchmarks

To the greatest extent possible, performance is optimized to be competitive with the standard
library. While some ribs features can lag behind their built in counterparts, tt's not uncommon for
ribs to outperform the standard library in certain scenarios. Ultimately the best way to determine
if ribs is right for your use-case is to test and measure yourself.

### Running

There are a number of benchmarks in `packages/bench` that compare the
performance of the different libraries.

```bash
# Install benchmark_harness
dart pub global activate benchmark_harness

# Compare Future and IO
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/io.dart

# Compare Stream and Rill
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/rill.dart

# Compare Dart json parsing with ribs
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/json.dart

# Compare raw Uint8List parsing with ribs
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/binary.dart

# Compare Collections
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/map.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/seq.dart
dart run benchmark_harness:bench --flavor aot --target packages/bench/bin/collection/set.dart
```