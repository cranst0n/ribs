part of '../vector.dart';

final class _Vector3<A> extends _BigVector<A> {
  final int len1;
  final _Arr2 prefix2;
  final int len12;
  final _Arr3 data3;
  final _Arr2 suffix2;

  _Vector3(
    super._prefix1,
    this.len1,
    this.prefix2,
    this.len12,
    this.data3,
    this.suffix2,
    super.suffix1,
    super.length0,
  );

  @override
  A operator [](int idx) {
    if (idx >= 0 && idx < length0) {
      final io = idx - len12;
      if (io >= 0) {
        final i3 = io >>> _BITS2;
        final i2 = (io >>> _BITS) & _MASK;
        final i1 = io & _MASK;
        if (i3 < data3.length) {
          return data3[i3]![i2]![i1] as A;
        } else if (i2 < suffix2.length) {
          return suffix2[i2]![i1] as A;
        } else {
          return suffix1[i1] as A;
        }
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
    } else if (data3.length < _WIDTH - 2) {
      return _copy(
        data3: _copyAppend3(data3, _copyAppend2(suffix2, suffix1)),
        suffix2: _empty2,
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else {
      return _Vector4(
        _prefix1,
        len1,
        prefix2,
        len12,
        data3,
        (_WIDTH - 2) * _WIDTH2 + len12,
        _empty4,
        _wrap3(_copyAppend2(suffix2, suffix1)),
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
  IVector<B> map<B>(Function1<A, B> f) => _Vector3(
        _mapElems1(_prefix1, f),
        len1,
        _mapElems2(prefix2, f),
        len12,
        _mapElems3(data3, f),
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
        length0: length0 + 1,
      );
    } else if (len12 < _WIDTH2) {
      return _copy(
          prefix1: _wrap1(elem),
          len1: 1,
          prefix2: _copyPrepend2(_prefix1, prefix2),
          len12: len12 + 1,
          length0: length0 + 1);
    } else if (data3.length < _WIDTH - 2) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        prefix2: _empty2,
        len12: 1,
        data3: _copyPrepend3(_copyPrepend2(_prefix1, prefix2), data3),
        length0: length0 + 1,
      );
    } else {
      return _Vector4(
        _wrap1(elem),
        1,
        _empty2,
        1,
        _wrap3(_copyPrepend2(_prefix1, prefix2)),
        len12 + 1,
        _empty4,
        data3,
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
        length0: length0 - 1,
      );
    } else {
      return _slice0(1, length0);
    }
  }

  @override
  IVector<A> updated(int index, A elem) {
    if (index >= 0 && index < length0) {
      if (index >= len12) {
        final io = index - len12;
        final i3 = io >>> _BITS2;
        final i2 = (io >>> _BITS) & _MASK;
        final i1 = io & _MASK;
        if (i3 < data3.length) {
          return _copy(data3: _copyUpdate3(data3, i3, i2, i1, elem));
        } else if (i2 < suffix2.length) {
          return _copy(suffix2: _copyUpdate2(suffix2, i2, i1, elem));
        } else {
          return _copy(suffix1: _copyUpdate1(suffix1, i1, elem));
        }
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
    b.consider(3, data3);
    b.consider(2, suffix2);
    b.consider(1, suffix1);
    return b.result();
  }

  @override
  Array<dynamic> _vectorSlice(int idx) => switch (idx) {
        0 => _prefix1,
        1 => prefix2,
        2 => data3,
        3 => suffix2,
        4 => suffix1,
        _ => throw ArgumentError('Vector3.vectorSlice: $idx'),
      };

  @override
  int get _vectorSliceCount => 5;

  _Vector3<A> _copy({
    _Arr1? prefix1,
    int? len1,
    _Arr2? prefix2,
    int? len12,
    _Arr3? data3,
    _Arr2? suffix2,
    _Arr1? suffix1,
    int? length0,
  }) =>
      _Vector3(
        prefix1 ?? _prefix1,
        len1 ?? this.len1,
        prefix2 ?? this.prefix2,
        len12 ?? this.len12,
        data3 ?? this.data3,
        suffix2 ?? this.suffix2,
        suffix1 ?? this.suffix1,
        length0 ?? this.length0,
      );
}
