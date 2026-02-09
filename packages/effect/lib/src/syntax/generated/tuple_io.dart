part of '../io.dart';

/// Provides additional functions on a tuple of 2 [IO]s.
extension Tuple2IOOps<T1, T2> on (IO<T1>, IO<T2>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T3> mapN<T3>(Function2<T1, T2, T3> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T3> parMapN<T3>(Function2<T1, T2, T3> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2)> get tupled => $1.flatMap((a) => $2.map((b) => (a, b)));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2)> get parTupled => IO.both($1, $2);
}

/// Provides additional functions on a tuple of 3 [IO]s.
extension Tuple3IOOps<T1, T2, T3> on (IO<T1>, IO<T2>, IO<T3>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T4> mapN<T4>(Function3<T1, T2, T3, T4> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T4> parMapN<T4>(Function3<T1, T2, T3, T4> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3)> get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 4 [IO]s.
extension Tuple4IOOps<T1, T2, T3, T4> on (IO<T1>, IO<T2>, IO<T3>, IO<T4>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T5> parMapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 5 [IO]s.
extension Tuple5IOOps<T1, T2, T3, T4, T5> on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T6> parMapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 6 [IO]s.
extension Tuple6IOOps<T1, T2, T3, T4, T5, T6> on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T7> parMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 7 [IO]s.
extension Tuple7IOOps<T1, T2, T3, T4, T5, T6, T7>
    on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>, IO<T7>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T8> parMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 8 [IO]s.
extension Tuple8IOOps<T1, T2, T3, T4, T5, T6, T7, T8>
    on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>, IO<T7>, IO<T8>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T9> parMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 9 [IO]s.
extension Tuple9IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>, IO<T7>, IO<T8>, IO<T9>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T10> parMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 10 [IO]s.
extension Tuple10IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>, IO<T7>, IO<T8>, IO<T9>, IO<T10>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T11> parMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 11 [IO]s.
extension Tuple11IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on (IO<T1>, IO<T2>, IO<T3>, IO<T4>, IO<T5>, IO<T6>, IO<T7>, IO<T8>, IO<T9>, IO<T10>, IO<T11>) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T12> parMapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 12 [IO]s.
extension Tuple12IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T13> parMapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 13 [IO]s.
extension Tuple13IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T14> mapN<T14>(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T14> parMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 14 [IO]s.
extension Tuple14IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T15> parMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 15 [IO]s.
extension Tuple15IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T16> parMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 16 [IO]s.
extension Tuple16IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T17> parMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 17 [IO]s.
extension Tuple17IOOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    on
        (
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T18> parMapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)> get parTupled =>
      IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 18 [IO]s.
extension Tuple18IOOps<
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
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
          IO<T18>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T19> parMapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 19 [IO]s.
extension Tuple19IOOps<
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
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
          IO<T18>,
          IO<T19>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T20> mapN<T20>(
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

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T20> parMapN<T20>(
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
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 20 [IO]s.
extension Tuple20IOOps<
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
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
          IO<T18>,
          IO<T19>,
          IO<T20>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T21> mapN<T21>(
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

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T21> parMapN<T21>(
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
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)>
  get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 21 [IO]s.
extension Tuple21IOOps<
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
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
          IO<T18>,
          IO<T19>,
          IO<T20>,
          IO<T21>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T22> mapN<T22>(
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

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T22> parMapN<T22>(
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
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 22 [IO]s.
extension Tuple22IOOps<
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
          IO<T1>,
          IO<T2>,
          IO<T3>,
          IO<T4>,
          IO<T5>,
          IO<T6>,
          IO<T7>,
          IO<T8>,
          IO<T9>,
          IO<T10>,
          IO<T11>,
          IO<T12>,
          IO<T13>,
          IO<T14>,
          IO<T15>,
          IO<T16>,
          IO<T17>,
          IO<T18>,
          IO<T19>,
          IO<T20>,
          IO<T21>,
          IO<T22>,
        ) {
  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T23> mapN<T23>(
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

  /// Creates a new IO that applies [fn] to the values of each respective tuple
  /// member if all IOs succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<T23> parMapN<T23>(
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
  ) => parTupled.map(fn.tupled);

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  IO<
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

  /// Creates a new [IO] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  IO<
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
  get parTupled => IO.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}
