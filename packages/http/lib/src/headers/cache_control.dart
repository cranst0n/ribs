import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class CacheControl {
  static const name = CIString('Cache-Control');

  static final CacheControl _singleton = CacheControl._();

  factory CacheControl() => _singleton;

  CacheControl._();

  Header call(
    CacheDirective directiveA, [
    CacheDirective? directiveB,
    CacheDirective? directiveC,
    CacheDirective? directiveD,
    CacheDirective? directiveE,
    CacheDirective? directiveF,
    CacheDirective? directiveG,
    CacheDirective? directiveH,
    CacheDirective? directiveI,
    CacheDirective? directiveJ,
  ]) =>
      Header(
        name,
        ilist([
          directiveA,
          directiveB,
          directiveC,
          directiveD,
          directiveE,
          directiveF,
          directiveG,
          directiveH,
          directiveI,
          directiveJ,
        ]).noNulls().map((a) => a.toString()).mkString(sep: '; '),
      );
}
