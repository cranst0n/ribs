part of '../ivector.dart';

final class IVectorBuilder<A> {
  _Arr6? a6;
  _Arr5? a5;
  _Arr4? a4;
  _Arr3? a3;
  _Arr2? a2;
  _Arr1 a1 = _arr1(_WIDTH);

  var _len1 = 0;
  var _lenRest = 0;
  var _offset = 0;
  var _prefixIsRightAligned = false;
  var _depth = 1;

  void setLen(int i) {
    _len1 = i & _MASK;
    _lenRest = i - _len1;
  }

  int knownSize() => _len1 + _lenRest - _offset;
  int size() => knownSize();
  bool get isEmpty => knownSize() == 0;
  bool get nonEmpty => knownSize() != 0;

  void clear() {
    a6 = null;
    a5 = null;
    a4 = null;
    a3 = null;
    a2 = null;
    a1 = _arr1(_WIDTH);
    _len1 = 0;
    _lenRest = 0;
    _offset = 0;
    _prefixIsRightAligned = false;
    _depth = 1;
  }

  void _initSparse(int size, A elem) {
    setLen(size);
    a1.filled(elem);

    if (size > _WIDTH) {
      a2 = _arr2(_WIDTH);
      a2!.filled(a1);
      if (size > _WIDTH2) {
        a3 = _arr3(_WIDTH);
        a3!.filled(a2);
        if (size > _WIDTH3) {
          a4 = _arr4(_WIDTH);
          a4!.filled(a3);
          if (size > _WIDTH4) {
            a5 = _arr5(_WIDTH);
            a5!.filled(a4);
            if (size > _WIDTH5) {
              a6 = _arr6(_WIDTH);
              a6!.filled(a5);
              _depth = 6;
            } else {
              _depth = 5;
            }
          } else {
            _depth = 4;
          }
        } else {
          _depth = 3;
        }
      } else {
        _depth = 2;
      }
    } else {
      _depth = 1;
    }
  }

  IVectorBuilder<A> _initFromVector(IVector<dynamic> v) {
    switch (v._vectorSliceCount) {
      case 0:
        final v0 = v as _Vector0;
        _depth = 1;
        setLen(v0._prefix1.length);
        a1 = _copyOrUse(v0._prefix1, 0, _WIDTH);
      case 1:
        final v1 = v as _Vector1;
        _depth = 1;
        setLen(v1._prefix1.length);
        a1 = _copyOrUse(v1._prefix1, 0, _WIDTH);
      case 3:
        final v2 = v as _Vector2;
        final d2 = v2.data2;
        a1 = _copyOrUse(v2.suffix1, 0, _WIDTH);
        _depth = 2;
        _offset = _WIDTH - v2.len1;
        setLen(v2.length0 + _offset);
        a2 = _arr2(_WIDTH);
        a2![0] = v2._prefix1;
        Array.arraycopy(d2, 0, a2!, 1, d2.length);
        a2![d2.length + 1] = a1;
      case 5:
        final v3 = v as _Vector3;
        final d3 = v3.data3;
        final s2 = v3.suffix2;
        a1 = _copyOrUse(v3.suffix1, 0, _WIDTH);
        _depth = 3;
        _offset = _WIDTH2 - v3.len12;
        setLen(v3.length0 + _offset);
        a3 = _arr3(_WIDTH);
        a3![0] = _copyPrepend2(v3._prefix1, v3.prefix2);
        Array.arraycopy(d3, 0, a3!, 1, d3.length);
        a2 = Array.copyOf(s2, _WIDTH);
        a3![d3.length + 1] = a2;
        a2![s2.length] = a1;
      case 7:
        final v4 = v as _Vector4;
        final d4 = v4.data4;
        final s3 = v4.suffix3;
        final s2 = v4.suffix2;
        a1 = _copyOrUse(v4.suffix1, 0, _WIDTH);
        _depth = 4;
        _offset = _WIDTH3 - v4.len123;
        setLen(v4.length0 + _offset);
        a4 = _arr4(_WIDTH);
        a4![0] =
            _copyPrepend3(_copyPrepend2(v4._prefix1, v4.prefix2), v4.prefix3);
        Array.arraycopy(d4, 0, a4!, 1, d4.length);
        a3 = Array.copyOf(s3, _WIDTH);
        a2 = Array.copyOf(s2, _WIDTH);
        a4![d4.length + 1] = a3;
        a3![s3.length] = a2;
        a2![s2.length] = a1;
      case 9:
        final v5 = v as _Vector5;
        final d5 = v5.data5;
        final s4 = v5.suffix4;
        final s3 = v5.suffix3;
        final s2 = v5.suffix2;
        a1 = _copyOrUse(v5.suffix1, 0, _WIDTH);
        _depth = 5;
        _offset = _WIDTH4 - v5.len1234;
        setLen(v5.length0 + _offset);
        a5 = _arr5(_WIDTH);
        a5![0] = _copyPrepend4(
            _copyPrepend3(_copyPrepend2(v5._prefix1, v5.prefix2), v5.prefix3),
            v5.prefix4);
        Array.arraycopy(d5, 0, a5!, 1, d5.length);
        a4 = Array.copyOf(s4, _WIDTH);
        a3 = Array.copyOf(s3, _WIDTH);
        a2 = Array.copyOf(s2, _WIDTH);
        a5![d5.length + 1] = a4;
        a4![s4.length] = a3;
        a3![s3.length] = a2;
        a2![s2.length] = a1;
      case 11:
        final v6 = v as _Vector6;
        final d6 = v6.data6;
        final s5 = v6.suffix5;
        final s4 = v6.suffix4;
        final s3 = v6.suffix3;
        final s2 = v6.suffix2;
        a1 = _copyOrUse(v6.suffix1, 0, _WIDTH);
        _depth = 6;
        _offset = _WIDTH5 - v6.len12345;
        setLen(v6.length0 + _offset);
        a6 = _arr6(_LASTWIDTH);
        a6![0] = _copyPrepend5(
            _copyPrepend4(
                _copyPrepend3(
                    _copyPrepend2(v6._prefix1, v6.prefix2), v6.prefix3),
                v6.prefix4),
            v6.prefix5);
        Array.arraycopy(d6, 0, a6!, 1, d6.length);
        a5 = Array.copyOf(s5, _WIDTH);
        a4 = Array.copyOf(s4, _WIDTH);
        a3 = Array.copyOf(s3, _WIDTH);
        a2 = Array.copyOf(s2, _WIDTH);
        a6![d6.length + 1] = a5;
        a5![s5.length] = a4;
        a4![s4.length] = a3;
        a3![s3.length] = a2;
        a2![s2.length] = a1;
      default:
        throw StateError(
            'VectorBuilder.initFromVector: ${v._vectorSliceCount}');
    }

    if (_len1 == 0 && _lenRest > 0) {
      // force advance() on next addition:
      _len1 = _WIDTH;
      _lenRest -= _WIDTH;
    }

    return this;
  }

  IVectorBuilder<A> _alignTo(int before, IVector<A> bigVector) {
    if (_len1 != 0 || _lenRest != 0) {
      throw Exception(
          "A non-empty VectorBuilder cannot be aligned retrospectively. Please call .reset() or use a new VectorBuilder.");
    }

    final (prefixLength, maxPrefixLength) = switch (bigVector) {
      _Vector0<dynamic> _ => (0, 1),
      _Vector1<dynamic> _ => (0, 1),
      _Vector2<dynamic> v2 => (v2.len1, _WIDTH),
      _Vector3<dynamic> v3 => (v3.len12, _WIDTH2),
      _Vector4<dynamic> v4 => (v4.len123, _WIDTH3),
      _Vector5<dynamic> v5 => (v5.len1234, _WIDTH4),
      _Vector6<dynamic> v6 => (v6.len12345, _WIDTH5),
    };

    if (maxPrefixLength == 1) {
      return this; // does not really make sense to align for <= 32 element-vector
    }

    final overallPrefixLength = (before + prefixLength) % maxPrefixLength;
    _offset = (maxPrefixLength - overallPrefixLength) % maxPrefixLength;

    // pretend there are already `offset` elements added
    _advanceN(_offset & ~_MASK);
    _len1 = _offset & _MASK;
    _prefixIsRightAligned = true;

    return this;
  }

  /// Removes `offset` leading `null`s in the prefix.
  /// This is needed after calling `alignTo` and subsequent additions,
  /// directly before the result is used for creating a new Vector.
  /// Note that the outermost array keeps its length to keep the
  /// Builder re-usable.
  ///
  /// example:
  ///     a2 = Array(null, ..., null, Array(null, .., null, 0, 1, .., x), Array(x+1, .., x+32), ...)
  /// becomes
  ///     a2 = Array(Array(0, 1, .., x), Array(x+1, .., x+32), ..., ?, ..., ?)
  void _leftAlignPrefix() {
    void shrinkOffsetIfToLarge(int width) {
      final newOffset = _offset % width;
      _lenRest -= _offset - newOffset;
      _offset = newOffset;
    }

    Array<dynamic>? a; // the array we modify
    Array<dynamic>? aParent; // a's parent, so aParent(0) == a

    if (_depth >= 6) {
      a ??= a6;

      final i = _offset >>> _BITS5;
      if (i > 0) Array.arraycopy(a!, i, a, 0, _LASTWIDTH - i);
      shrinkOffsetIfToLarge(_WIDTH5);
      if ((_lenRest >>> _BITS5) == 0) _depth = 5;
      aParent = a;
      a = a![0] as _Arr1;
    }
    if (_depth >= 5) {
      a ??= a5;

      final i = (_offset >>> _BITS4) & _MASK;
      if (_depth == 5) {
        if (i > 0) Array.arraycopy(a!, i, a, 0, _WIDTH - i);
        a5 = a! as _Arr5;
        shrinkOffsetIfToLarge(_WIDTH4);
        if ((_lenRest >>> _BITS4) == 0) _depth = 4;
      } else {
        if (i > 0) a = Array.copyOfRange(a!, i, _WIDTH);
        aParent![0] = a;
      }
      aParent = a;
      a = a![0] as _Arr1;
    }
    if (_depth >= 4) {
      a ??= a4;

      final i = (_offset >>> _BITS3) & _MASK;
      if (_depth == 4) {
        if (i > 0) Array.arraycopy(a!, i, a, 0, _WIDTH - i);
        a4 = a! as _Arr4;
        shrinkOffsetIfToLarge(_WIDTH3);
        if ((_lenRest >>> _BITS3) == 0) _depth = 3;
      } else {
        if (i > 0) a = Array.copyOfRange(a!, i, _WIDTH);
        aParent![0] = a;
      }
      aParent = a;
      a = a![0] as _Arr1;
    }
    if (_depth >= 3) {
      a ??= a3;

      final i = (_offset >>> _BITS2) & _MASK;
      if (_depth == 3) {
        if (i > 0) Array.arraycopy(a!, i, a, 0, _WIDTH - i);
        a3 = a! as _Arr3;
        shrinkOffsetIfToLarge(_WIDTH2);
        if ((_lenRest >>> _BITS2) == 0) _depth = 2;
      } else {
        if (i > 0) a = Array.copyOfRange(a!, i, _WIDTH);
        aParent![0] = a;
      }
      aParent = a;
      a = a![0] as _Arr1;
    }
    if (_depth >= 2) {
      a ??= a2;

      final i = (_offset >>> _BITS) & _MASK;
      if (_depth == 2) {
        if (i > 0) Array.arraycopy(a!, i, a, 0, _WIDTH - i);
        a2 = a! as _Arr2;
        shrinkOffsetIfToLarge(_WIDTH);
        if ((_lenRest >>> _BITS) == 0) _depth = 1;
      } else {
        if (i > 0) a = Array.copyOfRange(a!, i, _WIDTH);
        aParent![0] = a;
      }
      aParent = a;
      a = a![0] as _Arr1;
    }
    if (_depth >= 1) {
      a ??= a1;
      final i = _offset & _MASK;

      if (_depth == 1) {
        if (i > 0) Array.arraycopy(a, i, a, 0, _WIDTH - i);

        a1 = a;
        _len1 -= _offset;
        _offset = 0;
      } else {
        if (i > 0) a = Array.copyOfRange(a, i, _WIDTH);
        aParent![0] = a;
      }
    }

    _prefixIsRightAligned = false;
  }

  IVectorBuilder<A> addOne(A elem) {
    if (_len1 == _WIDTH) _advance();

    a1[_len1] = elem;

    _len1 += 1;
    return this;
  }

  void _addArr1(_Arr1 data) {
    final dl = data.length;
    if (dl > 0) {
      if (_len1 == _WIDTH) _advance();

      final copy1 = min(_WIDTH - _len1, dl);
      final copy2 = dl - copy1;

      Array.arraycopy(data, 0, a1, _len1, copy1);
      _len1 += copy1;

      if (copy2 > 0) {
        _advance();
        Array.arraycopy(data, copy1, a1, 0, copy2);
        _len1 += copy2;
      }
    }
  }

  void _addArrN(Array<dynamic> slice, int dim) {
    if (slice.isEmpty) return;
    if (_len1 == _WIDTH) _advance();
    final sl = slice.length;

    switch (dim) {
      case 2:
        // lenRest is always a multiple of WIDTH
        final copy1 = min(((_WIDTH2 - _lenRest) >>> _BITS) & _MASK, sl);
        final copy2 = sl - copy1;
        final destPos = (_lenRest >>> _BITS) & _MASK;
        Array.arraycopy(slice, 0, a2!, destPos, copy1);
        _advanceN(_WIDTH * copy1);
        if (copy2 > 0) {
          Array.arraycopy(slice, copy1, a2!, 0, copy2);
          _advanceN(_WIDTH * copy2);
        }
      case 3:
        if (_lenRest % _WIDTH2 != 0) {
          // lenRest is not multiple of WIDTH2, so this slice does not align, need to try lower dimension
          slice.foreach((e) => _addArrN(e as _Arr2, 2));
          return;
        }
        final copy1 = min(((_WIDTH3 - _lenRest) >>> _BITS2) & _MASK, sl);
        final copy2 = sl - copy1;
        final destPos = (_lenRest >>> _BITS2) & _MASK;
        Array.arraycopy(slice, 0, a3!, destPos, copy1);
        _advanceN(_WIDTH2 * copy1);
        if (copy2 > 0) {
          Array.arraycopy(slice, copy1, a3!, 0, copy2);
          _advanceN(_WIDTH2 * copy2);
        }
      case 4:
        if (_lenRest % _WIDTH3 != 0) {
          // lenRest is not multiple of WIDTH3, so this slice does not align, need to try lower dimensions
          slice.foreach((e) => _addArrN(e as _Arr3, 3));
          return;
        }
        final copy1 = min(((_WIDTH4 - _lenRest) >>> _BITS3) & _MASK, sl);
        final copy2 = sl - copy1;
        final destPos = (_lenRest >>> _BITS3) & _MASK;
        Array.arraycopy(slice, 0, a4!, destPos, copy1);
        _advanceN(_WIDTH3 * copy1);
        if (copy2 > 0) {
          Array.arraycopy(slice, copy1, a4!, 0, copy2);
          _advanceN(_WIDTH3 * copy2);
        }
      case 5:
        if (_lenRest % _WIDTH4 != 0) {
          // lenRest is not multiple of WIDTH4, so this slice does not align, need to try lower dimensions
          slice.foreach((e) => _addArrN(e as _Arr4, 4));
          return;
        }
        final copy1 = min(((_WIDTH5 - _lenRest) >>> _BITS4) & _MASK, sl);
        final copy2 = sl - copy1;
        final destPos = (_lenRest >>> _BITS4) & _MASK;
        Array.arraycopy(slice, 0, a5!, destPos, copy1);
        _advanceN(_WIDTH4 * copy1);
        if (copy2 > 0) {
          Array.arraycopy(slice, copy1, a5!, 0, copy2);
          _advanceN(_WIDTH4 * copy2);
        }
      case 6:
        if (_lenRest % _WIDTH5 != 0) {
          // lenRest is not multiple of WIDTH5, so this slice does not align, need to try lower dimensions
          slice.foreach((e) => _addArrN(e as _Arr3, 5));
          return;
        }
        final copy1 = sl;
        // there is no copy2 because there can't be another a6 to copy to
        final destPos = _lenRest >>> _BITS5;
        if (destPos + copy1 > _LASTWIDTH) {
          throw UnsupportedError('exceeding 2^31 elements');
        }
        Array.arraycopy(slice, 0, a6!, destPos, copy1);
        _advanceN(_WIDTH5 * copy1);
      default:
        throw UnsupportedError('VectorBuilder.addArrN: $dim');
    }
  }

  IVectorBuilder<A> _addVector(IVector<A> xs) {
    final sliceCount = xs._vectorSliceCount;
    var sliceIdx = 0;

    while (sliceIdx < sliceCount) {
      final slice = xs._vectorSlice(sliceIdx);
      final sliceDim = _vectorSliceDim(sliceCount, sliceIdx);

      if (sliceDim == 1) {
        _addArr1(slice);
      } else if (sliceDim == _WIDTH || _len1 == 0) {
        _addArrN(slice, sliceDim);
      } else {
        _foreachRec(sliceDim - 2, slice, _addArr1);
      }

      sliceIdx += 1;
    }

    return this;
  }

  IVectorBuilder<A> addAll(IterableOnce<A> xs) {
    if (xs is IVector) {
      if (_len1 == 0 && _lenRest == 0 && !_prefixIsRightAligned) {
        return _initFromVector(xs as IVector<A>);
      } else {
        return _addVector(xs as IVector<A>);
      }
    } else {
      final it = xs.iterator;
      while (it.hasNext) {
        addOne(it.next());
      }
    }

    return this;
  }

  void _advance() {
    final idx = _lenRest + _WIDTH;
    final xor = idx ^ _lenRest;
    _lenRest = idx;
    _len1 = 0;
    _advance1(idx, xor);
  }

  void _advanceN(int n) {
    if (n > 0) {
      final idx = _lenRest + n;
      final xor = idx ^ _lenRest;
      _lenRest = idx;
      _len1 = 0;
      _advance1(idx, xor);
    }
  }

  void _advance1(int idx, int xor) {
    if (xor <= 0) {
      // level = 6 or something very unexpected happened
      throw ArgumentError(
          'advance1($idx, $xor): a1=$a1, a2=$a2, a3=$a3, a4=$a4, a5=$a5, a6=$a6, depth=$_depth');
    } else if (xor < _WIDTH2) {
      if (_depth <= 1) {
        a2 = _arr2(_WIDTH);
        a2![0] = a1;
        _depth = 2;
      }
      a1 = _arr1(_WIDTH);
      a2![(idx >>> _BITS) & _MASK] = a1;
    } else if (xor < _WIDTH3) {
      if (_depth <= 2) {
        a3 = _arr3(_WIDTH);
        a3![0] = a2;
        _depth = 3;
      }
      a1 = _arr1(_WIDTH);
      a2 = _arr2(_WIDTH);
      a2![(idx >>> _BITS) & _MASK] = a1;
      a3![(idx >>> _BITS2) & _MASK] = a2;
    } else if (xor < _WIDTH4) {
      if (_depth <= 3) {
        a4 = _arr4(_WIDTH);
        a4![0] = a3;
        _depth = 4;
      }
      a1 = _arr1(_WIDTH);
      a2 = _arr2(_WIDTH);
      a3 = _arr3(_WIDTH);
      a2![(idx >>> _BITS) & _MASK] = a1;
      a3![(idx >>> _BITS2) & _MASK] = a2;
      a4![(idx >>> _BITS3) & _MASK] = a3;
    } else if (xor < _WIDTH5) {
      if (_depth <= 4) {
        a5 = _arr5(_WIDTH);
        a5![0] = a4;
        _depth = 5;
      }
      a1 = _arr1(_WIDTH);
      a2 = _arr2(_WIDTH);
      a3 = _arr3(_WIDTH);
      a4 = _arr4(_WIDTH);
      a2![(idx >>> _BITS) & _MASK] = a1;
      a3![(idx >>> _BITS2) & _MASK] = a2;
      a4![(idx >>> _BITS3) & _MASK] = a3;
      a5![(idx >>> _BITS4) & _MASK] = a4;
    } else {
      if (_depth <= 5) {
        a6 = _arr6(_LASTWIDTH);
        a6![0] = a5;
        _depth = 6;
      }
      a1 = _arr1(_WIDTH);
      a2 = _arr2(_WIDTH);
      a3 = _arr3(_WIDTH);
      a4 = _arr4(_WIDTH);
      a5 = _arr5(_WIDTH);
      a2![(idx >>> _BITS) & _MASK] = a1;
      a3![(idx >>> _BITS2) & _MASK] = a2;
      a4![(idx >>> _BITS3) & _MASK] = a3;
      a5![(idx >>> _BITS4) & _MASK] = a4;
      a6![idx >>> _BITS5] = a5;
    }
  }

  IVector<A> result() {
    if (_prefixIsRightAligned) _leftAlignPrefix();

    final len = _len1 + _lenRest;
    final realLen = len - _offset;

    if (realLen == 0) {
      return IVector.empty();
    } else if (len < 0) {
      throw RangeError('Vector cannot have negative size $len');
    } else if (len <= _WIDTH) {
      return _Vector1(_copyIfDifferentSize(a1, realLen));
    } else if (len <= _WIDTH2) {
      final i1 = (len - 1) & _MASK;
      final i2 = (len - 1) >>> _BITS;
      final data = Array.copyOfRange(a2!, 1, i2);
      final prefix1 = a2![0]!;
      final suffix1 = _copyIfDifferentSize(a2![i2]!, i1 + 1);
      return _Vector2(prefix1, _WIDTH - _offset, data, suffix1, realLen);
    } else if (len <= _WIDTH3) {
      final i1 = (len - 1) & _MASK;
      final i2 = ((len - 1) >>> _BITS) & _MASK;
      final i3 = (len - 1) >>> _BITS2;
      final data = Array.copyOfRange(a3!, 1, i3);
      final prefix2 = _copyTail(a3![0]!);
      final prefix1 = a3![0]![0]!;
      final suffix2 = Array.copyOf(a3![i3]!, i2);
      final suffix1 = _copyIfDifferentSize(a3![i3]![i2]!, i1 + 1);
      final len1 = prefix1.length;
      final len12 = len1 + prefix2.length * _WIDTH;
      return _Vector3(
          prefix1, len1, prefix2, len12, data, suffix2, suffix1, realLen);
    } else if (len <= _WIDTH4) {
      final i1 = (len - 1) & _MASK;
      final i2 = ((len - 1) >>> _BITS) & _MASK;
      final i3 = ((len - 1) >>> _BITS2) & _MASK;
      final i4 = (len - 1) >>> _BITS3;
      final data = Array.copyOfRange(a4!, 1, i4);
      final prefix3 = _copyTail(a4![0]!);
      final prefix2 = _copyTail(a4![0]![0]!);
      final prefix1 = a4![0]![0]![0]!;
      final suffix3 = Array.copyOf(a4![i4]!, i3);
      final suffix2 = Array.copyOf(a4![i4]![i3]!, i2);
      final suffix1 = _copyIfDifferentSize(a4![i4]![i3]![i2]!, i1 + 1);
      final len1 = prefix1.length;
      final len12 = len1 + prefix2.length * _WIDTH;
      final len123 = len12 + prefix3.length * _WIDTH2;

      return _Vector4(prefix1, len1, prefix2, len12, prefix3, len123, data,
          suffix3, suffix2, suffix1, realLen);
    } else if (len <= _WIDTH5) {
      final i1 = (len - 1) & _MASK;
      final i2 = ((len - 1) >>> _BITS) & _MASK;
      final i3 = ((len - 1) >>> _BITS2) & _MASK;
      final i4 = ((len - 1) >>> _BITS3) & _MASK;
      final i5 = (len - 1) >>> _BITS4;
      final data = Array.copyOfRange(a5!, 1, i5);
      final prefix4 = _copyTail(a5![0]!);
      final prefix3 = _copyTail(a5![0]![0]!);
      final prefix2 = _copyTail(a5![0]![0]![0]!);
      final prefix1 = a5![0]![0]![0]![0]!;
      final suffix4 = Array.copyOf(a5![i5]!, i4);
      final suffix3 = Array.copyOf(a5![i5]![i4]!, i3);
      final suffix2 = Array.copyOf(a5![i5]![i4]![i3]!, i2);
      final suffix1 = _copyIfDifferentSize(a5![i5]![i4]![i3]![i2]!, i1 + 1);
      final len1 = prefix1.length;
      final len12 = len1 + prefix2.length * _WIDTH;
      final len123 = len12 + prefix3.length * _WIDTH2;
      final len1234 = len123 + prefix4.length * _WIDTH3;
      return _Vector5(prefix1, len1, prefix2, len12, prefix3, len123, prefix4,
          len1234, data, suffix4, suffix3, suffix2, suffix1, realLen);
    } else {
      final i1 = (len - 1) & _MASK;
      final i2 = ((len - 1) >>> _BITS) & _MASK;
      final i3 = ((len - 1) >>> _BITS2) & _MASK;
      final i4 = ((len - 1) >>> _BITS3) & _MASK;
      final i5 = ((len - 1) >>> _BITS4) & _MASK;
      final i6 = (len - 1) >>> _BITS5;
      final data = Array.copyOfRange(a6!, 1, i6);
      final prefix5 = _copyTail(a6![0]!);
      final prefix4 = _copyTail(a6![0]![0]!);
      final prefix3 = _copyTail(a6![0]![0]![0]!);
      final prefix2 = _copyTail(a6![0]![0]![0]![0]!);
      final prefix1 = a6![0]![0]![0]![0]![0]!;
      final suffix5 = Array.copyOf(a6![i6]!, i5);
      final suffix4 = Array.copyOf(a6![i6]![i5]!, i4);
      final suffix3 = Array.copyOf(a6![i6]![i5]![i4]!, i3);
      final suffix2 = Array.copyOf(a6![i6]![i5]![i4]![i3]!, i2);
      final suffix1 =
          _copyIfDifferentSize(a6![i6]![i5]![i4]![i3]![i2]!, i1 + 1);
      final len1 = prefix1.length;
      final len12 = len1 + prefix2.length * _WIDTH;
      final len123 = len12 + prefix3.length * _WIDTH2;
      final len1234 = len123 + prefix4.length * _WIDTH3;
      final len12345 = len1234 + prefix5.length * _WIDTH4;
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
          data,
          suffix5,
          suffix4,
          suffix3,
          suffix2,
          suffix1,
          realLen);
    }
  }
}
