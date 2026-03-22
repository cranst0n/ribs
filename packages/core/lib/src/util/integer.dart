import 'package:ribs_core/src/util/integer/stub.dart'
    if (dart.library.html) 'integer/web.dart'
    if (dart.library.io) 'integer/native.dart';

sealed class Integer {
  static final IntegerImpl _platformImpl = IntegerImpl();

  static int get size => _platformImpl.size;

  static int get maxValue => _platformImpl.maxValue;
  static int get minValue => _platformImpl.minValue;

  static int bitCount(int i) => _platformImpl.bitCount(i);

  static int highestOneBit(int i) => _platformImpl.highestOneBit(i);

  static int numberOfLeadingZeros(int i) => _platformImpl.numberOfLeadingZeros(i);

  static int numberOfTrailingZeros(int i) => _platformImpl.numberOfTrailingZeros(i);

  static int rotateLeft(int i, int distance) =>
      (i << distance) | (i >>> (_platformImpl.size - distance));

  static int rotateRight(int i, int distance) =>
      (i >>> distance) | (i << (_platformImpl.size - distance));
}
