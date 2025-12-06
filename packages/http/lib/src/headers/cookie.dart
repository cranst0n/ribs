import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class Cookie {
  static const name = CIString('Cookie');

  static final Cookie _singleton = Cookie._();

  factory Cookie() => _singleton;

  Cookie._();

  Header call(
    RequestCookie cookieA, [
    RequestCookie? cookieB,
    RequestCookie? cookieC,
    RequestCookie? cookieD,
    RequestCookie? cookieE,
    RequestCookie? cookieF,
    RequestCookie? cookieG,
    RequestCookie? cookieH,
    RequestCookie? cookieI,
    RequestCookie? cookieJ,
  ]) => Header(
    name,
    ilist([
      cookieA,
      cookieB,
      cookieC,
      cookieD,
      cookieE,
      cookieF,
      cookieG,
      cookieH,
      cookieI,
      cookieJ,
    ]).noNulls().map((a) => a.toString()).mkString(sep: ', '),
  );
}
