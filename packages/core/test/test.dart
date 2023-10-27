import 'package:matcher/src/expect/async_matcher.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

IO<Unit> expectIO(
  dynamic actual,
  dynamic matcher, {
  String? reason,
  Object? skip,
}) =>
    IO
        .fromFutureF(
            () => expectLater(actual, matcher, reason: reason, skip: skip))
        .voided();

Matcher ioSucceeded([Object? matcher]) =>
    _Succeeded(matcher ?? anyOf(isNotNull, isNull));

Matcher ioErrored([Object? matcher]) =>
    _Errored(matcher ?? isA<RuntimeException>());

Matcher ioCanceled() => _Canceled();

class _Succeeded extends AsyncMatcher {
  final Object _matcher;

  _Succeeded(this._matcher);

  @override
  Description describe(Description description) => description.add('succeeds');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! IO) {
      return 'was not an IO';
    }

    return item.unsafeRunToFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('IO did not succeed, but was canceled'),
        (err) => fail('IO did not succeed, but errored: $err'),
        (a) => expect(a, _matcher),
      );
    });
  }
}

class _Errored extends AsyncMatcher {
  final Object _matcher;

  _Errored(this._matcher);

  @override
  Description describe(Description description) {
    return description.add('errors');
  }

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! IO) {
      return 'was not an IO';
    }

    return item.unsafeRunToFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('IO was canceled'),
        (err) => expect(err, _matcher),
        (a) => fail('IO did not error, but succeeded as: $a'),
      );
    });
  }
}

class _Canceled extends AsyncMatcher {
  _Canceled();

  @override
  Description describe(Description description) =>
      description.add('<Instance of IO<_>>');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! IO) {
      return 'was not an IO';
    }

    return item.unsafeRunToFutureOutcome().then((outcome) {
      return outcome.fold(
        () => expect(0, 0),
        (err) => fail('IO was not canceled, but errored: $err'),
        (a) => fail('IO was not canceled, but succeeded as: $a'),
      );
    });
  }
}
