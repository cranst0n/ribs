import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  test('getAndUpdate', () {
    final test = Ref.of(0)
        .flatMap((ref) => ref.getAndUpdate((a) => a + 1).product(ref.value()));

    expect(test, ioSucceeded((0, 1)));
  });

  test('getAndSet', () {
    final test =
        Ref.of(0).flatMap((ref) => ref.getAndSet(42).product(ref.value()));

    expect(test, ioSucceeded((0, 42)));
  });

  test('access successful set', () {
    final test = Ref.of(0).flatMap(
        (ref) => ref.access().flatMap((t) => t.$2(42)).product(ref.value()));

    expect(test, ioSucceeded((true, 42)));
  });

  test('access failed set', () {
    final test = Ref.of(0).flatMap((ref) => ref
        .access()
        .flatMap((t) => ref.setValue(10).flatMap((_) => t.$2(42)))
        .product(ref.value()));

    expect(test, ioSucceeded((false, 10)));
  });

  test('tryModify', () {
    final test = Ref.of(0).flatMap((ref) =>
        ref.tryModify((x) => (x + 3, x.toString())).product(ref.value()));

    expect(test, ioSucceeded(('0'.some, 3)));
  });
}
