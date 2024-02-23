sealed class Hashing {
  static int improve(int hcode) {
    var h = hcode + ~(hcode << 9);
    h = h ^ (h >>> 14);
    h = h + (h << 4);
    return h ^ (h >>> 10);
  }
}
