/// Basic mutable stack data structure.
///
/// ***For internal use only***
final class Stack<A> {
  final _list = <A>[];

  /// Adds [value] to the top of this stack
  void push(A value) => _list.add(value);

  /// Removes and returns the top element on this stack.
  ///
  /// If this stack is empty, an exception will be thrown
  A pop() => _list.removeLast();

  /// Returns the top element on this stack. The stack itself is unchanged.
  ///
  /// If this stack is empty, an exception will be thrown
  A get peek => _list.last;

  /// Returns true if this stack has no elements, false otherwise.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if this stack has any elements, false otherwise.
  bool get nonEmpty => _list.isNotEmpty;

  /// Returns the number of elements currently on this stack.
  int get size => _list.length;

  /// Removes all elements from this stack.
  void clear() => _list.clear();

  @override
  String toString() => _list.toString();
}
