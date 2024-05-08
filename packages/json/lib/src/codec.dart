import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/codec/codec_f.dart';
import 'package:ribs_json/src/decoder/option_decoder.dart';

@immutable
abstract class Codec<A> extends Decoder<A> with Encoder<A> {
  KeyValueCodec<A> atField(String key) => KeyValueCodec(key, this);

  Codec<B> iemap<B>(Function1<A, Either<String, B>> f, Function1<B, A> g) =>
      from(emap(f), contramap(g));

  Codec<A?> nullable() => optional().xmap((o) => o.toNullable(), Option.new);

  @override
  Codec<Option<A>> optional() => from(
        OptionDecoder(this),
        Encoder.instance<Option<A>>((a) => a.fold(() => JNull(), encode)),
      );

  Codec<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      iemap((a) => f(a).asRight(), g);

  static Codec<A> from<A>(Decoder<A> decoder, Encoder<A> encoder) =>
      CodecF(decoder, encoder);

  static Codec<A> instance<A>(
    Function1<HCursor, DecodeResult<A>> decodeF,
    Function1<A, Json> encodeF,
  ) =>
      from(Decoder.instance(decodeF), Encoder.instance(encodeF));

  //////////////////////////////////////////////////////////////////////////////
  /// Primitive Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<BigInt> bigInt = from(Decoder.bigInt, Encoder.bigInt);

  static Codec<bool> boolean = from(Decoder.boolean, Encoder.boolean);

  static Codec<DateTime> dateTime = from(Decoder.dateTime, Encoder.dateTime);

  static Codec<double> dubble = from(Decoder.dubble, Encoder.dubble);

  static Codec<Duration> duration = from(Decoder.duration, Encoder.duration);

  static Codec<T> enumerationByIndex<T extends Enum>(List<T> values) =>
      from(Decoder.enumerationByIndex(values), Encoder.enumerationByIndex());

  static Codec<T> enumerationByName<T extends Enum>(List<T> values) =>
      from(Decoder.enumerationByName(values), Encoder.enumerationByName());

  static Codec<int> integer = from(Decoder.integer, Encoder.integer);

  static Codec<IList<A>> ilist<A>(Codec<A> codec) =>
      from(Decoder.ilist(codec), Encoder.ilist(codec));

  static Codec<Json> json = from(Decoder.json, Encoder.json);

  static Codec<List<A>> list<A>(Codec<A> codec) =>
      from(Decoder.list(codec), Encoder.list(codec));

  static Codec<Map<K, V>> mapOf<K, V>(KeyCodec<K> codecK, Codec<V> codecV) =>
      from(Decoder.mapOf(codecK, codecV), Encoder.mapOf(codecK, codecV));

  static Codec<IMap<K, V>> imapOf<K, V>(KeyCodec<K> codecK, Codec<V> codecV) =>
      from(Decoder.imapOf(codecK, codecV), Encoder.imapOf(codecK, codecV));

  static Codec<NonEmptyIList<A>> nonEmptyIList<A>(Codec<A> codec) =>
      from(Decoder.nonEmptyIList(codec), Encoder.nonEmptyIList(codec));

  static Codec<num> number = from(Decoder.number, Encoder.number);

  static Codec<String> string = from(Decoder.string, Encoder.string);

  //////////////////////////////////////////////////////////////////////////////
  /// Product Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<C> product2<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) =>
      KeyValueCodec.product2(codecA, codecB, apply, tupled);

  static Codec<D> product3<A, B, C, D>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) =>
      KeyValueCodec.product3(codecA, codecB, codecC, apply, tupled);

  static Codec<E> product4<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) =>
      KeyValueCodec.product4(codecA, codecB, codecC, codecD, apply, tupled);

  static Codec<F> product5<A, B, C, D, E, F>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) =>
      KeyValueCodec.product5(
          codecA, codecB, codecC, codecD, codecE, apply, tupled);

  static Codec<G> product6<A, B, C, D, E, F, G>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) =>
      KeyValueCodec.product6(
          codecA, codecB, codecC, codecD, codecE, codecF, apply, tupled);

  static Codec<H> product7<A, B, C, D, E, F, G, H>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    Function7<A, B, C, D, E, F, G, H> apply,
    Function1<H, (A, B, C, D, E, F, G)> tupled,
  ) =>
      KeyValueCodec.product7(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, apply, tupled);

  static Codec<I> product8<A, B, C, D, E, F, G, H, I>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    Function8<A, B, C, D, E, F, G, H, I> apply,
    Function1<I, (A, B, C, D, E, F, G, H)> tupled,
  ) =>
      KeyValueCodec.product8(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, codecH, apply, tupled);

  static Codec<J> product9<A, B, C, D, E, F, G, H, I, J>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
    Function1<J, (A, B, C, D, E, F, G, H, I)> tupled,
  ) =>
      KeyValueCodec.product9(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, codecH, codecI, apply, tupled);

  static Codec<K> product10<A, B, C, D, E, F, G, H, I, J, K>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
    Function1<K, (A, B, C, D, E, F, G, H, I, J)> tupled,
  ) =>
      KeyValueCodec.product10(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, codecH, codecI, codecJ, apply, tupled);

  static Codec<L> product11<A, B, C, D, E, F, G, H, I, J, K, L>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
    Function1<L, (A, B, C, D, E, F, G, H, I, J, K)> tupled,
  ) =>
      KeyValueCodec.product11(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, codecH, codecI, codecJ, codecK, apply, tupled);

  static Codec<M> product12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
    Function1<M, (A, B, C, D, E, F, G, H, I, J, K, L)> tupled,
  ) =>
      KeyValueCodec.product12(codecA, codecB, codecC, codecD, codecE, codecF,
          codecG, codecH, codecI, codecJ, codecK, codecL, apply, tupled);

  static Codec<N> product13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
    Function1<N, (A, B, C, D, E, F, G, H, I, J, K, L, M)> tupled,
  ) =>
      KeyValueCodec.product13(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          apply,
          tupled);

  static Codec<O> product14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
    Function1<O, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)> tupled,
  ) =>
      KeyValueCodec.product14(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          codecN,
          apply,
          tupled);

  static Codec<P> product15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
    Function1<P, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> tupled,
  ) =>
      KeyValueCodec.product15(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          codecN,
          codecO,
          apply,
          tupled);

  static Codec<Q> product16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
    Function1<Q, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> tupled,
  ) =>
      KeyValueCodec.product16(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          codecN,
          codecO,
          codecP,
          apply,
          tupled);

  static Codec<R>
      product17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
    Function1<R, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> tupled,
  ) =>
          KeyValueCodec.product17(
              codecA,
              codecB,
              codecC,
              codecD,
              codecE,
              codecF,
              codecG,
              codecH,
              codecI,
              codecJ,
              codecK,
              codecL,
              codecM,
              codecN,
              codecO,
              codecP,
              codecQ,
              apply,
              tupled);

  static Codec<S>
      product18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
    Function1<S, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> tupled,
  ) =>
          KeyValueCodec.product18(
              codecA,
              codecB,
              codecC,
              codecD,
              codecE,
              codecF,
              codecG,
              codecH,
              codecI,
              codecJ,
              codecK,
              codecL,
              codecM,
              codecN,
              codecO,
              codecP,
              codecQ,
              codecR,
              apply,
              tupled);

  static Codec<T>
      product19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
        apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
        tupled,
  ) =>
          KeyValueCodec.product19(
              codecA,
              codecB,
              codecC,
              codecD,
              codecE,
              codecF,
              codecG,
              codecH,
              codecI,
              codecJ,
              codecK,
              codecL,
              codecM,
              codecN,
              codecO,
              codecP,
              codecQ,
              codecR,
              codecS,
              apply,
              tupled);

  static Codec<U>
      product20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
        apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
        tupled,
  ) =>
          KeyValueCodec.product20(
              codecA,
              codecB,
              codecC,
              codecD,
              codecE,
              codecF,
              codecG,
              codecH,
              codecI,
              codecJ,
              codecK,
              codecL,
              codecM,
              codecN,
              codecO,
              codecP,
              codecQ,
              codecR,
              codecS,
              codecT,
              apply,
              tupled);

  static Codec<V> product21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,
          R, S, T, U, V>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
        apply,
    Function1<V,
            (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
        tupled,
  ) =>
      KeyValueCodec.product21(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          codecN,
          codecO,
          codecP,
          codecQ,
          codecR,
          codecS,
          codecT,
          codecU,
          apply,
          tupled);

  static Codec<W> product22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,
          R, S, T, U, V, W>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
    KeyValueCodec<J> codecJ,
    KeyValueCodec<K> codecK,
    KeyValueCodec<L> codecL,
    KeyValueCodec<M> codecM,
    KeyValueCodec<N> codecN,
    KeyValueCodec<O> codecO,
    KeyValueCodec<P> codecP,
    KeyValueCodec<Q> codecQ,
    KeyValueCodec<R> codecR,
    KeyValueCodec<S> codecS,
    KeyValueCodec<T> codecT,
    KeyValueCodec<U> codecU,
    KeyValueCodec<V> codecV,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V,
            W>
        apply,
    Function1<W,
            (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
        tupled,
  ) =>
      KeyValueCodec.product22(
          codecA,
          codecB,
          codecC,
          codecD,
          codecE,
          codecF,
          codecG,
          codecH,
          codecI,
          codecJ,
          codecK,
          codecL,
          codecM,
          codecN,
          codecO,
          codecP,
          codecQ,
          codecR,
          codecS,
          codecT,
          codecU,
          codecV,
          apply,
          tupled);

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Codec<(A, B)> tuple2<A, B>(
    Codec<A> codecA,
    Codec<B> codecB,
  ) =>
      Codec.from(
          Decoder.tuple2(codecA, codecB), Encoder.tuple2(codecA, codecB));

  static Codec<(A, B, C)> tuple3<A, B, C>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
  ) =>
      Codec.from(Decoder.tuple3(codecA, codecB, codecC),
          Encoder.tuple3(codecA, codecB, codecC));

  static Codec<(A, B, C, D)> tuple4<A, B, C, D>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
  ) =>
      Codec.from(Decoder.tuple4(codecA, codecB, codecC, codecD),
          Encoder.tuple4(codecA, codecB, codecC, codecD));

  static Codec<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
  ) =>
      Codec.from(Decoder.tuple5(codecA, codecB, codecC, codecD, codecE),
          Encoder.tuple5(codecA, codecB, codecC, codecD, codecE));

  static Codec<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
  ) =>
      Codec.from(Decoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF),
          Encoder.tuple6(codecA, codecB, codecC, codecD, codecE, codecF));

  static Codec<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
  ) =>
      Codec.from(
          Decoder.tuple7(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG),
          Encoder.tuple7(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG));

  static Codec<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
  ) =>
      Codec.from(
          Decoder.tuple8(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH),
          Encoder.tuple8(
              codecA, codecB, codecC, codecD, codecE, codecF, codecG, codecH));

  static Codec<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
  ) =>
      Codec.from(
          Decoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF, codecG,
              codecH, codecI),
          Encoder.tuple9(codecA, codecB, codecC, codecD, codecE, codecF, codecG,
              codecH, codecI));

  static Codec<(A, B, C, D, E, F, G, H, I, J)>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
  ) =>
          Codec.from(
              Decoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ),
              Encoder.tuple10(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K)>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
  ) =>
          Codec.from(
              Decoder.tuple11(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK),
              Encoder.tuple11(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L)>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
  ) =>
          Codec.from(
              Decoder.tuple12(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL),
              Encoder.tuple12(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
      tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
  ) =>
          Codec.from(
              Decoder.tuple13(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL, codecM),
              Encoder.tuple13(codecA, codecB, codecC, codecD, codecE, codecF,
                  codecG, codecH, codecI, codecJ, codecK, codecL, codecM));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
      tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
  ) =>
          Codec.from(
              Decoder.tuple14(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN),
              Encoder.tuple14(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
      tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
  ) =>
          Codec.from(
              Decoder.tuple15(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO),
              Encoder.tuple15(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
      tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
  ) =>
          Codec.from(
              Decoder.tuple16(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP),
              Encoder.tuple16(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
      tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
  ) =>
          Codec.from(
              Decoder.tuple17(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ),
              Encoder.tuple17(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
      tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
  ) =>
          Codec.from(
              Decoder.tuple18(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR),
              Encoder.tuple18(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
      tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
  ) =>
          Codec.from(
              Decoder.tuple19(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS),
              Encoder.tuple19(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
  ) =>
          Codec.from(
              Decoder.tuple20(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT),
              Encoder.tuple20(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT));

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
  ) =>
          Codec.from(
              Decoder.tuple21(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT,
                  codecU),
              Encoder.tuple21(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT,
                  codecU));

  static Codec<
          (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
    Codec<A> codecA,
    Codec<B> codecB,
    Codec<C> codecC,
    Codec<D> codecD,
    Codec<E> codecE,
    Codec<F> codecF,
    Codec<G> codecG,
    Codec<H> codecH,
    Codec<I> codecI,
    Codec<J> codecJ,
    Codec<K> codecK,
    Codec<L> codecL,
    Codec<M> codecM,
    Codec<N> codecN,
    Codec<O> codecO,
    Codec<P> codecP,
    Codec<Q> codecQ,
    Codec<R> codecR,
    Codec<S> codecS,
    Codec<T> codecT,
    Codec<U> codecU,
    Codec<V> codecV,
  ) =>
          Codec.from(
              Decoder.tuple22(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT,
                  codecU,
                  codecV),
              Encoder.tuple22(
                  codecA,
                  codecB,
                  codecC,
                  codecD,
                  codecE,
                  codecF,
                  codecG,
                  codecH,
                  codecI,
                  codecJ,
                  codecK,
                  codecL,
                  codecM,
                  codecN,
                  codecO,
                  codecP,
                  codecQ,
                  codecR,
                  codecS,
                  codecT,
                  codecU,
                  codecV));
}

extension KeyValueCodecOps on String {
  KeyValueCodec<A> as<A>(Codec<A> codec) => KeyValueCodec(this, codec);
}
