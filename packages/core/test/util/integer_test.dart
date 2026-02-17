import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Integer (native)', () {
    test('size', () {
      expect(Integer.Size, 64);
    });

    test('highestOneBit', () {
      expect(Integer.highestOneBit(0), 0);
      expect(Integer.highestOneBit(1), 1);
      expect(Integer.highestOneBit(1234567), 1048576);
    });

    test('numberOfLeadingZeros', () {
      expect(Integer.numberOfLeadingZeros(0), 64);
      expect(Integer.numberOfLeadingZeros(1), 63);
      expect(Integer.numberOfLeadingZeros(1234567), 43);
    });

    test('numberOfTrailingZeros', () {
      expect(Integer.numberOfTrailingZeros(0), 64);
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

  group('Integer (web)', () {
    test('size', () {
      expect(Integer.Size, 53);
    });

    test('highestOneBit', () {
      expect(Integer.highestOneBit(0), 0);
      expect(Integer.highestOneBit(1), 1);
      expect(Integer.highestOneBit(1234567), 1048576);
    });

    test('numberOfLeadingZeros', () {
      expect(Integer.numberOfLeadingZeros(0), 32);
      expect(Integer.numberOfLeadingZeros(1), 31);
      expect(Integer.numberOfLeadingZeros(1234567), 11);
    });

    test('numberOfTrailingZeros', () {
      expect(Integer.numberOfTrailingZeros(0), 32);
      expect(Integer.numberOfTrailingZeros(1), 0);
      expect(Integer.numberOfTrailingZeros(1024), 10);
      expect(Integer.numberOfTrailingZeros(1234567), 0);
    });

    test('rotateLeft', () {
      expect(Integer.rotateLeft(0, 10), 0);
      expect(Integer.rotateLeft(1, 10), 1024);
      // 11 << 40 is 0 on web (32-bit shift behavior on >32 count)
      expect(Integer.rotateLeft(11, 40), 0);
    });

    test('rotateRight', () {
      expect(Integer.rotateRight(0, 10), 0);
      // 1 << (53 - 10) = 1 << 43 is 0 on web
      expect(Integer.rotateRight(1, 10), 0);
      // 11 << (53 - 40) = 11 << 13 = 90112 (valid 32-bit shift)
      expect(Integer.rotateRight(11, 40), 90112);
    });
  }, testOn: 'browser');
}
