import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IVectorBuilder', () {
    group('basic operations', () {
      test('fresh builder is empty', () {
        final b = IVector.builder<int>();
        expect(b.isEmpty, isTrue);
        expect(b.nonEmpty, isFalse);
        expect(b.knownSize(), 0);
      });

      test('addOne increases knownSize', () {
        final b = IVector.builder<int>();
        b.addOne(1);
        expect(b.isEmpty, isFalse);
        expect(b.nonEmpty, isTrue);
        expect(b.knownSize(), 1);
        b.addOne(2);
        expect(b.knownSize(), 2);
      });

      test('result() returns correct vector', () {
        final b = IVector.builder<int>();
        b.addOne(10);
        b.addOne(20);
        b.addOne(30);
        final v = b.result();
        expect(v.length, 3);
        expect(v[0], 10);
        expect(v[1], 20);
        expect(v[2], 30);
      });

      test('clear() resets to empty', () {
        final b = IVector.builder<int>();
        for (var i = 0; i < 50; i++) {
          b.addOne(i);
        }
        expect(b.knownSize(), 50);
        b.clear();
        expect(b.isEmpty, isTrue);
        expect(b.knownSize(), 0);
        expect(b.result().length, 0);
      });

      test('clear() then reuse produces correct result', () {
        final b = IVector.builder<int>();
        for (var i = 0; i < 100; i++) {
          b.addOne(i);
        }
        final v1 = b.result();
        b.clear();
        for (var i = 0; i < 5; i++) {
          b.addOne(i * 3);
        }
        final v2 = b.result();
        expect(v1.length, 100);
        expect(v2.length, 5);
        expect(v2[0], 0);
        expect(v2[4], 12);
      });

      test('addOne across depth 1→2 boundary (33 elements)', () {
        final b = IVector.builder<int>();
        for (var i = 0; i < 33; i++) {
          b.addOne(i);
        }
        final v = b.result();
        expect(v.length, 33);
        expect(v[0], 0);
        expect(v[31], 31);
        expect(v[32], 32);
      });

      test('addOne across depth 2→3 boundary (1025 elements)', () {
        final b = IVector.builder<int>();
        for (var i = 0; i < 1025; i++) {
          b.addOne(i);
        }
        final v = b.result();
        expect(v.length, 1025);
        expect(v[0], 0);
        expect(v[1024], 1024);
      });

      test('addOne across depth 3→4 boundary (32769 elements)', () {
        final b = IVector.builder<int>();
        for (var i = 0; i < 32769; i++) {
          b.addOne(i);
        }
        final v = b.result();
        expect(v.length, 32769);
        expect(v[0], 0);
        expect(v[32768], 32768);
      });

      test('addAll from non-IVector iterates elements', () {
        final b = IVector.builder<int>();
        b.addAll(IList.fromDart([10, 20, 30]));
        final v = b.result();
        expect(v.toList(), [10, 20, 30]);
      });

      test('setLen sets internal length pointers', () {
        final b = IVector.builder<int>();
        b.setLen(64);
        expect(b.knownSize(), 64);
      });
    });

    group('_initFromVector via appendedAll', () {
      test('Vector0: empty vector appendedAll small suffix', () {
        final result = IVector.empty<int>().appendedAll(IVector.fill(5, 7));
        expect(result.length, 5);
        expect(result[0], 7);
      });

      test('Vector1: small vector appendedAll medium suffix', () {
        final v1 = IVector.fill(10, 1);
        final result = v1.appendedAll(IVector.fill(20, 2));

        expect(result.length, 30);
        expect(result[0], 1);
        expect(result[10], 2);
      });

      test('Vector2: size 33–1024, initFromVector case 3', () {
        final v2 = IVector.fill(100, 5);
        final result = v2.appendedAll(IVector.fill(50, 9));

        expect(result.length, 150);
        expect(result[0], 5);
        expect(result[100], 9);
      });

      test('Vector3: size 1025–32768, initFromVector case 5', () {
        final v3 = IVector.fill(1025, 3);
        final result = v3.appendedAll(IVector.fill(50, 7));

        expect(result.length, 1075);
        expect(result[0], 3);
        expect(result[1025], 7);
      });

      test('Vector4: size 32769–1048576, initFromVector case 7', () {
        final v4 = IVector.fill(32769, 11);
        final result = v4.appendedAll(IVector.fill(50, 13));

        expect(result.length, 32819);
        expect(result[0], 11);
        expect(result[32769], 13);
        expect(result[32818], 13);
      });

      test('Vector5: size 1048577+, initFromVector case 9', () {
        final v5 = IVector.fill(1048577, 1);
        final result = v5.appendedAll(IVector.fill(50, 2));
        expect(result.length, 1048627);
        expect(result[0], 1);
        expect(result[1048577], 2);
      });
    });

    group('_alignTo and _leftAlignPrefix via appendedAll', () {
      test('alignTo: Vector2 bigVector (depth 2)', () {
        final small = IVector.fill(5, 0);
        final large = IVector.fill(100, 1);
        final result = small.appendedAll(large);

        expect(result.length, 105);
        expect(result[0], 0);
        expect(result[5], 1);
        expect(result[104], 1);
      });

      test('alignTo: Vector3 bigVector (depth 3, lines 222)', () {
        final small = IVector.fill(100, 0);
        final large = IVector.fill(1025, 1);
        final result = small.appendedAll(large);

        expect(result.length, 1125);
        expect(result[0], 0);
        expect(result[100], 1);
      });

      test('alignTo: Vector3 bigVector variant (different offset)', () {
        final small = IVector.fill(500, 0);
        final large = IVector.fill(1025, 1);
        final result = small.appendedAll(large);

        expect(result.length, 1525);
        expect(result[499], 0);
        expect(result[500], 1);
      });

      test('alignTo: Vector4 bigVector (depth 4, lines 222)', () {
        final small = IVector.fill(2000, 0);
        final large = IVector.fill(32769, 1);
        final result = small.appendedAll(large);

        expect(result.length, 34769);
        expect(result[0], 0);
        expect(result[1999], 0);
        expect(result[2000], 1);
      });

      test('alignTo: Vector4 bigVector variant (larger before)', () {
        final small = IVector.fill(10000, 0);
        final large = IVector.fill(32769, 1);
        final result = small.appendedAll(large);

        expect(result.length, 42769);
        expect(result[9999], 0);
        expect(result[10000], 1);
      });

      test('alignTo: Vector3 bigVector via prependedAll (line 471)', () {
        final base = IVector.fill(1025, 0);
        final prefix = IVector.fill(100, 1);
        final result = base.prependedAll(prefix);

        expect(result.length, 1125);
        expect(result[0], 1);
        expect(result[99], 1);
        expect(result[100], 0);
      });

      test('alignTo: Vector4 bigVector via prependedAll', () {
        final base = IVector.fill(32769, 0);
        final prefix = IVector.fill(2000, 1);
        final result = base.prependedAll(prefix);

        expect(result.length, 34769);
        expect(result[0], 1);
        expect(result[1999], 1);
        expect(result[2000], 0);
      });
    });

    group('_addVector with high-dim slices', () {
      test('Vector3 + Vector3 concatenation', () {
        final v3a = IVector.tabulate(1025, identity);
        final v3b = IVector.tabulate(1025, (i) => i + 1025);
        final result = v3a.appendedAll(v3b);

        expect(result.length, 2050);
        expect(result[0], 0);
        expect(result[1024], 1024);
        expect(result[1025], 1025);
        expect(result[2049], 2049);
      });

      test('Vector4 + Vector3 concatenation', () {
        final v4 = IVector.tabulate(32769, identity);
        final v3 = IVector.tabulate(1025, (i) => i + 32769);
        final result = v4.appendedAll(v3);

        expect(result.length, 33794);
        expect(result[0], 0);
        expect(result[32768], 32768);
        expect(result[32769], 32769);
        expect(result[33793], 33793);
      });

      test('Vector3 + Vector4 concatenation', () {
        final v3 = IVector.fill(1025, 0);
        final v4 = IVector.fill(32769, 1);
        final result = v3.appendedAll(v4);

        expect(result.length, 33794);
        expect(result[0], 0);
        expect(result[1024], 0);
        expect(result[1025], 1);
      });

      test('Vector4 + Vector4 concatenation', () {
        final v4a = IVector.fill(32769, 0);
        final v4b = IVector.fill(32769, 1);
        final result = v4a.appendedAll(v4b);

        expect(result.length, 65538);
        expect(result[0], 0);
        expect(result[32768], 0);
        expect(result[32769], 1);
        expect(result[65537], 1);
      });

      test('Vector5 + Vector3 concatenation', () {
        final v5 = IVector.fill(1048577, 0);
        final v3 = IVector.fill(1025, 1);
        final result = v5.appendedAll(v3);

        expect(result.length, 1049602);
        expect(result[0], 0);
        expect(result[1048577], 1);
      });
    });
  });
}
