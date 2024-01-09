part of '../vector.dart';

final class _Vector2<A> extends _BigVector<A> {
  final int len1;
  final _Arr2 data2;

  _Vector2(
    super._prefix1,
    this.len1,
    this.data2,
    super.suffix1,
    super.length0,
  );

  @override
  A operator [](int idx) {
    if (0 <= idx && idx < length0) {
      final io = idx - len1;
      if (io >= 0) {
        final i2 = io >>> _BITS;
        final i1 = io & _MASK;
        if (i2 < data2.length) {
          return data2[i2]![i1] as A;
        } else {
          return suffix1[io & _MASK] as A; // error!
        }
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
    } else if (data2.length < _WIDTH - 2) {
      return _copy(
        data2: _copyAppend2(data2, suffix1),
        suffix1: _wrap1(elem),
        length0: length0 + 1,
      );
    } else {
      return _Vector3(
        _prefix1,
        len1,
        data2,
        _WIDTH * (_WIDTH - 2) + len1,
        _empty3,
        _wrap2(suffix1),
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
  IVector<B> map<B>(Function1<A, B> f) => _Vector2(_mapElems1(_prefix1, f),
      len1, _mapElems2(data2, f), _mapElems1(suffix1, f), length0);

  @override
  IVector<A> prepended(A elem) {
    if (len1 < _WIDTH) {
      return _copy(
          prefix1: _copyPrepend1(elem, _prefix1),
          len1: len1 + 1,
          length0: length0 + 1);
    } else if (data2.length < _WIDTH - 2) {
      return _copy(
        prefix1: _wrap1(elem),
        len1: 1,
        data2: _copyPrepend2(_prefix1, data2),
        length0: length0 + 1,
      );
    } else {
      return _Vector3(
        _wrap1(elem),
        1,
        _wrap2(_prefix1),
        len1 + 1,
        _empty3,
        data2,
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
        length0: length0 - 1,
      );
    } else {
      return _slice0(1, length0);
    }
  }

  @override
  IVector<A> updated(int index, A elem) {
    if (index >= 0 && index < length0) {
      if (index >= len1) {
        final io = index - len1;
        final i2 = io >>> _BITS;
        final i1 = io & _MASK;
        if (i2 < data2.length) {
          return _copy(data2: _copyUpdate2(data2, i2, i1, elem));
        } else {
          return _copy(suffix1: _copyUpdate1(suffix1, i1, elem));
        }
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
    b.consider(2, data2);
    b.consider(1, suffix1);
    return b.result();
  }

  @override
  int get _vectorSliceCount => 3;

  @override
  Array<dynamic> _vectorSlice(int idx) => switch (idx) {
        0 => _prefix1,
        1 => data2,
        2 => suffix1,
        _ => throw ArgumentError('Vector2.vectorSlice: $idx'),
      };

  _Vector2<A> _copy({
    _Arr1? prefix1,
    int? len1,
    _Arr2? data2,
    _Arr1? suffix1,
    int? length0,
  }) =>
      _Vector2(
        prefix1 ?? _prefix1,
        len1 ?? this.len1,
        data2 ?? this.data2,
        suffix1 ?? this.suffix1,
        length0 ?? this.length0,
      );
}
