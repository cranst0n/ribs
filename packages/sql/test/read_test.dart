import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

Row row(List<Object?> cols) => Row(IList.fromDart(cols));

void main() {
  group('Read', () {
    group('built-in scalar types', () {
      test('integer reads int and has length 1', () {
        expect(Read.integer.length, 1);
        expect(Read.integer.unsafeGet(row([7]), 0), 7);
      });

      test('string reads string', () {
        expect(Read.string.unsafeGet(row(['hi']), 0), 'hi');
      });

      test('dubble reads double', () {
        expect(Read.dubble.unsafeGet(row([2.5]), 0), 2.5);
      });

      test('bigInt reads BigInt', () {
        final n = BigInt.from(123456789);
        expect(Read.bigInt.unsafeGet(row([n]), 0), n);
      });

      test('boolean reads 1 as true', () {
        expect(Read.boolean.unsafeGet(row([1]), 0), true);
      });

      test('boolean reads 0 as false', () {
        expect(Read.boolean.unsafeGet(row([0]), 0), false);
      });

      test('dateTime parses ISO 8601', () {
        final dt = DateTime.utc(2025);
        expect(Read.dateTime.unsafeGet(row([dt.toIso8601String()]), 0), dt);
      });

      test('blob reads bytes as ByteVector', () {
        final bytes = [10, 20, 30];
        expect(Read.blob.unsafeGet(row([bytes]), 0), ByteVector.fromDart(bytes));
      });

      test('json parses JSON string', () {
        final json = Json.arr([Json.number(1), Json.number(2)]);
        expect(Read.json.unsafeGet(row([Printer.noSpaces.print(json)]), 0), json);
      });
    });

    group('fromGet', () {
      test('wraps Get in a single-column Read', () {
        final read = Read.fromGet(Get.integer);
        expect(read.length, 1);
        expect(read.unsafeGet(row([99]), 0), 99);
      });

      test('gets list has one entry', () {
        final read = Read.fromGet(Get.string);
        expect(read.gets.length, 1);
      });
    });

    group('instance', () {
      test('multi-column read with custom function', () {
        final read = Read.instance(
          ilist([Get.integer, Get.string]),
          (r, n) => '${r[n]}-${r[n + 1]}',
        );
        expect(read.length, 2);
        expect(read.unsafeGet(row([42, 'abc']), 0), '42-abc');
      });

      test('reads starting at non-zero offset', () {
        final read = Read.fromGet(Get.string);
        expect(read.unsafeGet(row([1, 'second']), 1), 'second');
      });
    });

    group('map', () {
      test('transforms decoded value', () {
        final read = Read.string.map((s) => s.toUpperCase());
        expect(read.unsafeGet(row(['hello']), 0), 'HELLO');
      });

      test('preserves length and gets', () {
        final read = Read.integer.map((n) => n * 2);
        expect(read.length, 1);
        expect(read.gets.length, 1);
      });
    });

    group('emap', () {
      test('successful emap returns value', () {
        final read = Read.string.emap((s) => Either.right<String, int>(s.length));
        expect(read.unsafeGet(row(['hello']), 0), 5);
      });

      test('failed emap throws Exception', () {
        final read = Read.string.emap((_) => Either.left<String, int>('fail'));
        expect(() => read.unsafeGet(row(['x']), 0), throwsA(isA<Exception>()));
      });
    });

    group('optional', () {
      test('Some when column has a value', () {
        expect(Read.integer.optional().unsafeGet(row([42]), 0), const Some(42));
      });

      test('None when column is null', () {
        expect(Read.integer.optional().unsafeGet(row([null]), 0), isA<None>());
      });

      test('None when column index is out of range', () {
        expect(Read.integer.optional().unsafeGet(row([]), 0), isA<None>());
      });

      test('preserves gets from original Read', () {
        expect(Read.string.optional().gets.length, 1);
      });
    });
  });
}
