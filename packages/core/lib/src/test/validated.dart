import 'package:ribs_core/src/collection/immutable/non_empty_ilist.dart';
import 'package:ribs_core/src/validated.dart';
import 'package:test/test.dart';

Matcher isValid<E, A>([A? expected]) => _IsValid<E, A>(expected);

Matcher isValidNel<E, A>([A? expected]) =>
    _IsValid<NonEmptyIList<E>, A>(expected);

Matcher isInvalid<E, A>([E? expected]) => _IsInvalid<E, A>(expected);

class _IsValid<E, A> extends Matcher {
  final A? _expected;

  const _IsValid(this._expected);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Validated<E, A>) {
      if (_expected != null) {
        return item.fold((_) => false, (a) => a == _expected);
      } else {
        return item.isValid;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) =>
      description.add('<Instance of Validated<$A>>');
}

class _IsInvalid<E, A> extends Matcher {
  final E? _expected;

  const _IsInvalid(this._expected);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Validated<E, A>) {
      if (_expected != null) {
        return item.fold((e) => e == _expected, (_) => false);
      } else {
        return item.isInvalid;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) =>
      description.add('<Instance of Validated<$A>>');
}
