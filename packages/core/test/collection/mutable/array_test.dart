import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Array', () {
    test('filled', () {
      expect(Array.ofDim<int>(2).toList(), [null, null]);
      expect(arr([1, 2, null]).toList(), [1, 2, null]);
    });

    test('builder', () {
      final b = ArrayBuilder<int>();
      expect(b.result().toList(), <int>[]);

      b.clear();
      b.addOne(1);
      expect(b.result().toList(), [1]);

      b.clear();
      b.addArray(arr([1]));
      b.addOne(2);
      b.addArray(arr([3, null]));
      b.addAll(ilist([5, 6, 7]));
      expect(b.result().toList(), [1, 2, 3, null, 5, 6, 7]);
    });
  });
}
