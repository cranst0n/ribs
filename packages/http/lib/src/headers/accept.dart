import 'package:ribs_http/ribs_http.dart';

class Accept {
  static const name = CIString('Accept');

  static final Accept _singleton = Accept._();

  factory Accept() => _singleton;

  Accept._();

  Header call(MediaType mediaType) => Header(name, mediaType.toString());
}
