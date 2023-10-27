import 'package:ribs_core/ribs_core.dart';
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
      () => SyncIO.raiseError<int>(RuntimeException('boom!')).unsafeRunSync(),
      throwsException,
    );
  });

  test('map', () {
    expect(SyncIO.pure(21).map((a) => a * 2).unsafeRunSync(), 42);
  });

  test('flatMap', () {
    expect(
      SyncIO.pure(21).flatMap((a) => SyncIO.pure(a * 2)).unsafeRunSync(),
      42,
    );
  });

  test('handleErrorWith', () {
    expect(
      SyncIO.raiseError<int>(RuntimeException('boom!'))
          .handleErrorWith((a) => SyncIO.pure(42))
          .unsafeRunSync(),
      42,
    );
  });

  test('attempt (success)', () {
    expect(
      SyncIO.pure(42).attempt().unsafeRunSync(),
      42.asRight<RuntimeException>(),
    );
  });

  test('attempt (failure)', () {
    expect(
      SyncIO.raiseError<int>(RuntimeException('boom!'))
          .attempt()
          .unsafeRunSync()
          .isLeft,
      isTrue,
    );
  });
}
