import 'package:ribs_core/src/function.dart';

final intOrder = Order.from((int a, int b) => a.compareTo(b));
final doubleOrder = Order.from((double a, double b) => a.compareTo(b));
final stringOrder = Order.from((String a, String b) => a.compareTo(b));

abstract class Order<A> {
  const Order();

  factory Order.from(Function2<A, A, int> f) => OrderF(f);

  int compare(A x, A y);

  A max(A x, A y) => gt(x, y) ? x : y;

  A min(A x, A y) => lt(x, y) ? x : y;

  bool eqv(A x, A y) => compare(x, y) == 0;

  bool neqv(A x, A y) => !eqv(x, y);

  bool lteqv(A x, A y) => compare(x, y) <= 0;

  bool lt(A x, A y) => compare(x, y) < 0;

  bool gteqv(A x, A y) => compare(x, y) >= 0;

  bool gt(A x, A y) => compare(x, y) > 0;

  Order<A> reverse() => OrderF((a, b) => compare(b, a));
}

final class OrderF<A> extends Order<A> {
  final Function2<A, A, int> compareTo;

  const OrderF(this.compareTo);

  @override
  int compare(A x, A y) => compareTo(x, y);
}
