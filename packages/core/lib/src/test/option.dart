import 'package:ribs_core/src/option.dart';
import 'package:test/test.dart';

/// Returns a [Matcher] that matches a [Some] value.
///
/// If [matcher] is provided, the matched value inside [Some] must also satisfy
/// it. If omitted, any [Some] value matches.
Matcher isSome([Object? matcher]) => _IsSome(matcher);

/// Returns a [Matcher] that matches a [None] value.
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
