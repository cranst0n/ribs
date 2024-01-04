part of '../vector.dart';

final class _VectorSliceBuilder {
  final int lo;
  final int hi;

  final _slices = _arr2(11);

  int len = 0;
  int pos = 0;
  int maxDim = 0;

  _VectorSliceBuilder(this.lo, this.hi);

  int prefixIdx(int n) => n - 1;
  int suffixIdx(int n) => 11 - n;

  void consider<T>(int n, List<T> a) {
    final count = a.length * (1 << (_BITS * (n - 1)));
    final lo0 = max(lo - pos, 0);
    final hi0 = min(hi - pos, count);
    if (hi0 > lo0) {
      addSlice(n, a, lo0, hi0);
      len += hi0 - lo0;
    }
    pos += count;
  }

  void addSlice<T>(int n, List<T> a, int lo, int hi) {
    if (n == 1) {
      add(1, _copyOrUse(a, lo, hi));
    } else {
      final bitsN = _BITS * (n - 1);
      final widthN = 1 << bitsN;
      final loN = lo >>> bitsN;
      final hiN = hi >>> bitsN;
      final loRest = lo & (widthN - 1);
      final hiRest = hi & (widthN - 1);

      if (loRest == 0) {
        if (hiRest == 0) {
          add(n, _copyOrUse(a, loN, hiN));
        } else {
          if (hiN > loN) add(n, _copyOrUse(a, loN, hiN));
          addSlice(n - 1, a[hiN] as _Arr1, 0, hiRest);
        }
      } else {
        if (hiN == loN) {
          addSlice(n - 1, a[loN] as _Arr1, loRest, hiRest);
        } else {
          addSlice(n - 1, a[loN] as _Arr1, loRest, widthN);
          if (hiRest == 0) {
            if (hiN > loN + 1) add(n, _copyOrUse(a, loN + 1, hiN));
          } else {
            if (hiN > loN + 1) add(n, _copyOrUse(a, loN + 1, hiN));
            addSlice(n - 1, a[hiN] as _Arr1, 0, hiRest);
          }
        }
      }
    }
  }

  void add<T>(int n, List<T> a) {
    final int idx;
    if (n <= maxDim) {
      idx = suffixIdx(n);
    } else {
      maxDim = n;
      idx = prefixIdx(n);
    }

    _slices[idx] = a;
  }

  IVector<A> result<A>() {
    if (len <= 32) {
      if (len == 0) {
        return _Vector0();
      } else {
        final prefix1 = _slices[prefixIdx(1)];
        final suffix1 = _slices[suffixIdx(1)];

        final _Arr1 a;

        if (prefix1 != null) {
          if (suffix1 != null) {
            a = _concatArrays(prefix1, suffix1);
          } else {
            a = prefix1;
          }
        } else if (suffix1 != null) {
          a = suffix1;
        } else {
          final prefix2 = _slices[prefixIdx(2)] as _Arr2?;
          if (prefix2 != null) {
            a = prefix2[0]!;
          } else {
            final suffix2 = _slices[suffixIdx(2)]! as _Arr2;
            a = suffix2[0]!;
          }
        }

        return _Vector1(a);
      }
    } else {
      balancePrefix(1);
      balanceSuffix(1);
      var resultDim = maxDim;

      if (resultDim < 6) {
        final pre = _slices[prefixIdx(maxDim)];
        final suf = _slices[suffixIdx(maxDim)];
        if ((pre != null) && (suf != null)) {
          // The highest-dimensional data consists of two slices: concatenate if they fit into the main data array,
          // otherwise increase the dimension
          if (pre.length + suf.length <= _WIDTH - 2) {
            _slices[prefixIdx(maxDim)] = _concatArrays(pre, suf);
            _slices[suffixIdx(maxDim)] = null;
          } else {
            resultDim += 1;
          }
        } else {
          // A single highest-dimensional slice could have length WIDTH-1 if it came from a prefix or suffix but we
          // only allow WIDTH-2 for the main data, so increase the dimension in this case
          final one = pre ?? suf;
          if (one!.length > _WIDTH - 2) resultDim += 1;
        }
      }

      final prefix1 = _slices[prefixIdx(1)]!;
      final suffix1 = _slices[suffixIdx(1)]!;
      final len1 = prefix1.length;

      switch (resultDim) {
        case 2:
          return _Vector2(prefix1, len1, dataOr2(2, _empty2), suffix1, len);

        case 3:
          final prefix2 = prefixOr2(2, _empty2);
          final data3 = dataOr3(3, _empty3);
          final suffix2 = suffixOr2(2, _empty2);
          final len12 = len1 + (prefix2.length * _WIDTH);

          return _Vector3(
              prefix1, len1, prefix2, len12, data3, suffix2, suffix1, len);

        case 4:
          final prefix2 = prefixOr2(2, _empty2);
          final prefix3 = prefixOr3(3, _empty3);
          final data4 = dataOr4(4, _empty4);
          final suffix3 = suffixOr3(3, _empty3);
          final suffix2 = suffixOr2(2, _empty2);
          final len12 = len1 + (prefix2.length * _WIDTH);
          final len123 = len12 + (prefix3.length * _WIDTH2);

          return _Vector4(prefix1, len1, prefix2, len12, prefix3, len123, data4,
              suffix3, suffix2, suffix1, len);

        case 5:
          final prefix2 = prefixOr2(2, _empty2);
          final prefix3 = prefixOr3(3, _empty3);
          final prefix4 = prefixOr4(4, _empty4);
          final data5 = dataOr5(5, _empty5);
          final suffix4 = suffixOr4(4, _empty4);
          final suffix3 = suffixOr3(3, _empty3);
          final suffix2 = suffixOr2(2, _empty2);
          final len12 = len1 + (prefix2.length * _WIDTH);
          final len123 = len12 + (prefix3.length * _WIDTH2);
          final len1234 = len123 + (prefix4.length * _WIDTH3);

          return _Vector5(prefix1, len1, prefix2, len12, prefix3, len123,
              prefix4, len1234, data5, suffix4, suffix3, suffix2, suffix1, len);

        case 6:
          final prefix2 = prefixOr2(2, _empty2);
          final prefix3 = prefixOr3(3, _empty3);
          final prefix4 = prefixOr4(4, _empty4);
          final prefix5 = prefixOr5(5, _empty5);
          final data6 = dataOr6(6, _empty6);
          final suffix5 = suffixOr5(5, _empty5);
          final suffix4 = suffixOr4(4, _empty4);
          final suffix3 = suffixOr3(3, _empty3);
          final suffix2 = suffixOr2(2, _empty2);
          final len12 = len1 + (prefix2.length * _WIDTH);
          final len123 = len12 + (prefix3.length * _WIDTH2);
          final len1234 = len123 + (prefix4.length * _WIDTH3);
          final len12345 = len1234 + (prefix5.length * _WIDTH4);
          return _Vector6(
              prefix1,
              len1,
              prefix2,
              len12,
              prefix3,
              len123,
              prefix4,
              len1234,
              prefix5,
              len12345,
              data6,
              suffix5,
              suffix4,
              suffix3,
              suffix2,
              suffix1,
              len);

        default:
          throw ArgumentError.value(resultDim, 'resultDim');
      }
    }
  }

  _Arr2 prefixOr2(int n, _Arr2 a) => _arrCast2(_slices[prefixIdx(n)] ?? a);
  _Arr3 prefixOr3(int n, _Arr3 a) => _arrCast3(_slices[prefixIdx(n)] ?? a);
  _Arr4 prefixOr4(int n, _Arr4 a) => _arrCast4(_slices[prefixIdx(n)] ?? a);
  _Arr5 prefixOr5(int n, _Arr5 a) => _arrCast5(_slices[prefixIdx(n)] ?? a);

  _Arr2 suffixOr2(int n, _Arr2 a) => _arrCast2(_slices[suffixIdx(n)] ?? a);
  _Arr3 suffixOr3(int n, _Arr3 a) => _arrCast3(_slices[suffixIdx(n)] ?? a);
  _Arr4 suffixOr4(int n, _Arr4 a) => _arrCast4(_slices[suffixIdx(n)] ?? a);
  _Arr5 suffixOr5(int n, _Arr5 a) => _arrCast5(_slices[suffixIdx(n)] ?? a);

  _Arr2 dataOr2(int n, _Arr2 a) =>
      _arrCast2(_slices[prefixIdx(n)] ?? _slices[suffixIdx(n)] ?? a);

  _Arr3 dataOr3(int n, _Arr3 a) =>
      _arrCast3(_slices[prefixIdx(n)] ?? _slices[suffixIdx(n)] ?? a);

  _Arr4 dataOr4(int n, _Arr4 a) =>
      _arrCast4(_slices[prefixIdx(n)] ?? _slices[suffixIdx(n)] ?? a);

  _Arr5 dataOr5(int n, _Arr5 a) =>
      _arrCast5(_slices[prefixIdx(n)] ?? _slices[suffixIdx(n)] ?? a);

  _Arr6 dataOr6(int n, _Arr6 a) =>
      _arrCast6(_slices[prefixIdx(n)] ?? _slices[suffixIdx(n)] ?? a);

  void balancePrefix(int n) {
    if (_slices[prefixIdx(n)] == null) {
      if (n == maxDim) {
        _slices[prefixIdx(n)] = _slices[suffixIdx(n)];
        _slices[suffixIdx(n)] = null;
      } else {
        balancePrefix(n + 1);
        final preN1 = _slices[prefixIdx(n + 1)]!;
        _slices[prefixIdx(n)] = preN1[0] as _Arr1;
        if (preN1.length == 1) {
          _slices[prefixIdx(n + 1)] = null;
          if ((maxDim == n + 1) && (_slices[suffixIdx(n + 1)] == null)) {
            maxDim = n;
          }
        } else {
          _slices[prefixIdx(n + 1)] = _copyOfRange(preN1, 1, preN1.length);
        }
      }
    }
  }

  void balanceSuffix(int n) {
    if (_slices[suffixIdx(n)] == null) {
      if (n == maxDim) {
        _slices[suffixIdx(n)] = _slices[prefixIdx(n)];
        _slices[prefixIdx(n)] = null;
      } else {
        balanceSuffix(n + 1);
        final sufN1 = _slices[suffixIdx(n + 1)]!;
        _slices[suffixIdx(n)] = sufN1[sufN1.length - 1] as _Arr1;
        if (sufN1.length == 1) {
          _slices[suffixIdx(n + 1)] = null;
          if ((maxDim == n + 1) && (_slices[prefixIdx(n + 1)] == null)) {
            maxDim = n;
          }
        } else {
          _slices[suffixIdx(n + 1)] = _copyOfRange(sufN1, 0, sufN1.length - 1);
        }
      }
    }
  }
}
