import 'package:ribs_core/ribs_core.dart';

class MQueue<A> extends ArrayDeque<A> {
  MQueue([super.size = ArrayDeque.DefaultInitialSize]);

  MQueue._internal(super.array, super.start, super.end) : super.internal();

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

  static MQueue<A> empty<A>() => MQueue<A>();

  MQueue<A> enqueue(A elem) {
    super.addOne(elem);
    return this;
  }

  MQueue<A> enqueueAll(RIterableOnce<A> elems) {
    super.addAll(elems);
    return this;
  }

  A dequeue() => removeHead();

  Option<A> dequeueFirst(Function1<A, bool> p) => removeFirst(p);

  RSeq<A> dequeueAll(Function1<A, bool> p) => removeAll(p);

  RSeq<A> dequeueWhile(Function1<A, bool> p) => removeHeadWhile(p);

  A get front => head;
}
