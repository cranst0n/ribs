import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

typedef EncodeF<A> = Function1<A, Either<Err, BitVector>>;

abstract mixin class Encoder<A> {
  static Encoder<A> instance<A>(EncodeF<A> encode) => _EncoderF(encode);

  static Either<Err, BitVector> encodeBoth<A, B>(
    Encoder<A> encodeA,
    A a,
    Encoder<B> encodeB,
    B b,
  ) => encodeA.encode(a).flatMap((bvA) => encodeB.encode(b).map((bvB) => bvA.concat(bvB)));

  Either<Err, BitVector> encode(A a);

  Encoder<B> contramap<B>(Function1<B, A> f) => Encoder.instance<B>((b) => encode(f(b)));

  Either<Err, BitVector> encodeAll(Iterable<A> as) => as.fold(
    Either.right(BitVector.empty),
    (acc, a) => encode(a).flatMap((res) => acc.map((acc) => acc.concat(res))),
  );

  static Encoder<(T0, T1)> tuple2<T0, T1>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
  ) => Encoder.instance(
    (tuple) =>
        encode0.encode(tuple.$1).flatMap((bits) => encode1.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2)> tuple3<T0, T1, T2>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
  ) => Encoder.instance(
    (tuple) => tuple2(
      encode0,
      encode1,
    ).encode(tuple.init).flatMap((bits) => encode2.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3)> tuple4<T0, T1, T2, T3>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
  ) => Encoder.instance(
    (tuple) => tuple3(
      encode0,
      encode1,
      encode2,
    ).encode(tuple.init).flatMap((bits) => encode3.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4)> tuple5<T0, T1, T2, T3, T4>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
  ) => Encoder.instance(
    (tuple) => tuple4(
      encode0,
      encode1,
      encode2,
      encode3,
    ).encode(tuple.init).flatMap((bits) => encode4.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5)> tuple6<T0, T1, T2, T3, T4, T5>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
  ) => Encoder.instance(
    (tuple) => tuple5(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
    ).encode(tuple.init).flatMap((bits) => encode5.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6)> tuple7<T0, T1, T2, T3, T4, T5, T6>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
  ) => Encoder.instance(
    (tuple) => tuple6(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
    ).encode(tuple.init).flatMap((bits) => encode6.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7)> tuple8<T0, T1, T2, T3, T4, T5, T6, T7>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
  ) => Encoder.instance(
    (tuple) => tuple7(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
    ).encode(tuple.init).flatMap((bits) => encode7.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
  ) => Encoder.instance(
    (tuple) => tuple8(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
    ).encode(tuple.init).flatMap((bits) => encode8.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)>
  tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
  ) => Encoder.instance(
    (tuple) => tuple9(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
    ).encode(tuple.init).flatMap((bits) => encode9.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)>
  tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
  ) => Encoder.instance(
    (tuple) => tuple10(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
    ).encode(tuple.init).flatMap((bits) => encode10.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11)>
  tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
  ) => Encoder.instance(
    (tuple) => tuple11(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
    ).encode(tuple.init).flatMap((bits) => encode11.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12)>
  tuple13<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
  ) => Encoder.instance(
    (tuple) => tuple12(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
    ).encode(tuple.init).flatMap((bits) => encode12.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13)>
  tuple14<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
  ) => Encoder.instance(
    (tuple) => tuple13(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
    ).encode(tuple.init).flatMap((bits) => encode13.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14)>
  tuple15<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
  ) => Encoder.instance(
    (tuple) => tuple14(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
    ).encode(tuple.init).flatMap((bits) => encode14.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15)>
  tuple16<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
  ) => Encoder.instance(
    (tuple) => tuple15(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
    ).encode(tuple.init).flatMap((bits) => encode15.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16)>
  tuple17<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
  ) => Encoder.instance(
    (tuple) => tuple16(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
    ).encode(tuple.init).flatMap((bits) => encode16.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17)>
  tuple18<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
    Encoder<T17> encode17,
  ) => Encoder.instance(
    (tuple) => tuple17(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
      encode16,
    ).encode(tuple.init).flatMap((bits) => encode17.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18)
  >
  tuple19<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
    Encoder<T17> encode17,
    Encoder<T18> encode18,
  ) => Encoder.instance(
    (tuple) => tuple18(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
      encode16,
      encode17,
    ).encode(tuple.init).flatMap((bits) => encode18.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<
    (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19)
  >
  tuple20<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
    Encoder<T17> encode17,
    Encoder<T18> encode18,
    Encoder<T19> encode19,
  ) => Encoder.instance(
    (tuple) => tuple19(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
      encode16,
      encode17,
      encode18,
    ).encode(tuple.init).flatMap((bits) => encode19.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<
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
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
    Encoder<T17> encode17,
    Encoder<T18> encode18,
    Encoder<T19> encode19,
    Encoder<T20> encode20,
  ) => Encoder.instance(
    (tuple) => tuple20(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
      encode16,
      encode17,
      encode18,
      encode19,
    ).encode(tuple.init).flatMap((bits) => encode20.encode(tuple.last).map(bits.concat)),
  );

  static Encoder<
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
    Encoder<T0> encode0,
    Encoder<T1> encode1,
    Encoder<T2> encode2,
    Encoder<T3> encode3,
    Encoder<T4> encode4,
    Encoder<T5> encode5,
    Encoder<T6> encode6,
    Encoder<T7> encode7,
    Encoder<T8> encode8,
    Encoder<T9> encode9,
    Encoder<T10> encode10,
    Encoder<T11> encode11,
    Encoder<T12> encode12,
    Encoder<T13> encode13,
    Encoder<T14> encode14,
    Encoder<T15> encode15,
    Encoder<T16> encode16,
    Encoder<T17> encode17,
    Encoder<T18> encode18,
    Encoder<T19> encode19,
    Encoder<T20> encode20,
    Encoder<T21> encode21,
  ) => Encoder.instance(
    (tuple) => tuple21(
      encode0,
      encode1,
      encode2,
      encode3,
      encode4,
      encode5,
      encode6,
      encode7,
      encode8,
      encode9,
      encode10,
      encode11,
      encode12,
      encode13,
      encode14,
      encode15,
      encode16,
      encode17,
      encode18,
      encode19,
      encode20,
    ).encode(tuple.init).flatMap((bits) => encode21.encode(tuple.last).map(bits.concat)),
  );
}

final class _EncoderF<A> extends Encoder<A> {
  final EncodeF<A> _encodeF;

  _EncoderF(this._encodeF);

  @override
  Either<Err, BitVector> encode(A a) => _encodeF(a);
}
