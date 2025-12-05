import 'package:ribs_core/src/option.dart';
import 'package:test/test.dart';

Matcher isSome<A>([A? expected]) => _IsSome(expected);

Matcher isNone() => const _IsNone();

class _IsSome<A> extends Matcher {
  final A? _expected;

  const _IsSome(this._expected);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Option<A>) {
      if (_expected != null) {
        return item.filter((a) => a == _expected).isDefined;
      } else {
        return item.isDefined;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) => description.add('<Instance of Option<$A>>');
}

class _IsNone extends Matcher {
  const _IsNone();

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Option) {
      return item.isEmpty;
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) => description.add('<Instance of None>');
}
