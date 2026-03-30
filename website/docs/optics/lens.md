---
sidebar_position: 20
---


# Lens

A `Lens<S, A>` focuses on a field that is **always present** inside `S`. It is
the right optic whenever the target field is a required (non-optional) part of
the structure — which covers the vast majority of product-type fields.

A `Lens` provides two primitive operations:

- **`get(s)`** — read the focused value
- **`replace(a)(s)`** — return a new `S` with the focused value replaced
- **`modify(f)(s)`** — return a new `S` with the focused value transformed by `f`

## Defining a Lens

`Lens<S, A>` takes two functions: a getter and a setter. The setter follows the
curried form `(A) => (S) => S` so it composes cleanly without needing a
two-argument lambda:

<<< @/../snippets/lib/src/optics/lens.dart#lens-define

## Using a Lens

<<< @/../snippets/lib/src/optics/lens.dart#lens-use

`replace` and `modify` both return a `Function1<S, S>` — a function from the
old structure to the new one. This is the standard optic application style:
`lens.replace(newValue)(myStruct)`.

## Composing Lenses

Lenses compose with `andThenL`. The result is a new `Lens` that focuses through
both layers in sequence:

<<< @/../snippets/lib/src/optics/lens.dart#lens-compose

The composition is transparent — callers interact with `dbPortL` exactly like
any other `Lens<AppConfig, int>`.

## Composing with a Getter

`andThenG` pairs a `Lens` with a read-only `Getter` to project a derived value.
The result is a `Getter`, so it supports `get` but not `replace` or `modify`:

<<< @/../snippets/lib/src/optics/lens.dart#lens-andtheng

:::tip
Use `andThenG` when the target type has a meaningful derived value (a count,
a formatted string, a sub-field) that you never need to write back. It keeps
the optic read-only by type, preventing accidental mutations.
:::
