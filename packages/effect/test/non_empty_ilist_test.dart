import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('NonEmptyIList effects', () {
    test('flatTraverseIO', () {
      IO<IList<int>> f(int i) => IO.pure(ilist([i - 1, i, i + 1]));

      expect(
        ilist([1, 2, 3]).flatTraverseIO(f),
        ioSucceeded(ilist([0, 1, 2, 1, 2, 3, 2, 3, 4])),
      );
    });

    test('parTraverseIO_', () {
      final io = nel(1, [2, 3]).parTraverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('traverseIO', () {
      final io = nel(1, [2, 3]).traverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(nel(2, [4, 6])));
    });

    test('traverseIO_', () {
      final io = nel(1, [2, 3]).traverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('parTraverseIO', () {
      final io = nel(1, [2, 3]).parTraverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(nel(2, [4, 6])));
    });

    test('traverseFilterIO', () {
      final io =
          nel(1, [2, 3]).traverseFilterIO((a) => IO.pure(Option.when(() => a.isOdd, () => a)));

      expect(io, ioSucceeded(ilist([1, 3])));
    });
  });
}
