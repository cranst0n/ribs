---
sidebar_position: 30
---


# Iso

An `Iso<S, A>` is a **lossless, bidirectional conversion** between two types.
Both directions are total functions that are mutual inverses: converting `S` to
`A` and back always yields the original value, and vice versa.

An `Iso` is the right optic when two types represent exactly the same
information — a value-class wrapper around a primitive, a record paired with a
named type, or a newtype alias.

## Defining an Iso

`Iso<S, A>` takes a forward function (`S -> A`) and a reverse function
(`A -> S`):

<<< @/../snippets/lib/src/optics/iso.dart#iso-define

## Using an Iso

Because an `Iso` is also a `Lens`, it exposes the same `get`, `replace`, and
`modify` operations:

<<< @/../snippets/lib/src/optics/iso.dart#iso-use

`reverseGet` constructs an `S` from an `A` — the direction a `Lens` cannot
provide.

## Reversing an Iso

`reverse()` flips the two types, returning a new `Iso<A, S>`:

<<< @/../snippets/lib/src/optics/iso.dart#iso-reverse

## Composing Isos

`andThen` composes two `Iso`s into a single `Iso`:

<<< @/../snippets/lib/src/optics/iso.dart#iso-compose

## Using an Iso as a Lens

Because `Iso` is a subtype of `Lens`, it can be passed anywhere a `Lens` is
expected and composed with `andThenL` in a mixed optic chain:

<<< @/../snippets/lib/src/optics/iso.dart#iso-as-lens

:::tip
Reach for `Iso` when you have a wrapper type (a newtype, a value class) that
only exists for type safety and carries no additional structure. The `Iso` makes
the wrapped/unwrapped representations interchangeable without any runtime cost.
:::
