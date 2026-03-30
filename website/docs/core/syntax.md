---
sidebar_position: 9
---


# Syntax

`ribs_core` ships a set of Dart extension methods that add idiomatic
convenience to both ribs types and standard Dart types. They come by default
when you import the ribs_core library.

---

## Option

`OptionSyntaxOps` adds a `.some` getter to every type, lifting a value into
`Some` without an explicit constructor call.

<<< @/../snippets/lib/src/core/syntax.dart#option-some

---

## Either

`EitherSyntaxOps` adds `.asLeft<B>()` and `.asRight<B>()` to every type, so
you can create `Either` values inline without naming the constructor.

<<< @/../snippets/lib/src/core/syntax.dart#either-lift

---

## Duration

`DurationOps` adds named-unit getters to `int` for constructing `Duration`
values. All standard units are supported: `microseconds`, `milliseconds`,
`seconds`, `minutes`, `hours`, `days` (each also available in singular form).

<<< @/../snippets/lib/src/core/syntax.dart#duration

---

## Iterable

`IterableOps` adds conversion methods to Dart's `Iterable<A>`, making it easy
to move from mutable collections into ribs immutable types.

<<< @/../snippets/lib/src/core/syntax.dart#iterable-convert

---

## IList

Several extensions add higher-level operations to `IList` when its element
type is known.

### `IList<Option<A>>`

`sequence()` turns an `IList<Option<A>>` into an `Option<IList<A>>` — `None`
if any element is `None`, otherwise `Some` of all the unwrapped values.

<<< @/../snippets/lib/src/core/syntax.dart#ilist-option-sequence

`unNone()` drops all `None` elements and returns an `IList<A>` of the
unwrapped `Some` values.

<<< @/../snippets/lib/src/core/syntax.dart#ilist-unNone

### `IList<(A, B)>`

`unzip()` splits a list of pairs into a pair of lists. Variants exist for
3-tuples as well.

<<< @/../snippets/lib/src/core/syntax.dart#ilist-unzip

---

## String

`StringOps` adds familiar collection-style operations to `String`, treating it
as a sequence of single-character strings.

<<< @/../snippets/lib/src/core/syntax.dart#string-ops

The full set includes `take`, `takeRight`, `takeWhile`, `drop`, `dropRight`,
`dropWhile`, `filter`, `filterNot`, `find`, `exists`, `forall`, `foldLeft`,
`foldRight`, `splitAt`, `span`, `partition`, `slice`, `head`/`headOption`,
`last`/`lastOption`, `tail`, `init`, `stripPrefix`, `stripSuffix`, `sliding`,
and `grouped`.

---

## Tuples

`TupleNOps` extensions (generated for arities 2–22) add collection-like
operations to Dart records, making them behave as heterogeneous lists.

### Head, last, tail, init

`head` returns the first element; `last` returns the final element. `tail`
drops the first element and returns the remaining elements as a smaller tuple;
`init` drops the last element.

<<< @/../snippets/lib/src/core/syntax.dart#tuple-hlist

### Appending and prepending

`appended` and `prepended` grow the tuple by one element, returning a new
tuple with a statically-correct arity and type.

<<< @/../snippets/lib/src/core/syntax.dart#tuple-append-prepend

### Calling a function with tuple elements

`call` spreads the tuple's elements as positional arguments into a matching
function, eliminating manual destructuring.

<<< @/../snippets/lib/src/core/syntax.dart#tuple-call

---

## RIterable numeric & tuple extensions

`RIterableIntOps` / `RIterableDoubleOps` add `sum()` and `product()` to any
`RIterableOnce<int>` or `RIterableOnce<double>` (including `IList`, `IVector`,
etc.).

<<< @/../snippets/lib/src/core/syntax.dart#riterable-numeric

`RIterableTuple2Ops` adds `toIMap()` to a collection of pairs, constructing an
`IMap<A, B>` directly.

<<< @/../snippets/lib/src/core/syntax.dart#riterable-toIMap
