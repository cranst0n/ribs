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

part of '../riterator.dart';

final class _ScanLeftIterator<A, B> extends RIterator<B> {
  final RIterator<A> self;
  final B z;
  final Function2<B, A, B> op;

  B acc;

  late RIterator<B> _current = _RibsIteratorF(
    hasNextF: () => true,
    nextF: () {
      // Here we change our self-reference to a new iterator that iterates through `self`
      _current = _RibsIteratorF(
        hasNextF: () => self.hasNext,
        nextF: () => acc = op(acc, self.next()),
        knownSizeF: () => self.knownSize,
      );

      return z;
    },
    knownSizeF: () {
      final thisSize = self.knownSize;
      return thisSize < 0 ? -1 : thisSize + 1;
    },
  );

  _ScanLeftIterator(this.self, this.z, this.op) : acc = z;

  @override
  bool get hasNext => _current.hasNext;

  @override
  int get knownSize => _current.knownSize;

  @override
  B next() => _current.next();
}

final class _RibsIteratorF<A> extends RIterator<A> {
  final Function0<bool> hasNextF;
  final Function0<A> nextF;
  final Function0<int> knownSizeF;

  const _RibsIteratorF({
    required this.hasNextF,
    required this.nextF,
    required this.knownSizeF,
  });

  @override
  bool get hasNext => hasNextF();

  @override
  int get knownSize => knownSizeF();

  @override
  A next() => nextF();
}
