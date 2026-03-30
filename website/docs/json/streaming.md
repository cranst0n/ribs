---
sidebar_position: 4
---


# Streaming

Ribs JSON provides an `AsyncParser` that emits JSON values incrementally as
bytes or strings arrive — no need to buffer an entire document before parsing
begins. The parser is exposed through `JsonTransformer`, a
`StreamTransformerBase` that plugs directly into Dart's `Stream` API. For
`ribs_rill` users, a thin bridge makes it equally at home in a `Rill` pipeline.

The behaviour is controlled by `AsyncParserMode`:

| Mode | Description |
|---|---|
| `unwrapArray` | Expects a top-level JSON array; emits each element as it completes |
| `valueStream` | Expects a sequence of top-level JSON values; emits each one in turn |
| `singleValue` | Buffers until the whole stream is consumed, then emits one `Json` |

## Input variants

`JsonTransformer` has two factory constructors depending on the element type of
your source stream:

- **`JsonTransformer.bytes(mode)`** — accepts `Stream<List<int>>` (raw bytes)
- **`JsonTransformer.strings(mode)`** — accepts `Stream<String>` (text chunks)

Both return `Stream<Json>`.

---

## Unwrap Array

The `unwrapArray` mode expects the streamed JSON to be a top-level array. The
parser emits each child element as soon as it is fully received, which means
downstream processing can begin before the array closes.

To illustrate, let's start with a basic setup with a couple domain models and
JSON codecs defined for each:

<<< @/../snippets/lib/src/json/streaming.dart#streaming-1

Now consider that the incoming JSON — whether from a file, a socket, or an HTTP
response — takes this shape:

```json
[
    {
        "id": "2489651045",
        "type": "CreateEvent",
        "repo": { "id": 28688495, "name": "petroav/6.828" }
    },
    {
        "id": "2489651051",
        "type": "PushEvent",
        "repo": { "id": 28671719, "name": "rspt/rspt-theme" }
    }
]
```

`JsonTransformer.bytes` with `unwrapArray` streams the file and decodes each
`Event` as it arrives. Decoding failures are surfaced as
`Either<DecodingFailure, Event>` so they can be handled explicitly:

<<< @/../snippets/lib/src/json/streaming.dart#streaming-2

## Value Stream

When the source produces multiple top-level JSON values rather than a single
array, use `valueStream`. The data can be any sequence of heterogeneous JSON
values — objects, arrays, primitives — emitted one after another:

```json
["Name", "Session", "Score", "Completed"]
{"name": "Gilbert", "wins": [["straight", "7♣"], ["one pair", "10♥"]]}
["Gilbert", "2013", 24, true]
{"name": "Deloise", "wins": [["three of a kind", "5♣"]]}
```

<<< @/../snippets/lib/src/json/streaming.dart#streaming-3

## Single Value

`singleValue` mode buffers the entire byte stream and emits exactly one `Json`
once the stream closes. It behaves like a streaming version of `Json.parse` —
useful when the source delivers a complete document in chunks but you still want
the memory-efficient byte-at-a-time reading that file or socket streams provide:

<<< @/../snippets/lib/src/json/streaming.dart#streaming-4

## String input

If the data source already produces UTF-8 text chunks (for example, some HTTP
clients decode the body on your behalf), use `JsonTransformer.strings` to skip
the byte-decoding step:

<<< @/../snippets/lib/src/json/streaming.dart#streaming-5

---

## Streaming with Rill

If you are using `ribs_rill` and `ribs_rill_io`, `Rill<int>` is the natural
type for byte streams — produced by `Files.readAll` for files and by
`socket.reads` for network sockets.

Rather than bridging through Dart's `Stream` API, `AsyncParser` can be driven
directly inside the Rill pipeline. A mutable parser is created once via
`IO.delay`, and each `Chunk<int>` is fed to `parser.absorb` through `evalMap`,
keeping the side effect inside `IO`. A `finalAbsorb` step is appended with `+`
to flush any buffered data when the source terminates — this is required for
`singleValue` mode, which holds back the result until EOF.

<<< @/../snippets/lib/src/json/rill_streaming.dart#streaming-rill-file

Because `parseJsonRill` accepts any `Rill<int>`, the same helper works for a
network socket with no changes to the parsing or decoding logic:

<<< @/../snippets/lib/src/json/rill_streaming.dart#streaming-rill-socket

`IO.fromEither` promotes a decoding failure into an IO-level error, terminating
the stream. To silently skip undecodable elements instead, replace it with a
`flatMap` that returns `Rill.empty()` on the left branch and `Rill.emit(event)`
on the right.
