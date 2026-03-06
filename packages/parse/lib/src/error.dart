import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/char.dart';
import 'package:ribs_parse/src/location_map.dart';

/// A parse error, consisting of the offset at which the failure occurred and
/// the list of expectations that were not met.
@immutable
class ParseError implements Exception {
  /// The original input string, if available.
  final Option<String> input;

  /// The character offset in the input at which the failure occurred.
  final int offset;

  /// The non-empty list of expectations that were not satisfied at [offset].
  final NonEmptyIList<Expectation> expected;

  const ParseError(this.input, this.offset, this.expected);

  /// Creates a [ParseError] with a single expectation and no input string.
  factory ParseError.single(Expectation exp) => ParseError(none(), exp.offset, nel(exp));

  @override
  bool operator ==(Object other) =>
      other is ParseError && other.offset == offset && other.expected == expected;

  @override
  int get hashCode => Object.hash(offset, expected);

  @override
  String toString() {
    final errorMsg =
        'expectation${expected.tail.nonEmpty ? 's' : ''}: '
        '${expected.mkString(sep: '\n')}';

    return input.fold(
      () => 'at offset $offset\n$errorMsg',
      (input) {
        final locationMap = LocationMap(input);

        return locationMap.toCaret(offset).fold(
          () => errorMsg,
          (caret) {
            final lines = locationMap.lines;

            const contextSize = 2;

            final start = caret.line - contextSize;
            final end = caret.line + 1 + contextSize;

            const elipsis = '...';

            final beforeElipis = start > 0 ? elipsis : null;
            final beforeContext =
                Option(
                  lines.slice(start, caret.line).mkString(sep: '\n'),
                ).filter((str) => str.nonEmpty).toNullable();

            final line = lines[caret.line];

            final afterContext =
                Option(
                  lines.slice(caret.line + 1, end).mkString(sep: '\n'),
                ).filter((str) => str.nonEmpty).toNullable();
            final afterElipis = end < lines.length - 1 ? elipsis : null;

            return ilist([
              beforeElipis,
              beforeContext,
              line,
              ' ' * caret.col + '^',
              errorMsg,
              afterContext,
              afterElipis,
            ]).noNulls().mkString(sep: '\n');
          },
        );
      },
    );
  }
}

/// Represents what was expected at a given offset when a parse failed.
///
/// The sealed hierarchy covers every way a parser can express failure:
/// character ranges, literal strings, positional anchors, explicit failures,
/// and named contexts.
@immutable
sealed class Expectation {
  /// The character offset at which this expectation was not met.
  final int offset;

  const Expectation(this.offset);

  /// One of the literal strings in [strs] was expected at [offset].
  factory Expectation.oneOfStr(int offset, IList<String> strs) => OneOfStr(offset, strs);

  /// A character in the range `[lower, upper]` was expected at [offset].
  factory Expectation.inRange(int offset, Char lower, Char upper) => InRange(offset, lower, upper);

  /// The input was expected to start (offset 0) at [offset].
  factory Expectation.startOfString(int offset) => StartOfString(offset);

  /// The input was expected to end at [offset]; [length] is the total input length.
  factory Expectation.endOfString(int offset, int length) => EndOfString(offset, length);

  /// A `not`/`peek`-style parser failed because [matched] was present at [offset].
  factory Expectation.expectedFailureAt(int offset, String matched) =>
      ExpectedFailureAt(offset, matched);

  /// A fixed-length parser needed [expected] characters but only [actual] were available.
  factory Expectation.length(int offset, int expected, int actual) =>
      Length(offset, expected, actual);

  /// An unconditional failure was expected at [offset].
  factory Expectation.fail(int offset) => ExpectationFail(offset);

  /// An unconditional failure with [message] was expected at [offset].
  factory Expectation.failWith(int offset, String message) => ExpectationFailWith(offset, message);

  /// Wraps [inner] with a user-supplied [context] label for richer diagnostics.
  factory Expectation.withContext(String context, Expectation inner) =>
      WithContext(inner.offset, context, inner);

  static NonEmptyIList<Expectation> unify(NonEmptyIList<Expectation> errors) {
    List<String> contextOf(Expectation e) {
      final ctx = <String>[];
      var current = e;

      while (current is WithContext) {
        ctx.add(current.context);
        current = current.inner;
      }

      return ctx;
    }

    Expectation stripContext(Expectation e) {
      var current = e;

      while (current is WithContext) {
        current = current.inner;
      }

      return current;
    }

    Expectation addContext(List<String> revCtx, Expectation e) {
      var result = e;

      for (final ctx in revCtx) {
        result = WithContext(result.offset, ctx, result);
      }

      return result;
    }

    // Group by (offset, context chain). Use a string key since List lacks value equality.
    final groups = <String, ({int offset, List<String> ctx, List<Expectation> items})>{};

    for (final e in errors.toList()) {
      final ctx = contextOf(e);
      final key = '${e.offset}:\x00${ctx.join('\x00')}';
      final existing = groups[key];

      if (existing != null) {
        existing.items.add(e);
      } else {
        groups[key] = (offset: e.offset, ctx: ctx, items: [e]);
      }
    }

    final result = <Expectation>[];

    for (final group in groups.values) {
      final ranges = <InRange>[];
      final oneOfStrs = <OneOfStr>[];
      final fails = <Expectation>[];
      final others = <Expectation>[];

      for (final e in group.items) {
        switch (stripContext(e)) {
          case final InRange ir:
            ranges.add(ir);
          case final OneOfStr oos:
            oneOfStrs.add(oos);
          case ExpectationFail() || ExpectationFailWith():
            fails.add(stripContext(e));
          case final other:
            others.add(other);
        }
      }

      final mergedRanges = _mergeInRange(ranges);
      final mergedOneOfStr = _mergeOneOfStr(group.offset, oneOfStrs);

      final combined = [...others, ...mergedOneOfStr, ...mergedRanges];
      final finals = combined.isEmpty ? fails : combined;

      final ctx = group.ctx;

      if (ctx.isNotEmpty) {
        final revCtx = ctx.reversed.toList();
        result.addAll(finals.map((e) => addContext(revCtx, e)));
      } else {
        result.addAll(finals);
      }
    }

    // Deduplicate while preserving order.
    final seen = <Expectation>{};
    final distinct = <Expectation>[];

    for (final e in result) {
      if (seen.add(e)) distinct.add(e);
    }

    return NonEmptyIList.fromDartUnsafe(distinct);
  }

  static List<InRange> _mergeInRange(List<InRange> ranges) {
    if (ranges.isEmpty) {
      return [];
    } else {
      ranges.sort((a, b) => a.lower.codeUnit.compareTo(b.lower.codeUnit));

      final merged = <InRange>[];
      var current = ranges.first;

      for (final r in ranges.skip(1)) {
        if (r.lower.codeUnit <= current.upper.codeUnit + 1) {
          if (r.upper.codeUnit > current.upper.codeUnit) {
            current = InRange(current.offset, current.lower, r.upper);
          }
        } else {
          merged.add(current);
          current = r;
        }
      }

      merged.add(current);

      return merged;
    }
  }

  static List<OneOfStr> _mergeOneOfStr(int offset, List<OneOfStr> oneOfStrs) {
    if (oneOfStrs.isEmpty) {
      return [];
    } else {
      final seen = <String>{};
      final allStrs = <String>[];

      for (final oos in oneOfStrs) {
        for (final s in oos.strs.toList()) {
          if (seen.add(s)) allStrs.add(s);
        }
      }

      return [OneOfStr(offset, IList.fromDart(allStrs))];
    }
  }

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Expected one of the literal strings [strs] at [offset].
@immutable
final class OneOfStr extends Expectation {
  /// The candidate strings that were expected.
  final IList<String> strs;

  const OneOfStr(super.offset, this.strs);

  @override
  bool operator ==(Object other) =>
      other is OneOfStr && other.offset == offset && other.strs == strs;

  @override
  int get hashCode => Object.hash(offset, strs);

  @override
  String toString() => switch (strs.size) {
    final x when x > 1 =>
      'must match one of the strings: ${strs.iterator.map((s) => '"$s"').mkString(start: '{', sep: ', ', end: '}')}',
    final x when x > 0 => 'must match string: "${strs.head}"',
    _ => '??? bug with Expectation.OneOfStr',
  };

  //'OneOfStr($offset, ${strs.mkString(sep: ", ")})';
}

/// Expected a character whose code unit falls in the range `[lower, upper]`.
@immutable
final class InRange extends Expectation {
  final Char lower;
  final Char upper;

  const InRange(super.offset, this.lower, this.upper);

  @override
  bool operator ==(Object other) =>
      other is InRange && other.offset == offset && other.lower == lower && other.upper == upper;

  @override
  int get hashCode => Object.hash(offset, lower, upper);

  @override
  String toString() =>
      lower != upper
          ? 'must be char in range of: [${lower.asString}, ${upper.asString}]'
          : 'must be char: ${lower.asString}';
}

/// Expected the input to start here (i.e. expected offset 0).
@immutable
final class StartOfString extends Expectation {
  const StartOfString(super.offset);

  @override
  bool operator ==(Object other) => other is StartOfString && other.offset == offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  String toString() => 'must start the string';
}

/// Expected the input to end here.
@immutable
final class EndOfString extends Expectation {
  final int length;

  const EndOfString(super.offset, this.length);

  @override
  bool operator ==(Object other) =>
      other is EndOfString && other.offset == offset && other.length == length;

  @override
  int get hashCode => Object.hash(offset, length);

  @override
  String toString() => 'must end the string';
}

/// The input ended unexpectedly (needed more characters).
@immutable
final class Length extends Expectation {
  final int expected;
  final int actual;

  const Length(super.offset, this.expected, this.actual);

  @override
  bool operator ==(Object other) =>
      other is Length &&
      other.offset == offset &&
      other.expected == expected &&
      other.actual == actual;

  @override
  int get hashCode => Object.hash(offset, expected, actual);

  @override
  String toString() => 'must have a length of $expected but got a length of $actual';
}

/// A `not`/`peek`-style parser failed because [matched] was present at [offset].
///
/// This expectation is produced when a negative lookahead succeeds but the
/// enclosing parser requires the lookahead to fail.
@immutable
final class ExpectedFailureAt extends Expectation {
  /// The substring that was matched (and should not have been).
  final String matched;

  const ExpectedFailureAt(super.offset, this.matched);

  @override
  bool operator ==(Object other) =>
      other is ExpectedFailureAt && other.offset == offset && other.matched == matched;

  @override
  int get hashCode => Object.hash(offset, matched);

  @override
  String toString() => 'must fail but matched with: $matched';
}

/// The parser explicitly failed (via [Parser0.fail]).
@immutable
final class ExpectationFail extends Expectation {
  const ExpectationFail(super.offset);

  @override
  bool operator ==(Object other) => other is ExpectationFail && other.offset == offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  String toString() => 'must fail';
}

/// The parser explicitly failed with a descriptive message.
@immutable
final class ExpectationFailWith extends Expectation {
  /// The message supplied to [Parser0.failWith].
  final String message;

  const ExpectationFailWith(super.offset, this.message);

  @override
  bool operator ==(Object other) =>
      other is ExpectationFailWith && other.offset == offset && other.message == message;

  @override
  int get hashCode => Object.hash(offset, message);

  @override
  String toString() => 'must fail: $message';
}

/// A named context wrapping another expectation (from [Parser0.withContext]).
@immutable
final class WithContext extends Expectation {
  /// The user-supplied context label.
  final String context;

  /// The underlying expectation that failed.
  final Expectation inner;

  const WithContext(super.offset, this.context, this.inner);

  @override
  bool operator ==(Object other) =>
      other is WithContext &&
      other.offset == offset &&
      other.context == context &&
      other.inner == inner;

  @override
  int get hashCode => Object.hash(offset, context, inner);

  @override
  String toString() => 'context: $context, $inner';
}
