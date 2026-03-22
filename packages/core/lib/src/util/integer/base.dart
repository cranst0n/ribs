abstract class IntegerBase {
  int get size; // bits

  int get maxValue;
  int get minValue;

  int bitCount(int i);
  int highestOneBit(int i);
  int numberOfLeadingZeros(int i);
  int numberOfTrailingZeros(int i);
}
