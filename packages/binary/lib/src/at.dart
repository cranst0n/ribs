part of 'byte_vector.dart';

/// Represents a view or segment of bytes.
sealed class At {
  /// Creates an [At] given a getter function.
  factory At(Function1<int, int> f) => _AtF(f);

  At._();

  /// An empty [At] that throws on lookup.
  static final At empty = _AtEmpty();

  /// Creates an [At] backed by a byte array.
  factory At.array(Uint8List arr) => _AtArray(arr);

  /// Retrieves the byte at the given zero-based [i].
  int get(int i);

  /// Copies [size] bytes from this [At] starting at [offset] into [xs] starting at [start].
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

  @override
  int copyToArray(Uint8List xs, int start, int offset, int size) {
    xs.setRange(start, start + size, arr, offset);
    return size;
  }
}

final class _AtF extends At {
  final Function1<int, int> getImpl;

  _AtF(this.getImpl) : super._();

  @override
  int get(int i) => getImpl(i) & 0xff;
}
