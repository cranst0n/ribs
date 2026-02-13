import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('IList effects', () {
    test('flatTraverseIO', () {
      IO<IList<int>> f(int x) => IO.delay(() => ilist([x - 1, x, x + 1]));

      expect(nil<int>().flatTraverseIO(f), ioSucceeded(nil<int>()));
      expect(ilist([1]).flatTraverseIO(f), ioSucceeded(ilist([0, 1, 2])));
    });

    test('traverseIO', () {
      final io = ilist([1, 2, 3]).traverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(ilist([2, 4, 6])));
    });

    test('traverseIO_', () {
      final io = ilist([1, 2, 3]).traverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('parTraverseIO', () {
      final io = ilist([1, 2, 3]).parTraverseIO((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(ilist([2, 4, 6])));
    });

    test('parTraverseIO_', () {
      final io = ilist([1, 2, 3]).parTraverseIO_((a) => IO.pure(a * 2));
      expect(io, ioSucceeded(Unit()));
    });

    test('traverseFilterIO', () {
      final io = ilist([
        1,
        2,
        3,
      ]).traverseFilterIO((a) => IO.pure(Option.when(() => a.isOdd, () => a)));

      expect(io, ioSucceeded(ilist([1, 3])));
    });
  });
}
