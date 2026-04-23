import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

void main() {
  group('Write', () {
    group('built-in scalar types', () {
      test('integer encodes int and has length 1', () {
        expect(Write.integer.length, 1);
        expect(Write.integer.encode(42).toList, [42]);
      });

      test('string encodes string', () {
        expect(Write.string.encode('hello').toList, ['hello']);
      });

      test('dubble encodes double', () {
        expect(Write.dubble.encode(3.14).toList, [3.14]);
      });

      test('bigInt encodes BigInt', () {
        final n = BigInt.from(123456789);
        expect(Write.bigInt.encode(n).toList, [n]);
      });

      test('boolean stores Dart bool directly', () {
        expect(Write.boolean.encode(true).toList, [true]);
        expect(Write.boolean.encode(false).toList, [false]);
      });

      test('dateTime stores DateTime directly', () {
        final dt = DateTime.utc(2024, 6, 15);
        expect(Write.dateTime.encode(dt).toList, [dt]);
      });

      test('blob stores ByteVector directly', () {
        final bv = ByteVector.fromDart([1, 2, 3]);
        expect(Write.blob.encode(bv).toList, [bv]);
      });

      test('json stores Json object directly', () {
        final json = Json.obj([('k', Json.str('v'))]);
        expect(Write.json.encode(json).toList, [json]);
      });
    });

    group('unit', () {
      test('has length 0', () {
        expect(Write.unit.length, 0);
      });

      test('encode produces empty params', () {
        expect(Write.unit.encode(Unit()).toList, isEmpty);
      });

      test('puts list is empty', () {
        expect(Write.unit.puts.length, 0);
      });
    });

    group('fromPut', () {
      test('wraps Put in a single-slot Write', () {
        final write = Write.fromPut(Put.integer);
        expect(write.length, 1);
        expect(write.encode(7).toList, [7]);
      });

      test('puts list has one entry', () {
        expect(Write.fromPut(Put.string).puts.length, 1);
      });
    });

    group('contramap', () {
      test('adapts Write to a different type', () {
        final write = Write.integer.contramap<String>((s) => s.length);
        expect(write.encode('hello').toList, [5]);
      });

      test('preserves length', () {
        final write = Write.string.contramap<int>((n) => n.toString());
        expect(write.length, 1);
      });
    });

    group('encode', () {
      test('encodes into StatementParameters starting at 0', () {
        final params = Write.integer.encode(99);
        expect(params.toList, [99]);
      });
    });

    group('setParameter', () {
      test('sets value at given offset', () {
        final base = StatementParameters.empty().setParameter(0, 'first');
        final result = Write.integer.setParameter(base, 1, 42);
        expect(result.toList, ['first', 42]);
      });
    });

    group('optional', () {
      test('Some encodes the inner value', () {
        final write = Write.integer.optional();
        expect(write.encode(const Some(42)).toList, [42]);
      });

      test('None encodes as null', () {
        final write = Write.integer.optional();
        expect(write.encode(none<int>()).toList, [null]);
      });

      test('preserves puts length', () {
        expect(Write.string.optional().length, 1);
      });
    });
  });
}
