import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IChain', () {
    test('empty', () {
      expect(IChain.empty<int>().size, 0);
    });

    test('one', () {
      expect(IChain.one(1).size, 1);
    });

    test('take', () {
      expect(ichain([1, 2, 3]).take(2), ichain([1, 2]));
    });

    test('reverse', () {
      expect(
        ichain([1, 2, 3])
            .concat(IChain.one(4))
            .concat(ichain([5, 6, 7]))
            .reverse()
            .toList(),
        [7, 6, 5, 4, 3, 2, 1],
      );
    });
  });
}
