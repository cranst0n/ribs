import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// Provides a product operation on a 2-tuple of [Codec]s.
extension CodecTuple2Ops<T0, T1> on (Codec<T0>, Codec<T1>) {
  Codec<T2> product<T2>(
    Function2<T0, T1, T2> apply,
    Function1<T2, (T0, T1)> tupled,
  ) => Codec.product2(this.$1, this.$2, apply, tupled);
}

/// Provides a product operation on a 3-tuple of [Codec]s.
extension CodecTuple3Ops<T0, T1, T2> on (Codec<T0>, Codec<T1>, Codec<T2>) {
  Codec<T3> product<T3>(
    Function3<T0, T1, T2, T3> apply,
    Function1<T3, (T0, T1, T2)> tupled,
  ) => Codec.product3(this.$1, this.$2, this.$3, apply, tupled);
}

/// Provides a product operation on a 4-tuple of [Codec]s.
extension CodecTuple4Ops<T0, T1, T2, T3> on (Codec<T0>, Codec<T1>, Codec<T2>, Codec<T3>) {
  Codec<T4> product<T4>(
    Function4<T0, T1, T2, T3, T4> apply,
    Function1<T4, (T0, T1, T2, T3)> tupled,
  ) => Codec.product4(this.$1, this.$2, this.$3, this.$4, apply, tupled);
}

/// Provides a product operation on a 5-tuple of [Codec]s.
extension CodecTuple5Ops<T0, T1, T2, T3, T4>
    on (Codec<T0>, Codec<T1>, Codec<T2>, Codec<T3>, Codec<T4>) {
  Codec<T5> product<T5>(
    Function5<T0, T1, T2, T3, T4, T5> apply,
    Function1<T5, (T0, T1, T2, T3, T4)> tupled,
  ) => Codec.product5(this.$1, this.$2, this.$3, this.$4, this.$5, apply, tupled);
}

/// Provides a product operation on a 6-tuple of [Codec]s.
extension CodecTuple6Ops<T0, T1, T2, T3, T4, T5>
    on (Codec<T0>, Codec<T1>, Codec<T2>, Codec<T3>, Codec<T4>, Codec<T5>) {
  Codec<T6> product<T6>(
    Function6<T0, T1, T2, T3, T4, T5, T6> apply,
    Function1<T6, (T0, T1, T2, T3, T4, T5)> tupled,
  ) => Codec.product6(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, apply, tupled);
}

/// Provides a product operation on a 7-tuple of [Codec]s.
extension CodecTuple7Ops<T0, T1, T2, T3, T4, T5, T6>
    on (Codec<T0>, Codec<T1>, Codec<T2>, Codec<T3>, Codec<T4>, Codec<T5>, Codec<T6>) {
  Codec<T7> product<T7>(
    Function7<T0, T1, T2, T3, T4, T5, T6, T7> apply,
    Function1<T7, (T0, T1, T2, T3, T4, T5, T6)> tupled,
  ) => Codec.product7(this.$1, this.$2, this.$3, this.$4, this.$5, this.$6, this.$7, apply, tupled);
}

/// Provides a product operation on a 8-tuple of [Codec]s.
extension CodecTuple8Ops<T0, T1, T2, T3, T4, T5, T6, T7>
    on (Codec<T0>, Codec<T1>, Codec<T2>, Codec<T3>, Codec<T4>, Codec<T5>, Codec<T6>, Codec<T7>) {
  Codec<T8> product<T8>(
    Function8<T0, T1, T2, T3, T4, T5, T6, T7, T8> apply,
    Function1<T8, (T0, T1, T2, T3, T4, T5, T6, T7)> tupled,
  ) => Codec.product8(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 9-tuple of [Codec]s.
extension CodecTuple9Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
        ) {
  Codec<T9> product<T9>(
    Function9<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> apply,
    Function1<T9, (T0, T1, T2, T3, T4, T5, T6, T7, T8)> tupled,
  ) => Codec.product9(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 10-tuple of [Codec]s.
extension CodecTuple10Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
        ) {
  Codec<T10> product<T10>(
    Function10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> apply,
    Function1<T10, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> tupled,
  ) => Codec.product10(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 11-tuple of [Codec]s.
extension CodecTuple11Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
        ) {
  Codec<T11> product<T11>(
    Function11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> apply,
    Function1<T11, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> tupled,
  ) => Codec.product11(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 12-tuple of [Codec]s.
extension CodecTuple12Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
        ) {
  Codec<T12> product<T12>(
    Function12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> apply,
    Function1<T12, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)> tupled,
  ) => Codec.product12(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 13-tuple of [Codec]s.
extension CodecTuple13Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
        ) {
  Codec<T13> product<T13>(
    Function13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> apply,
    Function1<T13, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)> tupled,
  ) => Codec.product13(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 14-tuple of [Codec]s.
extension CodecTuple14Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
        ) {
  Codec<T14> product<T14>(
    Function14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> apply,
    Function1<T14, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)> tupled,
  ) => Codec.product14(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 15-tuple of [Codec]s.
extension CodecTuple15Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
        ) {
  Codec<T15> product<T15>(
    Function15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> apply,
    Function1<T15, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)> tupled,
  ) => Codec.product15(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 16-tuple of [Codec]s.
extension CodecTuple16Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
        ) {
  Codec<T16> product<T16>(
    Function16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> apply,
    Function1<T16, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)> tupled,
  ) => Codec.product16(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 17-tuple of [Codec]s.
extension CodecTuple17Ops<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
        ) {
  Codec<T17> product<T17>(
    Function17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>
    apply,
    Function1<T17, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
    tupled,
  ) => Codec.product17(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 18-tuple of [Codec]s.
extension CodecTuple18Ops<
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
    on
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
          Codec<T17>,
        ) {
  Codec<T18> product<T18>(
    Function18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>
    apply,
    Function1<T18, (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
    tupled,
  ) => Codec.product18(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 19-tuple of [Codec]s.
extension CodecTuple19Ops<
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
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
          Codec<T17>,
          Codec<T18>,
        ) {
  Codec<T19> product<T19>(
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
    apply,
    Function1<
      T19,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
    >
    tupled,
  ) => Codec.product19(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    this.$19,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 20-tuple of [Codec]s.
extension CodecTuple20Ops<
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
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
          Codec<T17>,
          Codec<T18>,
          Codec<T19>,
        ) {
  Codec<T20> product<T20>(
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
    apply,
    Function1<
      T20,
      (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
    >
    tupled,
  ) => Codec.product20(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    this.$19,
    this.$20,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 21-tuple of [Codec]s.
extension CodecTuple21Ops<
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
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
          Codec<T17>,
          Codec<T18>,
          Codec<T19>,
          Codec<T20>,
        ) {
  Codec<T21> product<T21>(
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
    apply,
    Function1<
      T21,
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
    tupled,
  ) => Codec.product21(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    this.$19,
    this.$20,
    this.$21,
    apply,
    tupled,
  );
}

/// Provides a product operation on a 22-tuple of [Codec]s.
extension CodecTuple22Ops<
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
        (
          Codec<T0>,
          Codec<T1>,
          Codec<T2>,
          Codec<T3>,
          Codec<T4>,
          Codec<T5>,
          Codec<T6>,
          Codec<T7>,
          Codec<T8>,
          Codec<T9>,
          Codec<T10>,
          Codec<T11>,
          Codec<T12>,
          Codec<T13>,
          Codec<T14>,
          Codec<T15>,
          Codec<T16>,
          Codec<T17>,
          Codec<T18>,
          Codec<T19>,
          Codec<T20>,
          Codec<T21>,
        ) {
  Codec<T22> product<T22>(
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
    apply,
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
        T21,
      )
    >
    tupled,
  ) => Codec.product22(
    this.$1,
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    this.$19,
    this.$20,
    this.$21,
    this.$22,
    apply,
    tupled,
  );
}
