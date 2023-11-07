import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'gen.dart';

void main() {
  group('ByteVector', () {
    forAll('hashCode / equality', bytesWithIndex, (t) {
      final (b, n) = t;

      expect(b.take(n).concat(b.drop(n)), b);
      expect(b.take(n).concat(b.drop(n)).hashCode, b.hashCode);
    });

    test('fromValidBin (invalid)', () {
      expect(
        () => ByteVector.fromValidBinString('21010'),
        throwsException,
      );
    });

    forAll('fromValidBin (gen)', binString, (str) {
      expect(ByteVector.fromValidBinString(str).size, str.length / 8);
    });

    test('fromValidHex (invalid)', () {
      expect(ByteVector.fromValidHexString('aa0').toHexString(), '0aa0');

      expect(
        () => ByteVector.fromValidHexString('ff324V'),
        throwsException,
      );
    });

    forAll('fromValidHex (gen)', hexString, (str) {
      expect(ByteVector.fromValidHexString(str).size, str.length / 2);
    });

    test('fromValidHex', () {
      expect(ByteVector.fromValidHexString('00').toHexString(), '00');
      expect(ByteVector.fromValidHexString('0x00').toHexString(), '00');
      expect(ByteVector.fromValidHexString('0x000F').toHexString(), '000f');

      expect(
        () => ByteVector.fromValidHexString('0x00QF').toHexString(),
        throwsException,
      );
    });

    forAll('and/or/not/xor', byteVector, (bv) {
      expect(bv & bv, bv);
      expect(bv & ~bv, ByteVector.low(bv.size));

      expect(bv | bv, bv);
      expect(bv | ~bv, ByteVector.high(bv.size));

      expect(bv ^ bv, ByteVector.low(bv.size));
      expect(bv ^ ~bv, ByteVector.high(bv.size));
    });

    forAll('acquire', byteVector, (bv) {
      if (bv.isEmpty) {
        expect(bv.acquire(1), isLeft<String, ByteVector>());
      } else {
        expect(bv.acquire(1), isRight<String, ByteVector>());
      }

      expect(bv.acquire(bv.size), isRight<String, ByteVector>());
      expect(bv.acquire(bv.size + 1), isLeft<String, ByteVector>());
    });

    forAll('concat', Gen.ilistOf(Gen.chooseInt(0, 10), byteVector), (bvs) {
      final c = ByteVector.concatAll(bvs);

      expect(c.size, bvs.foldLeft(0, (acc, bv) => acc + bv.size));

      bvs.headOption.forEach((h) => expect(c.startsWith(h), isTrue));
      bvs.lastOption.forEach((l) => expect(c.endsWith(l), isTrue));
    });

    forAll('containsSlice', byteVector, (bv) {
      if (bv.nonEmpty) {
        IList.range(0, bv.size).forEach((n) {
          expect(bv.containsSlice(bv.drop(n)), isTrue);
        });
      } else {
        expect(bv.containsSlice(bv), isFalse);
      }
    });

    forAll('dropWhile', byteVector, (bv) {
      expect(bv.dropWhile((_) => false), bv);
      expect(bv.dropWhile((_) => true), ByteVector.empty());

      if (bv.size > 1) {
        expect(bv.drop(1).head, bv.get(1));
      } else if (bv.size == 1) {
        expect(bv.drop(1).isEmpty, isTrue);
      } else {
        expect(bv.drop(1), bv);
      }
    });

    forAll('endsWith', byteVector, (bv) {
      IList.range(0, bv.size).forEach((n) {
        expect(bv.endsWith(bv.drop(n)), isTrue);
      });
    });

    forAll('foldLeft', byteVector, (bv) {
      expect(bv.foldLeft(ByteVector.empty(), (acc, b) => acc.append(b)), bv);
    });

    forAll('foldRight', byteVector, (bv) {
      expect(bv.foldRight(ByteVector.empty(), (b, acc) => acc.prepend(b)), bv);
    });

    forAll('headOption', byteVector, (bv) {
      expect(bv.headOption.isDefined, bv.nonEmpty);

      if (bv.nonEmpty) {
        expect(bv.headOption, isSome(bv.head));
      }
    });

    forAll('init', byteVector, (bv) {
      expect(bv.startsWith(bv.init()), isTrue);

      if (bv.nonEmpty) {
        expect(bv.init().size, bv.size - 1);
      } else {
        expect(bv.init(), bv);
      }
    });

    test('insert (1)', () {
      expect(ByteVector.empty().insert(0, 1), ByteVector.fromList([1]));
      expect(
        ByteVector.fromList([1, 2, 3, 4]).insert(0, 0),
        ByteVector.fromList([0, 1, 2, 3, 4]),
      );
      expect(
        ByteVector.fromList([1, 2, 3, 4]).insert(1, 0),
        ByteVector.fromList([1, 0, 2, 3, 4]),
      );
    });

    forAll('insert (2)', byteVector, (bv) {
      expect(
        bv.foldLeft(ByteVector.empty(), (acc, b) => acc.insert(acc.size, b)),
        bv,
      );
    });

    forAll('last', (byteVector, byte).tupled, (t) {
      final (bv, byte) = t;

      if (bv.nonEmpty) {
        expect(bv.last, bv.get(bv.size - 1));
      }

      expect(bv.append(byte).last, byte);
    });

    forAll('lastOption', (byteVector, byte).tupled, (t) {
      final (bv, byte) = t;

      expect(bv.lastOption.isDefined, bv.nonEmpty);
      expect(bv.append(byte).lastOption, isSome(byte));
    });

    forAll('padLeft', byteVector, (bv) {
      expect(bv.padLeft(0), bv);
      expect(bv.padLeft(bv.size), bv);
      expect(bv.padLeft(bv.size + 3).size, bv.size + 3);
      expect(bv.padLeft(bv.size + 1).head, 0);
    });

    forAll('padRight', byteVector, (bv) {
      expect(bv.padRight(0), bv);
      expect(bv.padRight(bv.size), bv);
      expect(bv.padRight(bv.size + 3).size, bv.size + 3);
      expect(bv.padRight(bv.size + 1).last, 0);

      expect(bv.padTo(bv.size + 10), bv.padRight(bv.size + 10));
    });

    forAll('patch', (byteVector, byteVector, Gen.integer).tupled, (t) {
      final (x, y, n0) = t;

      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
      expect(x.patch(n, x.slice(n, n)), x);
      expect(x.patch(n, y), x.take(n).concat(y).concat(x.drop(n + y.size)));
    });

    forAll('rotations', (byteVector, Gen.chooseInt(0, 100)).tupled, (t) {
      final (bv, n) = t;

      expect(bv.rotateLeft(bv.size * 8), bv);
      expect(bv.rotateRight(bv.size * 8), bv);
      expect(bv.rotateRight(n).rotateLeft(n), bv);
      expect(bv.rotateLeft(n).rotateRight(n), bv);
    });

    forAll('splice', (byteVector, byteVector, Gen.integer).tupled, (t) {
      final (x, y, n0) = t;

      final n = x.nonEmpty ? (n0 % x.size).abs() : 0;
      expect(x.splice(n, ByteVector.empty()), x);
      expect(x.splice(n, y), x.take(n).concat(y).concat(x.drop(n)));
    });

    forAll('splitAt', byteVector, (bv) {
      expect(bv.splitAt(0), (ByteVector.empty(), bv));
      expect(bv.splitAt(bv.size), (bv, ByteVector.empty()));

      IList.range(0, bv.size).forEach((n) {
        expect(bv.splitAt(n)((a, b) => a.concat(b)), bv);
      });
    });

    forAll('takeWhile', byteVector, (bv) {
      final (expected, _) = bv.foldLeft((ByteVector.empty(), true), (acct, b) {
        final (acc, taking) = acct;

        if (taking) {
          if (b == 0) {
            return (acc, false);
          } else {
            return (acc.append(b), true);
          }
        } else {
          return (acc, false);
        }
      });

      expect(bv.takeWhile((a) => a != 0), expected);
    });

    forAll('toBin / fromBin roundtrip', byteVector, (bv) {
      expect(ByteVector.fromBinString(bv.toBinString()), bv.asRight<String>());
    });

    forAll('toHex / fromHex roundtrip', byteVector, (bv) {
      expect(ByteVector.fromHexString(bv.toHexString()), bv.asRight<String>());
    });

    forAll('int conversion', Gen.integer, (i) {
      expect(ByteVector.fromInt(i).toInt(), i);
    });
  });
}
