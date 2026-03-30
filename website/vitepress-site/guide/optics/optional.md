---
sidebar_position: 50
---


# Optional

An `Optional<S, A>` focuses on a value that **may or may not be present**
inside `S`. Reads return `Option<A>`, and writes are applied only when the
value is present — when it is absent the structure is returned unchanged.

`Optional` is the most general read-write optic. Every `Lens` is an `Optional`
(a field that is always present is trivially "present"), and every `Prism` is an
`Optional` (a matching variant is present; a non-matching one is absent). It is
the right direct choice when the focus is an `Option<A>` field or any other
field whose existence depends on runtime state.

## Defining an Optional

`Optional<S, A>` takes two functions:

- **`getOrModify`** — `S -> Either<S, A>`: `Right(a)` when the value is
  present, `Left(s)` (unchanged) when it is absent
- **`set`** — `(A) => (S) => S`: replace the focused value

<<< @/../snippets/lib/src/optics/optional.dart#optional-define

## Using an Optional

<<< @/../snippets/lib/src/optics/optional.dart#optional-use

The conditional behaviour of `replace` and `modify` is what distinguishes
`Optional` from `Lens`: calling them on a structure where the focus is absent
returns the original structure untouched.

`modifyOption` makes the conditionality explicit: `Some(updatedS)` when the
value was present and the modification applied, `None` when it was absent.

## Composing Optionals

`andThenO` composes a `Lens` (or another `Optional`) with an `Optional`. The
result is an `Optional` that digs through both layers:

<<< @/../snippets/lib/src/optics/optional.dart#optional-compose

Because a `Lens` is a subtype of `Optional`, `andThenO` accepts a `Lens` on the
left-hand side. This means you can combine required and optional layers freely
in a single optic chain.

:::tip
Reach for `Optional` over `Lens` whenever the field type is `Option<A>` or the
focus depends on runtime state. Wrap the absent case in `Left(s)` in
`getOrModify` to leave the structure unchanged when the value is missing.
:::
