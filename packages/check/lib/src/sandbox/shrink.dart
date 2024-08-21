import 'package:ribs_core/ribs_core.dart';

sealed class Shrink<T> {
  static Shrink<int> integer = _ShrinkInteger();

  ILazyList<T> shrink(T x);

  Shrink<T> suchThat(Function1<T, bool> p) =>
      _ShrinkImpl((t) => shrink(t).filter(p));
}

final class _ShrinkImpl<T> extends Shrink<T> {
  final Function1<T, ILazyList<T>> f;

  _ShrinkImpl(this.f);

  @override
  ILazyList<T> shrink(T x) => f(x);
}

final class _ShrinkInteger extends Shrink<int> {
  @override
  ILazyList<int> shrink(int x) {
    if (x == 0) {
      return ILazyList.empty();
    } else {
      return _halves(x);
    }
  }

  ILazyList<int> _halves(int x) {
    final q = x ~/ 2;

    if (q == 0) {
      return ILazyList.empty();
    } else {
      return ILazyList.from(ilist([q]))
          .lazyAppendedAll(() => ILazyList.from(ilist([-q])))
          .lazyAppendedAll(() => _halves(q));
    }
  }
}
