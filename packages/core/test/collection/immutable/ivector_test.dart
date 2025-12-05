import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IVector', () {
    // 0, 2^5, 2^10, 2^15, 2^20, 2^25
    final vectorNBounds = [0, 32, 1024, 32768, 1048576, 33554432].expand((n) => [n, n + 1]);

    test('sandbox', () {
      vectorNBounds.forEach((n) {
        final v = IVector.fill(n, 0);
        // ignore: avoid_print
        print('($n) ${v.runtimeType}');
      });
    }, skip: true);

    test('fill / toList', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).toList().length, n);
      }
    });

    test('length', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).length, n);
      }
    });

    test('map', () {
      for (final n in vectorNBounds) {
        final l = IVector.tabulate(n, (x) => x).map((a) => a + 1).toList();

        expect(l.length, n);
        if (l.isNotEmpty) {
          expect(l.last, n);
        }
      }
    });

    test('appended', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).appended(1).toList().last, 1);
      }
    });

    test('appendedAll', () {
      for (final n in vectorNBounds) {
        final addN = max(n ~/ 2, 1);
        expect(IVector.fill(n, 0).appendedAll(IVector.fill(addN, 0)).toList().length, n + addN);
      }
    });

    test('appendedAll (random)', () {
      for (final n in vectorNBounds) {
        final addN = Random.secure().nextInt(max(n, 1));
        expect(IVector.fill(n, 0).appendedAll(IVector.fill(addN, 0)).toList().length, n + addN);
      }
    });

    test('drop', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).drop(1).toList().first, 1);
        } else {
          expect(IVector.tabulate(n, identity).drop(1).toList(), isEmpty);
        }
      }
    });

    test('dropRight', () {
      for (final n in vectorNBounds) {
        if (n > 2) {
          expect(IVector.tabulate(n, identity).dropRight(2).toList().last, n - 3);
        } else {
          expect(IVector.tabulate(n, identity).dropRight(2).toList(), isEmpty);
        }
      }
    });

    test('init', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).init().toList().last, n - 2);
        } else {
          expect(IVector.tabulate(n, identity).init().toList(), isEmpty);
        }
      }
    });

    test('prepended', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).prepended(1).toList().first, 1);
      }
    });

    test('slice', () {
      for (final n in vectorNBounds) {
        final until = max(0, n - 1);
        expect(
          IVector.tabulate(n + 1, identity).slice(0, until).toList().length,
          until,
        );
      }
    });

    test('tail', () {
      for (final n in vectorNBounds) {
        if (n > 1) {
          expect(IVector.tabulate(n, identity).tail().toList().first, 1);
        } else {
          expect(IVector.tabulate(n, identity).tail().toList(), isEmpty);
        }
      }
    });

    test('take', () {
      for (final n in vectorNBounds) {
        expect(IVector.fill(n, 0).take(n ~/ 2).toList().length, min(n, n ~/ 2));
      }
    });

    test('takeRight', () {
      for (final n in vectorNBounds) {
        if (n >= 5) {
          expect(
            IVector.tabulate(n, identity).takeRight(5).toList(),
            [n - 5, n - 4, n - 3, n - 2, n - 1],
          );
        } else {
          expect(IVector.tabulate(n, identity).takeRight(3).length, min(3, n));
        }
      }
    });

    test('unzip', () {
      final v = IVector.tabulate(5, (x) => (x, x + 1));

      final (x, y) = v.unzip();

      expect(x.toList(), [0, 1, 2, 3, 4]);
      expect(y.toList(), [1, 2, 3, 4, 5]);
    });

    test('view', () {
      final v0 = IVector.tabulate(5, (a) => a);
      final v1 = v0.view().map((a) => a + 1).take(4).takeRight(3).toList();

      expect(v1, [2, 3, 4]);
    });
  });
}
