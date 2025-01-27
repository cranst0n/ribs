import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('MMultiSet', () {
    test('empty', () {
      expect(MMultiSet.empty<String>(), MMultiSet.empty<String>());
      expect(MMultiSet.empty<String>().size, 0);
    });

    test('equality', () {
      final ms1 = mmultiset(['a', 'b', 'b', 'c']);
      final ms2 = mmultiset(['a', 'b', 'b', 'c']);

      expect(ms1, ms2);
      expect(ms2, ms1);
      expect(ms1.hashCode, ms2.hashCode);
    });

    test('concat', () {
      expect(
        mmultiset([1, 1]),
        mmultiset([1]).concat(mmultiset([1])),
      );

      expect(
        mmultiset(['a', 'a', 'a']),
        mmultiset(['a']).concat(mmultiset(['a', 'a'])),
      );
    });

    test('map', () {
      expect(
        mmultiset(['a', 'b', 'b']).map((x) => x.toUpperCase()),
        mmultiset(['A', 'B', 'B']),
      );

      expect(
        mmultiset(['a', 'b']).map((_) => 1),
        mmultiset([1, 1]),
      );

      expect(
        mmultiset(['a', 'b', 'b']).mapOccurences((_) => ('c', 2)),
        mmultiset(['c', 'c', 'c', 'c']),
      );
    });
  });
}
