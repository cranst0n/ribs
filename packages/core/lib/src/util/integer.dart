import 'package:ribs_core/src/util/integer/stub.dart'
    if (dart.library.html) 'integer/web.dart'
    if (dart.library.io) 'integer/native.dart';

/// Platform-aware integer utilities providing bit-manipulation operations.
///
/// The integer size and range values are platform-specific: 64-bit on native
/// and 32-bit on the web (where Dart integers are JavaScript numbers).
sealed class Integer {
  static final IntegerImpl _platformImpl = IntegerImpl();

  /// The number of bits in a platform integer (32 on web, 64 on native).
  static int get size => _platformImpl.size;

  /// The maximum value of a platform integer.
  static int get maxValue => _platformImpl.maxValue;

  /// The minimum value of a platform integer.
  static int get minValue => _platformImpl.minValue;

  /// Returns the number of one-bits in the binary representation of [i].
  static int bitCount(int i) => _platformImpl.bitCount(i);

  /// Returns an integer with at most a single one-bit, in the position of the
  /// highest-order one-bit in [i]. Returns zero if [i] is zero.
  static int highestOneBit(int i) => _platformImpl.highestOneBit(i);

  /// Returns the number of zero bits preceding the highest-order one-bit in
  /// [i]. Returns [size] if [i] is zero.
  static int numberOfLeadingZeros(int i) => _platformImpl.numberOfLeadingZeros(i);

  /// Returns the number of zero bits following the lowest-order one-bit in
  /// [i]. Returns [size] if [i] is zero.
  static int numberOfTrailingZeros(int i) => _platformImpl.numberOfTrailingZeros(i);

  /// Returns [i] rotated left by [distance] bits.
  static int rotateLeft(int i, int distance) =>
      (i << distance) | (i >>> (_platformImpl.size - distance));

  /// Returns [i] rotated right by [distance] bits.
  static int rotateRight(int i, int distance) =>
      (i >>> distance) | (i << (_platformImpl.size - distance));
}
