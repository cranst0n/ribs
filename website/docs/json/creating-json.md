---
sidebar_position: 2
---


# Creating JSON

It's also easy to create a typed JSON structure using Ribs using the `Json`
class:

<<< @/../snippets/lib/src/json/creating.dart#creating-1

By passing a list of `(String, Json)` elements to the `Json.obj` function, we now have a fully
typed `Json` object that we can interact with using the Ribs json API.

:::info
In many cases, you probably won't need to use the `Json` API itself. It's far
more common to define your domain models, and create encoders and decoders
for those. But it's still worthwhile knowing the `Json` type is what makes the
higher level APIs work.
:::

What about serializing the JSON? That's also an easy task:

<<< @/../snippets/lib/src/json/creating.dart#creating-2

## Value constructors

Every JSON primitive has a corresponding constructor on `Json`. The full set is:

<<< @/../snippets/lib/src/json/creating.dart#creating-3

`Json.boolean(b)` is the dynamic form of the two singleton constants `Json.True`
and `Json.False` — use whichever reads more naturally for the situation.

## Accessing values

Once you have a `Json` value you'll often need to pull individual fields out of
it. The cursor API provides two convenient entry points on `ACursor`:

- **`get(key, decoder)`** — navigate to a field by name and decode it in one
  step, returning `Either<DecodingFailure, A>`.
- **`decode(decoder)`** — apply a decoder to the currently focused node.

<<< @/../snippets/lib/src/json/creating.dart#creating-4

`asString()`, `asNumber()`, `asBoolean()`, `asArray()`, and `asObject()` are
also available directly on `Json` and return `Option<T>` — useful when you just
want to extract a value without going through a full decoder.

## Pattern matching with fold

`Json.fold` is the exhaustive pattern match over all six JSON types. Every
branch must be handled, so the compiler guarantees you never miss a case:

<<< @/../snippets/lib/src/json/creating.dart#creating-5

## Targeted transformations — mapX and withX

Sometimes you need to modify a specific kind of `Json` node without writing a
full `fold`. Two families of methods cover this:

- **`mapX(f)`** — transforms the typed value in-place and returns a new `Json`.
  If the node is a different type the call is a no-op and the original is
  returned unchanged.
- **`withX(f)`** — receives the typed value and returns a completely new `Json`,
  letting you swap the node for anything (including `Json.Null`). Also a no-op
  on a wrong-typed node.

Both families exist for all six JSON types: `mapBoolean`, `mapNumber`,
`mapString`, `mapArray`, `mapObject`, and the corresponding `withBoolean`,
`withNumber`, `withString`, `withArray`, `withObject`, `withNull`.

<<< @/../snippets/lib/src/json/creating.dart#creating-7

## Working with JsonObject directly

`JsonObject` is the immutable map type that backs every JSON object node. You
get one from `asObject()` or in the `jsonObject` branch of `fold`, and you can
also build one directly when you need fine-grained control:

<<< @/../snippets/lib/src/json/creating.dart#creating-8

`JsonObject` is immutable: `add`, `remove`, and `mapValues` all return new
instances. Call `.toJson()` to wrap the result back into a `Json` value for
printing or encoding.

## Navigating nested structures with the cursor

For nested JSON the cursor supports chaining navigation steps. `downField(key)`
moves into an object field and `downN(n)` moves to an array element at index
`n`. Each step returns an `ACursor` that can be chained further or decoded
directly with `get` / `decode`:

<<< @/../snippets/lib/src/json/creating.dart#creating-9

`getOrElse` is useful for optional fields: if the key is absent or the decode
fails it calls the fallback `Function0` instead. `pathString` gives a
human-readable dot/bracket path to the current focus, which is handy for
error messages.

## Merging and cleaning up objects

Two utility methods make it easy to compose or sanitise JSON objects:

- **`deepMerge`** — recursively merges two objects; keys in the right operand
  win, and nested objects are merged rather than replaced.
- **`dropNullValues`** — removes top-level fields whose value is `Json.Null`.
- **`deepDropNullValues`** — does the same recursively through nested objects.

<<< @/../snippets/lib/src/json/creating.dart#creating-6
