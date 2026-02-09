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

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/rseq_views.dart' as seqview;

mixin SeqView<A> on RIterableOnce<A>, RIterable<A>, RSeq<A>, View<A> {
  static SeqView<A> from<A>(RSeq<A> v) => seqview.Id(v);

  @override
  RSeq<A> appended(A elem) => seqview.Appended(this, elem);

  @override
  RSeq<A> appendedAll(RIterableOnce<A> suffix) => seqview.Concat(this, suffix.toSeq());

  @override
  RSeq<A> concat(covariant RIterableOnce<A> suffix) => seqview.Concat(this, suffix.toSeq());

  @override
  RSeq<A> drop(int n) => seqview.Drop(this, n);

  @override
  RSeq<A> dropRight(int n) => seqview.DropRight(this, n);

  @override
  SeqView<B> map<B>(Function1<A, B> f) => seqview.Map(this, f);

  @override
  RSeq<A> prepended(A elem) => seqview.Prepended(elem, this);

  @override
  RSeq<A> prependedAll(RIterableOnce<A> prefix) => seqview.Concat(prefix.toSeq(), this);

  @override
  RSeq<A> reverse() => seqview.Reverse(this);

  @override
  RSeq<A> sorted(Order<A> order) => seqview.Sorted(this, order);

  @override
  RSeq<A> take(int n) => seqview.Take(this, n);

  @override
  RSeq<A> takeRight(int n) => seqview.TakeRight(this, n);

  @override
  RSeq<A> tapEach<U>(Function1<A, U> f) => seqview.Map(this, (a) {
        f(a);
        return a;
      });

  @override
  SeqView<A> view() => this;
}
