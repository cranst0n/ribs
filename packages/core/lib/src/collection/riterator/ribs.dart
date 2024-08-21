part of '../riterator.dart';

class _RibsIterator<A> implements Iterator<A> {
  final RIterator<A> rit;

  late A currentValue;

  _RibsIterator(this.rit);

  @override
  A get current => currentValue;

  @override
  bool moveNext() {
    if (rit.hasNext) {
      currentValue = rit.next();
      return true;
    } else {
      return false;
    }
  }
}
