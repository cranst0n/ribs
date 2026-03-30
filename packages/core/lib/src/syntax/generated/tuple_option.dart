part of '../option.dart';

/// Provides additional functions on a tuple of 2 Options.
extension Tuple2OptionOps<T1, T2> on (Option<T1>, Option<T2>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T3> mapN<T3>(Function2<T1, T2, T3> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2)> get tupled => $1.flatMap((a) => $2.map((b) => (a, b)));
}

/// Provides additional functions on a tuple of 3 Options.
extension Tuple3OptionOps<T1, T2, T3> on (Option<T1>, Option<T2>, Option<T3>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T4> mapN<T4>(Function3<T1, T2, T3, T4> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 4 Options.
extension Tuple4OptionOps<T1, T2, T3, T4> on (Option<T1>, Option<T2>, Option<T3>, Option<T4>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 5 Options.
extension Tuple5OptionOps<T1, T2, T3, T4, T5>
    on (Option<T1>, Option<T2>, Option<T3>, Option<T4>, Option<T5>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}
