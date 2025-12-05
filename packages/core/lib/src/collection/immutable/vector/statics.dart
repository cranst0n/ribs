// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

part of '../ivector.dart';

typedef _Arr1 = Array<dynamic>;
typedef _Arr2 = Array<_Arr1>;
typedef _Arr3 = Array<_Arr2>;
typedef _Arr4 = Array<_Arr3>;
typedef _Arr5 = Array<_Arr4>;
typedef _Arr6 = Array<_Arr5>;

const _BITS = 5;
const _WIDTH = 1 << _BITS;
const _MASK = _WIDTH - 1;
const _BITS2 = _BITS * 2;
const _WIDTH2 = 1 << _BITS2;
const _BITS3 = _BITS * 3;
const _WIDTH3 = 1 << _BITS3;
const _BITS4 = _BITS * 4;
const _WIDTH4 = 1 << _BITS4;
const _BITS5 = _BITS * 5;
const _WIDTH5 = 1 << _BITS5;

// 1 extra bit in the last level to go up to Int.MaxValue (2^31-1) instead of 2^30:
const _LASTWIDTH = _WIDTH << 1;
const _Log2ConcatFaster = 5;
const _AlignToFaster = 64;

final _Arr1 _empty1 = Array.empty();
final _Arr2 _empty2 = Array.empty();
final _Arr3 _empty3 = Array.empty();
final _Arr4 _empty4 = Array.empty();
final _Arr5 _empty5 = Array.empty();
final _Arr6 _empty6 = Array.empty();

void _foreachRec<A, U>(int level, Array<dynamic> a, Function1<A, U> f) {
  var i = 0;
  final len = a.length;
  if (level == 0) {
    while (i < len) {
      f(a[i] as A);
      i += 1;
    }
  } else {
    final l = level - 1;
    while (i < len) {
      _foreachRec(l, a[i] as Array<dynamic>, f);
      i += 1;
    }
  }
}

_Arr1 _arr1(int size) => Array.ofDim(size);
_Arr2 _arr2(int size) => Array.ofDim(size);
_Arr3 _arr3(int size) => Array.ofDim(size);
_Arr4 _arr4(int size) => Array.ofDim(size);
_Arr5 _arr5(int size) => Array.ofDim(size);
_Arr6 _arr6(int size) => Array.ofDim(size);

int _vectorSliceDim(int count, int idx) {
  final c = count ~/ 2;
  return c + 1 - (idx - c).abs();
}

Array<dynamic> _copyOrUse(Array<dynamic> a, int start, int end) {
  if (start == 0 && end == a.length) {
    return a;
  } else {
    final newLength = end - start;
    final copy = Array.ofDim<dynamic>(newLength);
    Array.arraycopy(a, start, copy, 0, min(a.length - start, newLength));

    return copy;
  }
}

Array<A> _copyTail<A>(Array<A> a) => Array.copyOfRange(a, 1, a.length);
Array<A> _copyInit<A>(Array<A> a) => Array.copyOfRange(a, 0, a.length - 1);

Array<A> _copyIfDifferentSize<A>(Array<A> a, int len) => a.length == len ? a : Array.copyOf(a, len);

_Arr1 _wrap1(dynamic x) => Array.fill(1, x);
_Arr2 _wrap2(_Arr1 x) => Array.fill(1, x);
_Arr3 _wrap3(_Arr2 x) => Array.fill(1, x);
_Arr4 _wrap4(_Arr3 x) => Array.fill(1, x);
_Arr5 _wrap5(_Arr4 x) => Array.fill(1, x);

_Arr2 _arrCast2(Array<dynamic> a) =>
    a is _Arr2 ? a : Array.tabulate(a.length, (i) => a[i] as Array<dynamic>);
_Arr3 _arrCast3(Array<dynamic> a) =>
    a is _Arr3 ? a : Array.tabulate(a.length, (i) => _arrCast2(a[i] as Array<dynamic>));
_Arr4 _arrCast4(Array<dynamic> a) =>
    a is _Arr4 ? a : Array.tabulate(a.length, (i) => _arrCast3(a[i] as Array<dynamic>));
_Arr5 _arrCast5(Array<dynamic> a) =>
    a is _Arr5 ? a : Array.tabulate(a.length, (i) => _arrCast4(a[i] as Array<dynamic>));
_Arr6 _arrCast6(Array<dynamic> a) =>
    a is _Arr6 ? a : Array.tabulate(a.length, (i) => _arrCast5(a[i] as Array<dynamic>));

_Arr1 _copyAppend1(_Arr1 a, dynamic elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr2 _copyAppend2(_Arr2 a, _Arr1 elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr3 _copyAppend3(_Arr3 a, _Arr2 elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr4 _copyAppend4(_Arr4 a, _Arr3 elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr5 _copyAppend5(_Arr5 a, _Arr4 elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr6 _copyAppend6(_Arr6 a, _Arr5 elem) {
  final ac = Array.copyOf(a, a.length + 1);
  ac[a.length] = elem;
  return ac;
}

_Arr1 _copyPrepend1(dynamic elem, _Arr1 a) {
  final alen = a.length;
  final ac = _arr1(alen + 1);
  Array.arraycopy(a, 0, ac, 1, alen);
  ac[0] = elem;
  return ac;
}

_Arr2 _copyPrepend2(_Arr1 elem, _Arr2 a) {
  final ac = _arr2(a.length + 1);
  Array.arraycopy(a, 0, ac, 1, a.length);
  ac[0] = elem;
  return ac;
}

_Arr3 _copyPrepend3(_Arr2 elem, _Arr3 a) {
  final ac = _arr3(a.length + 1);
  Array.arraycopy(a, 0, ac, 1, a.length);
  ac[0] = elem;
  return ac;
}

_Arr4 _copyPrepend4(_Arr3 elem, _Arr4 a) {
  final ac = _arr4(a.length + 1);
  Array.arraycopy(a, 0, ac, 1, a.length);
  ac[0] = elem;
  return ac;
}

_Arr5 _copyPrepend5(_Arr4 elem, _Arr5 a) {
  final ac = _arr5(a.length + 1);
  Array.arraycopy(a, 0, ac, 1, a.length);
  ac[0] = elem;
  return ac;
}

_Arr6 _copyPrepend6(_Arr5 elem, _Arr6 a) {
  final ac = _arr6(a.length + 1);
  Array.arraycopy(a, 0, ac, 1, a.length);
  ac[0] = elem;
  return ac;
}

_Arr1 _copyUpdate1(_Arr1 a1, int idx1, dynamic elem) {
  final a1c = _clone1(a1);
  a1c[idx1] = elem;
  return a1c;
}

_Arr2 _copyUpdate2(_Arr2 a2, int idx2, int idx1, dynamic elem) {
  final a2c = _clone2(a2);
  a2c[idx2] = _copyUpdate1(a2c[idx2]!, idx1, elem);
  return a2c;
}

_Arr3 _copyUpdate3(_Arr3 a3, int idx3, int idx2, int idx1, dynamic elem) {
  final a3c = _clone3(a3);
  a3c[idx3] = _copyUpdate2(a3c[idx3]!, idx2, idx1, elem);
  return a3c;
}

_Arr4 _copyUpdate4(_Arr4 a4, int idx4, int idx3, int idx2, int idx1, dynamic elem) {
  final a4c = _clone4(a4);
  a4c[idx4] = _copyUpdate3(a4c[idx4]!, idx3, idx2, idx1, elem);
  return a4c;
}

_Arr5 _copyUpdate5(_Arr5 a5, int idx5, int idx4, int idx3, int idx2, int idx1, dynamic elem) {
  final a5c = _clone5(a5);
  a5c[idx5] = _copyUpdate4(a5c[idx5]!, idx4, idx3, idx2, idx1, elem);
  return a5c;
}

_Arr6 _copyUpdate6(
    _Arr6 a6, int idx6, int idx5, int idx4, int idx3, int idx2, int idx1, dynamic elem) {
  final a6c = _clone6(a6);
  a6c[idx6] = _copyUpdate5(a6c[idx6]!, idx5, idx4, idx3, idx2, idx1, elem);
  return a6c;
}

Array<T> _concatArrays<T>(Array<T> a, Array<T> b) {
  final dest = Array.copyOf(a, a.length + b.length);
  Array.arraycopy(b, 0, dest, a.length, b.length);
  return dest;
}

_Arr1 _clone1(_Arr1 a) => Array.copyOf(a, a.length);
_Arr2 _clone2(_Arr2 a) => a.map((x) => _clone1(x));
_Arr3 _clone3(_Arr3 a) => a.map((x) => _clone2(x));
_Arr4 _clone4(_Arr4 a) => a.map((x) => _clone3(x));
_Arr5 _clone5(_Arr5 a) => a.map((x) => _clone4(x));
_Arr6 _clone6(_Arr6 a) => a.map((x) => _clone5(x));

_Arr1 _mapElems1<A, B>(_Arr1 a, Function1<A, B> f) {
  var i = 0;

  while (i < a.length) {
    final v1 = a[i];
    final v2 = f(v1 as A);

    if (v1 != v2) {
      return _mapElems1Rest(a, f, i, v2);
    }

    i += 1;
  }

  return a;
}

_Arr1 _mapElems1Rest<A, B>(_Arr1 a, Function1<A, B> f, int at, dynamic v2) {
  final ac = _arr1(a.length);

  if (at > 0) {
    Array.arraycopy(a, 0, ac, 0, at);
  }

  ac[at] = v2;
  var i = at + 1;

  while (i < a.length) {
    ac[i] = f(a[i] as A);
    i += 1;
  }

  return ac;
}

_Arr2 _mapElems2<A, B>(_Arr2 a, Function1<A, B> f) {
  final ac = _arr2(a.length);

  var i = 0;
  while (i < a.length) {
    ac[i] = _mapElems1(a[i]!, f);
    i++;
  }

  return ac;
}

_Arr3 _mapElems3<A, B>(_Arr3 a, Function1<A, B> f) {
  final ac = _arr3(a.length);

  var i = 0;
  while (i < a.length) {
    ac[i] = _mapElems2(a[i]!, f);
    i++;
  }

  return ac;
}

_Arr4 _mapElems4<A, B>(_Arr4 a, Function1<A, B> f) {
  final ac = _arr4(a.length);

  var i = 0;
  while (i < a.length) {
    ac[i] = _mapElems3(a[i]!, f);
    i++;
  }

  return ac;
}

_Arr5 _mapElems5<A, B>(_Arr5 a, Function1<A, B> f) {
  final ac = _arr5(a.length);

  var i = 0;
  while (i < a.length) {
    ac[i] = _mapElems4(a[i]!, f);
    i++;
  }

  return ac;
}

_Arr6 _mapElems6<A, B>(_Arr6 a, Function1<A, B> f) {
  final ac = _arr6(a.length);

  var i = 0;
  while (i < a.length) {
    ac[i] = _mapElems5(a[i]!, f);
    i++;
  }

  return ac;
}
