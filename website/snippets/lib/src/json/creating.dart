// ignore_for_file: avoid_print, unused_local_variable

import 'package:ribs_json/ribs_json.dart';

// creating-1

final anObject = Json.obj([
  ('key1', Json.True),
  ('key2', Json.str('some string...')),
  (
    'key3',
    Json.arr([
      Json.number(123),
      Json.number(3.14),
    ]),
  ),
]);

// creating-1

// creating-2

final jsonString = anObject.printWith(Printer.noSpaces);
// {"key1":true,"key2":"some string...","key3":[123,3.14]}

final prettyJsonString = anObject.printWith(Printer.spaces2);
// {
//   "key1" : true,
//   "key2" : "some string...",
//   "key3" : [
//     123,
//     3.14
//   ]
// }

// creating-2

// creating-3

// The complete set of Json value constructors
final nullValue = Json.Null; //        null
final trueValue = Json.True; //        true
final falseValue = Json.False; //      false
final boolValue = Json.boolean(true); // same as Json.True, but from a Dart bool
final strValue = Json.str('hello'); //  "hello"
final numValue = Json.number(42); //    42

// creating-3

void accessingValues() {
  // creating-4

  final json = Json.obj([
    ('name', Json.str('Ribs')),
    ('version', Json.number(1)),
    ('stable', Json.False),
    ('tags', Json.arr([Json.str('dart'), Json.str('fp')])),
  ]);

  final name = json.hcursor.get('name', Decoder.string);
  // Right('Ribs')

  final missing = json.hcursor.get('missing', Decoder.string);
  // Left(DecodingFailure: ...)

  // For quick type checks without decoding, use the boolean predicates
  final strNode = Json.str('hello');
  print(strNode.isString); // true
  print(strNode.isNumber); // false

  // asX() gives direct access without a cursor — returns Option<T>
  print(Json.number(3.14).asNumber()); // Some(3.14)
  print(Json.str('hi').asString()); //   Some(hi)
  print(Json.True.asBoolean()); //       Some(true)
  print(Json.Null.asNull()); //          Some(Unit)
  print(Json.str('hi').asNumber()); //   None

  // creating-4
}

void foldExample() {
  // creating-5

  String describe(Json json) => json.fold(
    () => 'null',
    (b) => 'boolean: $b',
    (n) => 'number: $n',
    (s) => 'string: "$s"',
    (arr) => 'array of ${arr.length} elements',
    (obj) => 'object with keys: ${obj.keys.toList()}',
  );

  print(describe(Json.str('hello'))); //          string: "hello"
  print(describe(Json.number(42))); //             number: 42
  print(describe(Json.arr([Json.Null]))); //       array of 1 elements
  print(describe(Json.obj([('a', Json.True)]))); // object with keys: [a]

  // creating-5
}

void transformingValues() {
  // creating-7

  // mapX transforms a value in-place; it's a no-op when the node is a different type
  final doubled = Json.number(21).mapNumber((n) => n * 2); // 42
  final upper = Json.str('hello').mapString((s) => s.toUpperCase()); // "HELLO"
  final toggled = Json.True.mapBoolean((b) => !b); // false
  final noop = Json.str('hello').mapNumber((n) => n * 2); // still "hello"

  // withX replaces the whole node using the typed value — useful for conditional swaps
  final replaced = Json.number(0).withNumber(
    (n) => n == 0 ? Json.Null : Json.number(n),
  ); // Json.Null

  // A practical use: redact every string field in an object
  final sensitive = Json.obj([
    ('user', Json.str('alice')),
    ('token', Json.str('secret-token-123')),
    ('score', Json.number(42)),
  ]);

  final redacted = sensitive.mapObject(
    (obj) => obj.mapValues((v) => v.mapString((_) => '***')),
  );
  print(redacted.printWith(Printer.noSpaces));
  // {"user":"***","token":"***","score":42}

  // creating-7
}

void jsonObjectExample() {
  // creating-8

  // JsonObject is the type that backs JObject — you can build and query it directly
  var obj = JsonObject.empty;
  obj = obj.add('name', Json.str('Ribs'));
  obj = obj.add('version', Json.number(1));
  obj = obj.add('stable', Json.False);

  print(obj.size); // 3
  print(obj.contains('name')); // true

  // get() returns Option<Json>
  print(obj.get('name')); // Some("Ribs")
  print(obj.get('missing')); // None

  // remove() returns a new JsonObject without the key
  final trimmed = obj.remove('stable');

  // toJson() wraps the object back into a Json value
  print(trimmed.toJson().printWith(Printer.noSpaces));
  // {"name":"Ribs","version":1}

  // filter() keeps only entries matching a predicate
  final numbersOnly = obj.filter((kv) => kv.$2.isNumber);
  print(numbersOnly.toJson().printWith(Printer.noSpaces));
  // {"version":1}

  // mapValues() transforms every value in the object
  final stringified = obj.mapValues(
    (v) => v.mapNumber((n) => n + 10),
  );
  print(stringified.toJson().printWith(Printer.noSpaces));
  // {"name":"Ribs","version":11,"stable":false}

  // creating-8
}

void cursorNavigation() {
  // creating-9

  final json = Json.obj([
    ('project', Json.str('Ribs')),
    (
      'contributors',
      Json.arr([
        Json.obj([('name', Json.str('Alice')), ('commits', Json.number(42))]),
        Json.obj([('name', Json.str('Bob')), ('commits', Json.number(17))]),
      ]),
    ),
  ]);

  final cursor = json.hcursor;

  // Navigate into an array element with downField + downN
  final firstCommits = cursor.downField('contributors').downN(0).get('commits', Decoder.integer);
  // Right(42)

  // getOrElse provides a fallback for missing or null fields
  final version = cursor.getOrElse('version', Decoder.integer, () => 0);
  // Right(0) — 'version' is absent, so the fallback fires

  // pathString gives a human-readable description of the cursor position
  final c = cursor.downField('contributors').downN(0).downField('name');
  print(c.pathString); // .contributors[0].name

  // creating-9
}

void mergingAndCleanup() {
  // creating-6

  final defaults = Json.obj([
    ('timeout', Json.number(30)),
    ('retries', Json.number(3)),
    ('debug', Json.Null),
  ]);

  final overrides = Json.obj([
    ('retries', Json.number(5)),
    ('host', Json.str('localhost')),
  ]);

  // deepMerge: keys in the right operand win; nested objects are merged recursively
  final merged = defaults.deepMerge(overrides);
  print(merged.printWith(Printer.noSpaces));
  // {"timeout":30,"retries":5,"debug":null,"host":"localhost"}

  // dropNullValues removes top-level null fields from an object
  final clean = merged.dropNullValues();
  print(clean.printWith(Printer.noSpaces));
  // {"timeout":30,"retries":5,"host":"localhost"}

  // deepDropNullValues removes nulls recursively through nested objects
  final nested = Json.obj([
    ('a', Json.Null),
    ('b', Json.obj([('c', Json.Null), ('d', Json.number(1))])),
  ]);
  print(nested.deepDropNullValues().printWith(Printer.noSpaces));
  // {"b":{"d":1}}

  // creating-6
}
