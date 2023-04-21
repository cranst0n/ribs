final class Stack<A> {
  final _list = <A>[];

  void push(A value) => _list.add(value);

  A pop() => _list.removeLast();

  A get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  int get size => _list.length;

  void clear() {
    while (isNotEmpty) {
      pop();
    }
  }

  @override
  String toString() => _list.toString();
}
