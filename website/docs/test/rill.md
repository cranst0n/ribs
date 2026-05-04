---
sidebar_position: 3
---

# Rill Matchers

`ribs_test` provides async matchers that run a `Rill` to completion and assert
on what it emits and how it finishes — whether that's success, an error, or
cancelation.

```dart
import 'package:ribs_test/ribs_rill_test.dart';
```

All matchers extend `AsyncMatcher` and work directly with `expect` /
`expectLater`. Pass a `Rill<A>` as the actual value; the matcher drives it to
completion internally.

---

## Success matchers

### `producesInOrder(expected)`

Asserts the `Rill` succeeds and emits elements in exactly the given order.
`expected` may be a Dart `Iterable` or any `RIterableOnce`.

<<< @/../snippets/test/test/rill_test.dart#testing-rill-in-order

The test fails if the `Rill` emits a different sequence, errors, or is
canceled.

### `producesOnly(value)`

Shorthand for `producesInOrder([value])`. Asserts the `Rill` emits exactly one
element equal to `value`.

<<< @/../snippets/test/test/rill_test.dart#testing-rill-only

### `producesUnordered(expected)`

Asserts the `Rill` succeeds and emits the same *multiset* of elements as
`expected`, regardless of order. Useful for parallel or non-deterministically
ordered streams.

<<< @/../snippets/test/test/rill_test.dart#testing-rill-unordered

### `producesNothing()`

Asserts the `Rill` succeeds without emitting any elements.

<<< @/../snippets/test/test/rill_test.dart#testing-rill-nothing

---

## Error matcher

### `producesError([matcher])`

Asserts the `Rill` fails with an error. Pass a nested `matcher` to validate the
specific error value.

<<< @/../snippets/test/test/rill_test.dart#testing-rill-error

---

## Comparison matcher

### `producesSameAs(expected)`

Runs both rills to completion and asserts they have the same outcome **and** the
same emitted elements. Covers all three outcome types: success (same elements),
error (same error), and cancelation.

This is most useful when testing transformations that should preserve a rill's
contents exactly — for example, custom pipes or codec round-trips:

<<< @/../snippets/test/test/rill_test.dart#testing-rill-same-as

---

## Summary

| Matcher | Asserts |
|---|---|
| `producesInOrder(xs)` | Succeeds, emits `xs` in order |
| `producesOnly(x)` | Succeeds, emits exactly one element `x` |
| `producesUnordered(xs)` | Succeeds, emits the same elements as `xs` in any order |
| `producesNothing()` | Succeeds, emits no elements |
| `producesError([m])` | Fails with an error matching `m` |
| `producesSameAs(rill)` | Same outcome and same elements as `rill` |
