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

/// Provides additional functions on a tuple of 6 Options.
extension Tuple6OptionOps<T1, T2, T3, T4, T5, T6>
    on (Option<T1>, Option<T2>, Option<T3>, Option<T4>, Option<T5>, Option<T6>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 7 Options.
extension Tuple7OptionOps<T1, T2, T3, T4, T5, T6, T7>
    on (Option<T1>, Option<T2>, Option<T3>, Option<T4>, Option<T5>, Option<T6>, Option<T7>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 8 Options.
extension Tuple8OptionOps<T1, T2, T3, T4, T5, T6, T7, T8>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 9 Options.
extension Tuple9OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 10 Options.
extension Tuple10OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 11 Options.
extension Tuple11OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 12 Options.
extension Tuple12OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 13 Options.
extension Tuple13OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 14 Options.
extension Tuple14OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 15 Options.
extension Tuple15OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 16 Options.
extension Tuple16OptionOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on
        (
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 17 Options.
extension Tuple17OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 18 Options.
extension Tuple18OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
          Option<T18>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 19 Options.
extension Tuple19OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
          Option<T18>,
          Option<T19>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T20> mapN<T20>(
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

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 20 Options.
extension Tuple20OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
          Option<T18>,
          Option<T19>,
          Option<T20>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T21> mapN<T21>(
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

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 21 Options.
extension Tuple21OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
          Option<T18>,
          Option<T19>,
          Option<T20>,
          Option<T21>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T22> mapN<T22>(
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

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on a tuple of 22 Options.
extension Tuple22OptionOps<
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
          Option<T1>,
          Option<T2>,
          Option<T3>,
          Option<T4>,
          Option<T5>,
          Option<T6>,
          Option<T7>,
          Option<T8>,
          Option<T9>,
          Option<T10>,
          Option<T11>,
          Option<T12>,
          Option<T13>,
          Option<T14>,
          Option<T15>,
          Option<T16>,
          Option<T17>,
          Option<T18>,
          Option<T19>,
          Option<T20>,
          Option<T21>,
          Option<T22>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Some]. If **any** item is a [None], [None] will be returned.
  Option<T23> mapN<T23>(
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

  /// If **all** items of this tuple are a [Some], the respective items are
  /// turned into a tuple and returned as a [Some]. If **any** item is a
  Option<
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
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}
