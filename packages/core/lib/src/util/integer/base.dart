abstract class IntegerBase {
  int get Size; // bits

  int get MaxValue;
  int get MinValue;

  int bitCount(int i);
  int numberOfLeadingZeros(int i);
  int numberOfTrailingZeros(int i);
}
