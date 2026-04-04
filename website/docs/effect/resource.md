---
sidebar_position: 20
---


# Resource

## Motivation

Whenever you open a file, acquire a database connection, or bind a network
socket, you take on a responsibility: **you must release that resource when
you are done**, regardless of whether your program succeeds, fails, or is
canceled. Forgetting to do so leaks finite system resources and can silently
corrupt state.

The standard Dart answer is `try`/`finally`. For a single resource this is
manageable, but it degrades quickly as soon as you need two resources at once:

<<< @/../snippets/lib/src/effect/resource.dart#try-catch-finally

The deeper you nest, the more surface area exists for subtle mistakes —
a misplaced `return`, an exception thrown in the wrong `finally` block, or
simply losing track of which resource is closed by which handler.

---

## Step up: `IO.bracket`

`IO` provides `bracket`, which guarantees that a release action runs after a
`use` block, whether it completes successfully, raises an error, or is
canceled. The same two-file copy using `bracket` looks like this:

<<< @/../snippets/lib/src/effect/resource.dart#io-bracket

This is already safer than `try`/`finally` — cancellation is handled
correctly, and the release is guaranteed. But notice the shape: each
additional resource adds another level of nesting. With three or more
resources, `bracket` chains become a rightward-growing pyramid that is hard to
read and harder to refactor.

:::info
These examples use the built in `dart:io` functions to read/write to file. Ribs
also provides it's own functional ways of reading and writing files and sockets
in the `ribs_rill_io` package that seamlessly integrates with `IO` and `Resource`,
eliminating most of the noisy boilerplate you see in this contrived example.
:::

---

## `Resource`: composable lifecycle management

`Resource<A>` pairs an acquisition effect with its finalizer into a **single,
named value** that can be stored, passed around, and composed just like any
other type. Under the hood, `Resource` is implemented in terms of `bracket`,
so all the same safety guarantees apply — but the nesting disappears.

### Creating a Resource

`Resource.make` takes an acquire `IO` and a release function:

<<< @/../snippets/lib/src/effect/resource.dart#file-example

The resulting `Resource<RandomAccessFile>` is completely inert until it is
used — no file is opened yet.

### Using a Resource

Call `.use(f)` to open the resource, run `f` with the acquired value, then
close the resource. The finalizer runs even if `f` raises an error or the
fiber is canceled:

<<< @/../snippets/lib/src/effect/resource.dart#file-example-use

`use` returns a plain `IO<B>`, so the result integrates naturally with the
rest of your `IO` program. You can observe the outcome to react to success,
failure, or cancellation:

<<< @/../snippets/lib/src/effect/resource.dart#file-example-outcome

### Composing multiple Resources

Because `Resource` has `map` and `flatMap`, two resources compose with the
same combinators you already use on `IO`. When you need several resources
open at once, tuple them and call `useN` to receive each value as a
separate argument — no nesting required:

<<< @/../snippets/lib/src/effect/resource.dart#multiple-resources

Finalizers run in **reverse acquisition order** (LIFO), so the last resource
opened is always the first to be closed.

:::tip
`Resource` comes with the full set of `IO`-style combinators: `map`,
`flatMap`, `flatTap`, `evalMap`, `mapN` / `useN` for tuples, and more.
Any transformation you can express on `IO` can be expressed on `Resource`.
:::
