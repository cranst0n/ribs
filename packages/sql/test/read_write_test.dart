import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

Row row(List<Object?> cols) => Row(IList.fromDart(cols));

void main() {
  group('ReadWrite', () {
    group('built-in scalar types', () {
      test('integer reads and writes', () {
        expect(ReadWrite.integer.unsafeGet(row([7]), 0), 7);
        expect(ReadWrite.integer.encode(7).toList, [7]);
      });

      test('string reads and writes', () {
        expect(ReadWrite.string.unsafeGet(row(['hi']), 0), 'hi');
        expect(ReadWrite.string.encode('hi').toList, ['hi']);
      });

      test('dubble reads and writes', () {
        expect(ReadWrite.dubble.unsafeGet(row([1.5]), 0), 1.5);
        expect(ReadWrite.dubble.encode(1.5).toList, [1.5]);
      });

      test('bigInt reads and writes', () {
        final n = BigInt.from(999);
        expect(ReadWrite.bigInt.unsafeGet(row([n]), 0), n);
        expect(ReadWrite.bigInt.encode(n).toList, [n]);
      });

      test('boolean reads 1 as true; write stores Dart bool directly', () {
        // Read decodes DB int (0/1) → bool; Write stores the Dart bool as-is
        // for the DB driver to handle — there is no symmetric roundtrip.
        expect(ReadWrite.boolean.unsafeGet(row([1]), 0), true);
        expect(ReadWrite.boolean.encode(true).toList, [true]);
      });

      test('dateTime reads ISO string; write stores DateTime directly', () {
        final dt = DateTime.utc(2024, 3, 10);
        expect(ReadWrite.dateTime.unsafeGet(row([dt.toIso8601String()]), 0), dt);
        expect(ReadWrite.dateTime.encode(dt).toList, [dt]);
      });

      test('blob reads List<int>; write stores ByteVector directly', () {
        final bytes = [5, 6, 7];
        final bv = ByteVector.fromDart(bytes);
        expect(ReadWrite.blob.unsafeGet(row([bytes]), 0), bv);
        expect(ReadWrite.blob.encode(bv).toList, [bv]);
      });

      test('json reads JSON string; write stores Json object directly', () {
        final json = Json.str('test');
        final encoded = Printer.noSpaces.print(json);
        expect(ReadWrite.json.unsafeGet(row([encoded]), 0), json);
        expect(ReadWrite.json.encode(json).toList, [json]);
      });
    });

    group('gets and puts delegation', () {
      test('gets delegates to read', () {
        expect(ReadWrite.integer.gets.length, Read.integer.gets.length);
      });

      test('puts delegates to write', () {
        expect(ReadWrite.integer.puts.length, Write.integer.puts.length);
      });

      test('length is 1 for scalar types', () {
        expect(ReadWrite.string.length, 1);
      });
    });

    group('optional', () {
      test('Some reads and writes the inner value', () {
        final rw = ReadWrite.integer.optional();
        expect(rw.unsafeGet(row([42]), 0), const Some(42));
        expect(rw.encode(const Some(42)).toList, [42]);
      });

      test('None when column is null, encodes None as null', () {
        final rw = ReadWrite.string.optional();
        expect(rw.unsafeGet(row([null]), 0), isA<None>());
        expect(rw.encode(none<String>()).toList, [null]);
      });
    });

    group('xmap', () {
      test('maps read side and contramaps write side', () {
        final rw = ReadWrite.integer.xmap<String>(
          (n) => 'val:$n',
          (s) => int.parse(s.split(':')[1]),
        );
        expect(rw.unsafeGet(row([5]), 0), 'val:5');
        expect(rw.encode('val:5').toList, [5]);
      });
    });

    group('xemap', () {
      test('successful emap maps read side', () {
        final rw = ReadWrite.string.xemap<int>(
          (s) => Either.catching(() => int.parse(s), (_, _) => 'not a number'),
          (n) => n.toString(),
        );
        expect(rw.unsafeGet(row(['42']), 0), 42);
        expect(rw.encode(42).toList, ['42']);
      });

      test('failed emap throws on read', () {
        final rw = ReadWrite.string.xemap<int>(
          (_) => Either.left('always fails'),
          (n) => n.toString(),
        );
        expect(() => rw.unsafeGet(row(['x']), 0), throwsA(isA<Exception>()));
      });
    });
  });
}
