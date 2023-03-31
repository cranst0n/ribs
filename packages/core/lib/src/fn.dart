import 'package:ribs_core/ribs_core.dart';

final class Fn0<A> {
  final Function0<A> f;

  const Fn0(this.f);

  A call() => f();

  @override
  String toString() => '() -> $A';
}

final class Fn1<A, B> {
  final Function1<A, B> f;

  const Fn1(this.f);

  B call(A a) => f(a);

  @override
  String toString() => '$A -> $B';
}
