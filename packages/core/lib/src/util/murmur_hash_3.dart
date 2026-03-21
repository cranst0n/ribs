import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';

sealed class MurmurHash3 {
  static const arraySeed = 0x3c074a61;
  static final mapSeed = 'Map'.hashCode;
  static const productSeed = 0xcafebabe;
  static final seqSeed = 'Seq'.hashCode;
  static final setSeed = 'Set'.hashCode;
  static const stringSeed = 0xf7ca7fd2;

  static final _tuple2HashCode = 'Tuple2'.hashCode;

  static final _intSize = Integer.Size;

  static int bytesHash(Uint8List data) => _bytesHash(data, arraySeed);

  static int mix(int hash, int data) => _mix(hash, data);

  static int mixLast(int hash, int data) => _mixLast(hash, data);

  static int finalizeHash(int hash, int length) => _finalizeHash(hash, length);

  static int stringHash(String str) => _stringHash(str, stringSeed);

  static int listHash(IList<Object?> xs) => _listHash(xs, seqSeed);

  static int mapHash(RMap<Object?, Object?> xs) {
    if (xs.isEmpty) {
      return _emptyMapHash;
    } else {
      var a = 0;
      var b = 0;
      var n = 0;
      var c = 1;

      var h = mapSeed;

      final it = xs.iterator;

      while (it.hasNext) {
        final kv = it.next();
        final h = _tuple2Hash(kv.$1.hashCode, kv.$2.hashCode);

        a += h;
        b ^= h;
        c *= h | 1;
        n += 1;
      }

      h = _mix(h, a);
      h = _mix(h, b);
      h = _mixLast(h, c);

      return _finalizeHash(h, n);
    }
  }

  static int rangeHash(int start, int step, int last) => _rangeHash(start, step, last, seqSeed);

  static int seqHash(RSeq<Object?> seq) {
    return switch (seq) {
      final IndexedSeq<Object?> xs => _indexedSeqHash(xs, seqSeed),
      final IList<Object?> xs => _listHash(xs, seqSeed),
      _ => _orderedHash(seq, seqSeed),
    };
  }

  static int setHash(RSet<Object?> xs) => _unorderedHash(xs, setSeed);

  static int unorderedHash(RIterableOnce<Object?> xs, int seed) => _unorderedHash(xs, seed);

  static final _emptyMapHash = unorderedHash(nil(), mapSeed);

  // Private static implementations

  static int _mix(int hash, int data) {
    var h = _mixLast(hash, data);
    h = (h << 13) | (h >>> (_intSize - 13));
    return h * 5 + 0xe6546b64;
  }

  static int _mixLast(int hash, int data) {
    var k = data;

    k *= 0xcc9e2d51;
    k = (k << 15) | (k >>> (_intSize - 15));
    k *= 0x1b873593;

    return hash ^ k;
  }

  static int _finalizeHash(int hash, int length) => _avalanche(hash ^ length);

  static int _avalanche(int hash) {
    var h = hash;

    h ^= h >>> 16;
    h *= 0x85ebca6b;
    h ^= h >>> 13;
    h *= 0xc2b2ae35;
    h ^= h >>> 16;

    return h;
  }

  static int _tuple2Hash(int x, int y) {
    var h = productSeed;
    h = _mix(h, _tuple2HashCode);
    h = _mix(h, x);
    h = _mix(h, y);
    return _finalizeHash(h, 2);
  }

  static int _stringHash(String str, int seed) {
    var h = seed;
    var i = 0;

    while (i + 1 < str.length) {
      final data = (str.codeUnitAt(i) << 16) + str.codeUnitAt(i + 1);
      h = _mix(h, data);
      i += 2;
    }

    if (i < str.length) h = _mixLast(h, str.codeUnitAt(i));

    return _finalizeHash(h, str.length);
  }

  static int _unorderedHash(RIterableOnce<Object?> xs, int seed) {
    var a = 0;
    var b = 0;
    var n = 0;
    var c = 1;

    final iterator = xs.iterator;

    while (iterator.hasNext) {
      final x = iterator.next();
      final h = x.hashCode;
      a += h;
      b ^= h;
      c *= h | 1;
      n += 1;
    }

    var h = seed;
    h = _mix(h, a);
    h = _mix(h, b);
    h = _mixLast(h, c);

    return _finalizeHash(h, n);
  }

  static int _orderedHash(RIterableOnce<Object?> xs, int seed) {
    final it = xs.iterator;
    var h = seed;

    if (!it.hasNext) return _finalizeHash(h, 0);

    final x0 = it.next();
    if (!it.hasNext) return _finalizeHash(_mix(h, x0.hashCode), 1);

    final x1 = it.next();

    final initial = x0.hashCode;
    h = _mix(h, initial);
    final h0 = h;
    var prev = x1.hashCode;
    final rangeDiff = prev - initial;
    var i = 2;

    while (it.hasNext) {
      h = _mix(h, prev);
      final hash = it.next().hashCode;

      if (rangeDiff != hash - prev) {
        h = _mix(h, hash);
        i += 1;
        while (it.hasNext) {
          h = _mix(h, it.next().hashCode);
          i += 1;
        }
        return _finalizeHash(h, i);
      }

      prev = hash;
      i += 1;
    }
    return _avalanche(_mix(_mix(h0, rangeDiff), prev));
  }

  static int _rangeHash(int start, int step, int last, int seed) =>
      _avalanche(_mix(_mix(_mix(seed, start), step), last));

  static int _bytesHash(Uint8List data, int seed) {
    var len = data.length;
    var h = seed;

    final byteData = ByteData.view(data.buffer, data.offsetInBytes, data.lengthInBytes);

    // Body
    var i = 0;
    while (len >= 4) {
      final k = byteData.getUint32(i, Endian.little);

      h = _mix(h, k);

      i += 4;
      len -= 4;
    }

    // Tail
    var k = 0;
    if (len == 3) k ^= (data[i + 2] & 0xFF) << 16;
    if (len >= 2) k ^= (data[i + 1] & 0xFF) << 8;
    if (len >= 1) {
      k ^= data[i + 0] & 0xFF;
      h = _mixLast(h, k);
    }

    // Finalization
    return _finalizeHash(h, data.length);
  }

  static int _indexedSeqHash(IndexedSeq<Object?> a, int seed) {
    var h = seed;
    final l = a.length;

    switch (l) {
      case 0:
        return _finalizeHash(h, 0);
      case 1:
        return _finalizeHash(_mix(h, a[0].hashCode), 1);
      default:
        final initial = a[0].hashCode;
        h = _mix(h, initial);
        final h0 = h;
        var prev = a[1].hashCode;
        final rangeDiff = prev - initial;
        var i = 2;

        while (i < l) {
          h = _mix(h, prev);
          final hash = a[i].hashCode;
          if (rangeDiff != hash - prev) {
            h = _mix(h, hash);
            i += 1;
            while (i < l) {
              h = _mix(h, a[i].hashCode);
              i += 1;
            }
            return _finalizeHash(h, l);
          }
          prev = hash;
          i += 1;
        }

        return _avalanche(_mix(_mix(h0, rangeDiff), prev));
    }
  }

  static int _listHash(IList<Object?> xs, int seed) {
    var n = 0;
    var h = seed;

    // 0 = no data, 1 = first elem read, 2 = has valid diff, 3 = invalid
    var rangeState = 0;

    var rangeDiff = 0;
    var prev = 0;
    var initial = 0;
    var elems = xs;

    while (!elems.isEmpty) {
      final head = elems.head;
      final hash = head.hashCode;

      h = _mix(h, hash);

      switch (rangeState) {
        case 0:
          initial = hash;
          rangeState = 1;
        case 1:
          rangeDiff = hash - prev;
          rangeState = 2;
        case 2:
          if (rangeDiff != hash - prev) rangeState = 3;
        default:
      }

      prev = hash;
      n += 1;
      elems = elems.tail;
    }

    if (rangeState == 2) {
      return _rangeHash(initial, rangeDiff, prev, seed);
    } else {
      return _finalizeHash(h, n);
    }
  }
}
