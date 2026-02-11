part of '../function.dart';

/// Provides additional functions on functions with 0 parameters.
extension Function0Ops<T0> on Function0<T0> {
  /// Composes this function with the provided function, this function being applied first.
  Function0<T1> andThen<T1>(Function1<T0, T1> fn) => () => fn(this());
}

/// Provides additional functions on functions with 1 parameters.
extension Function1Ops<T0, T1> on Function1<T0, T1> {
  /// Composes this function with the provided function, this function being applied first.
  Function1<T0, T2> andThen<T2>(Function1<T1, T2> fn) => (t0) => fn(this(t0));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T2, T1> compose<T2>(Function1<T2, T0> fn) => (t2) => this(fn(t2));
}

/// Provides additional functions on functions with 2 parameters.
extension Function2Ops<T0, T1, T2> on Function2<T0, T1, T2> {
  /// Composes this function with the provided function, this function being applied first.
  Function2<T0, T1, T3> andThen<T3>(Function1<T2, T3> fn) => (t0, t1) => fn(this(t0, t1));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T3, T2> compose<T3>(Function1<T3, (T0, T1)> fn) => (t3) => tupled(fn(t3));

  /// Return the curried form of this function.
  Function2C<T0, T1, T2> get curried => (t0) => (t1) => this(t0, t1);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1), T2> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 3 parameters.
extension Function3Ops<T0, T1, T2, T3> on Function3<T0, T1, T2, T3> {
  /// Composes this function with the provided function, this function being applied first.
  Function3<T0, T1, T2, T4> andThen<T4>(Function1<T3, T4> fn) =>
      (t0, t1, t2) => fn(this(t0, t1, t2));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T4, T3> compose<T4>(Function1<T4, (T0, T1, T2)> fn) => (t4) => tupled(fn(t4));

  /// Return the curried form of this function.
  Function3C<T0, T1, T2, T3> get curried => (t0) => (t1) => (t2) => this(t0, t1, t2);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2), T3> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 4 parameters.
extension Function4Ops<T0, T1, T2, T3, T4> on Function4<T0, T1, T2, T3, T4> {
  /// Composes this function with the provided function, this function being applied first.
  Function4<T0, T1, T2, T3, T5> andThen<T5>(Function1<T4, T5> fn) =>
      (t0, t1, t2, t3) => fn(this(t0, t1, t2, t3));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T5, T4> compose<T5>(Function1<T5, (T0, T1, T2, T3)> fn) => (t5) => tupled(fn(t5));

  /// Return the curried form of this function.
  Function4C<T0, T1, T2, T3, T4> get curried =>
      (t0) => (t1) => (t2) => (t3) => this(t0, t1, t2, t3);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3), T4> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 5 parameters.
extension Function5Ops<T0, T1, T2, T3, T4, T5> on Function5<T0, T1, T2, T3, T4, T5> {
  /// Composes this function with the provided function, this function being applied first.
  Function5<T0, T1, T2, T3, T4, T6> andThen<T6>(Function1<T5, T6> fn) =>
      (t0, t1, t2, t3, t4) => fn(this(t0, t1, t2, t3, t4));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T6, T5> compose<T6>(Function1<T6, (T0, T1, T2, T3, T4)> fn) => (t6) => tupled(fn(t6));

  /// Return the curried form of this function.
  Function5C<T0, T1, T2, T3, T4, T5> get curried =>
      (t0) => (t1) => (t2) => (t3) => (t4) => this(t0, t1, t2, t3, t4);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4), T5> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 6 parameters.
extension Function6Ops<T0, T1, T2, T3, T4, T5, T6> on Function6<T0, T1, T2, T3, T4, T5, T6> {
  /// Composes this function with the provided function, this function being applied first.
  Function6<T0, T1, T2, T3, T4, T5, T7> andThen<T7>(Function1<T6, T7> fn) =>
      (t0, t1, t2, t3, t4, t5) => fn(this(t0, t1, t2, t3, t4, t5));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T7, T6> compose<T7>(Function1<T7, (T0, T1, T2, T3, T4, T5)> fn) =>
      (t7) => tupled(fn(t7));

  /// Return the curried form of this function.
  Function6C<T0, T1, T2, T3, T4, T5, T6> get curried =>
      (t0) => (t1) => (t2) => (t3) => (t4) => (t5) => this(t0, t1, t2, t3, t4, t5);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5), T6> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 7 parameters.
extension Function7Ops<T0, T1, T2, T3, T4, T5, T6, T7>
    on Function7<T0, T1, T2, T3, T4, T5, T6, T7> {
  /// Composes this function with the provided function, this function being applied first.
  Function7<T0, T1, T2, T3, T4, T5, T6, T8> andThen<T8>(Function1<T7, T8> fn) =>
      (t0, t1, t2, t3, t4, t5, t6) => fn(this(t0, t1, t2, t3, t4, t5, t6));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T8, T7> compose<T8>(Function1<T8, (T0, T1, T2, T3, T4, T5, T6)> fn) =>
      (t8) => tupled(fn(t8));

  /// Return the curried form of this function.
  Function7C<T0, T1, T2, T3, T4, T5, T6, T7> get curried =>
      (t0) => (t1) => (t2) => (t3) => (t4) => (t5) => (t6) => this(t0, t1, t2, t3, t4, t5, t6);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6), T7> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 8 parameters.
extension Function8Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8>
    on Function8<T0, T1, T2, T3, T4, T5, T6, T7, T8> {
  /// Composes this function with the provided function, this function being applied first.
  Function8<T0, T1, T2, T3, T4, T5, T6, T7, T9> andThen<T9>(Function1<T8, T9> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7) => fn(this(t0, t1, t2, t3, t4, t5, t6, t7));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T9, T8> compose<T9>(Function1<T9, (T0, T1, T2, T3, T4, T5, T6, T7)> fn) =>
      (t9) => tupled(fn(t9));

  /// Return the curried form of this function.
  Function8C<T0, T1, T2, T3, T4, T5, T6, T7, T8> get curried =>
      (t0) =>
          (t1) =>
              (t2) => (t3) => (t4) => (t5) => (t6) => (t7) => this(t0, t1, t2, t3, t4, t5, t6, t7);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7), T8> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 9 parameters.
extension Function9Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Function9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
  /// Composes this function with the provided function, this function being applied first.
  Function9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T10> andThen<T10>(Function1<T9, T10> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8) => fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T10, T9> compose<T10>(Function1<T10, (T0, T1, T2, T3, T4, T5, T6, T7, T8)> fn) =>
      (t10) => tupled(fn(t10));

  /// Return the curried form of this function.
  Function9C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) => (t6) => (t7) => (t8) => this(t0, t1, t2, t3, t4, t5, t6, t7, t8);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8), T9> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 10 parameters.
extension Function10Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Function10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> {
  /// Composes this function with the provided function, this function being applied first.
  Function10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T11> andThen<T11>(Function1<T10, T11> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9) => fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T11, T10> compose<T11>(Function1<T11, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> fn) =>
      (t11) => tupled(fn(t11));

  /// Return the curried form of this function.
  Function10C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) => (t9) => this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9), T10> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 11 parameters.
extension Function11Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Function11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> {
  /// Composes this function with the provided function, this function being applied first.
  Function11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T12> andThen<T12>(
    Function1<T11, T12> fn,
  ) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T12, T11> compose<T12>(
    Function1<T12, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> fn,
  ) => (t12) => tupled(fn(t12));

  /// Return the curried form of this function.
  Function11C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10);

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10), T11> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 12 parameters.
extension Function12Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Function12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> {
  /// Composes this function with the provided function, this function being applied first.
  Function12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T13> andThen<T13>(
    Function1<T12, T13> fn,
  ) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T13, T12> compose<T13>(
    Function1<T13, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> fn,
  ) => (t13) => tupled(fn(t13));

  /// Return the curried form of this function.
  Function12C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) => this(
                                                    t0,
                                                    t1,
                                                    t2,
                                                    t3,
                                                    t4,
                                                    t5,
                                                    t6,
                                                    t7,
                                                    t8,
                                                    t9,
                                                    t10,
                                                    t11,
                                                  );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11), T12> get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 13 parameters.
extension Function13Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Function13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> {
  /// Composes this function with the provided function, this function being applied first.
  Function13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T14> andThen<T14>(
    Function1<T13, T14> fn,
  ) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T14, T13> compose<T14>(
    Function1<T14, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> fn,
  ) => (t14) => tupled(fn(t14));

  /// Return the curried form of this function.
  Function13C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) => this(
                                                        t0,
                                                        t1,
                                                        t2,
                                                        t3,
                                                        t4,
                                                        t5,
                                                        t6,
                                                        t7,
                                                        t8,
                                                        t9,
                                                        t10,
                                                        t11,
                                                        t12,
                                                      );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12), T13> get tupled =>
      (t) => t(this);
}

/// Provides additional functions on functions with 14 parameters.
extension Function14Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Function14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> {
  /// Composes this function with the provided function, this function being applied first.
  Function14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T15> andThen<T15>(
    Function1<T14, T15> fn,
  ) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T15, T14> compose<T15>(
    Function1<T15, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> fn,
  ) => (t15) => tupled(fn(t15));

  /// Return the curried form of this function.
  Function14C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) => this(
                                                            t0,
                                                            t1,
                                                            t2,
                                                            t3,
                                                            t4,
                                                            t5,
                                                            t6,
                                                            t7,
                                                            t8,
                                                            t9,
                                                            t10,
                                                            t11,
                                                            t12,
                                                            t13,
                                                          );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13), T14> get tupled =>
      (t) => t(this);
}

/// Provides additional functions on functions with 15 parameters.
extension Function15Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Function15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> {
  /// Composes this function with the provided function, this function being applied first.
  Function15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T16> andThen<T16>(
    Function1<T15, T16> fn,
  ) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T16, T15> compose<T16>(
    Function1<T16, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> fn,
  ) => (t16) => tupled(fn(t16));

  /// Return the curried form of this function.
  Function15C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) => this(
                                                                t0,
                                                                t1,
                                                                t2,
                                                                t3,
                                                                t4,
                                                                t5,
                                                                t6,
                                                                t7,
                                                                t8,
                                                                t9,
                                                                t10,
                                                                t11,
                                                                t12,
                                                                t13,
                                                                t14,
                                                              );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14), T15> get tupled =>
      (t) => t(this);
}

/// Provides additional functions on functions with 16 parameters.
extension Function16Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Function16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> {
  /// Composes this function with the provided function, this function being applied first.
  Function16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T17>
  andThen<T17>(Function1<T16, T17> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T17, T16> compose<T17>(
    Function1<T17, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> fn,
  ) => (t17) => tupled(fn(t17));

  /// Return the curried form of this function.
  Function16C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) => this(
                                                                    t0,
                                                                    t1,
                                                                    t2,
                                                                    t3,
                                                                    t4,
                                                                    t5,
                                                                    t6,
                                                                    t7,
                                                                    t8,
                                                                    t9,
                                                                    t10,
                                                                    t11,
                                                                    t12,
                                                                    t13,
                                                                    t14,
                                                                    t15,
                                                                  );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15), T16>
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 17 parameters.
extension Function17Ops<
  T0,
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
    on Function17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> {
  /// Composes this function with the provided function, this function being applied first.
  Function17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T18>
  andThen<T18>(Function1<T17, T18> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T18, T17> compose<T18>(
    Function1<T18, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)> fn,
  ) => (t18) => tupled(fn(t18));

  /// Return the curried form of this function.
  Function17C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) => this(
                                                                        t0,
                                                                        t1,
                                                                        t2,
                                                                        t3,
                                                                        t4,
                                                                        t5,
                                                                        t6,
                                                                        t7,
                                                                        t8,
                                                                        t9,
                                                                        t10,
                                                                        t11,
                                                                        t12,
                                                                        t13,
                                                                        t14,
                                                                        t15,
                                                                        t16,
                                                                      );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16), T17>
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 18 parameters.
extension Function18Ops<
  T0,
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
        Function18<
          T0,
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
        > {
  /// Composes this function with the provided function, this function being applied first.
  Function18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T19>
  andThen<T19>(Function1<T18, T19> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17) =>
          fn(this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17));

  /// Composes this function with the provided function, this function being applied first.
  Function1<T19, T18> compose<T19>(
    Function1<T19, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
    fn,
  ) => (t19) => tupled(fn(t19));

  /// Return the curried form of this function.
  Function18C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) =>
                                                                          (t17) => this(
                                                                            t0,
                                                                            t1,
                                                                            t2,
                                                                            t3,
                                                                            t4,
                                                                            t5,
                                                                            t6,
                                                                            t7,
                                                                            t8,
                                                                            t9,
                                                                            t10,
                                                                            t11,
                                                                            t12,
                                                                            t13,
                                                                            t14,
                                                                            t15,
                                                                            t16,
                                                                            t17,
                                                                          );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17), T18>
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 19 parameters.
extension Function19Ops<
  T0,
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
        Function19<
          T0,
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
        > {
  /// Composes this function with the provided function, this function being applied first.
  Function19<
    T0,
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
    T20
  >
  andThen<T20>(Function1<T19, T20> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18) => fn(
        this(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18),
      );

  /// Composes this function with the provided function, this function being applied first.
  Function1<T20, T19> compose<T20>(
    Function1<
      T20,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
    >
    fn,
  ) => (t20) => tupled(fn(t20));

  /// Return the curried form of this function.
  Function19C<
    T0,
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
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) =>
                                                                          (t17) =>
                                                                              (t18) => this(
                                                                                t0,
                                                                                t1,
                                                                                t2,
                                                                                t3,
                                                                                t4,
                                                                                t5,
                                                                                t6,
                                                                                t7,
                                                                                t8,
                                                                                t9,
                                                                                t10,
                                                                                t11,
                                                                                t12,
                                                                                t13,
                                                                                t14,
                                                                                t15,
                                                                                t16,
                                                                                t17,
                                                                                t18,
                                                                              );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18),
    T19
  >
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 20 parameters.
extension Function20Ops<
  T0,
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
        Function20<
          T0,
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
        > {
  /// Composes this function with the provided function, this function being applied first.
  Function20<
    T0,
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
    T21
  >
  andThen<T21>(Function1<T20, T21> fn) =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19) =>
          fn(
            this(
              t0,
              t1,
              t2,
              t3,
              t4,
              t5,
              t6,
              t7,
              t8,
              t9,
              t10,
              t11,
              t12,
              t13,
              t14,
              t15,
              t16,
              t17,
              t18,
              t19,
            ),
          );

  /// Composes this function with the provided function, this function being applied first.
  Function1<T21, T20> compose<T21>(
    Function1<
      T21,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
    >
    fn,
  ) => (t21) => tupled(fn(t21));

  /// Return the curried form of this function.
  Function20C<
    T0,
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
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) =>
                                                                          (t17) =>
                                                                              (t18) =>
                                                                                  (t19) => this(
                                                                                    t0,
                                                                                    t1,
                                                                                    t2,
                                                                                    t3,
                                                                                    t4,
                                                                                    t5,
                                                                                    t6,
                                                                                    t7,
                                                                                    t8,
                                                                                    t9,
                                                                                    t10,
                                                                                    t11,
                                                                                    t12,
                                                                                    t13,
                                                                                    t14,
                                                                                    t15,
                                                                                    t16,
                                                                                    t17,
                                                                                    t18,
                                                                                    t19,
                                                                                  );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19),
    T20
  >
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 21 parameters.
extension Function21Ops<
  T0,
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
        Function21<
          T0,
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
        > {
  /// Composes this function with the provided function, this function being applied first.
  Function21<
    T0,
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
    T22
  >
  andThen<T22>(Function1<T21, T22> fn) =>
      (
        t0,
        t1,
        t2,
        t3,
        t4,
        t5,
        t6,
        t7,
        t8,
        t9,
        t10,
        t11,
        t12,
        t13,
        t14,
        t15,
        t16,
        t17,
        t18,
        t19,
        t20,
      ) => fn(
        this(
          t0,
          t1,
          t2,
          t3,
          t4,
          t5,
          t6,
          t7,
          t8,
          t9,
          t10,
          t11,
          t12,
          t13,
          t14,
          t15,
          t16,
          t17,
          t18,
          t19,
          t20,
        ),
      );

  /// Composes this function with the provided function, this function being applied first.
  Function1<T22, T21> compose<T22>(
    Function1<
      T22,
      (
        T0,
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
      )
    >
    fn,
  ) => (t22) => tupled(fn(t22));

  /// Return the curried form of this function.
  Function21C<
    T0,
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
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) =>
                                                                          (t17) =>
                                                                              (t18) =>
                                                                                  (t19) =>
                                                                                      (t20) => this(
                                                                                        t0,
                                                                                        t1,
                                                                                        t2,
                                                                                        t3,
                                                                                        t4,
                                                                                        t5,
                                                                                        t6,
                                                                                        t7,
                                                                                        t8,
                                                                                        t9,
                                                                                        t10,
                                                                                        t11,
                                                                                        t12,
                                                                                        t13,
                                                                                        t14,
                                                                                        t15,
                                                                                        t16,
                                                                                        t17,
                                                                                        t18,
                                                                                        t19,
                                                                                        t20,
                                                                                      );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20),
    T21
  >
  get tupled => (t) => t(this);
}

/// Provides additional functions on functions with 22 parameters.
extension Function22Ops<
  T0,
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
        Function22<
          T0,
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
        > {
  /// Composes this function with the provided function, this function being applied first.
  Function22<
    T0,
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
    T23
  >
  andThen<T23>(Function1<T22, T23> fn) =>
      (
        t0,
        t1,
        t2,
        t3,
        t4,
        t5,
        t6,
        t7,
        t8,
        t9,
        t10,
        t11,
        t12,
        t13,
        t14,
        t15,
        t16,
        t17,
        t18,
        t19,
        t20,
        t21,
      ) => fn(
        this(
          t0,
          t1,
          t2,
          t3,
          t4,
          t5,
          t6,
          t7,
          t8,
          t9,
          t10,
          t11,
          t12,
          t13,
          t14,
          t15,
          t16,
          t17,
          t18,
          t19,
          t20,
          t21,
        ),
      );

  /// Composes this function with the provided function, this function being applied first.
  Function1<T23, T22> compose<T23>(
    Function1<
      T23,
      (
        T0,
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
      )
    >
    fn,
  ) => (t23) => tupled(fn(t23));

  /// Return the curried form of this function.
  Function22C<
    T0,
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
  get curried =>
      (t0) =>
          (t1) =>
              (t2) =>
                  (t3) =>
                      (t4) =>
                          (t5) =>
                              (t6) =>
                                  (t7) =>
                                      (t8) =>
                                          (t9) =>
                                              (t10) =>
                                                  (t11) =>
                                                      (t12) =>
                                                          (t13) =>
                                                              (t14) =>
                                                                  (t15) =>
                                                                      (t16) =>
                                                                          (t17) =>
                                                                              (t18) =>
                                                                                  (t19) =>
                                                                                      (t20) =>
                                                                                          (t21) =>
                                                                                              this(
                                                                                                t0,
                                                                                                t1,
                                                                                                t2,
                                                                                                t3,
                                                                                                t4,
                                                                                                t5,
                                                                                                t6,
                                                                                                t7,
                                                                                                t8,
                                                                                                t9,
                                                                                                t10,
                                                                                                t11,
                                                                                                t12,
                                                                                                t13,
                                                                                                t14,
                                                                                                t15,
                                                                                                t16,
                                                                                                t17,
                                                                                                t18,
                                                                                                t19,
                                                                                                t20,
                                                                                                t21,
                                                                                              );

  /// Returns a function that takes a tuple of parameters rather than individual parameters.
  Function1<
    (
      T0,
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
    ),
    T22
  >
  get tupled => (t) => t(this);
}
