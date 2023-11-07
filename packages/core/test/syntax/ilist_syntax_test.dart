import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IList syntax', () {
    test('deleteFirstN', () {
      expect(
        ilist([(1, 2), (3, 4)]).deleteFirstN((a, b) => a < b),
        Some(((1, 2), ilist([(3, 4)]))),
      );

      expect(
        ilist([(1, 2, 3), (4, 5, 6)]).deleteFirstN((a, b, c) => c > 5),
        Some(((4, 5, 6), ilist([(1, 2, 3)]))),
      );
    });

    test('dropWhileN', () {
      expect(
        ilist([(1, 2), (3, 4)]).dropWhileN((a, b) => a < b),
        nil<(int, int)>(),
      );

      expect(
        ilist([(1, 2, 3), (4, 5, 6)]).dropWhileN((a, b, c) => c == 3),
        ilist([(4, 5, 6)]),
      );
    });

    test('mapN', () {
      expect(
        ilist([(1, 2), (3, 4)]).mapN((a, b) => a + b),
        ilist([3, 7]),
      );

      expect(
        ilist([(1, 2, 3), (4, 5, 6)]).mapN((a, b, c) => a + b + c),
        ilist([6, 15]),
      );
    });
  });
}
