part of '../resource.dart';

/// Provides additional functions on a tuple of 2 [Resource]s.
extension Tuple2ResourceOps<T1, T2> on (Resource<T1>, Resource<T2>) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T3> mapN<T3>(Function2<T1, T2, T3> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T3> parMapN<T3>(Function2<T1, T2, T3> fn) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2)> get tupled => $1.flatMap((a) => $2.map((b) => (a, b)));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2)> get parTupled => Resource.both($1, $2);
}

/// Provides additional functions on a tuple of 3 [Resource]s.
extension Tuple3ResourceOps<T1, T2, T3> on (Resource<T1>, Resource<T2>, Resource<T3>) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T4> mapN<T4>(Function3<T1, T2, T3, T4> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T4> parMapN<T4>(Function3<T1, T2, T3, T4> fn) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 4 [Resource]s.
extension Tuple4ResourceOps<T1, T2, T3, T4>
    on (Resource<T1>, Resource<T2>, Resource<T3>, Resource<T4>) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T5> mapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T5> parMapN<T5>(Function4<T1, T2, T3, T4, T5> fn) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 5 [Resource]s.
extension Tuple5ResourceOps<T1, T2, T3, T4, T5>
    on (Resource<T1>, Resource<T2>, Resource<T3>, Resource<T4>, Resource<T5>) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T6> mapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T6> parMapN<T6>(Function5<T1, T2, T3, T4, T5, T6> fn) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 6 [Resource]s.
extension Tuple6ResourceOps<T1, T2, T3, T4, T5, T6>
    on (Resource<T1>, Resource<T2>, Resource<T3>, Resource<T4>, Resource<T5>, Resource<T6>) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T7> mapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T7> parMapN<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> fn) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6)> get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 7 [Resource]s.
extension Tuple7ResourceOps<T1, T2, T3, T4, T5, T6, T7>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T8> mapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T8> parMapN<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 8 [Resource]s.
extension Tuple8ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T9> mapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T9> parMapN<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 9 [Resource]s.
extension Tuple9ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T10> mapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T10> parMapN<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 10 [Resource]s.
extension Tuple10ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T11> mapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T11> parMapN<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 11 [Resource]s.
extension Tuple11ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T12> mapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T12> parMapN<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> fn) =>
      parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 12 [Resource]s.
extension Tuple12ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T13> mapN<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn) =>
      tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T13> parMapN<T13>(
    Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 13 [Resource]s.
extension Tuple13ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T14> mapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T14> parMapN<T14>(
    Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 14 [Resource]s.
extension Tuple14ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T15> mapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T15> parMapN<T15>(
    Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 15 [Resource]s.
extension Tuple15ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T16> mapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T16> parMapN<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 16 [Resource]s.
extension Tuple16ResourceOps<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on
        (
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T17> mapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T17> parMapN<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get tupled =>
      init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> get parTupled =>
      Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 17 [Resource]s.
extension Tuple17ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T18> mapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T18> parMapN<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 18 [Resource]s.
extension Tuple18ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
          Resource<T18>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T19> mapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => tupled.map(fn.tupled);

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T19> parMapN<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    fn,
  ) => parTupled.map(fn.tupled);

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)>
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 19 [Resource]s.
extension Tuple19ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
          Resource<T18>,
          Resource<T19>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T20> mapN<T20>(
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

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T20> parMapN<T20>(
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

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)>
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 20 [Resource]s.
extension Tuple20ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
          Resource<T18>,
          Resource<T19>,
          Resource<T20>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T21> mapN<T21>(
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

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T21> parMapN<T21>(
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

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 21 [Resource]s.
extension Tuple21ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
          Resource<T18>,
          Resource<T19>,
          Resource<T20>,
          Resource<T21>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T22> mapN<T22>(
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

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T22> parMapN<T22>(
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

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get tupled => init.tupled.flatMap((x) => last.map(x.appended));

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<
    (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  >
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}

/// Provides additional functions on a tuple of 22 [Resource]s.
extension Tuple22ResourceOps<
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
          Resource<T1>,
          Resource<T2>,
          Resource<T3>,
          Resource<T4>,
          Resource<T5>,
          Resource<T6>,
          Resource<T7>,
          Resource<T8>,
          Resource<T9>,
          Resource<T10>,
          Resource<T11>,
          Resource<T12>,
          Resource<T13>,
          Resource<T14>,
          Resource<T15>,
          Resource<T16>,
          Resource<T17>,
          Resource<T18>,
          Resource<T19>,
          Resource<T20>,
          Resource<T21>,
          Resource<T22>,
        ) {
  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T23> mapN<T23>(
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

  /// Creates a new Resource that applies [fn] to the values of each respective tuple
  /// member if all Resources succeed. If **any** item fails or is canceled, the
  /// first instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<T23> parMapN<T23>(
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

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Each item is evaluated
  /// synchronously.
  Resource<
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

  /// Creates a new [Resource] that will return the tuple of all items if they all
  /// evaluate successfully. If **any** item fails or is canceled, the first
  /// instance encountered will be returned. Items are evaluated
  /// asynchronously.
  Resource<
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
  get parTupled => Resource.both(init.parTupled, last).map((t) => t.$1.appended(t.$2));
}
