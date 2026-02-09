part of 'byte_vector.dart';

sealed class At {
  factory At(Function1<int, int> f) => _AtF(f);

  At._();

  static final At empty = _AtEmpty();

  factory At.array(Uint8List arr) => _AtArray(arr);

  int get(int i);

  int copyToArray(Uint8List xs, int start, int offset, int size) {
    var i = 0;

    while (i < size) {
      xs[start + i] = get(offset + i);
      i += 1;
    }

    return i;
  }
}

final class _AtEmpty extends At {
  _AtEmpty() : super._();

  @override
  int get(int i) => throw ArgumentError('empty view');
}

final class _AtArray extends At {
  final Uint8List arr;

  _AtArray(this.arr) : super._();

  @override
  int get(int i) => arr[i] & 0xff;
}

final class _AtF extends At {
  final Function1<int, int> getImpl;

  _AtF(this.getImpl) : super._();

  @override
  int get(int i) => getImpl(i) & 0xff;
}
