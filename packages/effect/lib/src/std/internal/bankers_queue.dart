import 'package:ribs_core/ribs_core.dart';

/// A persistent, amortized double-ended queue backed by two [IList]s.
///
/// Elements are enqueued by prepending to the [back] list and dequeued from
/// the [front] list. When [front] becomes too small relative to [back], the
/// queue is rebalanced by redistributing elements across both lists, ensuring
/// O(1) amortized time for [pushBack], [pushFront], [tryPopFront], and
/// [tryPopBack].
///
/// The rebalancing invariant is maintained by [rebalance], which is called
/// automatically after every push operation. The invariant ensures that
/// neither list exceeds [RebalanceConstant] times the size of the other
/// (plus one).
final class BankersQueue<A> {
  /// The list from which elements are dequeued (head of the queue).
  final IList<A> front;

  /// The number of elements in [front].
  final int frontLen;

  /// The list to which elements are enqueued (tail of the queue), stored in
  /// reverse insertion order.
  final IList<A> back;

  /// The number of elements in [back].
  final int backLen;

  const BankersQueue(this.front, this.frontLen, this.back, this.backLen);

  /// Creates an empty [BankersQueue].
  static BankersQueue<A> empty<A>() => BankersQueue(nil(), 0, nil(), 0);

  /// Returns `true` if this queue contains no elements.
  bool get isEmpty => frontLen == 0 && backLen == 0;

  /// Returns `true` if this queue contains at least one element.
  bool get nonEmpty => frontLen > 0 || backLen > 0;

  /// Returns a new queue with [a] added to the front (head).
  BankersQueue<A> pushFront(A a) =>
      BankersQueue(front.prepended(a), frontLen + 1, back, backLen).rebalance();

  /// Returns a new queue with [a] added to the back (tail).
  BankersQueue<A> pushBack(A a) =>
      BankersQueue(front, frontLen, back.prepended(a), backLen + 1).rebalance();

  /// Returns the elements of this queue as an [IList] in FIFO order.
  IList<A> toList() => front.concat(back.reverse());

  /// Attempts to remove and return the front (oldest) element.
  ///
  /// Returns a tuple of the resulting queue and an [Option] containing the
  /// removed element, or [None] if the queue is empty.
  (BankersQueue<A>, Option<A>) tryPopFront() {
    if (frontLen > 0) {
      return (BankersQueue(front.tail, frontLen - 1, back, backLen).rebalance(), Some(front[0]));
    } else if (backLen > 0) {
      return (BankersQueue(front, frontLen, nil(), 0), Some(back[0]));
    } else {
      return (this, none());
    }
  }

  /// Attempts to remove and return the back (newest) element.
  ///
  /// Returns a tuple of the resulting queue and an [Option] containing the
  /// removed element, or [None] if the queue is empty.
  (BankersQueue<A>, Option<A>) tryPopBack() {
    if (backLen > 0) {
      return (
        BankersQueue(front, frontLen, back.tail, backLen - 1).rebalance(),
        Some(back[0]),
      );
    } else if (frontLen > 0) {
      return (BankersQueue(nil(), 0, back, backLen), Some(front[0]));
    } else {
      return (this, none());
    }
  }

  /// Returns a new queue with the [front] and [back] lists swapped,
  /// effectively reversing the logical order of elements.
  BankersQueue<A> reverse() => BankersQueue(back, backLen, front, frontLen);

  /// Restores the balance invariant between [front] and [back].
  ///
  /// If either list exceeds [RebalanceConstant] times the size of the other
  /// (plus one), elements are redistributed so that both lists have
  /// approximately equal length. This ensures amortized O(1) operations.
  BankersQueue<A> rebalance() {
    if (frontLen > RebalanceConstant * backLen + 1) {
      final i = (frontLen + backLen) ~/ 2;
      final j = frontLen + backLen - i;
      final f = front.take(i);
      final b = back.concat(front.drop(i).reverse());

      return BankersQueue(f, i, b, j);
    } else if (backLen > RebalanceConstant * frontLen + 1) {
      final i = (frontLen + backLen) ~/ 2;
      final j = frontLen + backLen - i;
      final f = front.concat(back.drop(j).reverse());
      final b = back.take(j);

      return BankersQueue(f, i, b, j);
    } else {
      return this;
    }
  }

  @override
  String toString() =>
      isEmpty ? 'Empty' : toList().mkString(start: 'BankersQueue(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is BankersQueue<A> && toList() == other.toList());

  @override
  int get hashCode => toList().hashCode;

  /// The maximum ratio allowed between [front] and [back] sizes before
  /// a [rebalance] is triggered.
  static const RebalanceConstant = 2;
}
