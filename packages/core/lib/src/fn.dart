import 'package:ribs_core/ribs_core.dart';

/// Nominal wrappers around Dart function types.
///
/// Dart function types and class types have different variance rules, and this
/// difference matters when building an interpreted ADT like `IO`.
///
/// Dart function types follow standard function subtyping: they are
/// contravariant in their parameter types and covariant in their return
/// type. `String Function(Object)` is a subtype of `String Function(String)`,
/// because a function that accepts any `Object` can safely stand in for one
/// that only accepts `String`.
///
/// This means that Dart enforces function signatures at runtime on casts.
/// If you store a `String Function(String)` as `Object` and later try to cast
/// it to `dynamic Function(dynamic)`, Dart will throw a `CastError` because
/// the two types are not in a subtype relationship in the parameter position.
///
/// Class instances in Dart carry only their erased type at runtime.
/// A cast `value as Fn1` checks only "is this an instance of `Fn1`?" — it
/// does not check the type arguments `A` or `B`. The cast succeeds
/// regardless of the concrete types stored in those parameters, yielding a
/// `Fn1<dynamic, dynamic>`. Calling the result then invokes the underlying
/// function, which performs its own checked cast internally.
///
/// In short, `Fn0`, `Fn1`, and `Fn2` exist to give functions class-like
/// variance behaviour so they can live safely in a heterogeneous,
/// type-erased collection without violating Dart's runtime type system.

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

final class Fn2<A, B, C> {
  final Function2<A, B, C> f;

  const Fn2(this.f);

  C call(A a, B b) => f(a, b);

  @override
  String toString() => '($A, $B) -> $C';
}
