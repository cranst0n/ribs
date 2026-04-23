import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

Row row(List<Object?> cols) => Row(IList.fromDart(cols));

void main() {
  group('Get', () {
    group('built-in instances', () {
      test('integer reads int', () {
        expect(Get.integer.unsafeGet(row([42]), 0), 42);
      });

      test('string reads string', () {
        expect(Get.string.unsafeGet(row(['hello']), 0), 'hello');
      });

      test('dubble reads double', () {
        expect(Get.dubble.unsafeGet(row([3.14]), 0), 3.14);
      });

      test('bigInt reads BigInt', () {
        final n = BigInt.from(9999999999999);
        expect(Get.bigInt.unsafeGet(row([n]), 0), n);
      });

      test('boolean reads 1 as true', () {
        expect(Get.boolean.unsafeGet(row([1]), 0), true);
      });

      test('boolean reads 0 as false', () {
        expect(Get.boolean.unsafeGet(row([0]), 0), false);
      });

      test('dateTime parses ISO 8601 string', () {
        final dt = DateTime.utc(2024, 6, 15, 12);
        expect(Get.dateTime.unsafeGet(row([dt.toIso8601String()]), 0), dt);
      });

      test('dateTime throws on invalid string', () {
        expect(() => Get.dateTime.unsafeGet(row(['not-a-date']), 0), throwsA(isA<Exception>()));
      });

      test('blob reads List<int> as ByteVector', () {
        final bytes = [1, 2, 3];
        final bv = Get.blob.unsafeGet(row([bytes]), 0);
        expect(bv, ByteVector.fromDart(bytes));
      });

      test('json parses JSON string', () {
        final json = Json.obj([('n', Json.number(1))]);
        final encoded = Printer.noSpaces.print(json);
        expect(Get.json.unsafeGet(row([encoded]), 0), json);
      });

      test('json throws on invalid JSON string', () {
        expect(() => Get.json.unsafeGet(row(['not json']), 0), throwsA(isA<Exception>()));
      });

      test('reads column at non-zero offset', () {
        expect(Get.string.unsafeGet(row([1, 'second']), 1), 'second');
      });
    });

    group('error handling', () {
      test('throws RangeError when column index >= row length', () {
        expect(() => Get.integer.unsafeGet(row([1]), 1), throwsA(isA<RangeError>()));
      });

      test('throws Exception on type mismatch', () {
        expect(() => Get.integer.unsafeGet(row(['not an int']), 0), throwsA(isA<Exception>()));
      });
    });

    group('map', () {
      test('transforms decoded value', () {
        final get = Get.string.map((s) => s.length);
        expect(get.unsafeGet(row(['hello']), 0), 5);
      });

      test('chained map', () {
        final get = Get.integer.map((n) => n * 2).map((n) => n.toString());
        expect(get.unsafeGet(row([3]), 0), '6');
      });
    });

    group('emap', () {
      test('successful emap returns mapped value', () {
        final get = Get.string.emap((s) => Either.right<String, int>(int.parse(s)));
        expect(get.unsafeGet(row(['42']), 0), 42);
      });

      test('failed emap throws Exception', () {
        final get = Get.string.emap((_) => Either.left<String, int>('bad value'));
        expect(() => get.unsafeGet(row(['x']), 0), throwsA(isA<Exception>()));
      });
    });

    group('instance', () {
      test('custom get function is called', () {
        final get = Get.instance<String>((row, n) => 'col$n:${row[n]}');
        expect(get.unsafeGet(row(['a']), 0), 'col0:a');
      });
    });
  });
}
