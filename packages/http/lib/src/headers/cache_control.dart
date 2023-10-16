import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class CacheControl {
  static const name = CIString('Cache-Control');

  static final CacheControl _singleton = CacheControl._();

  factory CacheControl() => _singleton;

  CacheControl._();

  Header call(
    CacheDirective head, [
    Iterable<CacheDirective> tail = const [],
  ]) =>
      Header(
        name,
        NonEmptyIList(head, ilist(tail))
            .map((a) => a.toString())
            .mkString(sep: '; '),
      );
}
