import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class Cookie {
  static const name = CIString('Cookie');

  static final Cookie _singleton = Cookie._();

  factory Cookie() => _singleton;

  Cookie._();

  Header call(
    RequestCookie head, [
    Iterable<RequestCookie> tail = const [],
  ]) =>
      Header(
        name,
        NonEmptyIList(head, ilist(tail))
            .map((a) => a.toString())
            .mkString(sep: ', '),
      );
}
