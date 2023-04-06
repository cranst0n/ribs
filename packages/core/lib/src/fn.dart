import 'package:ribs_core/ribs_core.dart';

class Fn0<A> {
  final Function0<A> f;

  const Fn0(this.f);

  A call() => f();

  @override
  String toString() => '() -> $A';
}

class Fn1F<A, B> extends Fn1<A, B> {
  final Function1<A, B> f;

  Fn1F._(this.f);

  @override
  B call(A a) => f(a);

  @override
  String toString() => '$A -> $B';
}

abstract mixin class Fn1<A, B> {
  static Fn1<A, B> of<A, B>(Function1<A, B> f) => Fn1F._(f);

  B call(A a);

  @override
  String toString() => '$A -> $B';
}
