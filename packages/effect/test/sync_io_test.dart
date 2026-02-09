import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:test/test.dart';

void main() {
  test('pure', () {
    expect(SyncIO.pure(42).unsafeRunSync(), 42);
  });

  test('delay', () {
    expect(SyncIO.delay(() => 42).unsafeRunSync(), 42);
  });

  test('raiseError', () {
    expect(
      () => SyncIO.raiseError<int>('boom!').unsafeRunSync(),
      throwsA('boom!'),
    );
  });

  test('map', () {
    expect(SyncIO.pure(21).map((a) => a * 2).unsafeRunSync(), 42);
  });

  test('as', () {
    expect(SyncIO.pure(21).as('hi').unsafeRunSync(), 'hi');
  });

  test('flatMap', () {
    expect(
      SyncIO.pure(21).flatMap((a) => SyncIO.pure(a * 2)).unsafeRunSync(),
      42,
    );
  });

  test('handleError', () {
    expect(
      SyncIO.raiseError<int>('boom!').handleError((a) => 42).unsafeRunSync(),
      42,
    );
  });

  test('handleErrorWith', () {
    expect(
      SyncIO.raiseError<int>(
        'boom!',
      ).handleErrorWith((a) => SyncIO.pure(42)).unsafeRunSync(),
      42,
    );
  });

  test('productL', () {
    expect(SyncIO.pure(42).productL(() => SyncIO.pure(0)).unsafeRunSync(), 42);
  });

  test('productR', () {
    expect(SyncIO.pure(42).productR(() => SyncIO.pure(0)).unsafeRunSync(), 0);
  });

  test('redeem', () {
    expect(SyncIO.pure(42).redeem((_) => 'bad', (_) => 'good').unsafeRunSync(), 'good');

    expect(
      SyncIO.raiseError<int>('boom').redeem((_) => 'bad', (_) => 'good').unsafeRunSync(),
      'bad',
    );
  });

  test('redeemWith', () {
    expect(
      SyncIO.pure(42)
          .redeemWith(
            (_) => SyncIO.pure('bad'),
            (_) => SyncIO.pure('good'),
          )
          .unsafeRunSync(),
      'good',
    );

    expect(
      SyncIO.raiseError<int>('boom')
          .redeemWith(
            (_) => SyncIO.pure('bad'),
            (_) => SyncIO.pure('good'),
          )
          .unsafeRunSync(),
      'bad',
    );
  });

  test('attempt (success)', () {
    expect(
      SyncIO.pure(42).attempt().unsafeRunSync(),
      42.asRight<Object>(),
    );
  });

  test('attempt (failure)', () {
    expect(
      SyncIO.raiseError<int>('boom!').attempt().unsafeRunSync().isLeft,
      isTrue,
    );
  });
}
