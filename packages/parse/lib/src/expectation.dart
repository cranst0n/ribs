import 'package:ribs_core/ribs_core.dart';

sealed class Expectation {
  final int offset;

  IList<String> get context => switch (this) {
        WithContext(contextStr: final ctx, expect: final inner) =>
          inner.context.prepend(ctx),
        _ => nil(),
      };

  const Expectation(this.offset);

  factory Expectation.endOfString(int offset, int length) =>
      EndOfString(offset, length);

  factory Expectation.inRange(int offset, String lower, String upper) =>
      InRange(offset, lower, upper);

  static NonEmptyIList<Expectation> unify(NonEmptyIList<Expectation> errors) {
    final IList<Expectation> result = errors
        .groupBy((ex) => (ex.offset, ex.context))
        .toIList()
        .flatMapN((a, list) {
      final (_, ctx) = a;

      final rm = List<InRange>.empty(growable: true);
      final om = List<OneOfStr>.empty(growable: true);
      final fails = List<Fail>.empty(growable: true);
      final others = List<Expectation>.empty(growable: true);

      Iterable<Expectation> items = list.toList();

      while (items.isNotEmpty) {
        switch (_stripContext(items.first)) {
          case final InRange ir:
            rm.add(ir);
          case final OneOfStr os:
            om.add(os);
          case final Fail fail:
            fails.add(fail);
          case final ex:
            others.add(ex);
        }

        items = items.skip(1);
      }

      final rangeMerge = _mergeInRange(rm);
      final oossMerge = _mergeOnOfStr(om).toIList();

      final errors =
          rangeMerge.concat(oossMerge).reverse().concat(others.toIList());

      final finals = errors.isEmpty ? fails.toIList() : errors;

      if (ctx.nonEmpty) {
        final revCtx = ctx.reverse();
        return finals.map((e) => _addContext(revCtx, e));
      } else {
        return finals;
      }
    });

    return NonEmptyIList.fromIterableUnsafe(result.toList());
  }

  static IList<Expectation> _mergeInRange(List<InRange> irs) {
    // todo: tailrec
    IList<Expectation> merge(IList<InRange> rs, IList<InRange> aux) {
      if (rs.size >= 2) {
        final x = rs[0];
        final y = rs[1];
        final rest = rs.drop(2);

        if (y.lower.codeUnitAt(0) > x.lower.codeUnitAt(0) + 1) {
          return merge(rs.drop(1), aux.append(x));
        } else {
          return merge(
            rest.prepend(InRange(x.offset, x.lower, x.lower.max(y.lower))),
            aux,
          );
        }
      } else {
        return aux.concat(rs.reverse());
      }
    }

    return merge(
      irs.toIList().sortWith((a, b) => a.lower < b.lower),
      nil(),
    ).toList().toIList(); // 'cast' from IList<InRange> to IList<Expectation>
  }

  static Option<Expectation> _mergeOnOfStr(List<OneOfStr> ooss) =>
      Option.when(() => ooss.isNotEmpty, () {
        // TODO: Not sure order is right here...
        return OneOfStr(
          ooss.first.offset,
          ooss.toIList().flatMap((a) => a.strs),
        );
      });

  static Expectation _stripContext(Expectation ex) => switch (ex) {
        WithContext(contextStr: _, expect: final inner) => _stripContext(inner),
        _ => ex,
      };

  static Expectation _addContext(IList<String> revCtx, Expectation ex) =>
      throw UnimplementedError('Expectation._addContext');
}

final class OneOfStr extends Expectation {
  final IList<String> strs;

  const OneOfStr(super.offset, this.strs);

  @override
  String toString() {
    if (strs.size > 1) {
      return strs.mkString(
          start: 'must match one of the strings: "', sep: '", "', end: '"}');
    } else {
      return strs.headOption.fold(
        () => '??? bug with Expectation.OneOfStr',
        (a) => 'must match string: "$a"',
      );
    }
  }
}

// expected a character in a given range
final class InRange extends Expectation {
  final String lower;
  final String upper;

  const InRange(super.offset, this.lower, this.upper);

  @override
  String toString() {
    if (lower != upper) {
      return "must be a char within the range of: ['$lower', '$upper']";
    } else {
      return "must be char: '$lower'";
    }
  }
}

// case class StartOfString(offset: Int) extends Expectation
final class EndOfString extends Expectation {
  final int length;

  const EndOfString(super.offset, this.length);

  @override
  String toString() => 'must end the string';
}

// case class Length(offset: Int, expected: Int, actual: Int) extends Expectation
// case class ExpectedFailureAt(offset: Int, matched: String) extends Expectation
// // this is the result of oneOf0(Nil) at a given location
final class Fail extends Expectation {
  const Fail(super.offset);

  @override
  String toString() => 'must fail';
}
// case class FailWith(offset: Int, message: String) extends Expectation

final class WithContext extends Expectation {
  final String contextStr;
  final Expectation expect;

  const WithContext(this.contextStr, this.expect) : super(0);

  @override
  int get offset => expect.offset;

  @override
  String toString() => 'context: $contextStr, $expect';
}

extension _StringOps on String {
  bool operator <(String other) => compareTo(other) < 0;
  String max(String other) => compareTo(other) > 0 ? this : other;
}
