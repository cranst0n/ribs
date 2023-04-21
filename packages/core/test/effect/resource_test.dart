import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('pure', () async {
    final res = Resource.pure(42)
        .map((a) => a * 2)
        .flatMap((a) => Resource.pure('abc'));

    final result =
        await res.use((a) => IO.pure('${a}123')).unsafeRunToFutureOutcome();

    expect(result, Outcome.succeeded('abc123'));
  });

  test('both', () async {
    bool aReleased = false;
    bool bReleased = false;

    final res = Resource.both(
      Resource.make(IO.pure(42), (a) => IO.exec(() => aReleased = true)),
      Resource.make(IO.pure(43), (a) => IO.exec(() => bReleased = true)),
    );

    final result =
        await res.use((a) => IO.pure(a.$1 + a.$2)).unsafeRunToFutureOutcome();

    expect(result, Outcome.succeeded(85));
    expect(aReleased, isTrue);
    expect(bReleased, isTrue);
  });

  test('attempt success', () async {
    bool released = false;

    final res = Resource.make(
      IO.pure(42),
      (_) => IO.exec(() => released = true),
    );

    final result = await res.attempt().use_().unsafeRunToFutureOutcome();

    expect(result, Outcome.succeeded(Unit()));
    expect(released, isTrue);
  });

  test('attempt failure', () async {
    bool released = false;

    final res = Resource.make(
      IO.raiseError<int>(IOError('boom')),
      (_) => IO.exec(() => released = true),
    );

    final result = await res.attempt().use_().unsafeRunToFutureOutcome();

    expect(result, Outcome.succeeded(Unit()));
    expect(released, isFalse);
  });
}
