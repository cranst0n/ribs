import 'package:ribs_http/ribs_http.dart';

class ContentEncoding {
  static const name = CIString('Content-Encoding');

  static final ContentEncoding _singleton = ContentEncoding._();

  factory ContentEncoding() => _singleton;

  ContentEncoding._();

  Header call(ContentCoding encoding) => Header(name, encoding.coding);
}
