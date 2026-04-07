import 'package:ribs_core/src/validated.dart';
import 'package:test/test.dart';

/// Returns a [Matcher] that matches a [Valid] value.
///
/// If [matcher] is provided, the matched value inside [Valid] must also satisfy
/// it. If omitted, any [Valid] value matches.
Matcher isValid([Object? matcher]) => _IsValid(matcher);

/// Returns a [Matcher] that matches a [Valid] value for a [ValidatedNel].
///
/// If [matcher] is provided, the matched value inside [Valid] must also satisfy
/// it. If omitted, any [Valid] value matches.
Matcher isValidNel([Object? matcher]) => _IsValid(matcher);

/// Returns a [Matcher] that matches an [Invalid] value.
///
/// If [matcher] is provided, the matched error inside [Invalid] must also
/// satisfy it. If omitted, any [Invalid] value matches.
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
