import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/encoder/contramap_encoder.dart';
import 'package:ribs_json/src/encoder/encoder_f.dart';
import 'package:ribs_json/src/encoder/map_encoder.dart';

/// Encodes a Dart value of type [A] into a [Json] value.
///
/// Use the static primitive instances and [instance] / [contramap] to build
/// and compose encoders.
@immutable
abstract mixin class Encoder<A> {
  /// Creates an [Encoder] from a plain function.
  static Encoder<A> instance<A>(Function1<A, Json> encodeF) => EncoderF(encodeF);

  /// Encodes [a] as a [Json] value.
  Json encode(A a);

  /// Returns an encoder for [B] that converts a [B] to [A] with [f] and then
  /// delegates to this encoder.
  Encoder<B> contramap<B>(Function1<B, A> f) => ContramapEncoder(this, f);

  /// Returns an encoder that applies [f] to the encoded [Json].
  Encoder<A> mapJson(Function1<Json, Json> f) => Encoder.instance((a) => f(encode(a)));

  //////////////////////////////////////////////////////////////////////////////
  /// Primitive Instances
  //////////////////////////////////////////////////////////////////////////////

  /// Encoder for [BigInt] as a JSON string.
  static Encoder<BigInt> bigInt = Encoder.instance((a) => Json.str(a.toString()));

  /// Encoder for [bool] as a JSON boolean.
  static Encoder<bool> boolean = Encoder.instance((a) => Json.boolean(a));

  /// Encoder for [Uint8List] as a Base64-encoded JSON string.
  static Encoder<Uint8List> bytes = string.contramap(base64Encode);

  /// Encoder for [DateTime] as an ISO-8601 JSON string.
  static Encoder<DateTime> dateTime = Encoder.instance((a) => Json.str(a.toIso8601String()));

  /// Encoder for [Duration] as a JSON integer (microseconds).
  static Encoder<Duration> duration = number.contramap((a) => a.inMicroseconds);

  /// Encoder for [double] as a JSON number.
  static Encoder<double> dubble = number.contramap(identity);

  /// Encoder for [Enum] subtype [T] as a JSON integer index.
  static Encoder<T> enumerationByIndex<T extends Enum>() => integer.contramap((e) => e.index);

  /// Encoder for [Enum] subtype [T] as a JSON string name.
  static Encoder<T> enumerationByName<T extends Enum>() => string.contramap((e) => e.name);

  /// Encoder for [int] as a JSON number.
  static Encoder<int> integer = number.contramap(identity);

  /// Encoder that returns the [Json] value unchanged.
  static Encoder<Json> json = Encoder.instance(identity);

  /// Encoder for [num] as a JSON number (non-finite values become `null`).
  static Encoder<num> number = Encoder.instance((a) => a.isFinite ? Json.number(a) : Json.Null);

  /// Encoder for [List<A>] as a JSON array.
  static Encoder<List<A>> list<A>(Encoder<A> encodeA) =>
      Encoder.instance((a) => JArray(IList.fromDart(a).map(encodeA.encode)));

  /// Encoder for [IList<A>] as a JSON array.
  static Encoder<IList<A>> ilist<A>(Encoder<A> encodeA) =>
      list(encodeA).contramap((a) => a.toList());

  /// Encoder for [Map<K, V>] as a JSON object.
  static Encoder<Map<K, V>> mapOf<K, V>(KeyEncoder<K> encodeK, Encoder<V> encodeV) =>
      MapEncoder(encodeK, encodeV);

  /// Encoder for [IMap<K, V>] as a JSON object.
  static Encoder<IMap<K, V>> imapOf<K, V>(KeyEncoder<K> encodeK, Encoder<V> encodeV) =>
      mapOf(encodeK, encodeV).contramap((im) => im.toMap());

  /// Encoder for [NonEmptyIList<A>] as a JSON array.
  static Encoder<NonEmptyIList<A>> nonEmptyIList<A>(Encoder<A> encodeA) =>
      list(encodeA).contramap((a) => a.toList());

  /// Encoder for [String] as a JSON string.
  static Encoder<String> string = Encoder.instance((a) => Json.str(a));

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Encoder<(A, B)> tuple2<A, B>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
  ) => EncoderF((t) => JArray(IList.fromDart([encodeA.encode(t.$1), encodeB.encode(t.$2)])));

  static Encoder<(A, B, C)> tuple3<A, B, C>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
  ) => EncoderF(
    (t) => tuple2(
      encodeA,
      encodeB,
    ).encode(t.init).mapArray((a) => a.appended(encodeC.encode(t.last))),
  );

  static Encoder<(A, B, C, D)> tuple4<A, B, C, D>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
  ) => EncoderF(
    (t) => tuple3(
      encodeA,
      encodeB,
      encodeC,
    ).encode(t.init).mapArray((a) => a.appended(encodeD.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
  ) => EncoderF(
    (t) => tuple4(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
    ).encode(t.init).mapArray((a) => a.appended(encodeE.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
  ) => EncoderF(
    (t) => tuple5(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
    ).encode(t.init).mapArray((a) => a.appended(encodeF.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
  ) => EncoderF(
    (t) => tuple6(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
    ).encode(t.init).mapArray((a) => a.appended(encodeG.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
  ) => EncoderF(
    (t) => tuple7(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
    ).encode(t.init).mapArray((a) => a.appended(encodeH.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
  ) => EncoderF(
    (t) => tuple8(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
    ).encode(t.init).mapArray((a) => a.appended(encodeI.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
  ) => EncoderF(
    (t) => tuple9(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
    ).encode(t.init).mapArray((a) => a.appended(encodeJ.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
  ) => EncoderF(
    (t) => tuple10(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
    ).encode(t.init).mapArray((a) => a.appended(encodeK.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
  ) => EncoderF(
    (t) => tuple11(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
    ).encode(t.init).mapArray((a) => a.appended(encodeL.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
  tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
  ) => EncoderF(
    (t) => tuple12(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
    ).encode(t.init).mapArray((a) => a.appended(encodeM.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
  tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
  ) => EncoderF(
    (t) => tuple13(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
    ).encode(t.init).mapArray((a) => a.appended(encodeN.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
  tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
  ) => EncoderF(
    (t) => tuple14(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
    ).encode(t.init).mapArray((a) => a.appended(encodeO.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
  tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
  ) => EncoderF(
    (t) => tuple15(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
    ).encode(t.init).mapArray((a) => a.appended(encodeP.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
  tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
  ) => EncoderF(
    (t) => tuple16(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
    ).encode(t.init).mapArray((a) => a.appended(encodeQ.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
  tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
  ) => EncoderF(
    (t) => tuple17(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
    ).encode(t.init).mapArray((a) => a.appended(encodeR.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
  tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
  ) => EncoderF(
    (t) => tuple18(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
    ).encode(t.init).mapArray((a) => a.appended(encodeS.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
  tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
  ) => EncoderF(
    (t) => tuple19(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
    ).encode(t.init).mapArray((a) => a.appended(encodeT.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
  tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
    Encoder<U> encodeU,
  ) => EncoderF(
    (t) => tuple20(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
      encodeT,
    ).encode(t.init).mapArray((a) => a.appended(encodeU.encode(t.last))),
  );

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
  tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
    Encoder<I> encodeI,
    Encoder<J> encodeJ,
    Encoder<K> encodeK,
    Encoder<L> encodeL,
    Encoder<M> encodeM,
    Encoder<N> encodeN,
    Encoder<O> encodeO,
    Encoder<P> encodeP,
    Encoder<Q> encodeQ,
    Encoder<R> encodeR,
    Encoder<S> encodeS,
    Encoder<T> encodeT,
    Encoder<U> encodeU,
    Encoder<V> encodeV,
  ) => EncoderF(
    (t) => tuple21(
      encodeA,
      encodeB,
      encodeC,
      encodeD,
      encodeE,
      encodeF,
      encodeG,
      encodeH,
      encodeI,
      encodeJ,
      encodeK,
      encodeL,
      encodeM,
      encodeN,
      encodeO,
      encodeP,
      encodeQ,
      encodeR,
      encodeS,
      encodeT,
      encodeU,
    ).encode(t.init).mapArray((a) => a.appended(encodeV.encode(t.last))),
  );
}
