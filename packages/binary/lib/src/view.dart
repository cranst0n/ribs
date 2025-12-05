part of 'byte_vector.dart';

final class _View {
  final At at;
  final int offset;
  final int size;

  _View(this.at, this.offset, this.size);

  factory _View.empty() => _View(At.empty, 0, 0);

  int get(int n) => at.get(offset + n);

  void foreach(Function1<int, void> f) {
    var i = 0;

    while (i < size) {
      f(at.get(offset + i));
      i += 1;
    }
  }

  bool foreachPartial(Function1<int, bool> f) {
    var i = 0;
    var cont = true;

    while (i < size && cont) {
      cont = f(at.get(offset + i));
      i += 1;
    }

    return cont;
  }

  void copyToArray(Uint8List xs, int start) => at.copyToArray(xs, start, offset, size);

  _View take(int n) {
    if (n <= 0) {
      return _View.empty();
    } else if (n >= size) {
      return this;
    } else {
      return _View(at, offset, n);
    }
  }

  _View drop(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return _View.empty();
    } else {
      return _View(at, offset + n, size - n);
    }
  }
}
