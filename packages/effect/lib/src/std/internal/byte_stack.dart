import 'dart:typed_data';

/// A specialized stack designed specifically for the IO interpreter to store
/// byte opcodes.
///
/// This is an extension type wrapping a [Uint32List]. Element 0 stores the
/// current size; remaining elements each pack 4 bytes (opcodes are in [0,255]).
/// Storing size inline and using a single typed-data allocation eliminates the
/// class-wrapper heap object that a regular class would require.
///
/// [push] returns a (potentially new) [ByteStack] to handle growth, since the
/// representation field of an extension type cannot be reassigned in place.
///
/// ***For internal use only***
extension type ByteStack._(Uint32List _list) {
  ByteStack([int initialCapacity = 16]) : this._(Uint32List(1 + (initialCapacity + 3) ~/ 4));

  /// Checks if stack is empty.
  @pragma('vm:prefer-inline')
  bool get isEmpty => _list[0] == 0;

  /// Checks if stack is non empty.
  @pragma('vm:prefer-inline')
  bool get nonEmpty => _list[0] != 0;

  /// Returns the number of elements currently on this stack.
  @pragma('vm:prefer-inline')
  int get size => _list[0];

  /// Removes all elements from this stack.
  @pragma('vm:prefer-inline')
  void clear() => _list[0] = 0;

  /// Pushes an element onto the stack, returning the (possibly grown) stack.
  @pragma('vm:prefer-inline')
  ByteStack push(int a) {
    final size = _list[0];
    final capacity = (_list.length - 1) * 4;
    final list = size < capacity ? _list : _growFrom(_list);
    final slot = 1 + size ~/ 4;
    final shift = (size % 4) * 8;

    list[slot] = (list[slot] & ~(0xFF << shift)) | ((a & 0xFF) << shift);
    list[0] = size + 1;

    return ByteStack._(list);
  }

  /// Pops the last element on the stack.
  ///
  /// Note: This assumes the caller has verified [isEmpty] is false,
  /// or that the logic guarantees a pop is safe.
  @pragma('vm:prefer-inline')
  int pop() {
    final size = _list[0] - 1;

    _list[0] = size;

    return (_list[1 + size ~/ 4] >> ((size % 4) * 8)) & 0xFF;
  }

  /// Returns the top element on this stack. The stack itself is unchanged.
  ///
  /// If this stack is empty, an exception will be thrown.
  int get peek {
    final i = _list[0] - 1;
    return (_list[1 + i ~/ 4] >> ((i % 4) * 8)) & 0xFF;
  }

  static Uint32List _growFrom(Uint32List old) {
    final newList = Uint32List((old.length - 1) * 2 + 1);

    List.copyRange(newList, 0, old);

    return newList;
  }
}
