import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('Put', () {
    group('built-in instances', () {
      test('integer encodes int', () {
        expect(Put.integer.encode(42), 42);
      });

      test('string encodes string', () {
        expect(Put.string.encode('hello'), 'hello');
      });

      test('dubble encodes double', () {
        expect(Put.dubble.encode(3.14), 3.14);
      });

      test('bigInt encodes BigInt', () {
        expect(Put.bigInt.encode(BigInt.from(9999999999999)), BigInt.from(9999999999999));
      });

      test('boolean encodes true as 1', () {
        expect(Put.boolean.encode(true), 1);
      });

      test('boolean encodes false as 0', () {
        expect(Put.boolean.encode(false), 0);
      });

      test('dateTime encodes as ISO 8601 string', () {
        final dt = DateTime.utc(2024, 6, 15, 12);
        expect(Put.dateTime.encode(dt), dt.toIso8601String());
      });

      test('blob encodes ByteVector as List<int>', () {
        final bv = ByteVector.fromDart([1, 2, 3]);
        expect(Put.blob.encode(bv), [1, 2, 3]);
      });

      test('json encodes Json as compact JSON string', () {
        final json = Json.obj([('key', Json.str('value'))]);
        final encoded = Put.json.encode(json);
        expect(encoded, Printer.noSpaces.print(json));
      });
    });

    group('contramap', () {
      test('adapts Put to a different type', () {
        final putLength = Put.integer.contramap<String>((s) => s.length);
        expect(putLength.encode('hello'), 5);
      });

      test('chains contraMaps', () {
        final put = Put.string
            .contramap<int>((n) => n.toString())
            .contramap<bool>((b) => b ? 1 : 0);
        expect(put.encode(true), '1');
        expect(put.encode(false), '0');
      });
    });

    group('instance', () {
      test('custom encoder is called', () {
        final put = Put.instance<String>((s) => s.toUpperCase());
        expect(put.encode('hello'), 'HELLO');
      });

      test('can encode null', () {
        final put = Put.instance<String?>((_) => null);
        expect(put.encode(null), null);
      });
    });
  });
}
