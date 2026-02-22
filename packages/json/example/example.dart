// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A simple domain model for our example.
class SoftwareProject {
  final String name;
  final String language;
  final int stars;
  final Option<String> description;

  SoftwareProject(this.name, this.language, this.stars, this.description);

  @override
  String toString() =>
      'SoftwareProject(name: $name, language: $language, stars: $stars, description: $description)';
}

/// Define a Codec for our domain model using the product syntax.
/// This acts as both a Decoder and an Encoder.
final projectCodec = (
  ("name", Codec.string),
  ("language", Codec.string),
  ("stars", Codec.integer),
  ("description", Codec.string.optional()),
).product(SoftwareProject.new, (p) => (p.name, p.language, p.stars, p.description));

Future<void> main() async {
  // Basic Parsing & Decoding
  const rawJson = '''
  {
    "name": "ribs",
    "language": "dart",
    "stars": 100,
    "description": "Functional programming in Dart"
  }
  ''';

  print('Parsing and Decoding:');
  Json.parse(rawJson).fold(
    (err) => print('  Parsing failed: $err'),
    (json) => projectCodec
        .decode(json)
        .fold(
          (err) => print('  Decoding failed: $err'),
          (project) => print('  Decoded: $project'),
        ),
  );

  // Encoding
  print('\nEncoding:');
  final myProject = SoftwareProject('My Awesome App', 'Dart', 42, const Some('Just a sample'));
  final encodedJson = projectCodec.encode(myProject);
  print('  Encoded JSON: ${encodedJson.printWith(Printer.spaces2)}');

  // Manual Traversal (HCursor)
  print('\n3. Manual Traversal with Cursors:');
  final complexJson = Json.parse('''
  {
    "metadata": {
      "updatedAt": "2024-02-22T12:00:00Z",
      "tags": ["functional", "type-safe", "dart"]
    }
  }
  ''').getOrElse(() => Json.Null);

  final secondTag = complexJson.hcursor
      .downField('metadata')
      .downField('tags')
      .downN(1)
      .decode(Decoder.string);

  print('  Second tag: ${secondTag.getOrElse(() => "Not found")}');

  // Async / Streaming Parsing
  print('\nAsync / Streaming Parsing:');

  // A single JSON string containing an array of various types
  const jsonArrayString = '[1, "two", true, {"four": 4}, [5]]';

  // Simulate a network stream of string chunks
  final stream = Stream.fromIterable([
    jsonArrayString.substring(0, 10),
    jsonArrayString.substring(10, 20),
    jsonArrayString.substring(20),
  ]);

  // Use JsonTransformer to parse the stream incrementally
  try {
    final parsedElements =
        await stream.transform(JsonTransformer.strings(AsyncParserMode.unwrapArray)).toList();

    print('  Successfully parsed ${parsedElements.length} independent elements from the stream:');
    for (final item in parsedElements) {
      // Formatted printind using ribs_json Printer
      print('    - ${item.printWith(Printer.noSpaces)}');
    }
  } catch (e, st) {
    print('  Caught error: $e\n$st');
  }
}
