---
sidebar_position: 2
---


# Encoding and Decoding

Much like Ribs JSON library, Ribs lets you define binary `Codec`s that make it
very easy to get complete control over decoding and encoding your Dart objects
to binary data.

Let's start with a hypothical set of models.

<<< @/../snippets/lib/src/binary/codecs.dart#codecs-1

## Codec

To start, we'll define a `Codec` for the `Info` and `Debug` classes:

<<< @/../snippets/lib/src/binary/codecs.dart#codecs-2

The `infoCodec` uses the `utf16_32` codec which prefixes a 32-bit integer,
indicating the length of the encoded string and then the string itself
using a UTF16 encoding.

The `debugCodec` needs to use 2 different codecs to properly encode/decode
the 2 fields from the `Debug` class:

* `int32L`: Serializes the `int` as little endian using 32-bits
* `ascii32`: Serializes the string using ASCII, while prepending a 32-bit
    integer to indicate the length of the string.

Next, we'll define a `Codec` for `Message`, the superclass of `Info` and `Debug`:

<<< @/../snippets/lib/src/binary/codecs.dart#codecs-3

Here we use `discriminatedBy` to allow us to properly encode and decode
instances of `Message` by prefixing an unique indentifier tag before each
message. In this particular instance, that tag is an 8-bit integer.

The only pieces left are the codecs for `Header` and `Document`:

<<< @/../snippets/lib/src/binary/codecs.dart#codecs-4

Finally let's see how you can use the `Codec` to encode and decode binary data:

<<< @/../snippets/lib/src/binary/codecs.dart#codecs-5

The example above illustrates a successful encoding of a `Document` and then a
successful decoding of those previously encoded bits.