import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('getAndUpdate', () async {
    final ref = Ref(0);

    final result = await ref
        .getAndUpdate((a) => a + 1)
        .product(ref.value())
        .unsafeRunToFuture();

    expect(result, const Tuple2(0, 1));
  });

  test('getAndSet', () async {
    final ref = Ref(0);

    final result =
        await ref.getAndSet(42).product(ref.value()).unsafeRunToFuture();

    expect(result, const Tuple2(0, 42));
  });

  test('access successful set', () async {
    final ref = Ref(0);

    final result = await ref
        .access()
        .flatMap((t) => t.$2(42))
        .product(ref.value())
        .unsafeRunToFuture();

    expect(result, const Tuple2(true, 42));
  });

  test('access failed set', () async {
    final ref = Ref(0);

    final result = await ref
        .access()
        .flatMap((t) => ref.setValue(10).flatMap((_) => t.$2(42)))
        .product(ref.value())
        .unsafeRunToFuture();

    expect(result, const Tuple2(false, 10));
  });

  test('tryModify', () async {
    final ref = Ref(0);

    final result = await ref
        .tryModify((x) => Tuple2(x + 3, x.toString()))
        .product(ref.value())
        .unsafeRunToFuture();

    expect(result, Tuple2('0'.some, 3));
  });
}
