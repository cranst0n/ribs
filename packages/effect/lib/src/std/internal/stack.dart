/// A specialized stack designed specifically for the IO interpreter but used
/// in other places as well.
///
/// This implementation avoids the overhead of standard [List.add] and
/// [List.removeLast] by managing a fixed-size buffer and a manual index pointer.
///
/// ***For internal use only***
class Stack<A> {
  // Start with a power of 2. 64 frames is deep enough for most
  // simple business logic, but it will grow if needed.
  static const int _initialCapacity = 64;

  // The backing store.
  List<Object?> _buffer;

  // The pointer to the *next* available slot.
  // 0 means empty.
  int _index = 0;

  Stack() : _buffer = List<Object?>.filled(_initialCapacity, null);

  /// Checks if stack is empty.
  @pragma('vm:prefer-inline')
  bool get isEmpty => _index == 0;
  bool get nonEmpty => _index != 0;

  /// Returns the number of elements currently on this stack.
  int get size => _index;

  /// Removes all elements from this stack.
  void clear() {
    // Null out all references to allow GC of closures.
    for (int ix = _index; ix >= 0; ix--) {
      _buffer[ix] = null;
    }

    _index = 0;
  }

  /// Pushes an element onto the stack.
  @pragma('vm:prefer-inline')
  void push(A a) {
    if (_index == _buffer.length) _grow();
    _buffer[_index++] = a;
  }

  /// Pops the last element on the stack..
  ///
  /// Note: This assumes the caller has verified [isEmpty] is false,
  /// or that the logic guarantees a pop is safe.
  @pragma('vm:prefer-inline')
  A pop() {
    // Decrement first to get the item at the top.
    final f = _buffer[--_index] as A;

    // Critical: Null out the slot to allow the closure to be Garbage Collected.
    // If we don't do this, the stack holds references to old closures, causing leaks.
    _buffer[_index] = null;

    return f;
  }

  /// Returns the top element on this stack. The stack itself is unchanged.
  ///
  /// If this stack is empty, an exception will be thrown
  A get peek => _buffer[_index - 1]! as A;

  /// Doubles the capacity of the buffer when full.
  void _grow() {
    final newCapacity = _buffer.length * 2;
    final newBuffer = List<Object?>.filled(newCapacity, null);

    // Fast intrinsic copy
    List.copyRange(newBuffer, 0, _buffer);
    _buffer = newBuffer;
  }
}
