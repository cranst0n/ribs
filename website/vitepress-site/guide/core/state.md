---
sidebar_position: 6
---


# State

## Motivation

Most programs have state — scores, inventories, counters, configuration that
changes as the program runs. The usual approach in Dart is to keep that state
in a mutable variable and update it in place. But mutable shared state is one
of the most common sources of bugs, especially as programs grow: functions that
silently change state that a caller expected to remain the same, or code that
reads stale data because an update happened in the wrong order.

The natural alternative is to make state **explicit**: functions take the
current state as a parameter and return a new state alongside their result.
No mutation, no hidden side effects.

The problem with that approach is threading. Once you have a sequence of
operations that each transform the state, you end up manually passing the
state from one step to the next:

<<< @/../snippets/lib/src/core/state.dart#motivation-before

This works, but it has friction. Every function in the chain must accept and
return the full state. Every call site must name intermediate states and pass
them correctly — using `s1` where you meant `s3` is a real mistake that the
compiler won't catch. Reusing sequences of operations requires either
duplicating the threading logic or wrapping it in another function.

`State<S, A>` solves this by making the threading itself automatic. A
`State<S, A>` is a description of a computation that:

- Takes a current state of type `S`
- Produces a result of type `A`
- Returns a new state of type `S`

Operations compose with `flatMap`, and the state is wired through the chain
without any explicit passing. The only time you interact with the state directly
is when you run the computation at the end.

---

## Modelling State

Here is the game state type we will use throughout this page, along with an
initial value:

<<< @/../snippets/lib/src/core/state.dart#state-model

The type is immutable — `copy` returns a new `GameState` rather than
modifying the original. This is important: `State<S, A>` works best when `S`
is immutable, so that each step produces a clearly distinct new state.

---

## Defining Operations

Individual operations become `State` values. Each one describes how to update
the state and what value to return:

<<< @/../snippets/lib/src/core/state.dart#state-ops

A few things to notice:

- Operations that only modify the state (like `takeDamage`) return
  `State<GameState, Unit>` — the result value carries no information, only
  the state transition matters.
- Operations that read from the state (like `isAlive`) return a meaningful
  result type — `bool` in this case — while leaving the state unchanged.
- `currentHealth` does both: it returns the health value as the result while
  not modifying the state.

These are ordinary values. You can store them, pass them to functions, return
them from a method — without any computation having run yet.

---

## Composing Operations

`flatMap` sequences operations together. Each step receives the result of the
previous one and contributes its own state transition. The chain reads left
to right, and the state flows through automatically:

<<< @/../snippets/lib/src/core/state.dart#state-compose

`exploreForest` is itself a `State<GameState, bool>` — a reusable description
of a sequence of actions. It can be embedded in larger compositions just like
any other operation. `stormCastle` is defined the same way and can be chained
after it.

Neither function runs anything when called. They build up a description that
is executed only when you explicitly run it.

---

## Running the Computation

`State` provides three ways to execute a computation against an initial state:

| Method | Returns |
|--------|---------|
| `run(s)` | A tuple `(S, A)` — the final state and the result value |
| `runA(s)` | Just the result value `A` |
| `runS(s)` | Just the final state `S` |

Here is the full adventure composed and run:

<<< @/../snippets/lib/src/core/state.dart#state-run

The conditional in the middle — branching on whether the forest was survived —
is handled naturally with `flatMap`. The state accumulated up to that point
is threaded through whichever branch is taken.

If you only care about one part of the output, `runA` and `runS` are
convenient shortcuts:

<<< @/../snippets/lib/src/core/state.dart#state-runas

---

## API Summary

| Member | Description |
|--------|-------------|
| `State(fn)` | Construct from a function `S → (S, A)` |
| `State.pure(value)` | A `State` that returns `value` and leaves the state unchanged |
| `map(f)` | Transform the result value without touching the state |
| `flatMap(f)` | Chain a follow-up operation; state flows through |
| `modify(f)` | Apply `f` to the current state; result is the previous `A` |
| `transform(f)` | Apply `f` to both the state and result, returning new `(S, B)` |
| `state()` | Replace the result with the current state value |
| `run(s)` | Execute with initial state `s`; return `(finalState, result)` |
| `runA(s)` | Execute and return only the result |
| `runS(s)` | Execute and return only the final state |
