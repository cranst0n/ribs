import 'package:ribs_core/ribs_core.dart';

/// A mutable FIFO queue backed by [ArrayDeque].
///
/// Use [enqueue] / [enqueueAll] to add elements at the back and [dequeue] to
/// remove from the front. [front] peeks at the head without removing it.
///
/// ```dart
/// final q = MQueue<int>();
/// q.enqueue(1).enqueue(2);
/// q.dequeue(); // 1
/// q.front;     // 2
/// ```
class MQueue<A> extends ArrayDeque<A> {
  MQueue([super.size = ArrayDeque.DefaultInitialSize]);

  MQueue._internal(super.array, super.start, super.end) : super.internal();

  /// Creates an [MQueue] from a [RIterableOnce], preserving order.
  static MQueue<A> from<A>(RIterableOnce<A> source) {
    if (source is MQueue<A>) {
      return source;
    } else if (source is ArrayDeque<A>) {
      return MQueue._internal(source.array, source.start, source.end);
    } else {
      final array = ArrayDeque.alloc<A>(source.size);
      final copied = source.copyToArray(array);

      return MQueue._internal(array, 0, copied);
    }
  }

  /// Returns an empty [MQueue].
  static MQueue<A> empty<A>() => MQueue<A>();

  /// Adds [elem] at the back of the queue and returns `this`.
  MQueue<A> enqueue(A elem) {
    super.addOne(elem);
    return this;
  }

  /// Adds all [elems] at the back of the queue and returns `this`.
  MQueue<A> enqueueAll(RIterableOnce<A> elems) {
    super.addAll(elems);
    return this;
  }

  /// Removes and returns the front element. Throws if empty.
  A dequeue() => removeHead();

  /// Removes and returns the first element satisfying [p], or [None] if none.
  Option<A> dequeueFirst(Function1<A, bool> p) => removeFirst(p);

  /// Removes and returns all elements satisfying [p].
  RSeq<A> dequeueAll(Function1<A, bool> p) => removeAll(p);

  /// Removes and returns all leading elements satisfying [p].
  RSeq<A> dequeueWhile(Function1<A, bool> p) => removeHeadWhile(p);

  /// Returns the front element without removing it.
  A get front => head;
}
