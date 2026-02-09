import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/src/ci_string.dart';

sealed class CacheDirective {
  CIString get name;

  const CacheDirective();

  String get value => name.toString();

  @override
  String toString() => value;

  static CacheDirective custom(String name) => _CustomDirective(name);

  static CacheDirective maxAge(Duration deltaSeconds) => _SecondsBased('max-age', deltaSeconds);

  static CacheDirective maxStale(Duration deltaSeconds) => _SecondsBased('max-stale', deltaSeconds);

  static CacheDirective minFresh(Duration deltaSeconds) => _SecondsBased('min-fresh', deltaSeconds);

  static CacheDirective mustRevalidate = _CustomDirective('must-revalidate');

  static CacheDirective noCache([Iterable<String> fieldNames = const []]) =>
      _FieldNameBased('no-cache', fieldNames);

  static CacheDirective noStore = _CustomDirective('no-store');

  static CacheDirective noTransform = _CustomDirective('no-transform');

  static CacheDirective onlyIfCached = _CustomDirective('only-if-cached');

  static CacheDirective private([Iterable<String> fieldNames = const []]) =>
      _FieldNameBased('private', fieldNames);

  static CacheDirective proxyRevalidate = _CustomDirective('proxy-revalidate');

  static CacheDirective public = _CustomDirective('public');

  static CacheDirective sMaxAge(Duration deltaSeconds) => _SecondsBased('s-maxage', deltaSeconds);

  static CacheDirective staleIfError(Duration deltaSeconds) =>
      _SecondsBased('stale-if-error', deltaSeconds);

  static CacheDirective staleWhileRevalidate(Duration deltaSeconds) =>
      _SecondsBased('stale-while-revalidate', deltaSeconds);
}

class _SecondsBased extends CacheDirective {
  @override
  final CIString name;

  final Duration deltaSeconds;

  _SecondsBased(String name, this.deltaSeconds) : name = CIString(name);

  @override
  String get value => '$name=${deltaSeconds.inSeconds}';
}

class _FieldNameBased extends CacheDirective {
  @override
  final CIString name;

  final IList<CIString> fieldNames;

  _FieldNameBased(String name, [Iterable<String> fieldNames = const []])
      : name = CIString(name),
        fieldNames = ilist(fieldNames.map(CIString.new));

  @override
  String get value =>
      '$name${fieldNames.isEmpty ? "" : "=${fieldNames.mkString(start: '"', sep: ",", end: '"')}"}';
}

final class _CustomDirective extends CacheDirective {
  @override
  final CIString name;

  _CustomDirective(String name) : name = CIString(name);
}
