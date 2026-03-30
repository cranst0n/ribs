import 'package:ribs_core/src/validated.dart';
import 'package:test/test.dart';

Matcher isValid([Object? matcher]) => _IsValid(matcher);

Matcher isValidNel([Object? matcher]) => _IsValid(matcher);

Matcher isInvalid([Object? expected]) => _IsInvalid(expected);

class _IsValid extends Matcher {
  final Object? matcher;

  const _IsValid(this.matcher);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Validated) {
      if (matcher != null) {
        return item.fold(
          (_) => false,
          (a) => wrapMatcher(matcher).matches(a, matchState),
        );
      } else {
        return item.isValid;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) => description.add('<Instance of Validated>');
}

class _IsInvalid extends Matcher {
  final Object? matcher;

  const _IsInvalid(this.matcher);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Validated) {
      if (matcher != null) {
        return item.fold(
          (e) => wrapMatcher(matcher).matches(e, matchState),
          (_) => false,
        );
      } else {
        return item.isInvalid;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) => description.add('<Instance of Validated>');
}
