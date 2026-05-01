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

/// Provides additional functions on tuple with 6 [ValidatedNel]s.
extension Tuple6ValidatedNelOps<E, T1, T2, T3, T4, T5, T6>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 7 [ValidatedNel]s.
extension Tuple7ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 8 [ValidatedNel]s.
extension Tuple8ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 9 [ValidatedNel]s.
extension Tuple9ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 10 [ValidatedNel]s.
extension Tuple10ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 11 [ValidatedNel]s.
extension Tuple11ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T12> mapN<T12>(
    Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 12 [ValidatedNel]s.
extension Tuple12ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T13> mapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 13 [ValidatedNel]s.
extension Tuple13ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 14 [ValidatedNel]s.
extension Tuple14ValidatedNelOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 15 [ValidatedNel]s.
extension Tuple15ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get tupled =>
      init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 16 [ValidatedNel]s.
extension Tuple16ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 17 [ValidatedNel]s.
extension Tuple17ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 18 [ValidatedNel]s.
extension Tuple18ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
          ValidatedNel<E, T18>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 19 [ValidatedNel]s.
extension Tuple19ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
          ValidatedNel<E, T18>,
          ValidatedNel<E, T19>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T20> mapN<T20>(
    Function19<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20
    >
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  >
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 20 [ValidatedNel]s.
extension Tuple20ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
          ValidatedNel<E, T18>,
          ValidatedNel<E, T19>,
          ValidatedNel<E, T20>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T21> mapN<T21>(
    Function20<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21
    >
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 21 [ValidatedNel]s.
extension Tuple21ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20,
  T21
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
          ValidatedNel<E, T18>,
          ValidatedNel<E, T19>,
          ValidatedNel<E, T20>,
          ValidatedNel<E, T21>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T22> mapN<T22>(
    Function21<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22
    >
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on tuple with 22 [ValidatedNel]s.
extension Tuple22ValidatedNelOps<
  E,
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8,
  T9,
  T10,
  T11,
  T12,
  T13,
  T14,
  T15,
  T16,
  T17,
  T18,
  T19,
  T20,
  T21,
  T22
>
    on
        (
          ValidatedNel<E, T1>,
          ValidatedNel<E, T2>,
          ValidatedNel<E, T3>,
          ValidatedNel<E, T4>,
          ValidatedNel<E, T5>,
          ValidatedNel<E, T6>,
          ValidatedNel<E, T7>,
          ValidatedNel<E, T8>,
          ValidatedNel<E, T9>,
          ValidatedNel<E, T10>,
          ValidatedNel<E, T11>,
          ValidatedNel<E, T12>,
          ValidatedNel<E, T13>,
          ValidatedNel<E, T14>,
          ValidatedNel<E, T15>,
          ValidatedNel<E, T16>,
          ValidatedNel<E, T17>,
          ValidatedNel<E, T18>,
          ValidatedNel<E, T19>,
          ValidatedNel<E, T20>,
          ValidatedNel<E, T21>,
          ValidatedNel<E, T22>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Valid]. If **any** item is an [Invalid], the accumulation of all
  /// [Invalid] instances is returned.
  ValidatedNel<E, T23> mapN<T23>(
    Function22<
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
      T23
    >
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Valid], the respective items are
  /// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an
  /// [Invalid], the accumulation of all [Invalid] instances is returned.
  ValidatedNel<
    E,
    (
      T1,
      T2,
      T3,
      T4,
      T5,
      T6,
      T7,
      T8,
      T9,
      T10,
      T11,
      T12,
      T13,
      T14,
      T15,
      T16,
      T17,
      T18,
      T19,
      T20,
      T21,
      T22,
    )
  >
  get tupled => init.tupled.product(last).map((t) => t.$1.appended(t.$2));
}
