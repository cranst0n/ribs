import 'dart:convert';
import 'dart:typed_data';

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
import 'package:ribs_json/src/decoder/option_decoder.dart';
import 'package:ribs_json/src/decoder/or_decoder.dart';
import 'package:ribs_json/src/decoder/prepared_decoder.dart';

@immutable
abstract mixin class Decoder<A> {
  static Decoder<A> constant<A>(A a) => Decoder.instance((_) => Right(a));

  static Decoder<A> instance<A>(Function1<HCursor, DecodeResult<A>> decodeF) => DecoderF(decodeF);

  static Decoder<A> failed<A>(DecodingFailure failure) => Decoder.instance((_) => Left(failure));

  static Decoder<A> failedWithMessage<A>(String message) =>
      Decoder.instance((c) => Left(DecodingFailure(CustomReason(message), c.history())));

  DecodeResult<A> decode(Json json) => decodeC(json.hcursor);

  DecodeResult<A> decodeC(HCursor cursor);

  DecodeResult<A> tryDecodeC(ACursor cursor) =>
      cursor is HCursor ? decodeC(cursor) : _cursorToFailure(cursor).asLeft();

  Decoder<A> at(String key) => DownFieldDecoder(key, this);

  Decoder<Either<A, B>> either<B>(Decoder<B> decodeB) => EitherDecoder(this, decodeB);

  Decoder<B> emap<B>(Function1<A, Either<String, B>> f) => EmapDecoder(this, f);

  Decoder<A> ensure(Function1<A, bool> p, Function0<String> message) => Decoder.instance(
    (c) => decodeC(c).filterOrElse(p, () => DecodingFailure.fromString(message(), c)),
  );

  Decoder<B> flatMap<B>(Function1<A, Decoder<B>> f) => FlatMapDecoder(this, f);

  Decoder<A> handleError(Function1<DecodingFailure, A> f) =>
      handleErrorWith((err) => Decoder.instance((_) => f(err).asRight()));

  Decoder<A> handleErrorWith(Function1<DecodingFailure, Decoder<A>> f) =>
      HandleErrorDecoder(this, f);

  Decoder<B> map<B>(Function1<A, B> f) => Decoder.instance((c) => decodeC(c).map(f));

  Decoder<Option<A>> optional() => OptionDecoder(this);

  Decoder<A> or(Decoder<A> d) => OrDecoder(this, d);

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

  static Decoder<BigInt> bigInt = string.emap(
    (a) => Option(BigInt.tryParse(a)).toRight(() => 'BigInt.tryParse failed: $a'),
  );

  static Decoder<bool> boolean = Decoder.instance(
    (c) => Either.cond(
      () => c.value is JBoolean,
      () => (c.value as JBoolean).value,
      () => _wrongTypeFail('bool', c),
    ),
  );

  static Decoder<Uint8List> bytes = string.map(base64Decode);

  static Decoder<DateTime> dateTime = string.emap(
    (a) => Either.catching(() => DateTime.parse(a), (err, _) => err.toString()),
  );

  static Decoder<double> dubble = Decoder.instance((j) {
    if (j.value is JNumber) {
      return (j.value as JNumber).value.toDouble().asRight();
    } else if (j.value is JNull) {
      return double.nan.asRight();
    } else {
      return _wrongTypeFail('double', j).asLeft();
    }
  });

  static Decoder<Duration> duration = integer.map((a) => Duration(microseconds: a));

  static Decoder<T> enumerationByIndex<T extends Enum>(List<T> values) => integer.emap(
    (index) => IList.fromDart(
      values,
    ).find((v) => v.index == index).toRight(() => 'Invalid enum index for $T: $index'),
  );

  static Decoder<T> enumerationByName<T extends Enum>(List<T> values) => string.emap(
    (name) => IList.fromDart(
      values,
    ).find((v) => v.name == name).toRight(() => 'Invalid enum name for $T: $name'),
  );

  static Decoder<IList<A>> ilist<A>(Decoder<A> decodeA) => list(decodeA).map(IList.fromDart);

  static Decoder<int> integer = number.emap(
    (number) => Either.cond(
      () => number is int,
      () => number as int,
      () => 'Found decimal ($number). Expected integer.',
    ),
  );

  static Decoder<Json> json = Decoder.instance((c) => c.value.asRight());

  static Decoder<num> number = Decoder.instance(
    (c) => Either.cond(
      () => c.value is JNumber,
      () => (c.value as JNumber).value,
      () => _wrongTypeFail('num', c),
    ),
  );

  static Decoder<List<A>> list<A>(Decoder<A> decodeA) => ListDecoder(decodeA);

  static Decoder<Map<K, V>> mapOf<K, V>(KeyDecoder<K> decodeK, Decoder<V> decodeV) =>
      MapDecoder<K, V>(decodeK, decodeV);

  static Decoder<IMap<K, V>> imapOf<K, V>(KeyDecoder<K> decodeK, Decoder<V> decodeV) =>
      mapOf(decodeK, decodeV).map(IMap.fromDart);

  static Decoder<NonEmptyIList<A>> nonEmptyIList<A>(Decoder<A> decodeA) =>
      NonEmptyIListDecoder(decodeA);

  static Decoder<String> string = Decoder.instance(
    (c) => Either.cond(
      () => c.value is JString,
      () => (c.value as JString).value,
      () => _wrongTypeFail('num', c),
    ),
  );

  static DecodingFailure _wrongTypeFail(String expected, HCursor cursor) =>
      DecodingFailure(WrongTypeExpectation(expected, cursor.value), cursor.history());

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  static Decoder<(A, B)> tuple2<A, B>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 2) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[2]', c).asLeft();
    }
  });

  static Decoder<(A, B, C)> tuple3<A, B, C>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 3) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[3]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D)> tuple4<A, B, C, D>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 4) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[4]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 5) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[5]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 6) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[6]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 7) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[7]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 8) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[8]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Decoder<A> decodeA,
    Decoder<B> decodeB,
    Decoder<C> decodeC,
    Decoder<D> decodeD,
    Decoder<E> decodeE,
    Decoder<F> decodeF,
    Decoder<G> decodeG,
    Decoder<H> decodeH,
    Decoder<I> decodeI,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 9) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[9]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 10) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[10]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 11) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[11]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 12) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[12]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 13) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[13]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 14) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[14]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
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
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 15) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[15]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
  tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
    Decoder<P> decodeP,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 16) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[16]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
  tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 17) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[17]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
  tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
    Decoder<R> decodeR,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 18) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
        decodeR.tryDecodeC(c.downN(17)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[18]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
  tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
    Decoder<R> decodeR,
    Decoder<S> decodeS,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 19) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
        decodeR.tryDecodeC(c.downN(17)),
        decodeS.tryDecodeC(c.downN(18)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[19]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
  tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
    Decoder<R> decodeR,
    Decoder<S> decodeS,
    Decoder<T> decodeT,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 20) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
        decodeR.tryDecodeC(c.downN(17)),
        decodeS.tryDecodeC(c.downN(18)),
        decodeT.tryDecodeC(c.downN(19)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[20]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
  tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
    Decoder<R> decodeR,
    Decoder<S> decodeS,
    Decoder<T> decodeT,
    Decoder<U> decodeU,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 21) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
        decodeR.tryDecodeC(c.downN(17)),
        decodeS.tryDecodeC(c.downN(18)),
        decodeT.tryDecodeC(c.downN(19)),
        decodeU.tryDecodeC(c.downN(20)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[21]', c).asLeft();
    }
  });

  static Decoder<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
  tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    Decoder<P> decodeP,
    Decoder<Q> decodeQ,
    Decoder<R> decodeR,
    Decoder<S> decodeS,
    Decoder<T> decodeT,
    Decoder<U> decodeU,
    Decoder<V> decodeV,
  ) => DecoderF((c) {
    if (c.value.isArray && (c.value as JArray).value.size == 22) {
      return (
        decodeA.tryDecodeC(c.downN(0)),
        decodeB.tryDecodeC(c.downN(1)),
        decodeC.tryDecodeC(c.downN(2)),
        decodeD.tryDecodeC(c.downN(3)),
        decodeE.tryDecodeC(c.downN(4)),
        decodeF.tryDecodeC(c.downN(5)),
        decodeG.tryDecodeC(c.downN(6)),
        decodeH.tryDecodeC(c.downN(7)),
        decodeI.tryDecodeC(c.downN(8)),
        decodeJ.tryDecodeC(c.downN(9)),
        decodeK.tryDecodeC(c.downN(10)),
        decodeL.tryDecodeC(c.downN(11)),
        decodeM.tryDecodeC(c.downN(12)),
        decodeN.tryDecodeC(c.downN(13)),
        decodeO.tryDecodeC(c.downN(14)),
        decodeP.tryDecodeC(c.downN(15)),
        decodeQ.tryDecodeC(c.downN(16)),
        decodeR.tryDecodeC(c.downN(17)),
        decodeS.tryDecodeC(c.downN(18)),
        decodeT.tryDecodeC(c.downN(19)),
        decodeU.tryDecodeC(c.downN(20)),
        decodeV.tryDecodeC(c.downN(21)),
      ).tupled;
    } else {
      return _wrongTypeFail('array[22]', c).asLeft();
    }
  });

  static Decoder<C> product2<A, B, C>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Function2<A, B, C> apply,
  ) => Decoder.instance(
    (cursor) => (decoderA.decodeC(cursor), decoderB.decodeC(cursor)).mapN(apply),
  );

  static Decoder<D> product3<A, B, C, D>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Function3<A, B, C, D> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<E> product4<A, B, C, D, E>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Function4<A, B, C, D, E> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<F> product5<A, B, C, D, E, F>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Function5<A, B, C, D, E, F> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<G> product6<A, B, C, D, E, F, G>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Function6<A, B, C, D, E, F, G> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<H> product7<A, B, C, D, E, F, G, H>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Function7<A, B, C, D, E, F, G, H> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<I> product8<A, B, C, D, E, F, G, H, I>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Function8<A, B, C, D, E, F, G, H, I> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<J> product9<A, B, C, D, E, F, G, H, I, J>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Function9<A, B, C, D, E, F, G, H, I, J> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<K> product10<A, B, C, D, E, F, G, H, I, J, K>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Function10<A, B, C, D, E, F, G, H, I, J, K> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<L> product11<A, B, C, D, E, F, G, H, I, J, K, L>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Function11<A, B, C, D, E, F, G, H, I, J, K, L> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<M> product12<A, B, C, D, E, F, G, H, I, J, K, L, M>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, M> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<N> product13<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, N> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<O> product14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<P> product15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<Q> product16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<R> product17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<S> product18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Decoder<R> decoderR,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
      decoderR.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<T> product19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Decoder<R> decoderR,
    Decoder<S> decoderS,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
      decoderR.decodeC(cursor),
      decoderS.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<U> product20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Decoder<R> decoderR,
    Decoder<S> decoderS,
    Decoder<T> decoderT,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
      decoderR.decodeC(cursor),
      decoderS.decodeC(cursor),
      decoderT.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<V> product21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Decoder<R> decoderR,
    Decoder<S> decoderS,
    Decoder<T> decoderT,
    Decoder<U> decoderU,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
      decoderR.decodeC(cursor),
      decoderS.decodeC(cursor),
      decoderT.decodeC(cursor),
      decoderU.decodeC(cursor),
    ).mapN(apply),
  );

  static Decoder<W> product22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
    Decoder<A> decoderA,
    Decoder<B> decoderB,
    Decoder<C> decoderC,
    Decoder<D> decoderD,
    Decoder<E> decoderE,
    Decoder<F> decoderF,
    Decoder<G> decoderG,
    Decoder<H> decoderH,
    Decoder<I> decoderI,
    Decoder<J> decoderJ,
    Decoder<K> decoderK,
    Decoder<L> decoderL,
    Decoder<M> decoderM,
    Decoder<N> decoderN,
    Decoder<O> decoderO,
    Decoder<P> decoderP,
    Decoder<Q> decoderQ,
    Decoder<R> decoderR,
    Decoder<S> decoderS,
    Decoder<T> decoderT,
    Decoder<U> decoderU,
    Decoder<V> decoderV,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
  ) => Decoder.instance(
    (cursor) => (
      decoderA.decodeC(cursor),
      decoderB.decodeC(cursor),
      decoderC.decodeC(cursor),
      decoderD.decodeC(cursor),
      decoderE.decodeC(cursor),
      decoderF.decodeC(cursor),
      decoderG.decodeC(cursor),
      decoderH.decodeC(cursor),
      decoderI.decodeC(cursor),
      decoderJ.decodeC(cursor),
      decoderK.decodeC(cursor),
      decoderL.decodeC(cursor),
      decoderM.decodeC(cursor),
      decoderN.decodeC(cursor),
      decoderO.decodeC(cursor),
      decoderP.decodeC(cursor),
      decoderQ.decodeC(cursor),
      decoderR.decodeC(cursor),
      decoderS.decodeC(cursor),
      decoderT.decodeC(cursor),
      decoderU.decodeC(cursor),
      decoderV.decodeC(cursor),
    ).mapN(apply),
  );
}
