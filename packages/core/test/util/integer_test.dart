import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Integer (native)', () {
    test('size', () {
      expect(Integer.Size, 64);
    });

    test('numberOfLeadingZeros', () {
      expect(Integer.numberOfLeadingZeros(0), Integer.Size);
      expect(Integer.numberOfLeadingZeros(1), Integer.Size - 1);
      expect(Integer.numberOfLeadingZeros(1234567), 43);
    });

    test('numberOfTrailingZeros', () {
      expect(Integer.numberOfTrailingZeros(0), Integer.Size);
      expect(Integer.numberOfTrailingZeros(1), 0);
      expect(Integer.numberOfTrailingZeros(1024), 10);
      expect(Integer.numberOfTrailingZeros(1234567), 0);
    });

    test('rotateLeft', () {
      expect(Integer.rotateLeft(0, 10), 0);
      expect(Integer.rotateLeft(1, 10), 1024);
      expect(Integer.rotateLeft(11, 40), 12094627905536);
    });

    test('rotateRight', () {
      expect(Integer.rotateRight(0, 10), 0);
      expect(Integer.rotateRight(1, 10), 18014398509481984);
      expect(Integer.rotateRight(11, 40), 184549376);
    });
  }, testOn: 'dart-vm');

  group('Integer (browser)', () {
    test('size', () {
      expect(Integer.Size, 32);
    });

    test('numberOfLeadingZeros', () {
      expect(Integer.numberOfLeadingZeros(0), Integer.Size);
      expect(Integer.numberOfLeadingZeros(1), Integer.Size - 1);
      expect(Integer.numberOfLeadingZeros(1234567), 43);
    });

    test('numberOfTrailingZeros', () {
      expect(Integer.numberOfTrailingZeros(0), Integer.Size);
      expect(Integer.numberOfTrailingZeros(1), 0);
      expect(Integer.numberOfTrailingZeros(1024), 10);
      expect(Integer.numberOfTrailingZeros(1234567), 0);
    });

    test('rotateLeft', () {
      expect(Integer.rotateLeft(0, 10), 0);
      expect(Integer.rotateLeft(1, 10), 1024);
      expect(Integer.rotateLeft(11, 30), -1073741822);
    });

    test('rotateRight', () {
      expect(Integer.rotateRight(0, 10), 0);
      expect(Integer.rotateRight(1, 10), 4194304);
      expect(Integer.rotateRight(11, 40), 46137344);
    });
  }, testOn: 'browser');
}
