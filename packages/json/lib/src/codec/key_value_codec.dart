import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/decoder/primitive_decoder.dart';

/// A [Codec] that reads and writes a single JSON object field.
///
/// [KeyValueCodec] binds a [Codec] to a named object key, so that decoding
/// navigates into that field and encoding wraps the value in a single-key
/// object. Multiple [KeyValueCodec]s can be combined into a product codec for
/// a whole object via the [product2]–[product8] static methods (or the
/// extension syntax on tuples exposed by [syntax.dart]).
///
/// ```dart
/// final nameCodec = KeyValueCodec('name', Codec.string);
/// final ageCodec  = KeyValueCodec('age',  Codec.integer);
///
/// final personCodec = KeyValueCodec.product2(
///   nameCodec, ageCodec,
///   Person.new,
///   (p) => (p.name, p.age),
/// );
/// ```
final class KeyValueCodec<A> extends Codec<A> {
  /// The JSON object key this codec reads from and writes to.
  final String key;

  /// The codec applied to the value at [key].
  final Codec<A> value;

  /// Internal codec that handles field navigation and single-key object
  /// wrapping.
  final Codec<A> codecKV;

  /// Creates a [KeyValueCodec] that decodes from and encodes to [key] using
  /// [value].
  KeyValueCodec(this.key, this.value)
    : codecKV = Codec.from(
        value.at(key),
        value.mapJson((a) => Json.fromJsonObject(JsonObject.fromIterable([(key, a)]))),
      );

  @override
  DecodeResult<A> decodeC(HCursor cursor) => codecKV.decodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) => codecKV.tryDecodeC(cursor);

  @override
  Json encode(A a) => codecKV.encode(a);

  @override
  KeyValueCodec<B> iemap<B>(
    Function1<A, Either<String, B>> f,
    Function1<B, A> g,
  ) => KeyValueCodec(key, value.iemap(f, g));

  @override
  KeyValueCodec<A?> nullable() => KeyValueCodec(key, value.nullable());

  @override
  KeyValueCodec<Option<A>> optional() => KeyValueCodec(key, value.optional());

  @override
  KeyValueCodec<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      KeyValueCodec(key, value.xmap(f, g));

  /// Returns a copy of this codec that reads from and writes to [newKey]
  /// instead of [key].
  KeyValueCodec<A> withKey(String newKey) => KeyValueCodec(newKey, value);

  // Here for performance reasons, to avoid the overhead of creating a new Codec for each field when decoding.
  @pragma('vm:prefer-inline')
  static Either<DecodingFailure, A> _decodeField<A>(
    JsonObject obj,
    KeyValueCodec<A> codec,
  ) {
    final v = obj.tryGet(codec.key);
    if (v == null) return DecodingFailure(MissingField(), nil<CursorOp>()).asLeft();
    return codec.value.decode(v);
  }

  // Here for performance reasons, to avoid the overhead of creating a new Codec for each field when decoding.
  @pragma('vm:prefer-inline')
  static A _get<A>(Either<DecodingFailure, A> e) => (e as Right<DecodingFailure, A>).b;

  // Product Instances
  //
  // You may be wondering why the product instances are implemented this way.
  // While ugly, this is done for performance reasons. The alternative would be
  // to create a new Codec for each field in the product, which would be very
  // expensive when decoding.

  /// Combines two field codecs into a codec for type [C].
  ///
  /// [apply] constructs a [C] from the two decoded field values; [tupled]
  /// destructs a [C] into the two field values for encoding.
  static Codec<C> product2<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    Function2<A, B, C> apply,
    Function1<C, (A, B)> tupled,
  ) {
    final decoder = PrimitiveDecoder<C>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        return apply(_get(ra), _get(rb)).asRight();
      },
      (cursor) => (codecA.decodeC(cursor), codecB.decodeC(cursor)).mapN(apply),
    );

    final encoder = Encoder.instance<C>(
      (a) => tupled(a)(
        (a, b) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines three field codecs into a codec for type [D].
  static Codec<D> product3<A, B, C, D>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    Function3<A, B, C, D> apply,
    Function1<D, (A, B, C)> tupled,
  ) {
    final decoder = PrimitiveDecoder<D>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        return apply(_get(ra), _get(rb), _get(rc)).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<D>(
      (a) => tupled(a)(
        (a, b, c) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines four field codecs into a codec for type [E].
  static Codec<E> product4<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    Function4<A, B, C, D, E> apply,
    Function1<E, (A, B, C, D)> tupled,
  ) {
    final decoder = PrimitiveDecoder<E>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        return apply(_get(ra), _get(rb), _get(rc), _get(rd)).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<E>(
      (a) => tupled(a)(
        (a, b, c, d) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 5 field codecs into a codec for type [F].
  static Codec<F> product5<A, B, C, D, E, F>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    Function5<A, B, C, D, E, F> apply,
    Function1<F, (A, B, C, D, E)> tupled,
  ) {
    final decoder = PrimitiveDecoder<F>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        return apply(_get(ra), _get(rb), _get(rc), _get(rd), _get(re)).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<F>(
      (a) => tupled(a)(
        (a, b, c, d, e) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 6 field codecs into a codec for type [G].
  static Codec<G> product6<A, B, C, D, E, F, G>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    Function6<A, B, C, D, E, F, G> apply,
    Function1<G, (A, B, C, D, E, F)> tupled,
  ) {
    final decoder = PrimitiveDecoder<G>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        return apply(_get(ra), _get(rb), _get(rc), _get(rd), _get(re), _get(rf)).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<G>(
      (a) => tupled(a)(
        (a, b, c, d, e, f) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 7 field codecs into a codec for type [H].
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
  ) {
    final decoder = PrimitiveDecoder<H>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<H>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 8 field codecs into a codec for type [I].
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
  ) {
    final decoder = PrimitiveDecoder<I>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<I>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 9 field codecs into a codec for type [J].
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
  ) {
    final decoder = PrimitiveDecoder<J>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<J>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 10 field codecs into a codec for type [K].
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
  ) {
    final decoder = PrimitiveDecoder<K>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<K>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 11 field codecs into a codec for type [L].
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
  ) {
    final decoder = PrimitiveDecoder<L>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<L>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 12 field codecs into a codec for type [M].
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
  ) {
    final decoder = PrimitiveDecoder<M>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<M>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 13 field codecs into a codec for type [N].
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
  ) {
    final decoder = PrimitiveDecoder<N>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<N>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 14 field codecs into a codec for type [O].
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
  ) {
    final decoder = PrimitiveDecoder<O>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<O>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 15 field codecs into a codec for type [P].
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
  ) {
    final decoder = PrimitiveDecoder<P>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<P>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 16 field codecs into a codec for type [Q].
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
  ) {
    final decoder = PrimitiveDecoder<Q>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<Q>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 17 field codecs into a codec for type [R].
  static Codec<R> product17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
  ) {
    final decoder = PrimitiveDecoder<R>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<R>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 18 field codecs into a codec for type [S].
  static Codec<S> product18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
  ) {
    final decoder = PrimitiveDecoder<S>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        final rr = _decodeField(obj, codecR);
        if (rr.isLeft) return (rr as Left<DecodingFailure, R>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
          _get(rr),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
        codecR.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<S>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
            (codecR.key, codecR.value.encode(r)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 19 field codecs into a codec for type [T].
  static Codec<T> product19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T> apply,
    Function1<T, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> tupled,
  ) {
    final decoder = PrimitiveDecoder<T>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        final rr = _decodeField(obj, codecR);
        if (rr.isLeft) return (rr as Left<DecodingFailure, R>).a.asLeft();

        final rs = _decodeField(obj, codecS);
        if (rs.isLeft) return (rs as Left<DecodingFailure, S>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
          _get(rr),
          _get(rs),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
        codecR.decodeC(cursor),
        codecS.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<T>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
            (codecR.key, codecR.value.encode(r)),
            (codecS.key, codecS.value.encode(s)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 20 field codecs into a codec for type [U].
  static Codec<U> product20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U> apply,
    Function1<U, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> tupled,
  ) {
    final decoder = PrimitiveDecoder<U>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        final rr = _decodeField(obj, codecR);
        if (rr.isLeft) return (rr as Left<DecodingFailure, R>).a.asLeft();

        final rs = _decodeField(obj, codecS);
        if (rs.isLeft) return (rs as Left<DecodingFailure, S>).a.asLeft();

        final rt = _decodeField(obj, codecT);
        if (rt.isLeft) return (rt as Left<DecodingFailure, T>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
          _get(rr),
          _get(rs),
          _get(rt),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
        codecR.decodeC(cursor),
        codecS.decodeC(cursor),
        codecT.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<U>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
            (codecR.key, codecR.value.encode(r)),
            (codecS.key, codecS.value.encode(s)),
            (codecT.key, codecT.value.encode(t)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 21 field codecs into a codec for type [V].
  static Codec<V> product21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V> apply,
    Function1<V, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> tupled,
  ) {
    final decoder = PrimitiveDecoder<V>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        final rr = _decodeField(obj, codecR);
        if (rr.isLeft) return (rr as Left<DecodingFailure, R>).a.asLeft();

        final rs = _decodeField(obj, codecS);
        if (rs.isLeft) return (rs as Left<DecodingFailure, S>).a.asLeft();

        final rt = _decodeField(obj, codecT);
        if (rt.isLeft) return (rt as Left<DecodingFailure, T>).a.asLeft();

        final ru = _decodeField(obj, codecU);
        if (ru.isLeft) return (ru as Left<DecodingFailure, U>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
          _get(rr),
          _get(rs),
          _get(rt),
          _get(ru),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
        codecR.decodeC(cursor),
        codecS.decodeC(cursor),
        codecT.decodeC(cursor),
        codecU.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<V>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
            (codecR.key, codecR.value.encode(r)),
            (codecS.key, codecS.value.encode(s)),
            (codecT.key, codecT.value.encode(t)),
            (codecU.key, codecU.value.encode(u)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  /// Combines 22 field codecs into a codec for type [W].
  static Codec<W> product22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
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
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W> apply,
    Function1<W, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> tupled,
  ) {
    final decoder = PrimitiveDecoder<W>(
      (json) {
        if (json is! JObject) {
          return DecodingFailure(WrongTypeExpectation('object', json), nil<CursorOp>()).asLeft();
        }

        final obj = json.value;

        final ra = _decodeField(obj, codecA);
        if (ra.isLeft) return (ra as Left<DecodingFailure, A>).a.asLeft();

        final rb = _decodeField(obj, codecB);
        if (rb.isLeft) return (rb as Left<DecodingFailure, B>).a.asLeft();

        final rc = _decodeField(obj, codecC);
        if (rc.isLeft) return (rc as Left<DecodingFailure, C>).a.asLeft();

        final rd = _decodeField(obj, codecD);
        if (rd.isLeft) return (rd as Left<DecodingFailure, D>).a.asLeft();

        final re = _decodeField(obj, codecE);
        if (re.isLeft) return (re as Left<DecodingFailure, E>).a.asLeft();

        final rf = _decodeField(obj, codecF);
        if (rf.isLeft) return (rf as Left<DecodingFailure, F>).a.asLeft();

        final rg = _decodeField(obj, codecG);
        if (rg.isLeft) return (rg as Left<DecodingFailure, G>).a.asLeft();

        final rh = _decodeField(obj, codecH);
        if (rh.isLeft) return (rh as Left<DecodingFailure, H>).a.asLeft();

        final ri = _decodeField(obj, codecI);
        if (ri.isLeft) return (ri as Left<DecodingFailure, I>).a.asLeft();

        final rj = _decodeField(obj, codecJ);
        if (rj.isLeft) return (rj as Left<DecodingFailure, J>).a.asLeft();

        final rk = _decodeField(obj, codecK);
        if (rk.isLeft) return (rk as Left<DecodingFailure, K>).a.asLeft();

        final rl = _decodeField(obj, codecL);
        if (rl.isLeft) return (rl as Left<DecodingFailure, L>).a.asLeft();

        final rm = _decodeField(obj, codecM);
        if (rm.isLeft) return (rm as Left<DecodingFailure, M>).a.asLeft();

        final rn = _decodeField(obj, codecN);
        if (rn.isLeft) return (rn as Left<DecodingFailure, N>).a.asLeft();

        final ro = _decodeField(obj, codecO);
        if (ro.isLeft) return (ro as Left<DecodingFailure, O>).a.asLeft();

        final rp = _decodeField(obj, codecP);
        if (rp.isLeft) return (rp as Left<DecodingFailure, P>).a.asLeft();

        final rq = _decodeField(obj, codecQ);
        if (rq.isLeft) return (rq as Left<DecodingFailure, Q>).a.asLeft();

        final rr = _decodeField(obj, codecR);
        if (rr.isLeft) return (rr as Left<DecodingFailure, R>).a.asLeft();

        final rs = _decodeField(obj, codecS);
        if (rs.isLeft) return (rs as Left<DecodingFailure, S>).a.asLeft();

        final rt = _decodeField(obj, codecT);
        if (rt.isLeft) return (rt as Left<DecodingFailure, T>).a.asLeft();

        final ru = _decodeField(obj, codecU);
        if (ru.isLeft) return (ru as Left<DecodingFailure, U>).a.asLeft();

        final rv = _decodeField(obj, codecV);
        if (rv.isLeft) return (rv as Left<DecodingFailure, V>).a.asLeft();

        return apply(
          _get(ra),
          _get(rb),
          _get(rc),
          _get(rd),
          _get(re),
          _get(rf),
          _get(rg),
          _get(rh),
          _get(ri),
          _get(rj),
          _get(rk),
          _get(rl),
          _get(rm),
          _get(rn),
          _get(ro),
          _get(rp),
          _get(rq),
          _get(rr),
          _get(rs),
          _get(rt),
          _get(ru),
          _get(rv),
        ).asRight();
      },
      (cursor) => (
        codecA.decodeC(cursor),
        codecB.decodeC(cursor),
        codecC.decodeC(cursor),
        codecD.decodeC(cursor),
        codecE.decodeC(cursor),
        codecF.decodeC(cursor),
        codecG.decodeC(cursor),
        codecH.decodeC(cursor),
        codecI.decodeC(cursor),
        codecJ.decodeC(cursor),
        codecK.decodeC(cursor),
        codecL.decodeC(cursor),
        codecM.decodeC(cursor),
        codecN.decodeC(cursor),
        codecO.decodeC(cursor),
        codecP.decodeC(cursor),
        codecQ.decodeC(cursor),
        codecR.decodeC(cursor),
        codecS.decodeC(cursor),
        codecT.decodeC(cursor),
        codecU.decodeC(cursor),
        codecV.decodeC(cursor),
      ).mapN(apply),
    );

    final encoder = Encoder.instance<W>(
      (a) => tupled(a)(
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v) => Json.fromJsonObject(
          JsonObject.fromIterable([
            (codecA.key, codecA.value.encode(a)),
            (codecB.key, codecB.value.encode(b)),
            (codecC.key, codecC.value.encode(c)),
            (codecD.key, codecD.value.encode(d)),
            (codecE.key, codecE.value.encode(e)),
            (codecF.key, codecF.value.encode(f)),
            (codecG.key, codecG.value.encode(g)),
            (codecH.key, codecH.value.encode(h)),
            (codecI.key, codecI.value.encode(i)),
            (codecJ.key, codecJ.value.encode(j)),
            (codecK.key, codecK.value.encode(k)),
            (codecL.key, codecL.value.encode(l)),
            (codecM.key, codecM.value.encode(m)),
            (codecN.key, codecN.value.encode(n)),
            (codecO.key, codecO.value.encode(o)),
            (codecP.key, codecP.value.encode(p)),
            (codecQ.key, codecQ.value.encode(q)),
            (codecR.key, codecR.value.encode(r)),
            (codecS.key, codecS.value.encode(s)),
            (codecT.key, codecT.value.encode(t)),
            (codecU.key, codecU.value.encode(u)),
            (codecV.key, codecV.value.encode(v)),
          ]),
        ),
      ),
    );

    return Codec.from(decoder, encoder);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Tuple Instances
  //////////////////////////////////////////////////////////////////////////////

  /// Combines 2 field codecs into a codec for a 2-tuple.
  static Codec<(A, B)> tuple2<A, B>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
  ) => product2(codecA, codecB, (a, b) => (a, b), identity);

  /// Combines 3 field codecs into a codec for a 3-tuple.
  static Codec<(A, B, C)> tuple3<A, B, C>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
  ) => product3(codecA, codecB, codecC, (a, b, c) => (a, b, c), identity);

  /// Combines 4 field codecs into a codec for a 4-tuple.
  static Codec<(A, B, C, D)> tuple4<A, B, C, D>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
  ) => product4(codecA, codecB, codecC, codecD, (a, b, c, d) => (a, b, c, d), identity);

  /// Combines 5 field codecs into a codec for a 5-tuple.
  static Codec<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
  ) => product5(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    (a, b, c, d, e) => (a, b, c, d, e),
    identity,
  );

  /// Combines 6 field codecs into a codec for a 6-tuple.
  static Codec<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
  ) => product6(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    (a, b, c, d, e, f) => (a, b, c, d, e, f),
    identity,
  );

  /// Combines 7 field codecs into a codec for a 7-tuple.
  static Codec<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
  ) => product7(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    codecG,
    (a, b, c, d, e, f, g) => (a, b, c, d, e, f, g),
    identity,
  );

  /// Combines 8 field codecs into a codec for a 8-tuple.
  static Codec<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
  ) => product8(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    codecG,
    codecH,
    (a, b, c, d, e, f, g, h) => (a, b, c, d, e, f, g, h),
    identity,
  );

  /// Combines 9 field codecs into a codec for a 9-tuple.
  static Codec<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    KeyValueCodec<A> codecA,
    KeyValueCodec<B> codecB,
    KeyValueCodec<C> codecC,
    KeyValueCodec<D> codecD,
    KeyValueCodec<E> codecE,
    KeyValueCodec<F> codecF,
    KeyValueCodec<G> codecG,
    KeyValueCodec<H> codecH,
    KeyValueCodec<I> codecI,
  ) => product9(
    codecA,
    codecB,
    codecC,
    codecD,
    codecE,
    codecF,
    codecG,
    codecH,
    codecI,
    (a, b, c, d, e, f, g, h, i) => (a, b, c, d, e, f, g, h, i),
    identity,
  );

  /// Combines 10 field codecs into a codec for a 10-tuple.
  static Codec<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
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
  ) => product10(
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
    (a, b, c, d, e, f, g, h, i, j) => (a, b, c, d, e, f, g, h, i, j),
    identity,
  );

  /// Combines 11 field codecs into a codec for a 11-tuple.
  static Codec<(A, B, C, D, E, F, G, H, I, J, K)> tuple11<A, B, C, D, E, F, G, H, I, J, K>(
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
  ) => product11(
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
    (a, b, c, d, e, f, g, h, i, j, k) => (a, b, c, d, e, f, g, h, i, j, k),
    identity,
  );

  /// Combines 12 field codecs into a codec for a 12-tuple.
  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L)> tuple12<A, B, C, D, E, F, G, H, I, J, K, L>(
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
  ) => product12(
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
    (a, b, c, d, e, f, g, h, i, j, k, l) => (a, b, c, d, e, f, g, h, i, j, k, l),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M)>
  tuple13<A, B, C, D, E, F, G, H, I, J, K, L, M>(
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
  ) => product13(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m) => (a, b, c, d, e, f, g, h, i, j, k, l, m),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>
  tuple14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
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
  ) => product14(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n) => (a, b, c, d, e, f, g, h, i, j, k, l, m, n),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>
  tuple15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
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
  ) => product15(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) => (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>
  tuple16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
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
  ) => product16(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>
  tuple17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
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
  ) => product17(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>
  tuple18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
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
  ) => product18(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
      r,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>
  tuple19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
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
  ) => product19(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
      r,
      s,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
  tuple20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
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
  ) => product20(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
      r,
      s,
      t,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
  tuple21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
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
  ) => product21(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
      r,
      s,
      t,
      u,
    ),
    identity,
  );

  static Codec<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
  tuple22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
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
  ) => product22(
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
    (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v) => (
      a,
      b,
      c,
      d,
      e,
      f,
      g,
      h,
      i,
      j,
      k,
      l,
      m,
      n,
      o,
      p,
      q,
      r,
      s,
      t,
      u,
      v,
    ),
    identity,
  );
}
