import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// Function type alias that a [Decoder] must fulfill.
typedef DecodeF<A> = Function1<BitVector, Either<Err, DecodeResult<A>>>;

final class DecodeResult<A> {
  final A value;
  final BitVector remainder;

  const DecodeResult(this.value, this.remainder);

  factory DecodeResult.successful(A value) => DecodeResult(value, BitVector.empty);

  DecodeResult<B> map<B>(Function1<A, B> f) => DecodeResult(f(value), remainder);

  DecodeResult<A> mapRemainder(Function1<BitVector, BitVector> f) =>
      DecodeResult(value, f(remainder));

  @override
  String toString() => 'DecodeResult($value, ${remainder.toHex()})';
}

abstract mixin class Decoder<A> {
  Either<Err, DecodeResult<A>> decode(BitVector bv);

  Decoder<B> map<B>(Function1<A, B> f) =>
      instance<B>((bv) => decode(bv).map((a) => DecodeResult(f(a.value), a.remainder)));

  Decoder<B> flatMap<B>(Function1<A, Decoder<B>> f) =>
      instance((bv) => decode(bv).flatMap((a) => f(a.value).decode(a.remainder)));

  Decoder<B> emap<B>(Function1<A, Either<Err, B>> f) => instance(
    (bv) => decode(bv).flatMap((a) => f(a.value).map((b) => DecodeResult(b, a.remainder))),
  );

  static Decoder<A> instance<A>(DecodeF<A> decode) => _DecoderF(decode);

  static Decoder<(T0, T1)> tuple2<T0, T1>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
  ) => Decoder.instance(
    (bv) => decode0
        .decode(bv)
        .flatMap(
          (t0) => decode1
              .decode(t0.remainder)
              .map((t1) => DecodeResult((t0.value, t1.value), t1.remainder)),
        ),
  );

  static Decoder<(T0, T1, T2)> tuple3<T0, T1, T2>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
  ) => Decoder.instance((bv) {
    return tuple2(decode0, decode1).decode(bv).flatMap((t) {
      return decode2
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3)> tuple4<T0, T1, T2, T3>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
  ) => Decoder.instance((bv) {
    return tuple3(decode0, decode1, decode2).decode(bv).flatMap((t) {
      return decode3
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4)> tuple5<T0, T1, T2, T3, T4>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
  ) => Decoder.instance((bv) {
    return tuple4(decode0, decode1, decode2, decode3).decode(bv).flatMap((t) {
      return decode4
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5)> tuple6<T0, T1, T2, T3, T4, T5>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
  ) => Decoder.instance((bv) {
    return tuple5(decode0, decode1, decode2, decode3, decode4).decode(bv).flatMap((t) {
      return decode5
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6)> tuple7<T0, T1, T2, T3, T4, T5, T6>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
  ) => Decoder.instance((bv) {
    return tuple6(decode0, decode1, decode2, decode3, decode4, decode5).decode(bv).flatMap((t) {
      return decode6
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7)> tuple8<T0, T1, T2, T3, T4, T5, T6, T7>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
  ) => Decoder.instance((bv) {
    return tuple7(decode0, decode1, decode2, decode3, decode4, decode5, decode6).decode(bv).flatMap(
      (t) {
        return decode7
            .decode(t.remainder)
            .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
      },
    );
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
  ) => Decoder.instance((bv) {
    return tuple8(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
    ).decode(bv).flatMap((t) {
      return decode8
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)>
  tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
  ) => Decoder.instance((bv) {
    return tuple9(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
    ).decode(bv).flatMap((t) {
      return decode9
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)>
  tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
  ) => Decoder.instance((bv) {
    return tuple10(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
    ).decode(bv).flatMap((t) {
      return decode10
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)>
  tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
  ) => Decoder.instance((bv) {
    return tuple11(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
    ).decode(bv).flatMap((t) {
      return decode11
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)>
  tuple13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
  ) => Decoder.instance((bv) {
    return tuple12(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
    ).decode(bv).flatMap((t) {
      return decode12
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)>
  tuple14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
  ) => Decoder.instance((bv) {
    return tuple13(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
    ).decode(bv).flatMap((t) {
      return decode13
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)>
  tuple15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
  ) => Decoder.instance((bv) {
    return tuple14(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
    ).decode(bv).flatMap((t) {
      return decode14
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)>
  tuple16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
  ) => Decoder.instance((bv) {
    return tuple15(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
    ).decode(bv).flatMap((t) {
      return decode15
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
  tuple17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
  ) => Decoder.instance((bv) {
    return tuple16(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
    ).decode(bv).flatMap((t) {
      return decode16
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  tuple18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
    Decoder<T17> decode17,
  ) => Decoder.instance((bv) {
    return tuple17(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
      decode16,
    ).decode(bv).flatMap((t) {
      return decode17
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
  >
  tuple19<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
    Decoder<T17> decode17,
    Decoder<T18> decode18,
  ) => Decoder.instance((bv) {
    return tuple18(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
      decode16,
      decode17,
    ).decode(bv).flatMap((t) {
      return decode18
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  >
  tuple20<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
    Decoder<T17> decode17,
    Decoder<T18> decode18,
    Decoder<T19> decode19,
  ) => Decoder.instance((bv) {
    return tuple19(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
      decode16,
      decode17,
      decode18,
    ).decode(bv).flatMap((t) {
      return decode19
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20)
  >
  tuple21<
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
  >(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
    Decoder<T17> decode17,
    Decoder<T18> decode18,
    Decoder<T19> decode19,
    Decoder<T20> decode20,
  ) => Decoder.instance((bv) {
    return tuple20(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
      decode16,
      decode17,
      decode18,
      decode19,
    ).decode(bv).flatMap((t) {
      return decode20
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });

  static Decoder<
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
  tuple22<
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
  >(
    Decoder<T0> decode0,
    Decoder<T1> decode1,
    Decoder<T2> decode2,
    Decoder<T3> decode3,
    Decoder<T4> decode4,
    Decoder<T5> decode5,
    Decoder<T6> decode6,
    Decoder<T7> decode7,
    Decoder<T8> decode8,
    Decoder<T9> decode9,
    Decoder<T10> decode10,
    Decoder<T11> decode11,
    Decoder<T12> decode12,
    Decoder<T13> decode13,
    Decoder<T14> decode14,
    Decoder<T15> decode15,
    Decoder<T16> decode16,
    Decoder<T17> decode17,
    Decoder<T18> decode18,
    Decoder<T19> decode19,
    Decoder<T20> decode20,
    Decoder<T21> decode21,
  ) => Decoder.instance((bv) {
    return tuple21(
      decode0,
      decode1,
      decode2,
      decode3,
      decode4,
      decode5,
      decode6,
      decode7,
      decode8,
      decode9,
      decode10,
      decode11,
      decode12,
      decode13,
      decode14,
      decode15,
      decode16,
      decode17,
      decode18,
      decode19,
      decode20,
    ).decode(bv).flatMap((t) {
      return decode21
          .decode(t.remainder)
          .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
    });
  });
}

final class _DecoderF<A> extends Decoder<A> {
  final DecodeF<A> decodeF;

  _DecoderF(this.decodeF);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) => decodeF(bv);
}
