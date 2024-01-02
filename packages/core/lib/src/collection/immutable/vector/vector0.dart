part of '../vector.dart';

final class _Vector0<A> extends _BigVector<A> {
  _Vector0() : super(_empty1, _empty1, 0);

  @override
  A operator [](int idx) => throw _rngErr(idx);

  @override
  IVector<A> appended(A elem) => _Vector1(_wrap1(elem));

  @override
  IVector<B> map<B>(Function1<A, B> f) => _Vector0();

  @override
  IVector<A> prepended(A elem) => _Vector1(_wrap1(elem));

  @override
  IVector<A> updated(int index, A elem) => throw _rngErr(index);

  @override
  IVector<A> _slice0(int lo, int hi) => this;

  @override
  int get _vectorSliceCount => 0;

  @override
  List<dynamic> _vectorSlice(int idx) => throw Exception('Vector0.vectorSlice');
}
