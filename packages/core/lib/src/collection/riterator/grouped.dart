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

final class _GroupedIterator<A> extends RIterator<RSeq<A>> {
  final RIterator<A> self;
  final int groupSize;
  final int step;

  late List<A>? _buffer;
  List<A>? _prev;

  bool _first = true;
  bool _filled = false;
  bool _partial = true;

  Function0<A>? _padding;

  _GroupedIterator(this.self, this.groupSize, this.step);

  @override
  bool get hasNext => fill();

  @override
  RSeq<A> next() {
    if (!fill()) {
      noSuchElement();
    } else {
      _filled = false;

      // if stepping, retain overlap in prev
      if (step < groupSize) {
        if (_first) {
          _prev = _buffer!.skip(step).toList();
        } else if (_buffer!.length == groupSize) {
          _prev = List.from(_buffer!.getRange(step, _buffer!.length));
        } else {
          _prev = null;
        }
      }
      final res = RSeq.fromDart(_buffer!);
      _buffer = null;
      _first = false;
      return res;
    }
  }

  _GroupedIterator<A> withPadding(Function0<A> x) {
    _padding = x;
    _partial = true;
    return this;
  }

  _GroupedIterator<A> withPartial(bool x) {
    _partial = x;
    _padding = null;
    return this;
  }

  bool get _pad => _padding != null;

  bool _fulfill() {
    final builder = List<A>.empty(growable: true);
    bool done = false;

    if (_prev != null) builder.addAll(_prev!);

    if (!_first && step > groupSize) {
      var dropping = step - groupSize;
      while (dropping > 0 && self.hasNext) {
        self.next();
        dropping -= 1;
      }
      done = dropping > 0; // skip failed
    }

    var index = builder.length;

    if (!done) {
      // advance to rest of segment if possible
      while (index < groupSize && self.hasNext) {
        builder.add(self.next());
        index += 1;
      }
      // if unable to complete segment, pad if possible
      if (index < groupSize && _pad) {
        // builder.sizeHint(size)
        while (index < groupSize) {
          builder.add(_padding!());
          index += 1;
        }
      }
    }

    // segment must have data, and must be complete unless they allow partial
    final ok = index > 0 && (_partial || index == groupSize);
    if (ok) {
      _buffer = builder;
    } else {
      _prev = null;
    }

    return ok;
  }

  // fill() returns false if no more sequences can be produced
  bool fill() {
    if (_filled) {
      return true;
    } else {
      return _filled = self.hasNext && _fulfill();
    }
  }
}
