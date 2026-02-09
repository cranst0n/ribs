part of '../function.dart';

/// Type alias for curried function that takes 2 arguments, one at a time.
typedef Function2C<T0, T1, T2> = Function1<T0, Function1<T1, T2>>;

/// Type alias for curried function that takes 3 arguments, one at a time.
typedef Function3C<T0, T1, T2, T3> = Function1<T0, Function2C<T1, T2, T3>>;

/// Type alias for curried function that takes 4 arguments, one at a time.
typedef Function4C<T0, T1, T2, T3, T4> = Function1<T0, Function3C<T1, T2, T3, T4>>;

/// Type alias for curried function that takes 5 arguments, one at a time.
typedef Function5C<T0, T1, T2, T3, T4, T5> = Function1<T0, Function4C<T1, T2, T3, T4, T5>>;

/// Type alias for curried function that takes 6 arguments, one at a time.
typedef Function6C<T0, T1, T2, T3, T4, T5, T6> = Function1<T0, Function5C<T1, T2, T3, T4, T5, T6>>;

/// Type alias for curried function that takes 7 arguments, one at a time.
typedef Function7C<T0, T1, T2, T3, T4, T5, T6, T7> =
    Function1<T0, Function6C<T1, T2, T3, T4, T5, T6, T7>>;

/// Type alias for curried function that takes 8 arguments, one at a time.
typedef Function8C<T0, T1, T2, T3, T4, T5, T6, T7, T8> =
    Function1<T0, Function7C<T1, T2, T3, T4, T5, T6, T7, T8>>;

/// Type alias for curried function that takes 9 arguments, one at a time.
typedef Function9C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> =
    Function1<T0, Function8C<T1, T2, T3, T4, T5, T6, T7, T8, T9>>;

/// Type alias for curried function that takes 10 arguments, one at a time.
typedef Function10C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> =
    Function1<T0, Function9C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>>;

/// Type alias for curried function that takes 11 arguments, one at a time.
typedef Function11C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> =
    Function1<T0, Function10C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>>;

/// Type alias for curried function that takes 12 arguments, one at a time.
typedef Function12C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> =
    Function1<T0, Function11C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>>;

/// Type alias for curried function that takes 13 arguments, one at a time.
typedef Function13C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> =
    Function1<T0, Function12C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>>;

/// Type alias for curried function that takes 14 arguments, one at a time.
typedef Function14C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> =
    Function1<T0, Function13C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>>;

/// Type alias for curried function that takes 15 arguments, one at a time.
typedef Function15C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> =
    Function1<T0, Function14C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>>;

/// Type alias for curried function that takes 16 arguments, one at a time.
typedef Function16C<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> =
    Function1<
      T0,
      Function15C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    >;

/// Type alias for curried function that takes 17 arguments, one at a time.
typedef Function17C<
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
> =
    Function1<
      T0,
      Function16C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    >;

/// Type alias for curried function that takes 18 arguments, one at a time.
typedef Function18C<
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
> =
    Function1<
      T0,
      Function17C<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
    >;

/// Type alias for curried function that takes 19 arguments, one at a time.
typedef Function19C<
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
> =
    Function1<
      T0,
      Function18C<
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
    >;

/// Type alias for curried function that takes 20 arguments, one at a time.
typedef Function20C<
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
> =
    Function1<
      T0,
      Function19C<
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
    >;

/// Type alias for curried function that takes 21 arguments, one at a time.
typedef Function21C<
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
> =
    Function1<
      T0,
      Function20C<
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
    >;

/// Type alias for curried function that takes 22 arguments, one at a time.
typedef Function22C<
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
> =
    Function1<
      T0,
      Function21C<
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
    >;
