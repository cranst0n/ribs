/// Property-based testing framework for Dart.
///
/// Provides primitives for generating random test data (`Gen`), defining
/// test properties (`Prop`), and shrinking failing test cases (`Shrinker`)
/// to find the minimal reproducible failure.
library;

export 'src/gen.dart';
export 'src/generated/gen_syntax.dart';
export 'src/generated/prop_syntax.dart';
export 'src/prop.dart';
export 'src/shrinker.dart';
