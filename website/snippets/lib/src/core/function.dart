import 'package:ribs_core/ribs_core.dart';

// #region aliases-1
typedef Function1<A, B> = B Function(A);
typedef Function2<A, B, C> = C Function(A, B);

// These 2 function signatures are identical
int dartFun(String Function(double) f) => throw UnimplementedError();
int ribsFun(Function1<double, String> f) => throw UnimplementedError();
// #endregion aliases-1

// #region andThen-1
int addOne(int x) => x + 1;
int doubleIt(int x) => x * 2;

final addOneThenDouble = addOne.andThen(doubleIt);

final a = addOneThenDouble(0); // (0 + 1) * 2 == 2
final b = addOneThenDouble(2); // (2 + 1) * 2 == 6
// #endregion andThen-1

// #region compose-1
final doubleItThenAddOne = addOne.compose(doubleIt);

final c = doubleItThenAddOne(0); // (0 * 2) + 1 == 1
final d = doubleItThenAddOne(2); // (2 * 2) + 1 == 5
// #endregion compose-1

// #region currying-1
// Converts a function from:
//     (A, B) => C
// to:
//     A => B => C
Function1<A, Function1<B, C>> curryFn<A, B, C>(Function2<A, B, C> f) =>
    throw UnimplementedError('???');
// #endregion currying-1

// #region curryFn-impl
Function1<A, Function1<B, C>> curryFnImpl<A, B, C>(Function2<A, B, C> f) => (a) => (b) => f(a, b);
// #endregion curryFn-impl

// #region currying-2
int add2(int a, int b) => a + b;

// Ribs also provides type aliases for curried functions that take the form
// of FunctionNC, where the 'C' denotes the function is curried.
final Function2C<int, int, int> add2Curried = add2.curried;
// #endregion currying-2

// #region currying-3
int add3(int a, int b, int c) => a + b + c;

final Function3C<int, int, int, int> add3Curried = add3.curried;
final Function3<int, int, int, int> add3Uncurried = add3Curried.uncurried;
// #endregion currying-3

// #region tupled-1
int fun(int a, String b, bool c) => throw UnimplementedError();

Function1<(int, String, bool), int> funTupled = fun.tupled;

final result = funTupled((2, 'Hello!', false));
// #endregion tupled-1
