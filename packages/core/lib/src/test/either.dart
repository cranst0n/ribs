import 'package:ribs_core/src/either.dart';
import 'package:test/test.dart';

/// Returns a [Matcher] that matches a [Left] value.
///
/// If [matcher] is provided, the matched value inside [Left] must also satisfy
/// it. If omitted, any [Left] value matches.
Matcher isLeft([Object? matcher]) => _IsLeft(matcher);

/// Returns a [Matcher] that matches a [Right] value.
///
/// If [matcher] is provided, the matched value inside [Right] must also satisfy
/// it. If omitted, any [Right] value matches.
Matcher isRight([Object? matcher]) => _IsRight(matcher);

class _IsLeft extends Matcher {
  final Object? matcher;

  const _IsLeft(this.matcher);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Either) {
      if (matcher != null) {
        return item.fold(
          (a) => wrapMatcher(matcher).matches(a, matchState),
          (_) => false,
        );
      } else {
        return item.isLeft;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('isLeft ').addDescriptionOf(matcher);
  }
}

class _IsRight extends Matcher {
  final Object? matcher;

  const _IsRight(this.matcher);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Either) {
      if (matcher != null) {
        return item.fold(
          (_) => false,
          (b) => wrapMatcher(matcher).matches(b, matchState),
        );
      } else {
        return item.isRight;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('isRight ').addDescriptionOf(matcher);
  }
}
