import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

import 'gen.dart';

void main() {
  forAll('JSON roundtrip', genJson, (json) {
    final str = json.printWith(Printer.spaces2);

    Json.parse(str).fold(
      (err) => fail('Json.roundtrip failed: $err [$str]'),
      (value) => expect(value, json),
    );
  }, numTests: 20);

  test('Json.cursor A', () {
    final json = Json.obj([
      (
        'a',
        Json.arr([
          Json.str('string'),
          Json.obj([
            ('b', Json.obj([('c', Json.False)]))
          ])
        ])
      ),
      ('c', Json.True),
    ]);

    expect(json.isObject, isTrue);

    final cursor = HCursor.fromJson(json)
        .downField('a')
        .downN(1)
        .downField('b')
        .downField('c');

    expect(cursor.focus(), Some(Json.boolean(false)));

    expect(
      cursor.pathToRoot(),
      PathToRoot(ilist([
        PathElem.objectKey('a'),
        PathElem.arrayIndex(1),
        PathElem.objectKey('b'),
        PathElem.objectKey('c'),
      ])),
    );

    expect(cursor.pathString, '.a[1].b.c');
  });

  test('Json.cursor B', () {
    final json = Json.parse('[{"foo": [1, 2,3]}, {"bar": null, "baz": "qux"}]')
        .getOrElse(() => fail('parse2 failed'));

    expect(
      json.hcursor.downN(1).focus(),
      Json.obj([('bar', JNull()), ('baz', JString('qux'))]).some,
    );

    expect(
      json.deepDropNullValues().hcursor.downN(1).focus(),
      Json.obj([('baz', JString('qux'))]).some,
    );

    final cursor = json.hcursor.downArray().downField('foo');
    final decoded = cursor
        .decode(Decoder.nonEmptyIList(Decoder.integer).map((a) => a.reverse()));

    expect(decoded, NonEmptyIList(3, ilist([2, 1])).asRight<DecodingFailure>());
  });

  test('Codec.parse3', () {
    final json = Json.parse('{"foo": 1, "bar": "hello", "baz": 32}')
        .getOrElse(() => fail('parse3.parse fail'));

    final decoded = Parse3.codec.decode(json);

    decoded.fold(
      (failure) =>
          expect(failure.reason, WrongTypeExpectation('bool', Json.number(32))),
      (good) => fail('should not have parsed successfully'),
    );
  });

  test('Json.deepMerge', () {
    final obj1 = Json.obj([
      ('a', Json.number(1)),
      ('b', Json.number(2)),
      ('c', Json.number(3)),
      ('z', Json.obj([('1', Json.number(1)), ('2', Json.number(2))])),
    ]);

    final obj2 = Json.obj([
      ('a', Json.number(2)),
      ('b', Json.number(3)),
      ('d', Json.number(5)),
      (
        'z',
        Json.obj([
          ('1', Json.number(1)),
          ('2', Json.number(-2)),
          ('3', Json.number(3))
        ]),
      ),
    ]);

    final oneIntoTwo = obj2.deepMerge(obj1);
    final twoIntoOne = obj1.deepMerge(obj2);

    expect(oneIntoTwo.asObject().flatMap((obj) => obj.get('a')),
        Json.number(1).some);

    expect(twoIntoOne.asObject().flatMap((obj) => obj.get('a')),
        Json.number(2).some);
  });

  test('Decoder.mapOf', () {
    final json = Json.parse('{"3": "1", "2": "2", "1": "3"}')
        .getOrElse(() => fail('parse3.map fail'));

    final decoded =
        Decoder.mapOf(MapKey.keyDecoder, Decoder.string).decode(json);

    decoded.fold(
      (err) => fail('Decoder.mapOf failed: $err'),
      (value) => expect(value, {
        const MapKey(3): '1',
        const MapKey(2): '2',
        const MapKey(1): '3',
      }),
    );
  });

  test('Encoder.mapOf', () {
    final encoder = Encoder.mapOf(
        KeyEncoder.instance<bool>((a) => a.toString().length.toString()),
        Encoder.integer);

    final encoded = encoder.encode({true: 1, false: 2});

    expect(
      encoded,
      Json.obj([
        ('4', Json.number(1)),
        ('5', Json.number(2)),
      ]),
    );
  });

  test('Encoder', () {
    expect(
      Parse3.codec.encode(const Parse3(1, 'two', false)),
      Json.obj([
        ('foo', JNumber(1)),
        ('bar', JString('two')),
        ('baz', JBoolean(false))
      ]),
    );
  });

  test('Codec.tuple', () {
    const value = (1, false);
    final codec = Codec.tuple2(Codec.integer, Codec.boolean);

    expect(codec.encode(value), Json.arr([JNumber(1), JBoolean(false)]));

    codec.decode(codec.encode(value)).fold(
          (err) => fail('Codec.tuple failed: $err'),
          (value) => expect(value, value),
        );

    Json.decode('[1, false, 2.2]', codec).fold(
      (err) => expect(err, isA<DecodingFailure>()),
      (_) => fail('Codec.tuple3 should not have succeeded.'),
    );
  });

  test('json.print', () {
    final json = Json.parse(
            '{"foo": "bar", "baz": [0, 1, 2], "qux": {"aaa": true, "bbb": 3.14, "ccc": "hello world!", "ddd": ["0", "1", "2", "3", "4"] } }')
        .getOrElse(() => fail('print parse failed.'));

    expect(
      Printer.noSpaces.print(json),
      '{"foo":"bar","baz":[0,1,2],"qux":{"aaa":true,"bbb":3.14,"ccc":"hello world!","ddd":["0","1","2","3","4"]}}',
    );

    expect(Printer.spaces2.print(json), '''
{
  "foo" : "bar",
  "baz" : [
    0,
    1,
    2
  ],
  "qux" : {
    "aaa" : true,
    "bbb" : 3.14,
    "ccc" : "hello world!",
    "ddd" : [
      "0",
      "1",
      "2",
      "3",
      "4"
    ]
  }
}''');

    expect(Printer.spaces4.print(json), '''
{
    "foo" : "bar",
    "baz" : [
        0,
        1,
        2
    ],
    "qux" : {
        "aaa" : true,
        "bbb" : 3.14,
        "ccc" : "hello world!",
        "ddd" : [
            "0",
            "1",
            "2",
            "3",
            "4"
        ]
    }
}''');
  });

  test('json.print escaped', () {
    final res = Json.obj([('0 ℃', Json.str('32 ℉'))]);

    final nonEscaped = res.printWith(Printer.noSpaces);
    final escaped = res.printWith(Printer.noSpaces.copy(escapeNonAscii: true));

    expect(nonEscaped, '{"0 ℃":"32 ℉"}');
    expect(escaped, '{"0 \\u2103":"32 \\u2109"}');
  });

  test('Decoder.either', () {
    final json = Json.parse('{"1": 3.14}').getOrElse(() => fail('lal'));

    final eitherNumOrBool = Decoder.mapOf(
        KeyDecoder.string, Decoder.number.either(Decoder.boolean));

    final eitherBoolOrNum = Decoder.mapOf(
        KeyDecoder.string, Decoder.boolean.either(Decoder.number));

    expect(eitherNumOrBool.decode(json).isRight, isTrue);
    expect(eitherBoolOrNum.decode(json).isRight, isTrue);
  });
}

class MapKey {
  final int k;

  const MapKey(this.k);

  static final KeyDecoder<MapKey> keyDecoder =
      KeyDecoder.lift((a) => Option(int.tryParse(a)).map(MapKey.new));

  @override
  String toString() => 'MK($k)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MapKey && other.k == k);

  @override
  int get hashCode => k.hashCode;
}

class Parse3 {
  final int foo;
  final String bar;
  final bool baz;

  const Parse3(this.foo, this.bar, this.baz);

  @override
  String toString() => 'Parse3($foo, $bar, $baz)';

  static final codec = Codec.product3(
    'foo'.as(Codec.integer),
    'bar'.as(Codec.string),
    'baz'.as(Codec.boolean),
    Parse3.new,
    (a) => (a.foo, a.bar, a.baz),
  );
}
