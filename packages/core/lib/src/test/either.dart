import 'package:ribs_core/src/either.dart';
import 'package:test/test.dart';

Matcher isLeft<A, B>([A? expected]) => _IsLeft<A, B>(expected);

Matcher isRight<A, B>([B? expected]) => _IsRight<A, B>(expected);

class _IsLeft<A, B> extends Matcher {
  final A? _expected;

  const _IsLeft(this._expected);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Either<A, B>) {
      if (_expected != null) {
        return item.fold((a) => a == _expected, (_) => false);
      } else {
        return item.isLeft;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) {
    if (_expected != null) {
      return description.add(Either.left<A, B>(_expected).toString());
    } else {
      return description.add('Left<$A, $B>()');
    }
  }
}

class _IsRight<A, B> extends Matcher {
  final B? _expected;

  const _IsRight(this._expected);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is Either<A, B>) {
      if (_expected != null) {
        return item.fold((_) => false, (b) => b == _expected);
      } else {
        return item.isRight;
      }
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) {
    if (_expected != null) {
      return description.add(Either.right<A, B>(_expected).toString());
    } else {
      return description.add('Right<$A, $B>()');
    }
  }
}
