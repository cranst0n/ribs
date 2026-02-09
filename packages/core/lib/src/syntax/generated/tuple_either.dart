part of '../either.dart';

/// Provides additional functions on tuple with 2 [Either]s.
extension Tuple2EitherOps<E, T1, T2> on (Either<E, T1>, Either<E, T2>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T3> mapN<T3>(Function2<T1, T2, T3> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2)> get tupled => $1.flatMap((a) => $2.map((b) => (a, b)));
}

/// Provides additional functions on tuple with 3 [Either]s.
extension Tuple3EitherOps<E, T1, T2, T3> on (Either<E, T1>, Either<E, T2>, Either<E, T3>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T4> mapN<T4>(Function3<T1, T2, T3, T4> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 4 [Either]s.
extension Tuple4EitherOps<E, T1, T2, T3, T4>
    on (Either<E, T1>, Either<E, T2>, Either<E, T3>, Either<E, T4>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 5 [Either]s.
extension Tuple5EitherOps<E, T1, T2, T3, T4, T5>
    on (Either<E, T1>, Either<E, T2>, Either<E, T3>, Either<E, T4>, Either<E, T5>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 6 [Either]s.
extension Tuple6EitherOps<E, T1, T2, T3, T4, T5, T6>
    on (Either<E, T1>, Either<E, T2>, Either<E, T3>, Either<E, T4>, Either<E, T5>, Either<E, T6>) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 7 [Either]s.
extension Tuple7EitherOps<E, T1, T2, T3, T4, T5, T6, T7>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 8 [Either]s.
extension Tuple8EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 9 [Either]s.
extension Tuple9EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 10 [Either]s.
extension Tuple10EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 11 [Either]s.
extension Tuple11EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 12 [Either]s.
extension Tuple12EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn) =>
      tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 13 [Either]s.
extension Tuple13EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 14 [Either]s.
extension Tuple14EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 15 [Either]s.
extension Tuple15EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 16 [Either]s.
extension Tuple16EitherOps<E, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on
        (
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 17 [Either]s.
extension Tuple17EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 18 [Either]s.
extension Tuple18EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
          Either<E, T18>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => tupled.map(fn.tupled);

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 19 [Either]s.
extension Tuple19EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
          Either<E, T18>,
          Either<E, T19>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T20> mapN<T20>(
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

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<E, (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 20 [Either]s.
extension Tuple20EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
          Either<E, T18>,
          Either<E, T19>,
          Either<E, T20>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T21> mapN<T21>(
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

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 21 [Either]s.
extension Tuple21EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
          Either<E, T18>,
          Either<E, T19>,
          Either<E, T20>,
          Either<E, T21>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T22> mapN<T22>(
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

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<
    E,
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}

/// Provides additional functions on tuple with 22 [Either]s.
extension Tuple22EitherOps<
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
          Either<E, T1>,
          Either<E, T2>,
          Either<E, T3>,
          Either<E, T4>,
          Either<E, T5>,
          Either<E, T6>,
          Either<E, T7>,
          Either<E, T8>,
          Either<E, T9>,
          Either<E, T10>,
          Either<E, T11>,
          Either<E, T12>,
          Either<E, T13>,
          Either<E, T14>,
          Either<E, T15>,
          Either<E, T16>,
          Either<E, T17>,
          Either<E, T18>,
          Either<E, T19>,
          Either<E, T20>,
          Either<E, T21>,
          Either<E, T22>,
        ) {
  /// Applies [fn] to the values of each respective tuple member if all values
  /// are a [Right]. If **any** item is a [Left], the first [Left] encountered
  /// will be returned.
  Either<E, T23> mapN<T23>(
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

  /// If **all** items of this tuple are a [Right], the respective items are
  /// turned into a tuple and returned as a [Right]. If **any** item is a
  /// [Left], the first [Left] encountered is returned.
  Either<
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
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));
}
