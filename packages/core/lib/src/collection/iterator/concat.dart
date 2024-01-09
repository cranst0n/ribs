part of '../iterator.dart';

final class _ConcatIterator<A> extends RibsIterator<A> {
  RibsIterator<A>? current;

  _ConcatIteratorCell<A>? tailCell;
  _ConcatIteratorCell<A>? lastCell;

  bool _currentHasNextChecked = false;

  _ConcatIterator(this.current);

  @override
  bool get hasNext {
    if (_currentHasNextChecked) {
      return true;
    } else if (current == null) {
      return false;
    } else if (current!.hasNext) {
      _currentHasNextChecked = true;
      return true;
    } else {
      // If we advanced the current iterator to a ConcatIterator, merge it into this one
      void merge() {
        while (current is _ConcatIterator) {
          final c = current! as _ConcatIterator<A>;
          current = c.current;
          _currentHasNextChecked = c._currentHasNextChecked;
          if (c.tailCell != null) {
            lastCell ??= c.lastCell;
            c.lastCell!.tailCell = tailCell;
            tailCell = c.tailCell;
          }
        }
      }

      // Advance current to the next non-empty iterator
      // current is set to null when all iterators are exhausted
      bool advance() {
        // due to lack of  tailrec
        while (true) {
          if (tailCell == null) {
            current = null;
            lastCell = null;
            return false;
          } else {
            current = tailCell!.headIterator;
            if (lastCell == tailCell) lastCell = lastCell!.tailCell;
            tailCell = tailCell!.tailCell;

            merge();

            if (_currentHasNextChecked) {
              return true;
            } else if (current != null && current!.hasNext) {
              _currentHasNextChecked = true;
              return true;
            }
          }
        }
      }

      return advance();
    }
  }

  @override
  A next() {
    if (hasNext) {
      _currentHasNextChecked = false;
      return current!.next();
    } else {
      noSuchElement();
    }
  }

  @override
  RibsIterator<A> concat(covariant IterableOnce<A> that) {
    final c = _ConcatIteratorCell(that, null);

    if (tailCell == null) {
      tailCell = c;
      lastCell = c;
    } else {
      lastCell!.tailCell = c;
      lastCell = c;
    }

    current ??= RibsIterator.empty();

    return this;
  }
}

final class _ConcatIteratorCell<A> {
  final IterableOnce<A> head;
  _ConcatIteratorCell<A>? tailCell;

  _ConcatIteratorCell(this.head, this.tailCell);

  RibsIterator<A> get headIterator => head.iterator;
}
