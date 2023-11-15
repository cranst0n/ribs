import 'package:ribs_binary/src/bases.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:test/test.dart';

void main() {
  group('Bases', () {
    group('binary', () {
      test('ignore', () {
        expect(Alphabets.binary.ignore(' '), isTrue);
      });

      test('toChar', () {
        expect(Alphabets.binary.toChar(0), '0');
        expect(Alphabets.binary.toChar(1), '1');
        expect(Alphabets.binary.toChar(2), '1');
      });

      test('toIndex', () {
        expect(Alphabets.binary.toIndex('0'), 0);
        expect(Alphabets.binary.toIndex('1'), 1);
        expect(() => Alphabets.binary.toIndex('2'), throwsArgumentError);
      });
    });

    group('truthy', () {
      test('ignore', () {
        expect(Alphabets.truthy.ignore(' '), isTrue);
      });

      test('toChar', () {
        expect(Alphabets.truthy.toChar(0), 't');
        expect(Alphabets.truthy.toChar(1), 'f');
        expect(Alphabets.truthy.toChar(2), 'f');
      });

      test('toIndex', () {
        expect(Alphabets.truthy.toIndex('t'), 0);
        expect(Alphabets.truthy.toIndex('f'), 1);
        expect(() => Alphabets.truthy.toIndex('?'), throwsArgumentError);
      });
    });

    group('hexLower', () {
      test('ignore', () {
        expect(Alphabets.hexLower.ignore(' '), isTrue);
      });

      forAll('toIndex (valid)', Gen.hexChar, (c) {
        expect(Alphabets.hexLower.toIndex(c), isNotNull);
      });

      test('toIndex (invalid)', () {
        expect(() => Alphabets.hexLower.toIndex('g'), throwsArgumentError);
        expect(Alphabets.hexLower.toIndex('\t'), -1);
      });
    });

    group('hexUpper', () {
      test('ignore', () {
        expect(Alphabets.hexUpper.ignore(' '), isTrue);
      });

      forAll('toIndex (valid)', Gen.hexChar, (c) {
        expect(Alphabets.hexUpper.toIndex(c), isNotNull);
      });

      test('toIndex (invalid)', () {
        expect(() => Alphabets.hexUpper.toIndex('g'), throwsArgumentError);
        expect(Alphabets.hexUpper.toIndex('\t'), -1);
      });
    });
  });
}
