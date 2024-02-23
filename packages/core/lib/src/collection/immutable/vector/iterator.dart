part of '../ivector.dart';

final class _NewVectorIterator<A> extends RIterator<A> {
  final IVector<A> v;
  int totalLength;
  int sliceCount;

  _Arr1 a1;
  _Arr2? a2;
  _Arr3? a3;
  _Arr4? a4;
  _Arr5? a5;
  _Arr6? a6;

  int a1len;
  int i1 = 0;
  int oldPos = 0;
  int len1;

  int sliceIdx = 0;
  int sliceDim = 1;
  int sliceStart = 0;
  int sliceEnd;

  _NewVectorIterator(this.v, this.totalLength, this.sliceCount)
      : a1 = v._prefix1,
        a1len = v._prefix1.length,
        len1 = totalLength,
        sliceEnd = v._prefix1.length;

  @override
  bool get hasNext => len1 > i1;

  @override
  A next() {
    if (i1 == a1len) advance();
    final r = a1[i1];
    i1 += 1;
    return r as A;
  }

  void advanceSlice() {
    if (!hasNext) throw Exception('VectorIterator advanceSlice');

    sliceIdx += 1;
    var slice = v._vectorSlice(sliceIdx);
    while (slice.isEmpty) {
      sliceIdx += 1;
      slice = v._vectorSlice(sliceIdx);
    }

    sliceStart = sliceEnd;
    sliceDim = _vectorSliceDim(sliceCount, sliceIdx);

    switch (sliceDim) {
      case 1:
        a1 = slice;
      case 2:
        a2 = slice as _Arr2;
      case 3:
        a3 = slice as _Arr3;
      case 4:
        a4 = slice as _Arr4;
      case 5:
        a5 = slice as _Arr5;
      case 6:
        a6 = slice as _Arr6;
      default:
        throw StateError('VectorIterator.sliceDim: $sliceDim');
    }

    sliceEnd = sliceStart + slice.length * (1 << (_BITS * (sliceDim - 1)));

    if (sliceEnd > totalLength) sliceEnd = totalLength;
    if (sliceDim > 1) oldPos = (1 << (_BITS * sliceDim)) - 1;
  }

  void advance() {
    final pos = i1 - len1 + totalLength;
    if (pos == sliceEnd) advanceSlice();
    if (sliceDim > 1) {
      final io = pos - sliceStart;
      final xor = oldPos ^ io;
      advanceA(io, xor);
      oldPos = io;
    }
    len1 -= i1;
    a1len = min(a1.length, len1);
    i1 = 0;
  }

  void advanceA(int io, int xor) {
    if (xor < _WIDTH2) {
      a1 = a2![(io >>> _BITS) & _MASK]!;
    } else if (xor < _WIDTH3) {
      a2 = a3![(io >>> _BITS2) & _MASK];
      a1 = a2![0]!;
    } else if (xor < _WIDTH4) {
      a3 = a4![(io >>> _BITS3) & _MASK];
      a2 = a3![0];
      a1 = a2![0]!;
    } else if (xor < _WIDTH5) {
      a4 = a5![(io >>> _BITS4) & _MASK];
      a3 = a4![0];
      a2 = a3![0];
      a1 = a2![0]!;
    } else {
      a5 = a6![io >>> _BITS5];
      a4 = a5![0];
      a3 = a4![0];
      a2 = a3![0];
      a1 = a2![0]!;
    }
  }
}
