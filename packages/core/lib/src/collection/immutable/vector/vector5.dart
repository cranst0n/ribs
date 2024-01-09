part of '../ivector.dart';

final class _Vector5<A> extends _BigVector<A> {
  final int len1;
  final _Arr2 prefix2;
  final int len12;
  final _Arr3 prefix3;
  final int len123;
  final _Arr4 prefix4;
  final int len1234;
  final _Arr5 data5;
  final _Arr4 suffix4;
  final _Arr3 suffix3;
  final _Arr2 suffix2;

  _Vector5(
    super._prefix1,
    this.len1,
    this.prefix2,
    this.len12,
    this.prefix3,
    this.len123,
    this.prefix4,
    this.len1234,
    this.data5,
    this.suffix4,
    this.suffix3,
    this.suffix2,
    super.suffix1,
    super.length0,
  );

  @override
  A operator [](int idx) {
    if (idx >= 0 && idx < length0) {
      final io = idx - len1234;
      if (io >= 0) {
        final i5 = io >>> _BITS4;
        final i4 = (io >>> _BITS3) & _MASK;
        final i3 = (io >>> _BITS2) & _MASK;
        final i2 = (io >>> _BITS) & _MASK;
        final i1 = io & _MASK;
        if (i5 < data5.length) {
          return data5[i5]![i4]![i3]![i2]![i1] as A;
        } else if (i4 < suffix4.length) {
          return suffix4[i4]![i3]![i2]![i1] as A;
        } else if (i3 < suffix3.length) {
          return suffix3[i3]![i2]![i1] as A;
        } else if (i2 < suffix2.length) {
          return suffix2[i2]![i1] as A;
        } else {
          return suffix1[i1] as A;
        }
      } else if (idx >= len123) {
        final io = idx - len123;
        return prefix4[io >>> _BITS3]![(io >>> _BITS2) & _MASK]![
            (io >>> _BITS) & _MASK]![io & _MASK] as A;
      } else if (idx >= len12) {
        final io = idx - len12;
        return prefix3[io >>> _BITS2]![(io >>> _BITS) & _MASK]![io & _MASK]
            as A;
      } else if (idx >= len1) {
        final io = idx - len1;
        return prefix2[io >>> _BITS]![io & _MASK] as A;
      } else {
        return _prefix1[idx] as A;
      }
    } else {
      throw _rngErr(idx);
    }
  }

  @override
  IVector<A> appended(A elem) {
    if (suffix1.length < _WIDTH) {
      return _copy(suffix1: _copyAppend1(suffix1, elem), length0: length0 + 1);
    } else if (suffix2.length < _WIDTH - 1) {
      return _copy(
        suffix2: _copyAppend2(suffix2, suffix1),
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else if (suffix3.length < _WIDTH - 1) {
      return _copy(
        suffix3: _copyAppend3(suffix3, _copyAppend2(suffix2, suffix1)),
        suffix2: _empty2,
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else if (suffix4.length < _WIDTH - 1) {
      return _copy(
        suffix4: _copyAppend4(
            suffix4, _copyAppend3(suffix3, _copyAppend2(suffix2, suffix1))),
        suffix3: _empty3,
        suffix2: _empty2,
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else if (data5.length < _WIDTH - 2) {
      return _copy(
        data5: _copyAppend5(
            data5,
            _copyAppend4(suffix4,
                _copyAppend3(suffix3, _copyAppend2(suffix2, suffix1)))),
        suffix4: _empty4,
        suffix3: _empty3,
        suffix2: _empty2,
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else {
      return _Vector6(
        _prefix1,
        len1,
        prefix2,
        len12,
        prefix3,
        len123,
        prefix4,
        len1234,
        data5,
        (_WIDTH - 2) * _WIDTH4 + len1234,
        _empty6,
        _wrap5(_copyAppend4(
            suffix4, _copyAppend3(suffix3, _copyAppend2(suffix2, suffix1)))),
        _empty4,
        _empty3,
        _empty2,
        _wrap1(elem),
        length0 + 1,
      );
    }
  }

  @override
  IVector<A> init() {
    if (suffix1.length > 1) {
      return _copy(suffix1: _copyInit(suffix1), length0: length0 - 1);
    } else {
      return _slice0(0, length0 - 1);
    }
  }

  @override
  IVector<B> map<B>(Function1<A, B> f) => _Vector5(
        _mapElems1(_prefix1, f),
        len1,
        _mapElems2(prefix2, f),
        len12,
        _mapElems3(prefix3, f),
        len123,
        _mapElems4(prefix4, f),
        len1234,
        _mapElems5(data5, f),
        _mapElems4(suffix4, f),
        _mapElems3(suffix3, f),
        _mapElems2(suffix2, f),
        _mapElems1(suffix1, f),
        length0,
      );

  @override
  IVector<A> prepended(A elem) {
    if (len1 < _WIDTH) {
      return _copy(
        prefix1: _copyPrepend1(elem, _prefix1),
        len1: len1 + 1,
        len12: len12 + 1,
        len123: len123 + 1,
        len1234: len1234 + 1,
        length0: length0 + 1,
      );
    } else if (len12 < _WIDTH2) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        prefix2: _copyPrepend2(_prefix1, prefix2),
        len12: len12 + 1,
        len123: len123 + 1,
        len1234: len1234 + 1,
        length0: length0 + 1,
      );
    } else if (len123 < _WIDTH3) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        prefix2: _empty2,
        len12: 1,
        prefix3: _copyPrepend3(_copyPrepend2(_prefix1, prefix2), prefix3),
        len123: len123 + 1,
        len1234: len1234 + 1,
        length0: length0 + 1,
      );
    } else if (len1234 < _WIDTH4) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        prefix2: _empty2,
        len12: 1,
        prefix3: _empty3,
        len123: 1,
        prefix4: _copyPrepend4(
            _copyPrepend3(_copyPrepend2(_prefix1, prefix2), prefix3), prefix4),
        len1234: len1234 + 1,
        length0: length0 + 1,
      );
    } else if (data5.length < _WIDTH - 2) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        prefix2: _empty2,
        len12: 1,
        prefix3: _empty3,
        len123: 1,
        prefix4: _empty4,
        len1234: 1,
        data5: _copyPrepend5(
          _copyPrepend4(
            _copyPrepend3(
              _copyPrepend2(_prefix1, prefix2),
              prefix3,
            ),
            prefix4,
          ),
          data5,
        ),
        length0: length0 + 1,
      );
    } else {
      return _Vector6(
        _wrap1(elem),
        1,
        _empty2,
        1,
        _empty3,
        1,
        _empty4,
        1,
        _wrap5(_copyPrepend4(
            _copyPrepend3(_copyPrepend2(_prefix1, prefix2), prefix3), prefix4)),
        len1234 + 1,
        _empty6,
        data5,
        suffix4,
        suffix3,
        suffix2,
        suffix1,
        length0 + 1,
      );
    }
  }

  @override
  IVector<A> tail() {
    if (len1 > 1) {
      return _copy(
        prefix1: _copyTail(_prefix1),
        len1: len1 - 1,
        len12: len12 - 1,
        len123: len123 - 1,
        len1234: len1234 - 1,
        length0: length0 - 1,
      );
    } else {
      return _slice0(1, length0);
    }
  }

  @override
  IVector<A> updated(int index, A elem) {
    if (index >= 0 && index < length0) {
      if (index >= len1234) {
        final io = index - len1234;
        final i5 = io >>> _BITS4;
        final i4 = (io >>> _BITS3) & _MASK;
        final i3 = (io >>> _BITS2) & _MASK;
        final i2 = (io >>> _BITS) & _MASK;
        final i1 = io & _MASK;
        if (i5 < data5.length) {
          return _copy(data5: _copyUpdate5(data5, i5, i4, i3, i2, i1, elem));
        } else if (i4 < suffix4.length) {
          return _copy(suffix4: _copyUpdate4(suffix4, i4, i3, i2, i1, elem));
        } else if (i3 < suffix3.length) {
          return _copy(suffix3: _copyUpdate3(suffix3, i3, i2, i1, elem));
        } else if (i2 < suffix2.length) {
          return _copy(suffix2: _copyUpdate2(suffix2, i2, i1, elem));
        } else {
          return _copy(suffix1: _copyUpdate1(suffix1, i1, elem));
        }
      } else if (index >= len123) {
        final io = index - len123;
        return _copy(
            prefix4: _copyUpdate4(
                prefix4,
                io >>> _BITS3,
                (io >>> _BITS2) & _MASK,
                (io >>> _BITS) & _MASK,
                io & _MASK,
                elem));
      } else if (index >= len12) {
        final io = index - len12;
        return _copy(
            prefix3: _copyUpdate3(prefix3, io >>> _BITS2,
                (io >>> _BITS) & _MASK, io & _MASK, elem));
      } else if (index >= len1) {
        final io = index - len1;
        return _copy(
            prefix2: _copyUpdate2(prefix2, io >>> _BITS, io & _MASK, elem));
      } else {
        return _copy(prefix1: _copyUpdate1(_prefix1, index, elem));
      }
    } else {
      throw _rngErr(index);
    }
  }

  @override
  IVector<A> _slice0(int lo, int hi) {
    final b = _VectorSliceBuilder(lo, hi);
    b.consider(1, _prefix1);
    b.consider(2, prefix2);
    b.consider(3, prefix3);
    b.consider(4, prefix4);
    b.consider(5, data5);
    b.consider(4, suffix4);
    b.consider(3, suffix3);
    b.consider(2, suffix2);
    b.consider(1, suffix1);
    return b.result();
  }

  @override
  Array<dynamic> _vectorSlice(int idx) => switch (idx) {
        0 => _prefix1,
        1 => prefix2,
        2 => prefix3,
        3 => prefix4,
        4 => data5,
        5 => suffix4,
        6 => suffix3,
        7 => suffix2,
        8 => suffix1,
        _ => throw ArgumentError('Vector5.vectorSlice: $idx'),
      };

  @override
  int get _vectorSliceCount => 9;

  _Vector5<A> _copy({
    _Arr1? prefix1,
    int? len1,
    _Arr2? prefix2,
    int? len12,
    _Arr3? prefix3,
    int? len123,
    _Arr4? prefix4,
    int? len1234,
    _Arr5? data5,
    _Arr4? suffix4,
    _Arr3? suffix3,
    _Arr2? suffix2,
    _Arr1? suffix1,
    int? length0,
  }) =>
      _Vector5(
        prefix1 ?? _prefix1,
        len1 ?? this.len1,
        prefix2 ?? this.prefix2,
        len12 ?? this.len12,
        prefix3 ?? this.prefix3,
        len123 ?? this.len123,
        prefix4 ?? this.prefix4,
        len1234 ?? this.len1234,
        data5 ?? this.data5,
        suffix4 ?? this.suffix4,
        suffix3 ?? this.suffix3,
        suffix2 ?? this.suffix2,
        suffix1 ?? this.suffix1,
        length0 ?? this.length0,
      );
}
