part of '../function.dart';

/// Provides additional functions on curried functions with 2 parameters.
extension Function2COps<T0, T1, T2> on Function2C<T0, T1, T2> {
  /// Return the uncurried form of this function.
  Function2<T0, T1, T2> get uncurried =>
      (t0, t1) => this(t0)(t1);
}

/// Provides additional functions on curried functions with 3 parameters.
extension Function3COps<T0, T1, T2, T3> on Function3C<T0, T1, T2, T3> {
  /// Return the uncurried form of this function.
  Function3<T0, T1, T2, T3> get uncurried =>
      (t0, t1, t2) => this(t0)(t1)(t2);
}

/// Provides additional functions on curried functions with 4 parameters.
extension Function4COps<T0, T1, T2, T3, T4> on Function4C<T0, T1, T2, T3, T4> {
  /// Return the uncurried form of this function.
  Function4<T0, T1, T2, T3, T4> get uncurried =>
      (t0, t1, t2, t3) => this(t0)(t1)(t2)(t3);
}

/// Provides additional functions on curried functions with 5 parameters.
extension Function5COps<T0, T1, T2, T3, T4, T5> on Function5C<T0, T1, T2, T3, T4, T5> {
  /// Return the uncurried form of this function.
  Function5<T0, T1, T2, T3, T4, T5> get uncurried =>
      (t0, t1, t2, t3, t4) => this(t0)(t1)(t2)(t3)(t4);
}

/// Provides additional functions on curried functions with 6 parameters.
extension Function6COps<T0, T1, T2, T3, T4, T5, T6> on Function6C<T0, T1, T2, T3, T4, T5, T6> {
  /// Return the uncurried form of this function.
  Function6<T0, T1, T2, T3, T4, T5, T6> get uncurried =>
      (t0, t1, t2, t3, t4, t5) => this(t0)(t1)(t2)(t3)(t4)(t5);
}

/// Provides additional functions on curried functions with 7 parameters.
extension Function7COps<T0, T1, T2, T3, T4, T5, T6, T7>
    on Function7C<T0, T1, T2, T3, T4, T5, T6, T7> {
  /// Return the uncurried form of this function.
  Function7<T0, T1, T2, T3, T4, T5, T6, T7> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6);
}

/// Provides additional functions on curried functions with 8 parameters.
extension Function8COps<T0, T1, T2, T3, T4, T5, T6, T7, T8>
    on Function8C<T0, T1, T2, T3, T4, T5, T6, T7, T8> {
  /// Return the uncurried form of this function.
  Function8<T0, T1, T2, T3, T4, T5, T6, T7, T8> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7);
}

/// Provides additional functions on curried functions with 9 parameters.
extension Function9COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Function9C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
  /// Return the uncurried form of this function.
  Function9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8);
}

/// Provides additional functions on curried functions with 10 parameters.
extension Function10COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on Function10C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> {
  /// Return the uncurried form of this function.
  Function10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9);
}

/// Provides additional functions on curried functions with 11 parameters.
extension Function11COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on Function11C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> {
  /// Return the uncurried form of this function.
  Function11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10);
}

/// Provides additional functions on curried functions with 12 parameters.
extension Function12COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on Function12C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> {
  /// Return the uncurried form of this function.
  Function12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11);
}

/// Provides additional functions on curried functions with 13 parameters.
extension Function13COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on Function13C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> {
  /// Return the uncurried form of this function.
  Function13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12);
}

/// Provides additional functions on curried functions with 14 parameters.
extension Function14COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on Function14C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> {
  /// Return the uncurried form of this function.
  Function14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13);
}

/// Provides additional functions on curried functions with 15 parameters.
extension Function15COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on Function15C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> {
  /// Return the uncurried form of this function.
  Function15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14);
}

/// Provides additional functions on curried functions with 16 parameters.
extension Function16COps<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on Function16C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> {
  /// Return the uncurried form of this function.
  Function16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
  get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15);
}

/// Provides additional functions on curried functions with 17 parameters.
extension Function17COps<
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
    on Function17C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> {
  /// Return the uncurried form of this function.
  Function17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
  get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16);
}

/// Provides additional functions on curried functions with 18 parameters.
extension Function18COps<
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
        Function18C<
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
  /// Return the uncurried form of this function.
  Function18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
  get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16)(t17);
}

/// Provides additional functions on curried functions with 19 parameters.
extension Function19COps<
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
        > {
  /// Return the uncurried form of this function.
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
  >
  get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16)(t17)(t18);
}

/// Provides additional functions on curried functions with 20 parameters.
extension Function20COps<
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
        > {
  /// Return the uncurried form of this function.
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
  >
  get uncurried =>
      (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19) =>
          this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16)(t17)(t18)(
            t19,
          );
}

/// Provides additional functions on curried functions with 21 parameters.
extension Function21COps<
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
        > {
  /// Return the uncurried form of this function.
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
  >
  get uncurried =>
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
      ) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16)(t17)(
        t18,
      )(t19)(t20);
}

/// Provides additional functions on curried functions with 22 parameters.
extension Function22COps<
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
        > {
  /// Return the uncurried form of this function.
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
  >
  get uncurried =>
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
      ) => this(t0)(t1)(t2)(t3)(t4)(t5)(t6)(t7)(t8)(t9)(t10)(t11)(t12)(t13)(t14)(t15)(t16)(t17)(
        t18,
      )(t19)(t20)(t21);
}
