import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart' hide ContentType;

import 'package:ribs_http/src/headers/content_type.dart' as ct;

export 'headers/headers.dart';

final class Headers {
  final IList<Header> headers;

  Headers(Iterable<Header> hdsr) : headers = ilist(hdsr);

  const Headers.ilist(this.headers);

  Headers add(Header header) => Headers.ilist(headers.appended(header));

  Headers concat(Headers those) {
    if (those.headers.isEmpty) {
      return this;
    } else if (headers.isEmpty) {
      return those;
    } else {
      final thoseNames = those.headers.map((h) => h.name);

      return Headers.ilist(
        headers.filterNot((h) => thoseNames.contains(h.name)).concat(those.headers),
      );
    }
  }

  Headers put(Header header) => concat(Headers([header]));

  Headers redactSensitive() => transform(
    (hdrs) => hdrs.map(
      (hdr) => sensitiveHeaders.contains(hdr.name) ? Header(hdr.name, '<REDACTED>') : hdr,
    ),
  );

  Headers transform(Function1<IList<Header>, IList<Header>> f) => Headers.ilist(f(headers));

  Option<NonEmptyIList<Header>> get(String key) =>
      headers.filter((h) => h.name == CIString(key)).toNel();

  Option<Header> find(Header header) => headers.find((h) => h == header);

  @override
  String toString() => headers.mkString(start: '[', sep: ', ', end: ']');

  static const empty = Headers.ilist(Nil());

  static ISet<CIString> sensitiveHeaders = iset({Authorization.name, Cookie.name, SetCookie.name});
}

final class Header {
  final CIString name;
  final String value;

  const Header(this.name, this.value);

  @override
  String toString() => '$name: $value';

  static final accept = Accept().call;
  static final authorization = Authorization();
  static final cacheControl = CacheControl().call;
  static final cookie = Cookie().call;
  static final contentEncoding = ContentEncoding().call;
  static final contentType = ct.ContentType().call;
  static final set_cookie = SetCookie().call;
}
