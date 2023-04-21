import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('getAndUpdate', () async {
    final result = await Ref.of(0)
        .flatMap((ref) => ref.getAndUpdate((a) => a + 1).product(ref.value()))
        .unsafeRunToFuture();

    expect(result, (0, 1));
  });

  test('getAndSet', () async {
    final result = await Ref.of(0)
        .flatMap((ref) => ref.getAndSet(42).product(ref.value()))
        .unsafeRunToFuture();

    expect(result, (0, 42));
  });

  test('access successful set', () async {
    final result = await Ref.of(0)
        .flatMap(
            (ref) => ref.access().flatMap((t) => t.$2(42)).product(ref.value()))
        .unsafeRunToFuture();

    expect(result, (true, 42));
  });

  test('access failed set', () async {
    final result = await Ref.of(0)
        .flatMap((ref) => ref
            .access()
            .flatMap((t) => ref.setValue(10).flatMap((_) => t.$2(42)))
            .product(ref.value()))
        .unsafeRunToFuture();

    expect(result, (false, 10));
  });

  test('tryModify', () async {
    final result = await Ref.of(0)
        .flatMap((ref) =>
            ref.tryModify((x) => (x + 3, x.toString())).product(ref.value()))
        .unsafeRunToFuture();

    expect(result, ('0'.some, 3));
  });
}
