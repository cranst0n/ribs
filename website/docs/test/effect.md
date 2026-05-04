---
sidebar_position: 2
---

# Effect Matchers

`ribs_test` provides matchers and a deterministic runtime for testing `IO`
programs. The matchers integrate with `package:test`'s `expect`/`expectLater`
and work with both live futures and the virtual-time `Ticker`.

```dart
import 'package:ribs_test/ribs_effect_test.dart';
```

---

## Outcome matchers

Every `IO<A>` computation finishes in one of three outcomes: it succeeds with a
value, raises an error, or is canceled. There is a matcher for each.

### `succeeds([matcher])`

Runs the `IO` and asserts it completes successfully. Pass a `matcher` to
also validate the result value.

### `errors([matcher])`

Asserts the `IO` raises an error. Optionally validates the thrown value.

### `cancels`

Asserts the `IO` is canceled before it completes. Use as a constant (no call
needed).

<<< @/../snippets/test/effect/testing_test.dart#testing-matchers

All matchers accept any `package:test` `Matcher` for further validation:

<<< @/../snippets/test/effect/testing_test.dart#testing-matchers-advanced

---

## Termination matchers

Sometimes you want to assert whether an `IO` *ever* completes rather than what
value it produces. These matchers use a `TestIORuntime` internally — they
fast-forward all pending timers and check whether the fiber has finished.

### `terminates`

Asserts the `IO` completes in finite (virtual) time — regardless of whether it
succeeds, errors, or is canceled.

### `nonTerminating`

Asserts the `IO` does **not** complete even after all pending work is drained.

---

## Virtual time with `Ticker`

Real `IO.sleep` calls block for wall-clock time, making tests slow and
non-deterministic. `Ticker` pairs an `IO` with a `TestIORuntime` whose clock
only advances when you explicitly tell it to, making sleep-based tests
**instantaneous**.

Any matcher that accepts an `IO<A>` also accepts a `Ticker<A>`. Obtain one via
the `.ticked` extension:

<<< @/../snippets/test/effect/testing_test.dart#testing-ticker

### Manual time control

When you need fine-grained control — for example, to assert intermediate states
between time steps — construct a `Ticker` explicitly and advance the clock
yourself. Call `tick()` first to run the fiber's startup step and register its
first scheduled task before advancing time:

<<< @/../snippets/test/effect/testing_test.dart#testing-ticker-manual

| `Ticker` method | What it does |
|---|---|
| `tick()` | Runs all tasks that are currently due |
| `tickOne()` | Runs the single earliest due task; returns `true` if one ran |
| `tickAll()` | Drains the queue — advances time and ticks until nothing remains |
| `advance(d)` | Moves the clock forward by `d` without running any tasks |
| `advanceAndTick(d)` | Advances by `d` then runs all newly-due tasks |
| `nonTerminating()` | Calls `tickAll()` and returns `true` if the fiber is still running |
| `nextInterval()` | Duration until the next scheduled task |
| `outcome` | `Future<Outcome<A>>` — completes when the fiber finishes |

### Real-world example: testing a poller

<<< @/../snippets/test/effect/testing_test.dart#testing-ticker-realworld

---

## `expectIO`

When you need to assert inside a running `IO` program rather than at the
top-level, `expectIO` lifts an `expectLater` call into `IO`:

<<< @/../snippets/test/effect/testing_test.dart#testing-expect-io

---

## `TestIORuntime`

`TestIORuntime` is the runtime that powers `Ticker`. You can also construct one
directly when a test needs access to the runtime itself (e.g., to check
`autoCedeN`):

```dart
final runtime = TestIORuntime();
io.unsafeRunAsync((oc) => ..., runtime: runtime);
runtime.tickAll();
```

`TestIORuntime` exposes the same `tick` / `advance` / `tickAll` API as
`Ticker`. The `autoCedeN` constructor parameter controls how many steps run
before an automatic cooperative yield, matching `IORuntime.defaultRuntime.autoCedeN`.
