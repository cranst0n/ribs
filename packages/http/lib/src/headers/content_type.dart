import 'package:ribs_http/ribs_http.dart' as http;

class ContentType {
  static const name = http.CIString('Content-Type');

  static final ContentType _singleton = ContentType._();

  factory ContentType() => _singleton;

  ContentType._();

  http.Header call(http.ContentType contentType) => http.Header(name, contentType.toString());
}
