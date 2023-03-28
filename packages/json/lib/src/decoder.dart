import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/decoder/decoder_f.dart';
import 'package:ribs_json/src/decoder/down_field_decoder.dart';
import 'package:ribs_json/src/decoder/either_decoder.dart';
import 'package:ribs_json/src/decoder/emap_decoder.dart';
import 'package:ribs_json/src/decoder/flatmap_decoder.dart';
import 'package:ribs_json/src/decoder/handle_error_decoder.dart';
import 'package:ribs_json/src/decoder/list_decoder.dart';
import 'package:ribs_json/src/decoder/map_decoder.dart';
import 'package:ribs_json/src/decoder/non_empty_ilist_decoder.dart';
import 'package:ribs_json/src/decoder/prepared_decoder.dart';

@immutable
abstract class Decoder<A> {
  static Decoder<A> instance<A>(Function1<HCursor, DecodeResult<A>> decodeF) =>
      DecoderF(decodeF);

  DecodeResult<A> decode(HCursor cursor);

  DecodeResult<A> tryDecode(ACursor cursor) =>
      cursor is HCursor ? decode(cursor) : _cursorToFailure(cursor).asLeft();

  Decoder<A> at(String key) => DownFieldDecoder(key, this);

  Decoder<Either<A, B>> either<B>(Decoder<B> decodeB) =>
      EitherDecoder(this, decodeB);

  Decoder<B> emap<B>(Function1<A, Either<String, B>> f) => EmapDecoder(this, f);

  Decoder<A> ensure(Function1<A, bool> p, Function0<String> message) =>
      Decoder.instance((c) => decode(c)
          .filterOrElse(p, () => DecodingFailure.fromString(message(), c)));

  Decoder<B> flatMap<B>(covariant Function1<A, Decoder<B>> f) =>
      FlatMapDecoder(this, f);

  Decoder<A> handleError(Function1<DecodingFailure, A> f) =>
      handleErrorWith((err) => Decoder.instance((_) => f(err).asRight()));

  Decoder<A> handleErrorWith(Function1<DecodingFailure, Decoder<A>> f) =>
      HandleErrorDecoder(this, f);

  Decoder<B> map<B>(Function1<A, B> f) =>
      Decoder.instance((c) => decode(c).map(f));

  Decoder<A> prepare(Function1<ACursor, ACursor> f) => PreparedDecoder(this, f);

  Decoder<A> recover(A a) => recoverWith(Decoder.instance((_) => a.asRight()));

  Decoder<A> recoverWith(Decoder<A> other) => handleErrorWith((_) => other);

  DecodingFailure _cursorToFailure(ACursor cursor) {
    final Reason reason;

    if (cursor is FailedCursor && cursor.missingField) {
      reason = MissingField();
    } else {
      reason = CustomReason('Could not decode path: ${cursor.pathString}');
    }

    return DecodingFailure.from(reason, cursor);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Primitive Instances
  //////////////////////////////////////////////////////////////////////////////

  static Decoder<BigInt> bigInt = string.emap((a) =>
      Option.of(BigInt.tryParse(a))
          .toRight(() => 'BigInt.tryParse failed: $a'));

  static Decoder<bool> boolean = Decoder.instance((c) => Either.cond(
      () => c.value is JBoolean,
      () => (c.value as JBoolean).value,
      () => _wrongTypeFail('bool', c)));

  static Decoder<DateTime> dateTime = string.emap((a) =>
      Either.catching(() => DateTime.parse(a), (err, _) => err.toString()));

  static Decoder<double> dubble = number.map((a) => a.toDouble());

  static Decoder<Duration> duration =
      integer.map((a) => Duration(milliseconds: a));

  static Decoder<IList<A>> ilist<A>(Decoder<A> decodeA) =>
      list(decodeA).map(IList.of);

  static Decoder<int> integer = number.emap((number) => Either.cond(
      () => number is int,
      () => number as int,
      () => 'Found decimal ($number). Expected integer.'));

  static Decoder<Json> json = Decoder.instance((c) => c.value.asRight());

  static Decoder<num> number = Decoder.instance((c) => Either.cond(
      () => c.value is JNumber,
      () => (c.value as JNumber).value,
      () => _wrongTypeFail('num', c)));

  static Decoder<List<A>> list<A>(Decoder<A> decodeA) => ListDecoder(decodeA);

  static Decoder<Map<K, V>> mapOf<K, V>(
          KeyDecoder<K> decodeK, Decoder<V> decodeV) =>
      MapDecoder<K, V>(decodeK, decodeV);

  static Decoder<NonEmptyIList<A>> nonEmptyIList<A>(Decoder<A> decodeA) =>
      NonEmptyIListDecoder(decodeA);

  static Decoder<String> string = Decoder.instance((c) => Either.cond(
      () => c.value is JString,
      () => (c.value as JString).value,
      () => _wrongTypeFail('num', c)));

  static DecodingFailure _wrongTypeFail(String expected, HCursor cursor) =>
      DecodingFailure(
          WrongTypeExpectation(expected, cursor.value), cursor.history());

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Decoder<Tuple2<A, B>> tuple2<A, B>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 2) {
          return Tuple2(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[2]', c).asLeft();
        }
      });

  static Decoder<Tuple3<A, B, C>> tuple3<A, B, C>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 3) {
          return Tuple3(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[3]', c).asLeft();
        }
      });

  static Decoder<Tuple4<A, B, C, D>> tuple4<A, B, C, D>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 4) {
          return Tuple4(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
            decodeD.tryDecode(c.downN(3)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[4]', c).asLeft();
        }
      });

  static Decoder<Tuple5<A, B, C, D, E>> tuple5<A, B, C, D, E>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 5) {
          return Tuple5(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
            decodeD.tryDecode(c.downN(3)),
            decodeE.tryDecode(c.downN(4)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[5]', c).asLeft();
        }
      });

  static Decoder<Tuple6<A, B, C, D, E, F>> tuple6<A, B, C, D, E, F>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 6) {
          return Tuple6(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
            decodeD.tryDecode(c.downN(3)),
            decodeE.tryDecode(c.downN(4)),
            decodeF.tryDecode(c.downN(5)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[6]', c).asLeft();
        }
      });

  static Decoder<Tuple7<A, B, C, D, E, F, G>> tuple7<A, B, C, D, E, F, G>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 7) {
          return Tuple7(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
            decodeD.tryDecode(c.downN(3)),
            decodeE.tryDecode(c.downN(4)),
            decodeF.tryDecode(c.downN(5)),
            decodeG.tryDecode(c.downN(6)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[7]', c).asLeft();
        }
      });

  static Decoder<Tuple8<A, B, C, D, E, F, G, H>> tuple8<A, B, C, D, E, F, G, H>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
  ) =>
      DecoderF((c) {
        if (c.value.isArray && (c.value as JArray).value.size == 8) {
          return Tuple8(
            decodeA.tryDecode(c.downN(0)),
            decodeB.tryDecode(c.downN(1)),
            decodeC.tryDecode(c.downN(2)),
            decodeD.tryDecode(c.downN(3)),
            decodeE.tryDecode(c.downN(4)),
            decodeF.tryDecode(c.downN(5)),
            decodeG.tryDecode(c.downN(6)),
            decodeH.tryDecode(c.downN(7)),
          ).sequence();
        } else {
          return _wrongTypeFail('array[8]', c).asLeft();
        }
      });

  static Decoder<Tuple9<A, B, C, D, E, F, G, H, I>>
      tuple9<A, B, C, D, E, F, G, H, I>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 9) {
              return Tuple9(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[9]', c).asLeft();
            }
          });

  static Decoder<Tuple10<A, B, C, D, E, F, G, H, I, J>>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 10) {
              return Tuple10(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[10]', c).asLeft();
            }
          });

  static Decoder<Tuple11<A, B, C, D, E, F, G, H, I, J, K>>
      tuple11<A, B, C, D, E, F, G, H, I, J, K>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 11) {
              return Tuple11(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
                decodeK.tryDecode(c.downN(10)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[11]', c).asLeft();
            }
          });

  static Decoder<Tuple12<A, B, C, D, E, F, G, H, I, J, K, L>>
      tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 12) {
              return Tuple12(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
                decodeK.tryDecode(c.downN(10)),
                decodeL.tryDecode(c.downN(11)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[12]', c).asLeft();
            }
          });

  static Decoder<Tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>>
      tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 13) {
              return Tuple13(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
                decodeK.tryDecode(c.downN(10)),
                decodeL.tryDecode(c.downN(11)),
                decodeM.tryDecode(c.downN(12)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[13]', c).asLeft();
            }
          });

  static Decoder<Tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>>
      tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
    Decoder<N> decodeN,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 14) {
              return Tuple14(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
                decodeK.tryDecode(c.downN(10)),
                decodeL.tryDecode(c.downN(11)),
                decodeM.tryDecode(c.downN(12)),
                decodeN.tryDecode(c.downN(13)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[14]', c).asLeft();
            }
          });

  static Decoder<Tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>>
      tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
    Decoder<J> decodeJ,
    Decoder<K> decodeK,
    Decoder<L> decodeL,
    Decoder<M> decodeM,
    Decoder<N> decodeN,
    Decoder<O> decodeO,
  ) =>
          DecoderF((c) {
            if (c.value.isArray && (c.value as JArray).value.size == 15) {
              return Tuple15(
                decodeA.tryDecode(c.downN(0)),
                decodeB.tryDecode(c.downN(1)),
                decodeC.tryDecode(c.downN(2)),
                decodeD.tryDecode(c.downN(3)),
                decodeE.tryDecode(c.downN(4)),
                decodeF.tryDecode(c.downN(5)),
                decodeG.tryDecode(c.downN(6)),
                decodeH.tryDecode(c.downN(7)),
                decodeI.tryDecode(c.downN(8)),
                decodeJ.tryDecode(c.downN(9)),
                decodeK.tryDecode(c.downN(10)),
                decodeL.tryDecode(c.downN(11)),
                decodeM.tryDecode(c.downN(12)),
                decodeN.tryDecode(c.downN(13)),
                decodeO.tryDecode(c.downN(14)),
              ).sequence();
            } else {
              return _wrongTypeFail('array[15]', c).asLeft();
            }
          });
}
