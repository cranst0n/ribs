---
sidebar_position: 1
---


# Parsing JSON

If you've ever used the built in Dart SDK `jsonDecode` function, you'll know
that your JSON (de)serialization code becomes littered with the dreaded
`dynamic` type. Dynamic bring along with a lot of responsibility for the
developer to check what type of data exactly they're dealing with. Then you
also have to deal with the potential thrown exception, adding yet another
responsibility which could instead be encoded as a type.

By contrast Ribs uses it's own parser (derived from Scala's jawn),
to build typed JSON data. No more type checks or casts using `is` or `as`
which pollute your code and reduce the readability.

Let's begin with a very simple example to get aquainted with the Ribs JSON
API:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-1

You can see that we can simply pass a string to the `Json.parse` function
and get our **value** back (emphasis on value because an exception will
*never* be raised). With our value, it's easy to check if the parse succeeded
or failed from the provided JSON string. The developer will need to explicitly
handle a failure because the `Either` type dictates it.

<<< @/../snippets/lib/src/json/parsing.dart#parsing-2

Assuming that we've got a valid string to parse, as we do in this example,
what exactly is the `Json` type and what do we do with it? `Json` is a sealed
class that can be one of a few possible types:

* `JNull`
* `JBoolean`
* `JNumber`
* `JString`
* `JArray`
* `JObject`

These represent all the possible types of JSON as defined by the spec. To
confirm this, print out the result of parsing the string from above:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-3

You can see that each element of the top-level array has successfully been
parsed and has the proper type.

Naturally if we feed an invalid JSON string into the parser, we'll get an
error. For illustrative purposes:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-4

## Parsing from bytes

`Json.parse` expects a `String`, but in practice JSON often arrives as raw
bytes — from an HTTP response body, a file read, or a network socket.
`Json.parseBytes` accepts a `Uint8List` directly, skipping the intermediate
string allocation:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-5

The return type is identical to `Json.parse`: `Either<ParsingFailure, Json>`.

## ParsingFailure in detail

A `ParsingFailure` wraps a single `message` string produced by the parser.
The message includes the unexpected token, the line number, and the column
number, which makes it straightforward to present a meaningful error to a user
or write it to a structured log:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-6

## Parsing and decoding in one step

`Json.parse` only takes you as far as an untyped `Json` tree. The vast
majority of the time you also want to decode that tree into a domain type.
`Json.decode` combines both steps and returns `Either<Error, A>`:

<<< @/../snippets/lib/src/json/parsing.dart#parsing-7

`Error` is a sealed supertype of both `ParsingFailure` and `DecodingFailure`,
so a single `fold` handles every failure mode at once. `Json.decodeBytes`
is the byte-input counterpart, matching `Json.parseBytes`.

:::tip
`Json.decode` is usually the right starting point when you know the expected
shape of the data up front. Save `Json.parse` for cases where you need to
inspect or transform the raw `Json` tree before handing it off to a decoder.
:::
