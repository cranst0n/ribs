import 'package:ribs_core/ribs_core.dart';

final class BankersQueue<A> {
  final IList<A> front;
  final int frontLen;
  final IList<A> back;
  final int backLen;

  const BankersQueue(this.front, this.frontLen, this.back, this.backLen);

  static BankersQueue<A> empty<A>() => BankersQueue(nil(), 0, nil(), 0);

  bool get nonEmpty => frontLen > 0 || backLen > 0;

  BankersQueue<A> pushFront(A a) =>
      BankersQueue(front.prepended(a), frontLen + 1, back, backLen).rebalance();

  BankersQueue<A> pushBack(A a) =>
      BankersQueue(front, frontLen, back.prepended(a), backLen + 1).rebalance();

  (BankersQueue<A>, Option<A>) tryPopFront() {
    if (frontLen > 0) {
      return (BankersQueue(front.tail, frontLen - 1, back, backLen).rebalance(), Some(front[0]));
    } else if (backLen > 0) {
      return (BankersQueue(front, frontLen, nil(), 0), Some(back[0]));
    } else {
      return (this, none());
    }
  }

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

  BankersQueue<A> reverse() => BankersQueue(back, backLen, front, frontLen);

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

  static const RebalanceConstant = 2;
}
