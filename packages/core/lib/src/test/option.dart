import 'package:ribs_core/src/option.dart';
import 'package:test/test.dart';

Matcher isSome([Object? matcher]) => _IsSome(matcher);

Matcher isNone() => isA<None>();

class _IsSome extends Matcher {
  final Object? matcher;

  const _IsSome(this.matcher);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Option) {
      if (matcher != null) {
        return item.filter((a) => wrapMatcher(matcher).matches(a, matchState)).isDefined;
      } else {
        return item.isDefined;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) => description.add('<Instance of Option>');
}
