import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_json/ribs_json.dart' hide DecodeResult;

abstract class EntityDecoder<A> {
  IO<DecodeResult<A>> decode(Media media, bool strict);

  ISet<MediaRange> get consumes;

  EntityDecoder<B> map<B>(Function1<A, B> f) => _DecoderF(
      (m, s) => decode(m, s).map((result) => result.map(f)), consumes);

  EntityDecoder<B> flatMapR<B>(Function1<A, DecodeResult<B>> f) =>
      _DecoderF((m, s) => decode(m, s).map((a) => a.flatMap(f)), consumes);

  static final binary = _DecoderF<List<int>>(
    (media, strict) => IO
        .fromFutureF(() => media.body.fold(
            List<int>.empty(growable: true), (acc, elem) => acc..addAll(elem)))
        .redeem(
          (err) => DecodeFailure(err.message).asLeft(),
          (bytes) => bytes.asRight(),
        ),
    iset({MediaRange.all}),
  );

  static final json = _DecoderF<Json>(
    (media, strict) => IO
        .fromFutureF(
          () => media.body
              .transform(JsonTransformer.bytes(AsyncParserMode.singleValue))
              .first,
        )
        .redeem(
          (err) => DecodeFailure(err.message).asLeft(),
          (j) => j.asRight(),
        ),
    iset({MediaRange.text}),
  );

  static EntityDecoder<A> jsonAs<A>(Decoder<A> decoder) => json.flatMapR(
      (json) => decoder.decode(json).leftMap((a) => DecodeFailure(a)));

  static final string = _DecoderF<String>(
    (media, strict) => IO
        .fromFutureF(() => media.bodyText.fold('', (acc, elem) => acc + elem))
        .redeem(
          (err) => DecodeFailure(err.message, err.stackTrace).asLeft(),
          (str) => str.asRight(),
        ),
    iset({}),
  );

  static final voided = _DecoderF<Unit>(
    (media, strict) => IO.fromFutureF(() => media.body.drain(Unit().asRight())),
    iset({MediaRange.all}),
  );
}

class _DecoderF<A> extends EntityDecoder<A> {
  final Function2<Media, bool, IO<DecodeResult<A>>> f;

  @override
  final ISet<MediaRange> consumes;

  _DecoderF(this.f, this.consumes);

  @override
  IO<DecodeResult<A>> decode(Media media, bool strict) => f(media, strict);
}
