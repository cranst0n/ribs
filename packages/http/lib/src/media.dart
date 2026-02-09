import 'dart:convert';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

abstract class Media {
  final EntityBody body;
  final Headers headers;

  const Media({
    this.headers = Headers.empty,
    this.body = EntityBody.Empty,
  });

  Option<ContentType> get contentType =>
      headers.get('Content-Type').flatMap((nel) => ContentType.parse(nel.head.value));

  IO<DecodeResult<A>> attemptAs<A>(EntityDecoder<A> decoder) => decoder.decode(this, false);

  Stream<String> get bodyText => body.map(utf8.decode);
}
