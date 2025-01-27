import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IMultiSet', () {
    test('empty', () {
      expect(IMultiSet.empty<String>(), IMultiSet.empty<String>());
      expect(IMultiSet.empty<String>().size, 0);
    });

    test('equality', () {
      final ms1 = imultiset(['a', 'b', 'b', 'c']);
      final ms2 = imultiset(['a', 'b', 'b', 'c']);

      expect(ms1, ms2);
      expect(ms2, ms1);
      expect(ms1.hashCode, ms2.hashCode);
    });

    test('concat', () {
      expect(
        imultiset([1, 1]),
        imultiset([1]).concat(imultiset([1])),
      );

      expect(
        imultiset(['a', 'a', 'a']),
        imultiset(['a']).concat(imultiset(['a', 'a'])),
      );
    });

    test('map', () {
      expect(
        imultiset(['a', 'b', 'b']).map((x) => x.toUpperCase()),
        imultiset(['A', 'B', 'B']),
      );

      expect(
        imultiset(['a', 'b']).map((_) => 1),
        imultiset([1, 1]),
      );

      expect(
        imultiset(['a', 'b', 'b']).mapOccurences((_) => ('c', 2)),
        imultiset(['c', 'c', 'c', 'c']),
      );
    });
  });
}
