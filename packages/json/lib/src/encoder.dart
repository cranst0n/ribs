import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/encoder/contramap_encoder.dart';
import 'package:ribs_json/src/encoder/encoder_f.dart';
import 'package:ribs_json/src/encoder/map_encoder.dart';

@immutable
abstract mixin class Encoder<A> {
  static Encoder<A> instance<A>(Function1<A, Json> encodeF) =>
      EncoderF(encodeF);

  Json encode(A a);

  Encoder<B> contramap<B>(Function1<B, A> f) => ContramapEncoder(this, f);

  Encoder<A> mapJson(Function1<Json, Json> f) =>
      Encoder.instance((a) => f(encode(a)));

  //////////////////////////////////////////////////////////////////////////////
  /// Primitive Instances
  //////////////////////////////////////////////////////////////////////////////

  static Encoder<BigInt> bigInt =
      Encoder.instance((a) => Json.str(a.toString()));

  static Encoder<bool> boolean = Encoder.instance((a) => Json.boolean(a));

  static Encoder<DateTime> dateTime =
      Encoder.instance((a) => Json.str(a.toIso8601String()));

  static Encoder<Duration> duration = number.contramap((a) => a.inMicroseconds);

  static Encoder<double> dubble = number.contramap(identity);

  static Encoder<T> enumerationByIndex<T extends Enum>() =>
      integer.contramap((e) => e.index);

  static Encoder<T> enumerationByName<T extends Enum>() =>
      string.contramap((e) => e.name);

  static Encoder<int> integer = number.contramap(identity);

  static Encoder<Json> json = Encoder.instance(identity);

  static Encoder<num> number =
      Encoder.instance((a) => a.isFinite ? Json.number(a) : Json.Null);

  static Encoder<List<A>> list<A>(Encoder<A> encodeA) =>
      Encoder.instance((a) => JArray(IList.fromDart(a).map(encodeA.encode)));

  static Encoder<IList<A>> ilist<A>(Encoder<A> encodeA) =>
      list(encodeA).contramap((a) => a.toList());

  static Encoder<Map<K, V>> mapOf<K, V>(
          KeyEncoder<K> encodeK, Encoder<V> encodeV) =>
      MapEncoder(encodeK, encodeV);

  static Encoder<IMap<K, V>> imapOf<K, V>(
          KeyEncoder<K> encodeK, Encoder<V> encodeV) =>
      mapOf(encodeK, encodeV).contramap((im) => im.toMap());

  static Encoder<NonEmptyIList<A>> nonEmptyIList<A>(Encoder<A> encodeA) =>
      list(encodeA).contramap((a) => a.toList());

  static Encoder<String> string = Encoder.instance((a) => Json.str(a));

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Encoder<(A, B)> tuple2<A, B>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
  ) =>
      EncoderF((t) =>
          JArray(IList.fromDart([encodeA.encode(t.$1), encodeB.encode(t.$2)])));

  static Encoder<(A, B, C)> tuple3<A, B, C>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
  ) =>
      EncoderF((t) => tuple2(encodeA, encodeB)
          .encode(t.init())
          .mapArray((a) => a.appended(encodeC.encode(t.last))));

  static Encoder<(A, B, C, D)> tuple4<A, B, C, D>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
  ) =>
      EncoderF((t) => tuple3(encodeA, encodeB, encodeC)
          .encode(t.init())
          .mapArray((a) => a.appended(encodeD.encode(t.last))));

  static Encoder<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
  ) =>
      EncoderF((t) => tuple4(encodeA, encodeB, encodeC, encodeD)
          .encode(t.init())
          .mapArray((a) => a.appended(encodeE.encode(t.last))));

  static Encoder<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
  ) =>
      EncoderF((t) => tuple5(encodeA, encodeB, encodeC, encodeD, encodeE)
          .encode(t.init())
          .mapArray((a) => a.appended(encodeF.encode(t.last))));

  static Encoder<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
  ) =>
      EncoderF((t) =>
          tuple6(encodeA, encodeB, encodeC, encodeD, encodeE, encodeF)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeG.encode(t.last))));

  static Encoder<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Encoder<A> encodeA,
    Encoder<B> encodeB,
    Encoder<C> encodeC,
    Encoder<D> encodeD,
    Encoder<E> encodeE,
    Encoder<F> encodeF,
    Encoder<G> encodeG,
    Encoder<H> encodeH,
  ) =>
      EncoderF((t) =>
          tuple7(encodeA, encodeB, encodeC, encodeD, encodeE, encodeF, encodeG)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeH.encode(t.last))));

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
  ) =>
      EncoderF((t) => tuple8(encodeA, encodeB, encodeC, encodeD, encodeE,
              encodeF, encodeG, encodeH)
          .encode(t.init())
          .mapArray((a) => a.appended(encodeI.encode(t.last))));

  static Encoder<(A, B, C, D, E, F, G, H, I, J)>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) =>
          EncoderF((t) => tuple9(encodeA, encodeB, encodeC, encodeD, encodeE,
                  encodeF, encodeG, encodeH, encodeI)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeJ.encode(t.last))));

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K)>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) =>
          EncoderF((t) => tuple10(encodeA, encodeB, encodeC, encodeD, encodeE,
                  encodeF, encodeG, encodeH, encodeI, encodeJ)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeK.encode(t.last))));

  static Encoder<(A, B, C, D, E, F, G, H, I, J, K, L)>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) =>
          EncoderF((t) => tuple11(encodeA, encodeB, encodeC, encodeD, encodeE,
                  encodeF, encodeG, encodeH, encodeI, encodeJ, encodeK)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeL.encode(t.last))));

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
  ) =>
          EncoderF((t) => tuple12(encodeA, encodeB, encodeC, encodeD, encodeE,
                  encodeF, encodeG, encodeH, encodeI, encodeJ, encodeK, encodeL)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeM.encode(t.last))));

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
  ) =>
          EncoderF((t) => tuple13(
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
                  encodeM)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeN.encode(t.last))));

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
  ) =>
          EncoderF((t) => tuple14(
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
                  encodeN)
              .encode(t.init())
              .mapArray((a) => a.appended(encodeO.encode(t.last))));
}
