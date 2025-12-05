import 'dart:async';
import 'dart:convert';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_http/src/url_form.dart';
import 'package:ribs_json/ribs_json.dart';

final class EntityBody extends StreamView<List<int>> {
  final Headers headers;
  final Option<int> bodyLength;

  const EntityBody(
    super.stream, {
    this.headers = Headers.empty,
    this.bodyLength = const None(),
  });

  EntityBody withContentType(ContentType contentType) => EntityBody(
        this,
        headers: headers.put(Header.contentType(contentType)),
        bodyLength: bodyLength,
      );

  static EntityBody string(String str) {
    final body = utf8.encode(str);
    return EntityBody(Stream.value(body), bodyLength: Some(body.length));
  }

  static EntityBody json(Json json) => string(json.printWith(Printer.noSpaces))
      .withContentType(ContentType(MediaType.application.json));

  static EntityBody urlForm(UrlForm urlForm) => EntityBody.string(UrlForm.encodeString(urlForm))
      .withContentType(ContentType(MediaType.application.xWwwFormUrlEncoded));

  static const Empty = EntityBody(Stream.empty());
}
