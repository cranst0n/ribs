import 'package:ribs_http/ribs_http.dart';

class SetCookie {
  static const name = CIString('Set-Cookie');

  static final SetCookie _singleton = SetCookie._();

  factory SetCookie() => _singleton;

  SetCookie._();

  Header call(RequestCookie head) => Header(name, head.toString());
}
