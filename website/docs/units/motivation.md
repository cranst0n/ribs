---
sidebar_position: 1
---


# Motivation

Physical quantities — distances, durations, file sizes, temperatures — are
everywhere in real software. The most common way to represent them in Dart is
as plain `double` or `int` values, with the unit implied by a variable name or
a comment.

This works until it doesn't.

## The problem with raw numbers

Consider adding two speeds together:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-raw-problem

Both bugs compile and run without error. The type of `combined` and `total` is
just `double` — the compiler has no idea that the values come from different
unit systems. Errors like these famously brought down the
[Mars Climate Orbiter](https://en.wikipedia.org/wiki/Mars_Climate_Orbiter)
(a unit mismatch between pound-force seconds and newton seconds).

Comments and naming conventions are the only defence, and they are not enforced.

## The solution: units as types

`ribs_units` represents every quantity as a value *and* a unit together. The
type of a length is `Length`, the type of a velocity is `Velocity`, and they
cannot be mixed:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-typed-solution

Adding `usMilesPerHour` and `kilometersPerHour` without conversion is still a
compile-time error — they are both `Velocity`, so the `+` operator compiles,
but the values are internally aligned to a common base unit. The conversion is
automatic and correct. `Length` and `Velocity` cannot be added at all.

---

## Conversions

Every quantity can be converted to any compatible unit using `.to(unit)` (which
returns a `double`) or typed convenience getters (which return the same quantity
type):

<<< @/../snippets/lib/src/units/motivation.dart#motivation-conversions

Comparison operators (`>`, `<`, `>=`, `<=`) and `equivalentTo` all convert
internally, so `5280.feet >= 1.usMiles` evaluates correctly without any manual
conversion.

---

## Dimensional arithmetic

Some operations between quantity types produce a different quantity type.
`ribs_units` encodes this at the type level:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-arithmetic

`Length * Length` returns `Area`. `Area * Length` returns `Volume`. `Area /
Length` returns `Length`. These relationships are part of the API — if you try
to multiply two `Area` values and assign the result to a `Length`, the compiler
will tell you.

---

## Information sizes

`Information` covers both metric (1000-based) and binary (1024-based) unit
families as distinct units, so the difference between a marketing gigabyte and
a memory gibibyte is always explicit:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-information

`toCoarsest` converts a quantity to the largest unit in which it has a whole
(or near-whole) value — useful for human-readable output.

---

## Temperatures

Temperature is special: converting between *scales* (e.g. Celsius to
Fahrenheit) involves a zero-point offset, but converting a temperature
*difference* (a delta) does not. `ribs_units` exposes both:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-temperature

`toFahrenheit` uses the full scale conversion (multiply and add offset).
`toFahrenheitDegrees` treats the value as a delta — no offset, just the 9/5
ratio. Using the wrong one when computing a temperature change is a common
source of subtle bugs; having both named explicitly removes the ambiguity.

---

## Parsing

Quantities can be parsed from strings — useful for reading configuration files
or user input. The result is `Option<A>`, making the possibility of an invalid
input explicit in the type:

<<< @/../snippets/lib/src/units/motivation.dart#motivation-parsing
