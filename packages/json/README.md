# ribs_json

Fully typed JSON parsing, encoding, and decoding for Dart. Inspired by [circe](https://circe.github.io/circe/) for Scala, `ribs_json` provides a type-safe ADT for JSON, powerful cursors for manual traversal, and highly composable encoders and decoders.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Core Features

- **Type-Safe ADT**: Represent JSON as a `Json` sealed class (`JNull`, `JBoolean`, `JNumber`, `JString`, `JArray`, `JObject`).
- **Composability**: Combine small decoders into larger ones for complex data structures.
- **Manual Traversal**: Use `HCursor` and `ACursor` for easy navigation through deeply nested JSON.
- **Streaming Parsing**: Support for incremental parsing of large JSON data using `AsyncParser`.
- **Flexible Printing**: Beautifully printed or minified JSON output.

## Installation

Add `ribs_json` and `ribs_core` to your `pubspec.yaml`:

```yaml
dependencies:
  ribs_core: any
  ribs_json: any
```

## Basic Usage

### Parsing and Decoding

Decoders allow you to robustly convert JSON into your own domain models:

```dart
final rawJson = '{"name": "Alice", "age": 30}';

final result = Json.decode(rawJson, Decoder.instance((c) => 
  (
    c.downField("name").decode(Decoder.string),
    c.downField("age").decode(Decoder.integer),
  ).mapN((name, age) => User(name, age))
));
```

### Codecs (Encoder + Decoder)

`Codec` combines both `Encoder` and `Decoder` into a single, composable unit using a powerful product-matching syntax:

```dart
final userCodec = (
  ("name", Codec.string),
  ("age", Codec.integer),
).product(User.new, (u) => (u.name, u.age));

// Encode
final json = userCodec.encode(User("Alice", 30));

// Decode
final user = userCodec.decode(json);
```

### Manual Traversal (Cursors)

`HCursor` allows you to navigate and modify JSON data manually when you don't want to define a full decoder:

```dart
final json = Json.parse('{"users": [{"id": 1, "name": "Alice"}]}').getOrElse(() => Json.Null);

// Navigate to Alice's name
final name = json.hcursor
  .downField("users")
  .downN(0)
  .downField("name")
  .decode(Decoder.string); // Right("Alice")
```

### Async / Streaming Parsing

`AsyncParser` can parse JSON chunks incrementally, which is essential for processing large datasets over a stream:

```dart
final parser = AsyncParser(mode: AsyncParserMode.unwrapArray);

// Absorb chunks of data as they arrive
parser.absorbString('[{"id":1},');
parser.absorbString('{"id":2}]');

// Finish parsing and collect results
final results = parser.finish(); // Right(IList([Json.obj(...), Json.obj(...)]))
```

## In-Depth Examples
For a more comprehensive look at `ribs_json` features, check out the example located at `example/example.dart` in the package source.