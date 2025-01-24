import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IMultiDict', () {
    test('empty', () {
      expect(IMultiDict.empty<String, int>(), IMultiDict.empty<String, int>());
      expect(IMultiDict.empty<String, int>().size, 0);
    });

    test('equality', () {
      final md1 = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      final md2 = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      expect(md1, md2);
      expect(md2, md1);
      expect(md2.hashCode, md1.hashCode);
    });

    test('access', () {
      final md = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      expect(iset({0, 1}), md.get('b'));
      expect(iset(<int>{}), md.get('d'));
      expect(md.containsKey('a'), isTrue);
      expect(md.containsKey('d'), isFalse);
      expect(md.containsEntry(('a', 1)), isTrue);
      expect(md.containsEntry(('a', 2)), isFalse);
      expect(md.containsEntry(('d', 2)), isFalse);
      expect(md.containsValue(1), isTrue);
      expect(md.containsValue(3), isTrue);
      expect(md.containsValue(4), isFalse);
    });

    test('concat', () {
      expect(
        imultidict([(1, true), (1, false)]),
        imultidict([(1, true)]).concat(imultidict([(1, false)])),
      );
    });
  });

  test('map', () {
    final md1 = imultidict([('a', 1), ('b', 2)]);
    final md1Mapped =
        IMultiDict.from(md1.map((t) => (t.$1.toUpperCase(), t.$2)));
    final md1Expected = imultidict([('A', 1), ('B', 2)]);

    final md2 = imultidict([('a', true), ('b', true)]);
    final md2Mapped = IMultiDict.from(md2.map((t) => (1, t.$2)));
    final md2Expected = imultidict([(1, true), (1, true)]);

    final md3 = imultidict([('a', 1), ('b', 2), ('b', 3)]);
    final md3Mapped =
        IMultiDict.from(md3.mapSets((_) => ('c', iset({1, 2, 3, 4}))));
    final md3Expected = imultidict([('c', 1), ('c', 2), ('c', 3), ('c', 4)]);

    expect(md1Mapped, md1Expected);
    expect(md2Mapped, md2Expected);
    expect(md3Mapped, md3Expected);
  });

  test('filter', () {
    final filtered = imultidict([('a', 1), ('b', 2)])
        .filter((kv) => kv.$1 == 'a' && kv.$2.isEven);

    expect(filtered.toSeq().isEmpty, isTrue);
  });
}
