// TODO: ...
import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

abstract class Range
    with RIterableOnce<int>, RIterable<int>, RSeq<int>, IndexedSeq<int> {
  final int start;
  final int end;
  final int step;

  Range(this.start, this.end, this.step);

  factory Range.exclusive(int start, int end, [int step = 1]) =>
      _RangeExclusive(start, end, step);

  factory Range.inclusive(int start, int end, [int step = 1]) =>
      _RangeInclusive(start, end, step);

  @override
  bool get isEmpty =>
      (start > end && step > 0) ||
      (start < end && step < 0) ||
      (start == end && !isInclusive);

  bool get isInclusive;

  @override
  int operator [](int idx) {
    _validateMaxLength();
    if (0 <= idx && idx < _numRangeElements) {
      return start + (step * idx);
    } else {
      throw RangeError(
          '$idx is out of bound (min 0, max ${_numRangeElements - 1})');
    }
  }

  Range by(int step) => _copy(step: step);

  @override
  bool contains(int elem) {
    if (elem == end && !isInclusive) {
      return false;
    } else if (step > 0) {
      if (elem < start || elem > end) {
        return false;
      } else {
        return (step == 1) || (elem - start) % step == 0;
      }
    } else {
      if (elem < end || elem > start) {
        return false;
      } else {
        return (step == -1) || (start - elem) % -step == 0;
      }
    }
  }

  @override
  Range distinct() => this;

  @override
  Range drop(int n) {
    if (n <= 0 || isEmpty) {
      return this;
    } else if (n >= _numRangeElements && _numRangeElements >= 0) {
      return _newEmptyRange(end);
    } else {
      // May have more than Int.MaxValue elements (numRangeElements < 0)
      // but the logic is the same either way: go forwards n steps, keep the rest
      return _copy(start: _locationAfterN(n));
    }
  }

  @override
  Range dropRight(int n) {
    if (n <= 0) {
      return this;
    } else if (_numRangeElements >= 0) {
      return take(_numRangeElements - n);
    } else {
      // Need to handle over-full range separately
      final y = last - step * n;
      if ((step > 0 && y < start) || (step < 0 && y > start)) {
        return _newEmptyRange(start);
      } else {
        return Range.inclusive(start, y, step);
      }
    }
  }

  @override
  Range dropWhile(Function1<int, bool> p) {
    final stop = _argTakeWhile(p);
    if (stop == start) {
      return this;
    } else {
      final x = stop - step;
      if (x == last) {
        return _newEmptyRange(last);
      } else {
        return Range.inclusive(x + step, last, step);
      }
    }
  }

  Range exclusive() => !isInclusive ? this : Range.exclusive(start, end, step);

  @override
  RIterator<Range> grouped(int size) => _RangeGroupedIterator(this, size);

  Range inclusive() => isInclusive ? this : Range.inclusive(start, end, step);

  @override
  Option<int> indexOf(int elem, [int from = 0]) {
    final pos = _posOf(elem);
    return Option.when(() => 0 <= pos && from <= pos, () => pos);
  }

  @override
  int get head => isEmpty ? throw _emptyRangeError('head') : start;

  @override
  Range init() => isEmpty ? throw _emptyRangeError('init') : dropRight(1);

  @override
  RIterator<Range> inits() => _RangeInitsIterator(this);

  @override
  RIterator<int> get iterator =>
      _RangeIterator(start, step, _lastElement, isEmpty);

  @override
  int get last => isEmpty ? throw _emptyRangeError('last') : _lastElement;

  @override
  Option<int> lastIndexOf(int elem, [int end = 2147483647]) {
    final pos = _posOf(elem);
    return Option.when(() => 0 <= pos && pos <= end, () => pos);
  }

  @override
  int get length => _numRangeElements;

  @override
  IndexedSeq<B> map<B>(covariant Function1<int, B> f) {
    _validateMaxLength();
    return super.map(f).toIndexedSeq();
  }

  @override
  IndexedSeq<int> reverse() =>
      isEmpty ? this : Range.inclusive(last, start, -step);

  @override
  bool sameElements(RIterable<int> that) {
    if (that is Range) {
      return switch (length) {
        0 => that.isEmpty,
        1 => that.length == 1 && start == that.start,
        final n =>
          that.length == n && (start == that.start && step == that.step),
      };
    } else {
      return super.sameElements(that);
    }
  }

  @override
  Range slice(int from, int until) {
    if (from <= 0) {
      return take(until);
    } else if (until >= _numRangeElements && _numRangeElements >= 0) {
      return drop(from);
    } else {
      final fromValue = _locationAfterN(from);
      if (from >= until) {
        return _newEmptyRange(fromValue);
      } else {
        return Range.inclusive(fromValue, _locationAfterN(until - 1), step);
      }
    }
  }

  @override
  (Range, Range) span(Function1<int, bool> p) {
    final border = _argTakeWhile(p);
    if (border == start) {
      return (_newEmptyRange(start), this);
    } else {
      final x = border - step;
      if (x == last) {
        return (this, _newEmptyRange(last));
      } else {
        return (
          Range.inclusive(start, x, step),
          Range.inclusive(x + step, last, step)
        );
      }
    }
  }

  @override
  IndexedSeq<int> sorted(Order<int> order) {
    if (order == Order.ints) {
      if (step > 0) {
        return this;
      } else {
        return reverse();
      }
    } else {
      return super.sorted(order).toIndexedSeq();
    }
  }

  @override
  (Range, Range) splitAt(int n) => (take(n), drop(n));

  @override
  Range tail() {
    if (isEmpty) throw _emptyRangeError("tail");
    if (_numRangeElements == 1) {
      return _newEmptyRange(end);
    } else if (isInclusive) {
      return Range.inclusive(start + step, end, step);
    } else {
      return Range.exclusive(start + step, end, step);
    }
  }

  @override
  RIterator<Range> tails() => _RangeTailsIterator(this);

  @override
  Range take(int n) {
    if (n <= 0 || isEmpty) {
      return _newEmptyRange(start);
    } else if (n >= _numRangeElements && _numRangeElements >= 0) {
      return this;
    } else {
      // May have more than Int.MaxValue elements in range (numRangeElements < 0)
      // but the logic is the same either way: take the first n
      return Range.inclusive(start, _locationAfterN(n - 1), step);
    }
  }

  @override
  Range takeRight(int n) {
    if (n <= 0) {
      return _newEmptyRange(start);
    } else if (_numRangeElements >= 0) {
      return drop(_numRangeElements - n);
    } else {
      // Need to handle over-full range separately
      final y = last;
      final x = y - step * (n - 1);

      if ((step > 0 && x < start) || (step < 0 && x > start)) {
        return this;
      } else {
        return Range.inclusive(x, y, step);
      }
    }
  }

  @override
  Range takeWhile(Function1<int, bool> p) {
    final stop = _argTakeWhile(p);
    if (stop == start) {
      return _newEmptyRange(start);
    } else {
      final x = stop - step;
      if (x == last) {
        return this;
      } else {
        return Range.inclusive(start, x, step);
      }
    }
  }

  @override
  Range tapEach<U>(Function1<int, U> f) {
    foreach(f);
    return this;
  }

  @override
  String toString() {
    final preposition = isInclusive ? 'to' : 'until';
    final stepped = step == 1 ? '' : ' by $step';
    final prefix = isEmpty
        ? 'empty '
        : !_isExact
            ? 'inexact '
            : '';
    return '${prefix}Range $start $preposition $end$stepped';
  }

  @override
  bool operator ==(Object that) {
    if (that is Range) {
      return (isEmpty == that.isEmpty) &&
          (start == that.start) &&
          (last == that.last) &&
          (start == last || step == that.step);
    } else {
      return super == that;
    }
  }

  @override
  int get hashCode => length > 2
      ? MurmurHash3.rangeHash(start, step, _lastElement)
      : super.hashCode;

  Range _copy({int? start, int? end, int? step, bool? isInclusive}) {
    if (isInclusive ?? this.isInclusive) {
      return Range.inclusive(
        start ?? this.start,
        end ?? this.end,
        step ?? this.step,
      );
    } else {
      return Range.exclusive(
        start ?? this.start,
        end ?? this.end,
        step ?? this.step,
      );
    }
  }

  RangeError _emptyRangeError(String function) =>
      RangeError('$function on empty Range');

  int _argTakeWhile(Function1<int, bool> p) {
    if (isEmpty) {
      return start;
    } else {
      var current = start;
      final stop = last;
      while (current != stop && p(current)) {
        current += step;
      }
      if (current != stop || !p(current)) {
        return current;
      } else {
        return current + step;
      }
    }
  }

  int _locationAfterN(int n) => start + (step * n);
  Range _newEmptyRange(int value) => Range.exclusive(value, value, step);
  int _posOf(int i) => contains(i) ? (i - start) ~/ step : -1;
  void _validateMaxLength() {
    if (_numRangeElements < 0) throw RangeError('Range overflow');
  }

  int get _gap => end - start;
  bool get _isExact => _gap % step == 0;
  bool get _hasStub => isInclusive || !_isExact;
  int get _numRangeElements => _gap ~/ step + (_hasStub ? 1 : 0);

  late final int _lastElement = _lastElementFn();
  int _lastElementFn() {
    if (step == 0) {
      throw ArgumentError('step cannot be 0');
    } else if (step == 1) {
      return isInclusive ? end : end - 1;
    } else if (step == -1) {
      return isInclusive ? end : end + 1;
    } else {
      var remainder = _gap % step;

      // Dart has different module behavior than Scala
      if (_gap < 0 && remainder != 0) remainder += step;

      if (remainder != 0) {
        return end - remainder;
      } else if (isInclusive) {
        return end;
      } else {
        return end - step;
      }
    }
  }

  static int elementCount(
    int start,
    int end,
    int step, {
    bool isInclusive = false,
  }) {
    if (step == 0) throw ArgumentError('zero step');

    final bool isEmpty;

    if (start == end) {
      isEmpty = !isInclusive;
    } else if (start < end) {
      isEmpty = step < 0;
    } else {
      isEmpty = step > 0;
    }

    if (isEmpty) {
      return 0;
    } else {
      final gap = end - start;
      final jumps = gap ~/ step;

      // Whether the size of this range is one larger than the
      // number of full-sized jumps.
      final hasStub = isInclusive || (gap % step != 0);
      final result = jumps + (hasStub ? 1 : 0);

      if (result > Integer.MaxValue) {
        return -1;
      } else {
        return result;
      }
    }
  }
}

final class _RangeInclusive extends Range {
  _RangeInclusive(super.start, super.end, super.step);

  @override
  bool get isInclusive => true;
}

final class _RangeExclusive extends Range {
  _RangeExclusive(super.start, super.end, super.step);

  @override
  bool get isInclusive => false;
}

final class _RangeIterator extends RIterator<int> {
  final int start;
  final int step;
  final int lastElement;
  final bool initiallyEmpty;

  bool _hasNext;
  int _next;

  _RangeIterator(this.start, this.step, this.lastElement, this.initiallyEmpty)
      : _hasNext = !initiallyEmpty,
        _next = start;

  @override
  RIterator<int> drop(int n) {
    if (n > 0) {
      final longPos = _next + step * n;
      if (step > 0) {
        _next = min(lastElement, longPos);
        _hasNext = longPos <= lastElement;
      } else if (step < 0) {
        _next = max(lastElement, longPos);
        _hasNext = longPos >= lastElement;
      }
    }

    return this;
  }

  @override
  bool get hasNext => _hasNext;

  @override
  int get knownSize => _hasNext ? (lastElement - _next) ~/ step + 1 : 0;

  @override
  int next() {
    if (!_hasNext) noSuchElement();

    final value = _next;
    _hasNext = value != lastElement;
    _next = value + step;

    return value;
  }
}

final class _RangeInitsIterator extends RIterator<Range> {
  final Range self;
  var _i = 0;

  _RangeInitsIterator(this.self);

  @override
  bool get hasNext => _i < self.length;

  @override
  Range next() {
    if (hasNext) {
      final res = self.dropRight(_i);
      _i += 1;
      return res;
    } else {
      noSuchElement();
    }
  }
}

final class _RangeTailsIterator extends RIterator<Range> {
  final Range self;
  var _i = 0;

  _RangeTailsIterator(this.self);

  @override
  bool get hasNext => _i < self.length;

  @override
  Range next() {
    if (hasNext) {
      final res = self.drop(_i);
      _i += 1;
      return res;
    } else {
      noSuchElement();
    }
  }
}

final class _RangeGroupedIterator extends RIterator<Range> {
  final Range self;
  final int n;
  var _i = 0;

  _RangeGroupedIterator(this.self, this.n);

  @override
  bool get hasNext => _i < self.length;

  @override
  Range next() {
    if (hasNext) {
      final res = self.slice(_i, _i + n);
      _i += n;
      return res;
    } else {
      noSuchElement();
    }
  }
}
