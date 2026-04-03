---
sidebar_position: 3
---


# Streaming

A common need when working with binary data is encoding domain objects into a
byte stream and decoding them back out — for example when reading from a file or
communicating over a network socket.

Ribs binary provides adapters for both Dart's built-in `Stream` API and the
`Rill` streaming library. Both approaches use the same `Codec` definitions, so
the choice between them is purely about which streaming model you are already
using.

Let's assume we've got a simple domain model with its binary `Codec` already
defined:

<<< @/../snippets/lib/src/binary/streaming.dart#streaming-1

## With Rill

If you are using `ribs_rill` and `ribs_rill_io`, the `RillEncoder` and
`RillDecoder` types from `package:ribs_rill/binary.dart` plug directly into the
`Rill` streaming pipeline as `Pipe`s.

### RillEncoder

`RillEncoder.many(codec)` produces an encoder that repeatedly consumes one
element at a time from the source `Rill<A>` and encodes each to `BitVector`.
`.toPipeByte` flattens the bits into individual bytes so the result composes
directly with `Socket.writes`:

<<< @/../snippets/lib/src/binary/rill_streaming.dart#streaming-rill-encode

### RillDecoder

`RillDecoder.many(codec)` is the streaming counterpart: it accumulates raw bytes
from `Socket.reads`, decodes one `A` at a time, and emits each value
downstream. `.toPipeByte` accepts a `Rill<int>` so it connects directly to
`socket.reads` without any manual conversion:

<<< @/../snippets/lib/src/binary/rill_streaming.dart#streaming-rill-decode

Both `RillEncoder` and `RillDecoder` handle framing automatically: the decoder
buffers partial chunks across `BitVector` boundaries, so there is no need to
worry about TCP segmentation splitting a message mid-frame.

:::tip
`evalMap` in `runServer` handles one client at a time. For concurrent clients use
`parEvalMap` instead, supplying a bound on the number of simultaneous connections.
:::

## once — encoding and decoding a header

`RillEncoder.many` and `RillDecoder.many` keep consuming until the stream ends.
`once` reads or writes **exactly one value**, which is useful for a fixed-size
protocol header that precedes the variable-length body.

### Encoding a header with RillEncoder.once

Encode the header with `RillEncoder.once`, then concatenate the body stream
encoded with `RillEncoder.many` using the `+` operator:

<<< @/../snippets/lib/src/binary/rill_streaming.dart#streaming-rill-header-encode

### Decoding a header with RillDecoder.once

On the receiving side, `RillDecoder.once` reads the header and `flatMap` hands
the remaining bytes to the next decoder. The composed decoder is a plain
`Pipe<int, Event>` that hides all the framing logic:

<<< @/../snippets/lib/src/binary/rill_streaming.dart#streaming-rill-header-decode

`flatMap` can also branch on the decoded header value — for example to select a
different body `Codec` based on a protocol version field.

## With Dart Streams

### StreamEncoder

`StreamEncoder` is a `StreamTransformer<A, BitVector>`. Pipe a `Stream<A>`
through it and each element is encoded to a `BitVector` using the provided
`Codec`. You then convert each `BitVector` to a `Uint8List` and hand it off to
whatever sink you need:

<<< @/../snippets/lib/src/binary/streaming.dart#streaming-2

### StreamDecoder

`StreamDecoder` is the reverse: a `StreamTransformer<BitVector, A>`. It buffers
incoming `BitVector` chunks and emits a decoded `A` as soon as enough bits have
arrived. The receiving side maps raw bytes to `BitVector` first, then applies the
transformer:

<<< @/../snippets/lib/src/binary/streaming.dart#streaming-3
