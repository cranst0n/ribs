---
sidebar_position: 1
---

# Core Matchers

`ribs_test` provides custom matchers for the fundamental `ribs_core` types —
`Option`, `Either`, and `Validated` — so your test assertions read naturally
alongside the types they check.

```dart
import 'package:ribs_test/ribs_test_core.dart';
```

---

## Option

### `isSome([matcher])`

Matches a `Some` value. If a nested `matcher` is supplied, the contained value
must also satisfy it. Without an argument, any `Some` matches.

### `isNone()`

Matches `None`.

<<< @/../snippets/test/test/core_test.dart#testing-core-option

---

## Either

### `isLeft([matcher])`

Matches a `Left` value. If a nested `matcher` is supplied, the value inside
`Left` must also satisfy it.

### `isRight([matcher])`

Matches a `Right` value. The inner value is validated against `matcher` when
provided.

<<< @/../snippets/test/test/core_test.dart#testing-core-either

---

## Validated

`Validated` is `ribs_core`'s accumulating error type. Its matchers mirror the
`Either` pair but work with `Valid`/`Invalid` directly.

### `isValid([matcher])`

Matches a `Valid` value, optionally checking the contained value.

### `isValidNel([matcher])`

Alias for `isValid`. Use this variant when you're working with `ValidatedNel`
to make intent clear at the call site.

### `isInvalid([matcher])`

Matches an `Invalid` value. Pass a `matcher` to inspect the error.

<<< @/../snippets/test/test/core_test.dart#testing-core-validated

---

## Composing with standard matchers

All ribs matchers accept any `package:test` `Matcher` as their optional
argument, so you can combine them with the full matcher vocabulary:

<<< @/../snippets/test/test/core_test.dart#testing-core-composing
