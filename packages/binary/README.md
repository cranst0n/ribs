# ribs_binary

`ribs_binary` is a library for working with binary data in a type-safe, purely functional way. It provides powerful data structures for bit and byte manipulation, along with a composable codec system for encoding and decoding complex data structures.

## Core Components

### BitVector & ByteVector

`BitVector` and `ByteVector` are immutable data structures for handling binary data at the bit and byte levels, respectively.

- **BitVector**: Perfect for protocols that require bit-level precision.
- **ByteVector**: Optimized for byte-aligned data.

```dart
// Create a BitVector from a hex string
final bv = BitVector.fromValidHex('0a0b0c');

// Bit-level manipulation
final adjusted = bv.drop(4).take(12).concat(BitVector.fromInt(0xff, size: 8));

// Convert to ByteVector
final bytes = bv.bytes;
```

### Binary Codecs

The `Codec` class allows you to define how Dart types are converted to and from binary representation. Codecs are highly composable, similar to `scodec` in Scala.

```dart
// Define a simple codec for a 32-bit integer followed by a boolean
final codec = Codec.tuple2(Codec.int32, Codec.boolean);

// Encode a tuple
final encoded = codec.encode((42, true));

// Decode back
final decoded = codec.decode(encoded.getOrElse(() => BitVector.empty));
```

### Composing Complex Codecs

You can build complex codecs by composing smaller ones by using the `product` function on a tuple
of `Codec`s. Just provied a function to convert the tuple to your type and a function to convert
your type to a tuple.

```dart
final userCodec = (
  Codec.uint8,                                  // age
  Codec.variableSized(Codec.uint8, Codec.utf8), // name
).product(
  (age, name) => User(age, name),
  (user) => (user.age, user.name),
);
```

## Streaming

`ribs_binary` supports streaming binary data using standard Dart `Stream`s.

### StreamDecoder

Use `StreamDecoder` to decode a stream of bits/bytes into a stream of Dart objects incrementally. This is useful for processing data from sockets or files without loading everything into memory.

```dart
final stream = socket.transform(StreamDecoder(messageCodec));

await for (final msg in stream) {
  print('Received message: $msg');
}
```

### StreamEncoder

Conversely, `StreamEncoder` allows you to encode a stream of Dart objects into a continuous stream of bits.

## Documentation

For more detailed information, guides, and API documentation, visit the [Full Ribs Documentation Site](https://cranst0n.github.io/ribs/).

## Example

Check out the full example program in [example/example.dart](example/example.dart).