// ignore_for_file: avoid_dynamic_calls

import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';

sealed class MurmurHash3 {
  static final mapSeed = 'Map'.hashCode;
  static const productSeed = 0xcafebabe;
  static final seqSeed = 'Seq'.hashCode;
  static final setSeed = 'Set'.hashCode;

  static final _Murmur3Impl _impl = _Murmur3Impl();

  static int listHash(IList<dynamic> xs) => _impl.listHash(xs, seqSeed);

  static int mapHash(RMap<dynamic, dynamic> xs) {
    if (xs.isEmpty) {
      return _emptyMapHash;
    } else {
      var a = 0;
      var b = 0;
      var n = 0;
      var c = 1;

      var h = mapSeed;

      xs.foreach((kv) {
        final h = _tuple2Hash(kv.$1, kv.$2);
        a += h;
        b ^= h;
        c *= h | 1;
        n += 1;
      });

      h = _impl.mix(h, a);
      h = _impl.mix(h, b);
      h = _impl.mixLast(h, c);

      return _impl.finalizeHash(h, n);
    }
  }

  static int rangeHash(int start, int step, int last) =>
      _impl.rangeHash(start, step, last, seqSeed);

  static int seqHash(RSeq<dynamic> seq) {
    return switch (seq) {
      final IndexedSeq<dynamic> xs => _impl.indexedSeqHash(xs, seqSeed),
      final IList<dynamic> xs => _impl.listHash(xs, seqSeed),
      _ => _impl.orderedHash(seq, seqSeed),
    };
  }

  static int setHash(RSet<dynamic> xs) => _impl.unorderedHash(xs, setSeed);

  static int unorderedHash(RIterableOnce<dynamic> xs, int seed) =>
      _impl.unorderedHash(xs, seed);

  static final _emptyMapHash = unorderedHash(nil(), mapSeed);

  static int _tuple2Hash(dynamic x, dynamic y) =>
      _impl.tuple2Hash(x.hashCode, y.hashCode, productSeed);
}

final class _Murmur3Impl {
  int mix(int hash, int data) {
    var h = mixLast(hash, data);
    h = Integer.rotateLeft(h, 13);
    return h * 5 + 0xe6546b64;
  }

  int mixLast(int hash, int data) {
    var k = data;

    k *= 0xcc9e2d51;
    k = Integer.rotateLeft(k, 15);
    k *= 0x1b873593;

    return hash ^ k;
  }

  int finalizeHash(int hash, int length) => avalanche(hash ^ length);

  int avalanche(int hash) {
    var h = hash;

    h ^= h >>> 16;
    h *= 0x85ebca6b;
    h ^= h >>> 13;
    h *= 0xc2b2ae35;
    h ^= h >>> 16;

    return h;
  }

  int tuple2Hash(int x, int y, int seed) {
    var h = seed;
    h = mix(h, 'Tuple2'.hashCode);
    h = mix(h, x);
    h = mix(h, y);
    return finalizeHash(h, 2);
  }

  int stringHash(String str, int seed) {
    var h = seed;
    var i = 0;

    while (i + 1 < str.length) {
      final data = (str.codeUnitAt(i) << 16) + str.codeUnitAt(i + 1);
      h = mix(h, data);
      i += 2;
    }

    if (i < str.length) h = mixLast(h, str.codeUnitAt(i));

    return finalizeHash(h, str.length);
  }

  int unorderedHash(RIterableOnce<dynamic> xs, int seed) {
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
    h = mix(h, a);
    h = mix(h, b);
    h = mixLast(h, c);

    return finalizeHash(h, n);
  }

  int orderedHash(RIterableOnce<dynamic> xs, int seed) {
    final it = xs.iterator;
    var h = seed;

    if (!it.hasNext) return finalizeHash(h, 0);

    final x0 = it.next();
    if (!it.hasNext) return finalizeHash(mix(h, x0.hashCode), 1);

    final x1 = it.next();

    final initial = x0.hashCode;
    h = mix(h, initial);
    final h0 = h;
    var prev = x1.hashCode;
    final rangeDiff = prev - initial;
    var i = 2;

    while (it.hasNext) {
      h = mix(h, prev);
      final hash = it.next().hashCode;

      if (rangeDiff != hash - prev) {
        h = mix(h, hash);
        i += 1;
        while (it.hasNext) {
          h = mix(h, it.next().hashCode);
          i += 1;
        }
        return finalizeHash(h, i);
      }

      prev = hash;
      i += 1;
    }
    return avalanche(mix(mix(h0, rangeDiff), prev));
  }

  int rangeHash(int start, int step, int last, int seed) =>
      avalanche(mix(mix(mix(seed, start), step), last));

  int bytesHash(Uint8List data, int seed) {
    var len = data.length;
    var h = seed;

    // Body
    var i = 0;
    while (len >= 4) {
      var k = data[i + 0] & 0xFF;
      k |= (data[i + 1] & 0xFF) << 8;
      k |= (data[i + 2] & 0xFF) << 16;
      k |= (data[i + 3] & 0xFF) << 24;

      h = mix(h, k);

      i += 4;
      len -= 4;
    }

    // Tail
    var k = 0;
    if (len == 3) k ^= (data[i + 2] & 0xFF) << 16;
    if (len >= 2) k ^= (data[i + 1] & 0xFF) << 8;
    if (len >= 1) {
      k ^= data[i + 0] & 0xFF;
      h = mixLast(h, k);
    }

    // Finalization
    return finalizeHash(h, data.length);
  }

  int indexedSeqHash(IndexedSeq<dynamic> a, int seed) {
    var h = seed;
    final l = a.length;

    switch (l) {
      case 0:
        return finalizeHash(h, 0);
      case 1:
        return finalizeHash(mix(h, a[0].hashCode), 1);
      default:
        final initial = a[0].hashCode;
        h = mix(h, initial);
        final h0 = h;
        var prev = a[1].hashCode;
        final rangeDiff = prev - initial;
        var i = 2;

        while (i < l) {
          h = mix(h, prev);
          final hash = a[i].hashCode;
          if (rangeDiff != hash - prev) {
            h = mix(h, hash);
            i += 1;
            while (i < l) {
              h = mix(h, a[i].hashCode);
              i += 1;
            }
            return finalizeHash(h, l);
          }
          prev = hash;
          i += 1;
        }

        return avalanche(mix(mix(h0, rangeDiff), prev));
    }
  }

  int listHash(IList<dynamic> xs, int seed) {
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

      h = mix(h, hash);

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
      elems = elems.tail();
    }

    if (rangeState == 2) {
      return rangeHash(initial, rangeDiff, prev, seed);
    } else {
      return finalizeHash(h, n);
    }
  }
}
