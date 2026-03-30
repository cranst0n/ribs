part of '../validated.dart';

/// Provides additional functions on tuple with 2 [ValidatedNel]s.
extension Tuple2ValidatedNelOps<E, T1, T2> on (ValidatedNel<E, T1>, ValidatedNel<E, T2>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T3> mapN<T3>(Function2<T1, T2, T3> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2)> get tupled => $1.product($2);
}

/// Provides additional functions on tuple with 3 [ValidatedNel]s.
extension Tuple3ValidatedNelOps<E, T1, T2, T3>
    on (ValidatedNel<E, T1>, ValidatedNel<E, T2>, ValidatedNel<E, T3>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T4> mapN<T4>(Function3<T1, T2, T3, T4> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 4 [ValidatedNel]s.
extension Tuple4ValidatedNelOps<E, T1, T2, T3, T4>
    on (ValidatedNel<E, T1>, ValidatedNel<E, T2>, ValidatedNel<E, T3>, ValidatedNel<E, T4>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 5 [ValidatedNel]s.
extension Tuple5ValidatedNelOps<E, T1, T2, T3, T4, T5>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}
