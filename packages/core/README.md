# ribs_core

Functional programming (FP) kernel for Dart. Provides common FP datatypes like `Option`, `Either`, `State`,  and `Validated`, as well as a comprehensive immutable collection hierarchy inspired by the Scala programming language.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Core Data Types

### Option
`Option` represents optional values. Instances of `Option` are either a `Some` or `None`. It brings a wide variety of combinators not available on standard nullable types.

```dart
import 'package:ribs_core/ribs_core.dart';

final Option<int> someValue = Some(42);
final Option<int> noValue = none();

// Map and flatMap allow safe transformations
final result = someValue
  .map((v) => v * 2)
  .filter((v) => v > 50)
  .getOrElse(() => 0); // 84
```

### Either
`Either` represents one of two possible values (a disjoint union). It is right-biased, meaning methods like `map` and `flatMap` operate on the `Right` value. It is usually used for safe error handling.

```dart
Either<String, int> parse(String str) {
  try {
    return Right(int.parse(str));
  } catch (_) {
    return Left('Not a number');
  }
}

final valid = parse("42").map((n) => n + 1); // Right(43)
final invalid = parse("foo").map((n) => n + 1); // Left('Not a number')
```

### Validated
Unlike `Either`, `Validated` does not form a Monad (has no `flatMap`), but it supports error accumulation, usually in the form of `ValidatedNel` (a Validated instance where errors are collected in a `NonEmptyIList`).

```dart
ValidatedNel<String, User> validateUser(String name, int age) {
  final vName = name.isEmpty ? "Name cannot be empty".invalidNel<String>() : name.validNel<String>();
  final vAge = age < 18 ? "Must be 18 or older".invalidNel<int>() : age.validNel<String>();

  return vName.product(vAge).map((t) => User(t.$1, t.$2));
}
```

### State
`State` models state transitions of type `S`, yielding a value of type `A`. It allows for pure functional representations of state mutation.

```dart
final nextInt = State<int, int>((seed) {
  final next = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
  return (next, next);
});

final (finalState, value) = nextInt.run(42);
```

## Tuple Extensions

`ribs_core` provides extensive syntax extensions for tuples up to 22 elements, adding utility methods like `appended`, `prepended`, `map`, `head`, `tail`, `last`, and more.

```dart
final t2 = (1, "A");
final t3 = t2.appended(true); // (1, "A", true)
final first = t3.head; // 1
final last = t3.last; // true
```

## Collections Library

`ribs_core` offers an immutable collections hierarchy inspired by Scala. These provide safer, more flexible alternatives to built-in collections.

- **`IList`**: Immutable linked list, perfect for fast prepends and recursive algorithms.
- **`IVector`**: Immutable vector, providing fast random access and updates.
- **`IMap`**: Immutable key-value map.
- **`IChain`**: Constant time append/prepend connection.
- **`NonEmptyIList`**: An `IList` guaranteed to contain at least one element.
- **`ILazyList`**: A lazy, potentially infinite linked list.
- **`IMultiDict`**: Immutable map that associates keys with multiple values.
- ** **Many More!**

Mutable variants also exist (`ListBuffer`, `Array`, `HashMap`, etc.) for use when performance dictates mutability under the hood.

### Small Snippets

```dart
// IList: standard linked list
final list = ilist([1, 2, 3]);
final more = list.prepended(0).appended(4); // IList(0, 1, 2, 3, 4)

// IVector: ideal for random lookups
final vec = ivec(["a", "b", "c"]);
final updatedVec = vec.updated(1, "z"); // IVector("a", "z", "c")

// IMap: immutable mapping
final map = imap({"test": 1});
final newMap = map.updated("other", 2); // IMap({"test": 1, "other": 2})

// Collection traversals
final evens = list.filter((x) => x % 2 == 0);
```

### Rich Collections API

The collections API includes hundreds of methods for transforming, filtering, and aggregating data, many of which are not available in the standard Dart SDK:

- **`foldLeft` / `foldRight`**: Explicitly ordered reductions.
- **`zip` / `zipWithIndex`**: Combine collections or pair elements with their indices.
- **`partition`**: Split a collection into two based on a predicate.
- **`collect`**: Filter and transform elements in a single pass.
- **`groupBy`**: Organize elements into a map based on a key selector.
- **`sliding` / `grouped`**: Windowed or chunked iteration.
- **`distinctBy`**: Filter for unique elements based on a specific property.
- **Many More!**

```dart
final items = ilist([1, 2, 3, 4, 5]);

// Partition into evens and odds
final (evens, odds) = items.partition((x) => x % 2 == 0);

// Sliding window of size 2
final windows = items.sliding(2); // [[1, 2], [2, 3], [3, 4], [4, 5]]
```

## In-Depth Examples
For a more comprehensive look at `ribs_core` features working together to solve problems robustly, check out the example located at `example/example.dart` in the package source.