import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

final class Request extends Message {
  final Method method;
  final Uri uri;

  const Request({
    this.method = Method.GET,
    required this.uri,
    super.headers,
    super.version,
    super.body,
  });

  factory Request.delete(Uri uri) => Request(method: Method.DELETE, uri: uri);
  factory Request.get(Uri uri) => Request(uri: uri);
  factory Request.post(Uri uri) => Request(method: Method.POST, uri: uri);
  factory Request.put(Uri uri) => Request(method: Method.PUT, uri: uri);

  Request copy({
    Method? method,
    Uri? uri,
    Headers? headers,
    HttpVersion? version,
    EntityBody? body,
  }) =>
      Request(
        method: method ?? this.method,
        uri: uri ?? this.uri,
        headers: headers ?? this.headers,
        version: version ?? this.version,
        body: body ?? this.body,
      );

  Request withMethod(Method method) => copy(method: method);
  Request withUri(Uri uri) => copy(uri: uri);
  Request withHeaders(Headers headers) => copy(headers: headers);
  Request withVersion(HttpVersion version) => copy(version: version);
  Request withBody(EntityBody body) => copy(body: body);
  Request withEmptyBody() => withBody(EntityBody.Empty);

  Request transformHeaders(Function1<Headers, Headers> f) =>
      copy(headers: f(headers));

  Request filterHeaders(Function1<Header, bool> p) =>
      transformHeaders((h) => h.transform((a) => a.filter(p)));

  Request removeHeader(CIString key) => transformHeaders(
      (h) => h.transform((l) => l.filterNot((hdrs) => hdrs.name == key)));

  Request addHeader(Header header) => transformHeaders((h) => h.add(header));
  Request putHeader(Header header) => transformHeaders((h) => h.put(header));

  @override
  String toString() =>
      'Request(method=$method, uri=$uri, httpVersion=$version, headers=${headers.redactSensitive()}, entity=$body)';
}
