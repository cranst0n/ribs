import 'package:ribs_core/ribs_core.dart';

/// A mutable LIFO stack backed by [ArrayDeque].
///
/// Use [push] / [pushAll] to add elements at the top and [pop] to remove from
/// the top. [top] peeks without removing. Elements are pushed front-to-back so
/// [pushAll] reverses the input before inserting.
///
/// ```dart
/// final s = MStack<int>();
/// s.push(1).push(2);
/// s.pop();  // 2
/// s.top;    // 1
/// ```
class MStack<A> extends ArrayDeque<A> {
  MStack([super.size = ArrayDeque.DefaultInitialSize]);

  MStack._internal(super.array, super.start, super.end) : super.internal();

  /// Creates an [MStack] from a [RIterableOnce], preserving order.
  static MStack<A> from<A>(RIterableOnce<A> source) {
    if (source is MStack<A>) {
      return source;
    } else if (source is ArrayDeque<A>) {
      return MStack._internal(source.array, source.start, source.end);
    } else {
      final array = ArrayDeque.alloc<A>(source.size);
      final copied = source.copyToArray(array);

      return MStack._internal(array, 0, copied);
    }
  }

  /// Returns an empty [MStack].
  static MStack<A> empty<A>() => MStack<A>();

  /// Pushes [elem] onto the top of the stack and returns `this`.
  MStack<A> push(A elem) {
    super.prepend(elem);
    return this;
  }

  /// Pushes all [elems] onto the stack (last element of [elems] ends up on top)
  /// and returns `this`.
  MStack<A> pushAll(RIterableOnce<A> elems) => prependAll(RSeq.from(elems).reverse());

  /// Removes and returns the top element. Throws if empty.
  A pop() => removeHead();

  /// Removes and returns all elements in LIFO order.
  RSeq<A> popAll() => removeAll((_) => true);

  /// Removes and returns all leading elements satisfying [p] in LIFO order.
  RSeq<A> popWhile(Function1<A, bool> p) => removeHeadWhile(p);

  /// Returns the top element without removing it.
  A get top => head;

  @override
  MStack<A> addAll(RIterableOnce<A> elems) {
    super.addAll(elems);
    return this;
  }

  @override
  MStack<A> prependAll(RIterableOnce<A> elems) {
    super.prependAll(elems);
    return this;
  }

  @override
  MStack<A> reverse() => from(super.reverse());
}
