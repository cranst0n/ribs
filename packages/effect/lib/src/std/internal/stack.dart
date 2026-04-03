/// A specialized stack designed specifically for the IO interpreter but used
/// in other places as well.
///
/// This is an extension type wrapping a [List<Object?>]. Element 0 stores the
/// current size as an [int]; elements 1..size store the actual items.
/// Storing size inline and using a single list allocation eliminates the
/// class-wrapper heap object that a regular class would require.
///
/// [push] returns a (potentially new) [Stack] to handle growth, since the
/// representation field of an extension type cannot be reassigned in place.
///
/// ***For internal use only***
extension type Stack<A>._(List<Object?> _list) {
  Stack([int initialCapacity = 16])
    : this._(List<Object?>.filled(initialCapacity + 1, null)..[0] = 0);

  /// Checks if stack is empty.
  @pragma('vm:prefer-inline')
  bool get isEmpty => (_list[0]! as int) == 0;

  /// Checks if stack is not empty.
  @pragma('vm:prefer-inline')
  bool get nonEmpty => (_list[0]! as int) != 0;

  /// Returns the number of elements currently on this stack.
  @pragma('vm:prefer-inline')
  int get size => _list[0]! as int;

  /// Removes all elements from this stack.
  void clear() {
    final size = _list[0]! as int;
    _list.fillRange(1, size + 1, null); // Null out references to allow GC.
    _list[0] = 0;
  }

  /// Pushes an element onto the stack, returning the (possibly grown) stack.
  @pragma('vm:prefer-inline')
  Stack<A> push(A a) {
    final size = _list[0]! as int;
    final capacity = _list.length - 1;
    final list = size < capacity ? _list : _growFrom(_list);

    list[size + 1] = a;
    list[0] = size + 1;

    return Stack<A>._(list);
  }

  /// Pops the last element on the stack.
  ///
  /// Note: This assumes the caller has verified [isEmpty] is false,
  /// or that the logic guarantees a pop is safe.
  @pragma('vm:prefer-inline')
  A pop() {
    final idx = _list[0]! as int;
    final item = _list[idx]! as A;

    _list[0] = idx - 1;
    _list[idx] = null; // Null out to allow GC.

    return item;
  }

  /// Returns the top element on this stack. The stack itself is unchanged.
  ///
  /// If this stack is empty, an exception will be thrown.
  A get peek => _list[_list[0]! as int]! as A;

  static List<Object?> _growFrom(List<Object?> old) {
    final newList = List<Object?>.filled((old.length - 1) * 2 + 1, null);
    List.copyRange(newList, 0, old);
    return newList;
  }
}
