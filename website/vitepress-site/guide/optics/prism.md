---
sidebar_position: 40
---


# Prism

A `Prism<S, A>` focuses on **one variant of a sum type**. The focus may or may
not be present depending on which variant the value holds, so reads return
`Option<A>`. Unlike an `Optional`, a `Prism` also knows how to *construct* an
`S` from an `A` — wrapping a value back into the target variant.

A `Prism` is the right optic for:

- Sealed class hierarchies where each subclass is a distinct case
- Discriminated unions or tagged values
- Extracting and constructing a specific variant without pattern-matching at
  every call site

## Defining a Prism

`Prism<S, A>` takes two functions:

- **`getOrModify`** — `S -> Either<S, A>`: `Right(a)` when the variant matches,
  `Left(s)` (the original value, unchanged) when it does not
- **`reverseGet`** — `A -> S`: wrap `a` back into the matching variant

<<< @/../snippets/lib/src/optics/prism.dart#prism-domain

<<< @/../snippets/lib/src/optics/prism.dart#prism-define

## Using a Prism

<<< @/../snippets/lib/src/optics/prism.dart#prism-use

`modify` and `replace` are **no-ops** when the variant does not match — the
original value is returned unchanged.

## Composing Prisms

`andThenP` composes two `Prism`s. The resulting `Prism` succeeds only when both
match:

<<< @/../snippets/lib/src/optics/prism.dart#prism-compose

:::tip
Dart's exhaustive `switch` already handles sum-type matching at a single call
site. `Prism` pays off when the same variant is extracted or constructed in
*multiple* places, or when you want to pass the extraction logic as a value
(e.g. to a higher-order combinator).
:::
