import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('integer', () async {
    final prop = Prop('integer', Gen.chooseInt(0, 100), (int n) {
      if (n >= 50) expect(n, lessThan(50));
    });

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, 50),
    );
  });

  test('double', () async {
    final prop = Prop('double', Gen.chooseDouble(0.0, 10.0), (n) {
      if (n >= 1.0) expect(n, lessThan(1.0));
    });

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, closeTo(1.0, 1e-6)),
    );
  });

  test('IMap', () async {
    final prop = Prop(
      'imap',
      Gen.imapOf(Gen.chooseInt(1, 10), Gen.alphaLowerString(5), Gen.integer),
      (m) => expect(m.isEmpty, isTrue),
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value.size, 1),
    );
  });

  test('tuple', () async {
    final prop = Prop(
      'tuple',
      (Gen.chooseInt(0, 10), Gen.chooseInt(0, 10)).tupled,
      (t) {
        if (t.$1 >= 5 && t.$2 >= 5) fail('fail');
      },
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, (5, 5)),
    );
  });
  test('Option - Some', () async {
    final prop = Prop(
      'option some',
      Gen.option(Gen.chooseInt(0, 10)),
      (Option<int> o) => expect(o.isEmpty, isTrue),
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, const Some(0)),
    );
  });

  test('Option - None', () async {
    final prop = Prop(
      'option none',
      Gen.option(Gen.chooseInt(0, 10)),
      (Option<int> o) => fail('fail'),
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, const None()),
    );
  });

  test('Either - Left', () async {
    final prop = Prop(
      'either left',
      Gen.either(Gen.chooseInt(0, 10), Gen.chooseInt(0, 10)),
      (Either<int, int> e) => e.fold((i) => expect(i, lessThan(0)), (i) => true),
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, Either.left<int, int>(0)),
    );
  });

  test('Either - Right', () async {
    final prop = Prop(
      'either right',
      Gen.either(Gen.chooseInt(0, 10), Gen.chooseInt(0, 10)),
      (e) => e.fold((i) => true, (i) => expect(i, lessThan(0))),
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(failure.value, Either.right<int, int>(0)),
    );
  });

  test('List', () async {
    final prop = Prop<List<int>>(
      'list',
      Gen.listOf<int>(Gen.chooseInt(1, 10), Gen.chooseInt(0, 10)),
      (l) {
        if (l.contains(5) && l.length >= 2) fail('fail');
      },
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(
        failure.value,
        anyOf([
          [5, 0],
          [0, 5],
        ]),
      ),
    );
  });

  test('Map', () async {
    final prop = Prop<Map<int, int>>(
      'map',
      Gen.mapOf(Gen.chooseInt(1, 10), Gen.chooseInt(0, 10), Gen.chooseInt(0, 10)),
      (m) {
        if (m.containsKey(5) && m.length >= 2) fail('fail');
      },
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(
        failure.value,
        anyOf([
          {5: 0, 0: 0},
          {0: 0, 5: 0},
        ]),
      ),
    );
  });

  test('String', () async {
    final prop = Prop<String>(
      'string',
      Gen.alphaLowerString(10),
      (s) {
        if (s.contains('z') && s.length >= 2) fail('fail');
      },
    );

    final result = await prop.check();

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(
        failure.value,
        allOf([
          contains('z'),
          hasLength(2),
        ]),
      ),
    );
  });

  test('String - multiple steps', () async {
    final prop = Prop<String>(
      'string steps',
      Gen.alphaLowerString(20),
      (s) {
        if (s.contains('z') && s.length >= 3 && s.contains('a')) fail('fail');
      },
    );

    final result = await prop.check(numTests: 1000);

    result.fold(
      () => fail('shrink should have a prop failure.'),
      (failure) => expect(
        failure.value,
        allOf([
          contains('z'),
          contains('a'),
          hasLength(3),
        ]),
      ),
    );
  });
}
