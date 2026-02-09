part of '../tuple.dart';

// Provides additional functions on tuple/record with 2 elements.
extension Tuple2Ops<T1, T2> on (T1, T2) {
  // Returns a new tuple with [$3] appended to the end.
  (T1, T2, T3) appended<T3>(T3 $3) => ($1, $2, $3);

  // Applies each element of this tuple to the function [f].
  T3 call<T3>(Function2<T1, T2, T3> f) => f($1, $2);

  // Replaces all elements with the given associated value(s).
  (T1, T2) copy({
    T1? $1,
    T2? $2,
  }) => ($1 ?? this.$1, $2 ?? this.$2);

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns the last element of the tuple.
  T2 get last => $2;

  // Returns a new tuple with [$3] prepended to the beginning.
  (T3, T1, T2) prepended<T3>(T3 $3) => ($3, $1, $2);
}

// Provides additional functions on tuple/record with 3 elements.
extension Tuple3Ops<T1, T2, T3> on (T1, T2, T3) {
  // Returns a new tuple with [$4] appended to the end.
  (T1, T2, T3, T4) appended<T4>(T4 $4) => ($1, $2, $3, $4);

  // Applies each element of this tuple to the function [f].
  T4 call<T4>(Function3<T1, T2, T3, T4> f) => f($1, $2, $3);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3) copy({
    T1? $1,
    T2? $2,
    T3? $3,
  }) => ($1 ?? this.$1, $2 ?? this.$2, $3 ?? this.$3);

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2) get init => ($1, $2);

  // Returns the last element of the tuple.
  T3 get last => $3;

  // Returns a new tuple with [$4] prepended to the beginning.
  (T4, T1, T2, T3) prepended<T4>(T4 $4) => ($4, $1, $2, $3);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3) get tail => ($2, $3);
}

// Provides additional functions on tuple/record with 4 elements.
extension Tuple4Ops<T1, T2, T3, T4> on (T1, T2, T3, T4) {
  // Returns a new tuple with [$5] appended to the end.
  (T1, T2, T3, T4, T5) appended<T5>(T5 $5) => ($1, $2, $3, $4, $5);

  // Applies each element of this tuple to the function [f].
  T5 call<T5>(Function4<T1, T2, T3, T4, T5> f) => f($1, $2, $3, $4);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
  }) => ($1 ?? this.$1, $2 ?? this.$2, $3 ?? this.$3, $4 ?? this.$4);

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3) get init => ($1, $2, $3);

  // Returns the last element of the tuple.
  T4 get last => $4;

  // Returns a new tuple with [$5] prepended to the beginning.
  (T5, T1, T2, T3, T4) prepended<T5>(T5 $5) => ($5, $1, $2, $3, $4);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4) get tail => ($2, $3, $4);
}

// Provides additional functions on tuple/record with 5 elements.
extension Tuple5Ops<T1, T2, T3, T4, T5> on (T1, T2, T3, T4, T5) {
  // Returns a new tuple with [$6] appended to the end.
  (T1, T2, T3, T4, T5, T6) appended<T6>(T6 $6) => ($1, $2, $3, $4, $5, $6);

  // Applies each element of this tuple to the function [f].
  T6 call<T6>(Function5<T1, T2, T3, T4, T5, T6> f) => f($1, $2, $3, $4, $5);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
  }) => ($1 ?? this.$1, $2 ?? this.$2, $3 ?? this.$3, $4 ?? this.$4, $5 ?? this.$5);

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4) get init => ($1, $2, $3, $4);

  // Returns the last element of the tuple.
  T5 get last => $5;

  // Returns a new tuple with [$6] prepended to the beginning.
  (T6, T1, T2, T3, T4, T5) prepended<T6>(T6 $6) => ($6, $1, $2, $3, $4, $5);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5) get tail => ($2, $3, $4, $5);
}

// Provides additional functions on tuple/record with 6 elements.
extension Tuple6Ops<T1, T2, T3, T4, T5, T6> on (T1, T2, T3, T4, T5, T6) {
  // Returns a new tuple with [$7] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7) appended<T7>(T7 $7) => ($1, $2, $3, $4, $5, $6, $7);

  // Applies each element of this tuple to the function [f].
  T7 call<T7>(Function6<T1, T2, T3, T4, T5, T6, T7> f) => f($1, $2, $3, $4, $5, $6);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
  }) => ($1 ?? this.$1, $2 ?? this.$2, $3 ?? this.$3, $4 ?? this.$4, $5 ?? this.$5, $6 ?? this.$6);

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5) get init => ($1, $2, $3, $4, $5);

  // Returns the last element of the tuple.
  T6 get last => $6;

  // Returns a new tuple with [$7] prepended to the beginning.
  (T7, T1, T2, T3, T4, T5, T6) prepended<T7>(T7 $7) => ($7, $1, $2, $3, $4, $5, $6);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6) get tail => ($2, $3, $4, $5, $6);
}

// Provides additional functions on tuple/record with 7 elements.
extension Tuple7Ops<T1, T2, T3, T4, T5, T6, T7> on (T1, T2, T3, T4, T5, T6, T7) {
  // Returns a new tuple with [$8] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8) appended<T8>(T8 $8) => ($1, $2, $3, $4, $5, $6, $7, $8);

  // Applies each element of this tuple to the function [f].
  T8 call<T8>(Function7<T1, T2, T3, T4, T5, T6, T7, T8> f) => f($1, $2, $3, $4, $5, $6, $7);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6) get init => ($1, $2, $3, $4, $5, $6);

  // Returns the last element of the tuple.
  T7 get last => $7;

  // Returns a new tuple with [$8] prepended to the beginning.
  (T8, T1, T2, T3, T4, T5, T6, T7) prepended<T8>(T8 $8) => ($8, $1, $2, $3, $4, $5, $6, $7);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7) get tail => ($2, $3, $4, $5, $6, $7);
}

// Provides additional functions on tuple/record with 8 elements.
extension Tuple8Ops<T1, T2, T3, T4, T5, T6, T7, T8> on (T1, T2, T3, T4, T5, T6, T7, T8) {
  // Returns a new tuple with [$9] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9) appended<T9>(T9 $9) => ($1, $2, $3, $4, $5, $6, $7, $8, $9);

  // Applies each element of this tuple to the function [f].
  T9 call<T9>(Function8<T1, T2, T3, T4, T5, T6, T7, T8, T9> f) => f($1, $2, $3, $4, $5, $6, $7, $8);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7) get init => ($1, $2, $3, $4, $5, $6, $7);

  // Returns the last element of the tuple.
  T8 get last => $8;

  // Returns a new tuple with [$9] prepended to the beginning.
  (T9, T1, T2, T3, T4, T5, T6, T7, T8) prepended<T9>(T9 $9) => ($9, $1, $2, $3, $4, $5, $6, $7, $8);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8) get tail => ($2, $3, $4, $5, $6, $7, $8);
}

// Provides additional functions on tuple/record with 9 elements.
extension Tuple9Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9> on (T1, T2, T3, T4, T5, T6, T7, T8, T9) {
  // Returns a new tuple with [$10] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) appended<T10>(T10 $10) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  // Applies each element of this tuple to the function [f].
  T10 call<T10>(Function9<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8) get init => ($1, $2, $3, $4, $5, $6, $7, $8);

  // Returns the last element of the tuple.
  T9 get last => $9;

  // Returns a new tuple with [$10] prepended to the beginning.
  (T10, T1, T2, T3, T4, T5, T6, T7, T8, T9) prepended<T10>(T10 $10) =>
      ($10, $1, $2, $3, $4, $5, $6, $7, $8, $9);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9) get tail => ($2, $3, $4, $5, $6, $7, $8, $9);
}

// Provides additional functions on tuple/record with 10 elements.
extension Tuple10Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) {
  // Returns a new tuple with [$11] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) appended<T11>(T11 $11) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  // Applies each element of this tuple to the function [f].
  T11 call<T11>(Function10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9) get init => ($1, $2, $3, $4, $5, $6, $7, $8, $9);

  // Returns the last element of the tuple.
  T10 get last => $10;

  // Returns a new tuple with [$11] prepended to the beginning.
  (T11, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) prepended<T11>(T11 $11) =>
      ($11, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10) get tail => ($2, $3, $4, $5, $6, $7, $8, $9, $10);
}

// Provides additional functions on tuple/record with 11 elements.
extension Tuple11Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) {
  // Returns a new tuple with [$12] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) appended<T12>(T12 $12) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  // Applies each element of this tuple to the function [f].
  T12 call<T12>(Function11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) get init => ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

  // Returns the last element of the tuple.
  T11 get last => $11;

  // Returns a new tuple with [$12] prepended to the beginning.
  (T12, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) prepended<T12>(T12 $12) =>
      ($12, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) get tail => ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
}

// Provides additional functions on tuple/record with 12 elements.
extension Tuple12Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) {
  // Returns a new tuple with [$13] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) appended<T13>(T13 $13) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  // Applies each element of this tuple to the function [f].
  T13 call<T13>(Function12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

  // Returns the last element of the tuple.
  T12 get last => $12;

  // Returns a new tuple with [$13] prepended to the beginning.
  (T13, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) prepended<T13>(T13 $13) =>
      ($13, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}

// Provides additional functions on tuple/record with 13 elements.
extension Tuple13Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) {
  // Returns a new tuple with [$14] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) appended<T14>(T14 $14) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  // Applies each element of this tuple to the function [f].
  T14 call<T14>(Function13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);

  // Returns the last element of the tuple.
  T13 get last => $13;

  // Returns a new tuple with [$14] prepended to the beginning.
  (T14, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) prepended<T14>(T14 $14) =>
      ($14, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
}

// Provides additional functions on tuple/record with 14 elements.
extension Tuple14Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) {
  // Returns a new tuple with [$15] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) appended<T15>(T15 $15) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  // Applies each element of this tuple to the function [f].
  T15 call<T15>(Function14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> f) =>
      f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);

  // Returns the last element of the tuple.
  T14 get last => $14;

  // Returns a new tuple with [$15] prepended to the beginning.
  (T15, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) prepended<T15>(T15 $15) =>
      ($15, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
}

// Provides additional functions on tuple/record with 15 elements.
extension Tuple15Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) {
  // Returns a new tuple with [$16] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) appended<T16>(T16 $16) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  // Applies each element of this tuple to the function [f].
  T16 call<T16>(
    Function15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

  // Returns the last element of the tuple.
  T15 get last => $15;

  // Returns a new tuple with [$16] prepended to the beginning.
  (T16, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) prepended<T16>(T16 $16) =>
      ($16, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}

// Provides additional functions on tuple/record with 16 elements.
extension Tuple16Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) {
  // Returns a new tuple with [$17] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) appended<T17>(
    T17 $17,
  ) => ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

  // Applies each element of this tuple to the function [f].
  T17 call<T17>(
    Function16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

  // Returns the last element of the tuple.
  T16 get last => $16;

  // Returns a new tuple with [$17] prepended to the beginning.
  (T17, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) prepended<T17>(
    T17 $17,
  ) => ($17, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);
}

// Provides additional functions on tuple/record with 17 elements.
extension Tuple17Ops<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) {
  // Returns a new tuple with [$18] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) appended<T18>(
    T18 $18,
  ) => ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);

  // Applies each element of this tuple to the function [f].
  T18 call<T18>(
    Function17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);

  // Returns the last element of the tuple.
  T17 get last => $17;

  // Returns a new tuple with [$18] prepended to the beginning.
  (T18, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) prepended<T18>(
    T18 $18,
  ) => ($18, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);
}

// Provides additional functions on tuple/record with 18 elements.
extension Tuple18Ops<
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
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) {
  // Returns a new tuple with [$19] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  appended<T19>(T19 $19) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19);

  // Applies each element of this tuple to the function [f].
  T19 call<T19>(
    Function18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>
    f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
    T18? $18,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
    $18 ?? this.$18,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

  // Returns the last element of the tuple.
  T18 get last => $18;

  // Returns a new tuple with [$19] prepended to the beginning.
  (T19, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
  prepended<T19>(T19 $19) =>
      ($19, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);
}

// Provides additional functions on tuple/record with 19 elements.
extension Tuple19Ops<
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
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) {
  // Returns a new tuple with [$20] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  appended<T20>(T20 $20) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);

  // Applies each element of this tuple to the function [f].
  T20 call<T20>(
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
    f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
    T18? $18,
    T19? $19,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
    $18 ?? this.$18,
    $19 ?? this.$19,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);

  // Returns the last element of the tuple.
  T19 get last => $19;

  // Returns a new tuple with [$20] prepended to the beginning.
  (T20, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  prepended<T20>(T20 $20) =>
      ($20, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19);

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19);
}

// Provides additional functions on tuple/record with 20 elements.
extension Tuple20Ops<
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
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20) {
  // Returns a new tuple with [$21] appended to the end.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  appended<T21>(T21 $21) => (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
  );

  // Applies each element of this tuple to the function [f].
  T21 call<T21>(
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
    f,
  ) => f($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20) copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
    T18? $18,
    T19? $19,
    T20? $20,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
    $18 ?? this.$18,
    $19 ?? this.$19,
    $20 ?? this.$20,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19);

  // Returns the last element of the tuple.
  T20 get last => $20;

  // Returns a new tuple with [$21] prepended to the beginning.
  (T21, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  prepended<T21>(T21 $21) => (
    $21,
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
  );

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);
}

// Provides additional functions on tuple/record with 21 elements.
extension Tuple21Ops<
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
        ) {
  // Returns a new tuple with [$22] appended to the end.
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
  appended<T22>(T22 $22) => (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
    $22,
  );

  // Applies each element of this tuple to the function [f].
  T22 call<T22>(
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
    f,
  ) => f(
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
  );

  // Replaces all elements with the given associated value(s).
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
    T18? $18,
    T19? $19,
    T20? $20,
    T21? $21,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
    $18 ?? this.$18,
    $19 ?? this.$19,
    $20 ?? this.$20,
    $21 ?? this.$21,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  get init =>
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);

  // Returns the last element of the tuple.
  T21 get last => $21;

  // Returns a new tuple with [$22] prepended to the beginning.
  (
    T22,
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
  prepended<T22>(T22 $22) => (
    $22,
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
  );

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  get tail =>
      ($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21);
}

// Provides additional functions on tuple/record with 22 elements.
extension Tuple22Ops<
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
        ) {
  // Applies each element of this tuple to the function [f].
  T23 call<T23>(
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
    f,
  ) => f(
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
    $22,
  );

  // Replaces all elements with the given associated value(s).
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
  copy({
    T1? $1,
    T2? $2,
    T3? $3,
    T4? $4,
    T5? $5,
    T6? $6,
    T7? $7,
    T8? $8,
    T9? $9,
    T10? $10,
    T11? $11,
    T12? $12,
    T13? $13,
    T14? $14,
    T15? $15,
    T16? $16,
    T17? $17,
    T18? $18,
    T19? $19,
    T20? $20,
    T21? $21,
    T22? $22,
  }) => (
    $1 ?? this.$1,
    $2 ?? this.$2,
    $3 ?? this.$3,
    $4 ?? this.$4,
    $5 ?? this.$5,
    $6 ?? this.$6,
    $7 ?? this.$7,
    $8 ?? this.$8,
    $9 ?? this.$9,
    $10 ?? this.$10,
    $11 ?? this.$11,
    $12 ?? this.$12,
    $13 ?? this.$13,
    $14 ?? this.$14,
    $15 ?? this.$15,
    $16 ?? this.$16,
    $17 ?? this.$17,
    $18 ?? this.$18,
    $19 ?? this.$19,
    $20 ?? this.$20,
    $21 ?? this.$21,
    $22 ?? this.$22,
  );

  // Returns the first element of the tuple.
  T1 get head => $1;

  // Returns a new tuple with all elements from this tuple except the last.
  (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21)
  get init => (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
  );

  // Returns the last element of the tuple.
  T22 get last => $22;

  // Returns a new tuple with all elements from this tuple except the first.
  (T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22)
  get tail => (
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
    $22,
  );
}
