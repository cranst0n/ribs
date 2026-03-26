import 'package:ribs_core/ribs_core.dart';

class MStack<A> extends ArrayDeque<A> {
  MStack([super.size = ArrayDeque.DefaultInitialSize]);

  MStack._internal(super.array, super.start, super.end) : super.internal();

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

  static MStack<A> empty<A>() => MStack<A>();

  MStack<A> push(A elem) {
    super.prepend(elem);
    return this;
  }

  MStack<A> pushAll(RIterableOnce<A> elems) => prependAll(RSeq.from(elems).reverse());

  A pop() => removeHead();

  RSeq<A> popAll() => removeAll((_) => true);

  RSeq<A> popWhile(Function1<A, bool> p) => removeHeadWhile(p);

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
