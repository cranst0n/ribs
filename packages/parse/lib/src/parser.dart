import 'dart:collection';

import 'package:ribs_core/ribs_core.dart' hide State;
import 'package:ribs_parse/src/accumulator.dart';
import 'package:ribs_parse/src/bit_set.dart';
import 'package:ribs_parse/src/caret.dart';
import 'package:ribs_parse/src/char.dart';
import 'package:ribs_parse/src/error.dart';
import 'package:ribs_parse/src/location_map.dart';
import 'package:ribs_parse/src/radix_node.dart';

part 'impl/any_char.dart';
part 'impl/backtrack.dart';
part 'impl/chars_while.dart';
part 'impl/caret.dart';
part 'impl/char_in.dart';
part 'impl/defer.dart';
part 'impl/end.dart';
part 'impl/fail.dart';
part 'impl/flat_map.dart';
part 'impl/index.dart';
part 'impl/length.dart';
part 'impl/map.dart';
part 'impl/not.dart';
part 'impl/one_of.dart';
part 'impl/peek.dart';
part 'impl/prod.dart';
part 'impl/pure.dart';
part 'impl/rep.dart';
part 'impl/rep_sep.dart';
part 'impl/select.dart';
part 'impl/soft_prod.dart';
part 'impl/start.dart';
part 'impl/str.dart';
part 'impl/string.dart';
part 'impl/string_in.dart';
part 'impl/voided.dart';
part 'impl/with_context.dart';
part 'impl/with_string.dart';

final class State {
  final String str;

  int offset = 0;
  Eval<IChain<Expectation>>? error;
  bool capture = true;

  late LocationMap locationMap = LocationMap(str);

  State(this.str);
}

sealed class Parser0<A> {
  Either<ParseError, (String, A)> parse(String str) {
    final state = State(str);
    final result = _parseMut(state);
    final err = state.error;
    final offset = state.offset;

    if (err == null) {
      return Right((str.substring(offset), result!));
    } else {
      return Left(
        ParseError(
          Some(str),
          offset,
          Expectation.unify(NonEmptyIList.unsafe(err.value.toIList())),
        ),
      );
    }
  }

  Either<ParseError, A> parseAll(String str) {
    final state = State(str);
    final result = _parseMut(state);
    final err = state.error;
    final offset = state.offset;

    if (err == null) {
      if (result != null && offset == str.length) {
        return Right(result);
      } else {
        return Left(
          ParseError(
            Some(str),
            offset,
            NonEmptyIList(Expectation.endOfString(offset, str.length)),
          ),
        );
      }
    } else {
      return Left(
        ParseError(
          Some(str),
          offset,
          Expectation.unify(NonEmptyIList.unsafe(err.value.toIList())),
        ),
      );
    }
  }

  Parser0<A> operator |(covariant Parser0<A> that) => orElse(that);

  Parser0<B> as<B>(B b) => Parsers.as0(this, b);

  Parser0<A> get backtrack => Parsers.backtrack0(this);

  Parser0<A> between(Parser0<dynamic> b, Parser0<dynamic> c) =>
      b.voided.product(product(c.voided)).map((tuple) => tuple.$2.$1);

  Parser0<Either<B, A>> eitherOr<B>(covariant Parser0<B> pb) => Parsers.eitherOr0(this, pb);

  Parser0<B> flatMap<B>(Function1<A, Parser0<B>> f) => Parsers.flatMap0(this, f);

  Parser0<B> map<B>(Function1<A, B> f) => Parsers.map0(this, f);

  Parser0<B> mapFilter<B>(Function1<A, Option<B>> f) {
    return Parsers.select0<Unit, B>(
      map((a) {
        return f(a).fold(
          () => Left(Unit()),
          (b) => Right(b),
        );
      }),
      Parsers.fail(),
    );
  }

  Parser0<A> filter(Function1<A, bool> p) {
    return Parsers.select0<Unit, A>(
      map((a) => p(a) ? Right(a) : Left(Unit())),
      Parsers.fail(),
    );
  }

  Parser0<Unit> get not => Parsers.not(this);

  Parser0<Option<A>> get opt =>
      Parsers.oneOf0(ilist([Parsers.map0(this, (a) => a.some), Parsers.pure(none<A>())]));

  Parser0<A> orElse(covariant Parser0<A> that) => Parsers.oneOf0(ilist([this, that]));

  Parser0<(A, B)> product<B>(Parser0<B> that) => Parsers.product0(this, that);

  Parser0<B> productR<B>(Parser0<B> that) => voided.product(that).map((t) => t.$2);

  Parser0<A> productL<B>(Parser0<B> that) => product(that.voided).map((t) => t.$1);

  Soft0<A> get soft => Soft0(this);

  Parser0<String> get string => Parsers.stringP0(this);

  Parser0<Unit> get peek => Parsers.peek(this);

  Parser0<A> surroundedBy(Parser<dynamic> b) => between(b, b);

  Parser0<Unit> get voided => Parsers.voided0(this);

  With1<A> get with1 => With1(this);

  Parser0<A> withContext(String str) => Parsers.withContext0(this, str);

  Parser0<(A, String)> get withString => Parsers.withString0(this);

  A? _parseMut(State state);
}

//
//
//
//
//
sealed class Parser<A> extends Parser0<A> {
  @override
  Parser<A> operator |(Parser<A> that) => orElse(that);

  @override
  Parser<B> as<B>(B b) => Parsers.as(this, b);

  @override
  Parser<A> get backtrack => Parsers.backtrack(this);

  @override
  Parser<A> between(Parser0<dynamic> b, Parser0<dynamic> c) =>
      b.voided.with1.product(product(c.voided)).map((tuple) => tuple.$2.$1);

  @override
  Parser<A> filter(Function1<A, bool> p) {
    return Parsers.select<Unit, A>(
      map((a) => p(a) ? Right(a) : Left(Unit())),
      Parsers.fail(),
    );
  }

  @override
  Parser<B> flatMap<B>(Function1<A, Parser0<B>> f) => Parsers.flatMap10(this, f);

  @override
  Parser<Either<B, A>> eitherOr<B>(Parser<B> pb) => Parsers.eitherOr(this, pb);

  @override
  Parser<B> map<B>(Function1<A, B> f) => Parsers.map(this, f);

  @override
  Parser<B> mapFilter<B>(Function1<A, Option<B>> f) {
    return Parsers.select<Unit, B>(
      map((a) {
        return f(a).fold(
          () => Left(Unit()),
          (b) => Right(b),
        );
      }),
      Parsers.fail(),
    );
  }

  @override
  Parser<A> orElse(Parser<A> that) => Parsers.oneOf(ilist([this, that]));

  @override
  Parser<(A, B)> product<B>(Parser0<B> that) => Parsers.product10(this, that);

  @override
  Parser<A> productL<B>(Parser0<B> that) => product(that.voided).map((t) => t.$1);

  @override
  Parser<B> productR<B>(Parser0<B> that) => voided.product(that).map((t) => t.$2);

  Parser0<IList<A>> rep0({int? min, int? max}) {
    if (min == null || min == 0) {
      return repAs0(Accumulator0.ilist(), max: max);
    } else {
      return repAs(Accumulator0.ilist(), min: min, max: max);
    }
  }

  Parser<NonEmptyIList<A>> rep({int? min, int? max}) =>
      repAs(Accumulator.nel(), min: min, max: max);

  Parser0<B> repAs0<B>(Accumulator0<A, B> acc, {int? max}) => Parsers.repAs0(this, acc, max: max);

  Parser<B> repAs<B>(Accumulator<A, B> acc, {int? min, int? max}) =>
      Parsers.repAs(this, acc, min ?? 1, max: max);

  Parser<B> repExactlyAs<B>(int times, Accumulator<A, B> acc) =>
      Parsers.repExactlyAs(this, times, acc);

  Parser0<IList<A>> repSep0(Parser0<dynamic> sep, {int? min, int? max}) =>
      Parsers.repSep0(this, sep, min: min ?? 0, max: max);

  Parser<NonEmptyIList<A>> repSep(Parser0<dynamic> sep, {int? min, int? max}) =>
      Parsers.repSep(this, sep, min: min ?? 1, max: max);

  Parser0<IList<A>> repUntil0(Parser0<dynamic> sep) => Parsers.repUntil0(this, sep);

  Parser0<B> repUntilAs0<B>(Parser0<dynamic> end, Accumulator0<A, B> acc) =>
      Parsers.repUntilAs0(this, end, acc);

  Parser<B> repUntilAs<B>(Parser0<dynamic> end, Accumulator<A, B> acc) =>
      Parsers.repUntilAs(this, end, acc);

  Parser<NonEmptyIList<A>> repUntil(Parser0<dynamic> sep) => Parsers.repUntil(this, sep);

  @override
  Soft<A> get soft => Soft(this);

  @override
  Parser<String> get string => Parsers.stringP(this);

  @override
  Parser0<A> surroundedBy(Parser<dynamic> b) => between(b, b);

  @override
  Parser<Unit> get voided => Parsers.voided(this);

  @override
  Parser<(A, String)> get withString => Parsers.withString(this);

  @override
  Parser<A> withContext(String str) => Parsers.withContext(this, str);
}

//
//
//
//
//
final class Parsers {
  Parsers._();

  static final Parser<String> anyChar = AnyChar();

  static Parser0<B> as0<B>(Parser0<dynamic> pa, B b) {
    switch (pa) {
      case final Parser<dynamic> p:
        return as(p, b);
      default:
        final voided = pa.voided;

        if (b == Unit()) {
          return voided as Parser0<B>;
        } else if (_alwaysSucceeds(voided)) {
          return pure(b);
        } else {
          return Map0(voided, (_) => b);
        }
    }
  }

  static Parser<B> as<B>(Parser<dynamic> pa, B b) {
    final v = pa.voided;

    // If b is (), such as foo.as(())
    // we can just return v
    if (b == Unit()) {
      return v as Parser<B>;
    } else {
      return switch (v) {
        // CharIn is common and cheap, no need to wrap with Void since CharIn
        // always returns the char even when voided.
        Void(:final parser) => switch (_singleChar(parser)) {
          final String c when b == c => parser as Parser<B>,
          _ => Map(parser, (_) => b),
        },
        final Fail<dynamic> f => f.widen(),
        final FailWith<dynamic> f => f.widen(),
        final voided => Map(voided, (_) => b),
      };
    }
  }

  static Parser0<A> backtrack0<A>(Parser0<A> pa) {
    return switch (pa) {
      final Parser<A> p1 => backtrack(p1),
      final pa when _doesBacktrack(pa) => pa,
      // flow analysis doesn't narrow A -> Unit
      final Void0<A> v0 => Void0(Backtrack0(v0.parser)) as Parser0<A>,
      final nbt => Backtrack0(nbt),
    };
  }

  static Parser<A> backtrack<A>(Parser<A> pa) {
    return switch (pa) {
      final pa when _doesBacktrack(pa) => pa,
      final Void<A> v => Void(Backtrack(v.parser)) as Parser<A>,
      final nbt => Backtrack(nbt),
    };
  }

  static Parser0<Caret> get caret => GetCaret();

  static Parser<Unit> char(String char) {
    final cidx = Char.fromString(char).codeUnit - 32;

    if (0 <= cidx && cidx < _charArray.length) {
      return _charArray[cidx];
    } else {
      return _charImpl(char);
    }
  }

  // Cache the common parsers to reduce allocations
  static final _charArray = Range.inclusive(
    32,
    126,
  ).map((idx) => _charImpl(String.fromCharCode(idx)));

  static Parser<Unit> _charImpl(String char) => charIn(ilist([char])).voided;

  static Parser<String> charIn(RIterableOnce<String> cs) {
    switch (cs) {
      default:
        final ary = cs.toList()..sort((a, b) => a.compareTo(b));

        final ranges = _rangesFor(ary);

        if (ranges.size == 1 && ranges.head.bounds == (Char.MinValue, Char.MaxValue)) {
          return anyChar;
        } else {
          return CharIn(BitSet.bitSetFor(ary), ranges);
        }
    }
  }

  static Parser<String> charInRange(String start, String end) {
    return CharIn.fromRanges(nel(CharsRange((Char.fromString(start), Char.fromString(end)))));
  }

  static Parser<String> charInString(String str) => charIn(str.split('').toIList());

  static Parser<String> charWhere(Function1<Char, bool> p) =>
      anyChar.filter((s) => p(Char.fromString(s)));

  /// Like [charsWhile] but succeeds with an empty string when nothing matches.
  static Parser0<String> charsWhile0(bool Function(Char) predicate) => CharsWhile0(predicate);

  /// Scans forward while [predicate] holds on successive characters, returning
  /// the matched substring.  Fails if no characters match.  Equivalent to
  /// `charIn(set).rep().string` but avoids per-character virtual dispatch.
  static Parser<String> charsWhile(bool Function(Char) predicate) => CharsWhile(predicate);

  static Parser0<A> defer0<A>(Function0<Parser0<A>> pa) => Defer0(pa);

  static Parser<A> defer<A>(Function0<Parser<A>> pa) => Defer(pa);

  static Parser0<Either<A, B>> eitherOr0<A, B>(
    Parser0<B> first,
    Parser0<A> second,
  ) => oneOf0(ilist([first.map((a) => Right(a)), second.map((b) => Left(b))]));

  static Parser<Either<A, B>> eitherOr<A, B>(
    Parser<B> first,
    Parser<A> second,
  ) => oneOf(ilist([first.map((a) => Right(a)), second.map((b) => Left(b))]));

  static final Parser0<String> emptyStringParser0 = Pure('');

  static Parser0<Unit> get end => EndParser();

  static Parser<A> fail<A>() => Fail();

  static Parser<A> failWith<A>(String message) => FailWith(message);

  static Parser0<B> flatMap0<A, B>(
    Parser0<A> pa,
    Function1<A, Parser0<B>> f,
  ) => switch (pa) {
    final Parser<A> p => flatMap10(p, f),
    _ => _hasKnownResult(pa).fold(
      () => FlatMap0(pa, f),
      (a) => pa.productR(f(a)),
    ),
  };

  static Parser<B> flatMap01<A, B>(
    Parser0<A> pa,
    Function1<A, Parser<B>> f,
  ) => switch (pa) {
    final Parser<A> p1 => flatMap10(p1, f),
    _ => _hasKnownResult(pa).fold(
      () => FlatMap(pa, f),
      (a) => pa.with1.productR(f(a)),
    ),
  };

  static Parser<B> flatMap10<A, B>(
    Parser<A> pa,
    Function1<A, Parser0<B>> f,
  ) => switch (pa) {
    final Fail<dynamic> f => f.widen(),
    final FailWith<dynamic> f => f.widen(),
    _ => _hasKnownResult(pa).fold(
      () => FlatMap(pa, f),
      (a) => pa.productR(f(a)),
    ),
  };

  static Parser<A> fromCharMap<A>(IMap<String, A> charMap) =>
      charIn(charMap.keys).map((key) => charMap[key]);

  static Parser0<A> fromStringMap0<A>(IMap<String, A> charMap) =>
      stringIn0(charMap.keys).map((key) => charMap[key]);

  static Parser<A> fromStringMap<A>(IMap<String, A> charMap) =>
      stringIn(charMap.keys).map((key) => charMap[key]);

  static Parser0<Unit> ignoreCase0(String str) => str.isEmpty ? unit : ignoreCase(str);

  static Parser<Unit> ignoreCase(String str) => IgnoreCase(str.toLowerCase());

  static Parser<String> ignoreCaseChar(String char) =>
      charIn([char.toLowerCase(), char.toUpperCase()].toIList());

  static Parser<String> ignoreCaseCharIn(RIterableOnce<String> chars) =>
      charIn(chars.flatMap((c) => ilist([c.toLowerCase(), c.toUpperCase()])));

  static Parser<String> ignoreCaseCharInRange(String start, String end) {
    final lowerStart = Char.fromString(start.toLowerCase());
    final lowerEnd = Char.fromString(end.toLowerCase());
    final upperStart = Char.fromString(start.toUpperCase());
    final upperEnd = Char.fromString(end.toUpperCase());

    if (lowerStart == upperStart && lowerEnd == upperEnd) {
      return charInRange(start, end);
    } else {
      return CharIn.fromRanges(
        NonEmptyIList(
          CharsRange((lowerStart, lowerEnd)),
          ilist([CharsRange((upperStart, upperEnd))]),
        ),
      );
    }
  }

  static Parser<String> ignoreCaseCharInString(String str) =>
      ignoreCaseCharIn(str.split('').toIList());

  static Parser0<int> get index => Index();

  static Parser0<String> length0(int len) => len > 0 ? length(len) : emptyStringParser0;

  static Parser<String> length(int len) => Length(len);

  static Parser0<B> map0<A, B>(Parser0<A> p, Function1<A, B> f) {
    return switch (p) {
      final Parser<A> p1 => map(p1, f),
      _ => _hasKnownResult(p).fold(
        () {
          return switch (p) {
            final Fail<dynamic> f => f.widen(),
            final FailWith<dynamic> f => f.widen(),
            Map0<dynamic, dynamic>() => (p as Map0<dynamic, A>).andThen(f),
            _ => Map0(p, f),
          };
        },
        (a) => p.as(f(a)),
      ),
    };
  }

  static Parser<B> map<A, B>(Parser<A> p, Function1<A, B> f) {
    return _hasKnownResult(p).fold(
      () {
        return switch (p) {
          final Fail<dynamic> f => f.widen(),
          final FailWith<dynamic> f => f.widen(),
          Map<dynamic, dynamic>() => (p as Map<dynamic, A>).andThen(f),
          _ => Map(p, f),
        };
      },
      (a) => p.as(f(a)),
    );
  }

  static Parser0<Unit> not(Parser0<dynamic> pa) {
    return switch (voided0(pa)) {
      final Fail<dynamic> _ || FailWith<dynamic> _ => unit,
      final u when _alwaysSucceeds(u) => Fail(),
      final notFail => Not(notFail),
    };
  }

  static Parser0<A> oneOf0<A>(IList<Parser0<A>> ps) {
    final res = _oneOf0Internal(ps);
    return _hasKnownResult(res).fold(() => res, (a) => res.as(a));
  }

  static Parser<A> oneOf<A>(IList<Parser<A>> ps) {
    final res = _oneOfInternal(ps);
    return _hasKnownResult(res).fold(() => res, (a) => res.as(a));
  }

  static Parser0<A> _oneOf0Internal<A>(IList<Parser0<A>> ps) {
    // Fast path: if all parsers are committing, delegate to _oneOfInternal.
    final allCommitting = ps.traverseOption<Parser<A>>(
      (Parser0<A> p) => switch (p) {
        final Parser<A> cp => Some(cp),
        _ => none<Parser<A>>(),
      },
    );
    if (allCommitting case Some(:final value)) {
      return _oneOfInternal(value);
    }

    // Dart lacks tail-call optimisation, so the Scala @tailrec loop is
    // converted to an explicit while loop.
    var remaining = ps.toList();
    final acc = <Parser0<A>>[];

    while (remaining.isNotEmpty) {
      if (remaining.length == 1) {
        acc.add(remaining[0]);
        remaining = <Parser0<A>>[];
      } else {
        final h1 = remaining[0];
        final h2 = remaining[1];
        final tail2 = remaining.sublist(2);
        final merged = _merge0(h1, h2);

        // merge0 signals "no merge" by returning OneOf0([h1, h2]) or
        // OneOf([h1, h2]) with the same object identities.
        final noMerge = switch (merged) {
          OneOf0<A>(:final all)
              when all.size == 2 && identical(all[0], h1) && identical(all[1], h2) =>
            true,
          OneOf<A>(:final all)
              when all.size == 2 && identical(all[0], h1) && identical(all[1], h2) =>
            true,
          _ => false,
        };

        if (noMerge) {
          acc.add(h1);
          remaining = remaining.sublist(1); // t1 = h2 :: tail2
        } else {
          remaining = [merged, ...tail2];
        }
      }
    }

    // Flatten acc, expanding nested OneOf0 and OneOf nodes.
    // Note: acc is built with List.add (append), so it is already in the correct
    // forward order. Do NOT reverse it — the Scala @tailrec version used prepend
    // (h1 :: acc) which builds in reverse, so Scala iterates acc in order to get
    // the reversed-then-iterated result. Dart's List.add avoids that reversal.
    final flat = <Parser0<A>>[];

    for (final p in acc) {
      switch (p) {
        case OneOf0<A>(:final all):
          flat.addAll(all.toList());
        case OneOf<A>(:final all):
          flat.addAll(all.toList());
        default:
          flat.add(p);
      }
    }

    return _cheapOneOf0(flat);
  }

  static Parser<A> _oneOfInternal<A>(IList<Parser<A>> ps) {
    // Dart lacks tail-call optimisation, so the Scala @tailrec loop is
    // converted to an explicit while loop.
    var remaining = ps.toList();
    final acc = <Parser<A>>[];

    while (remaining.isNotEmpty) {
      if (remaining.length == 1) {
        acc.add(remaining[0]);
        remaining = <Parser<A>>[];
      } else {
        final h1 = remaining[0];
        final h2 = remaining[1];
        final tail2 = remaining.sublist(2);
        final merged = _merge(h1, h2);

        // If merge returns OneOf([h1, h2]) with the same object identity it
        // signals "could not merge" — push h1 to acc and continue with t1.
        if (merged is OneOf<A> &&
            merged.all.size == 2 &&
            identical(merged.all[0], h1) &&
            identical(merged.all[1], h2)) {
          acc.add(h1);
          remaining = remaining.sublist(1); // t1 = h2 :: tail2
        } else {
          remaining = [merged, ...tail2];
        }
      }
    }

    // Flatten acc, expanding nested OneOf nodes.
    // Note: acc is built with List.add (append), so it is already in the correct
    // forward order. Do NOT reverse it — the Scala @tailrec version used prepend
    // (h1 :: acc) which builds in reverse, so Scala iterates acc in order to get
    // the reversed-then-iterated result. Dart's List.add avoids that reversal.
    final flat = <Parser<A>>[];
    for (final p in acc) {
      if (p is OneOf<A>) {
        flat.addAll(p.all.toList());
      } else {
        flat.add(p);
      }
    }

    if (flat.isEmpty) {
      return Fail();
    } else if (flat.length == 1) {
      return flat[0];
    } else {
      final many = IList.fromDart(flat);

      // If all parsers are StringP, lift the OneOf inside the StringP wrapper.
      final asStrings = many.traverseOption<Parser<dynamic>>(
        (Parser<A> p) => switch (p) {
          StringP<dynamic>(:final parser) => Some(parser),
          _ => none<Parser<dynamic>>(),
        },
      );

      return asStrings.fold(
        () {
          // If all parsers are Void, lift the OneOf inside the Void wrapper.
          final asVoided = many.traverseOption<Parser<dynamic>>(
            (Parser<A> p) => switch (p) {
              Void<dynamic>(:final parser) => Some(parser),
              _ => none<Parser<dynamic>>(),
            },
          );

          return asVoided.fold(
            () => OneOf(many),
            (voidParsers) => Void(OneOf(voidParsers)) as Parser<A>,
          );
        },
        (stringParsers) => StringP(OneOf(stringParsers)) as Parser<A>,
      );
    }
  }

  static Parser0<Unit> peek(Parser0<dynamic> pa) {
    return switch (pa) {
      final Peek peek => peek,
      final s when _alwaysSucceeds(s) => unit,
      final notPeek => Peek(voided0(notPeek)),
    };
  }

  static Parser0<(A, B)> product0<A, B>(
    Parser0<A> first,
    Parser0<B> second,
  ) => switch (first) {
    final Parser<A> f1 => product10(f1, second),
    Pure<A>(:final a) => map0(second, (b) => (a, b)),
    _ => switch (second) {
      final Parser<B> s1 => product01(first, s1),
      Pure<B>(a: final pureB) => map0(first, (x) => (x, pureB)),
      _ => Prod0(first, second),
    },
  };

  static Parser<(A, B)> product10<A, B>(
    Parser<A> first,
    Parser0<B> second,
  ) => switch (first) {
    final Fail<dynamic> f => f.widen(),
    final FailWith<dynamic> f => f.widen(),
    _ => switch (second) {
      Pure<B>(a: final pureB) => map(first, (x) => (x, pureB)),
      _ => Prod(first, second),
    },
  };

  static Parser<(A, B)> product01<A, B>(
    Parser0<A> first,
    Parser<B> second,
  ) => switch (first) {
    final Parser<A> p1 => product10(p1, second),
    Pure<A>(:final a) => map(second, (b) => (a, b)),
    _ => Prod(first, second),
  };

  static Parser0<A> pure<A>(A a) => Pure(a);

  static Parser<A> recursive<A>(Function1<Parser<A>, Parser<A>> f) {
    late Parser<A> result;
    // ignore: join_return_with_assignment
    result = f(defer(() => result));
    return result;
  }

  static Parser0<B> repAs0<A, B>(
    Parser<A> p1,
    Accumulator0<A, B> acc, {
    int? max,
  }) {
    if (max == null) {
      return OneOf0(
        ilist([
          Rep(p1, 1, Integer.maxValue, acc),
          pure(acc.newAppender().finish()),
        ]),
      );
    } else {
      assert(max >= 0, 'max should be >= 0, was $max');

      final empty = acc.newAppender().finish();

      if (max == 0) {
        return pure(empty);
      } else {
        // 0 or more items
        return OneOf0(
          ilist([
            Rep(p1, 1, max - 1, acc),
            pure(empty),
          ]),
        );
      }
    }
  }

  static Parser<B> repAs<A, B>(
    Parser<A> p1,
    Accumulator<A, B> acc,
    int min, {
    int? max,
  }) {
    if (max == null) {
      assert(min >= 1, 'min should be >= 1, was $min');
      return Rep(p1, min, Integer.maxValue, acc);
    } else if (min == max) {
      return repExactlyAs(p1, min, acc);
    } else {
      assert(max > min, 'max should be >= min, but $max < $min');
      return Rep(p1, min, max - 1, acc);
    }
  }

  static Parser<B> repExactlyAs<A, B>(
    Parser<A> p,
    int times,
    Accumulator<A, B> acc,
  ) {
    if (times == 1) {
      return p.map((a) => acc.newAppender(a).finish());
    } else {
      assert(times > 1, 'times should be >= 1, was $times');
      return Rep(p, times, times - 1, acc);
    }
  }

  static Parser0<IList<A>> repSep0<A>(
    Parser<A> p1,
    Parser0<dynamic> sep, {
    int min = 0,
    int? max,
  }) {
    if (max == null) {
      if (min == 0) {
        return repSep(p1, sep).opt.map(
          (nelOpt) => nelOpt.fold(
            () => nil(),
            (nel) => nel.toIList(),
          ),
        );
      } else {
        return repSep(p1, sep, min: min).map((nel) => nel.toIList());
      }
    } else {
      if (min == 0) {
        if (max == 0) {
          return pure(nil());
        } else {
          return repSep(p1, sep, max: max).opt.map(
            (nelOpt) => nelOpt.fold(
              () => nil(),
              (nel) => nel.toIList(),
            ),
          );
        }
      } else {
        return repSep(p1, sep, min: min, max: max).map((nel) => nel.toIList());
      }
    }
  }

  static Parser<NonEmptyIList<A>> repSep<A>(
    Parser<A> p1,
    Parser0<dynamic> sep, {
    int min = 1,
    int? max,
  }) {
    if (min < 0) throw ArgumentError('min must be > 0, found: $min');

    if (max == null && min == 1) {
      // Fast path: direct loop avoids the OneOf0+SoftProd+Void combinator chain.
      return RepSep(p1, sep);
    } else {
      if (max == null) {
        final rest = sep.voided.with1.soft.productR(p1).rep0(min: min - 1);
        return p1.product(rest).map((tup) => NonEmptyIList(tup.$1, tup.$2));
      } else {
        if (max < min) throw ArgumentError('max must be greater than min, found: $max < $min');

        if ((min == 1) && (max == 1)) {
          return p1.map((a) => nel(a));
        } else {
          final rest = sep.voided.with1.soft.productR(p1).rep0(min: min - 1, max: max - 1);
          return p1.product(rest).map((tup) => NonEmptyIList(tup.$1, tup.$2));
        }
      }
    }
  }

  static Parser0<IList<A>> repUntil0<A>(
    Parser<A> p,
    Parser0<dynamic> end,
  ) => not(end).with1.productR(p).rep0();

  static Parser<NonEmptyIList<A>> repUntil<A>(
    Parser<A> p,
    Parser0<dynamic> end,
  ) => not(end).with1.productR(p).rep();

  static Parser0<B> repUntilAs0<A, B>(
    Parser<A> p,
    Parser0<dynamic> end,
    Accumulator0<A, B> acc,
  ) => not(end).with1.productR(p).repAs0(acc);

  static Parser<B> repUntilAs<A, B>(
    Parser<A> p,
    Parser0<dynamic> end,
    Accumulator<A, B> acc,
  ) => not(end).with1.productR(p).repAs(acc);

  static Parser0<B> select0<A, B>(
    Parser0<Either<A, B>> p,
    Parser0<Function1<A, B>> fn,
  ) => _hasKnownResult(p).fold(
    () => Select0(p, fn).map(
      (either) => either.fold(
        (tup) => tup.$2(tup.$1),
        (b) => b,
      ),
    ),
    (either) => either.fold(
      (a) => p.productR(fn.map((f) => f(a))),
      (b) => p.as(b),
    ),
  );

  static Parser<B> select<A, B>(
    Parser<Either<A, B>> p,
    Parser0<Function1<A, B>> fn,
  ) => _hasKnownResult(p).fold(
    () => Select(p, fn).map(
      (either) => either.fold(
        (tup) => tup.$2(tup.$1),
        (b) => b,
      ),
    ),
    (either) => either.fold(
      (a) => p.productR(fn.map((f) => f(a))),
      (b) => p.as(b),
    ),
  );

  static Parser0<(A, B)> softProduct0<A, B>(
    Parser0<A> first,
    Parser0<B> second,
  ) => switch (first) {
    final Parser<A> f1 => softProduct10(f1, second),
    Pure<A>(:final a) => map0(second, (b) => (a, b)),
    _ => switch (second) {
      final Parser<B> s1 => softProduct01(first, s1),
      Pure<B>(a: final pureB) => map0(first, (x) => (x, pureB)),
      _ => SoftProd0(first, second),
    },
  };

  static Parser<(A, B)> softProduct10<A, B>(
    Parser<A> first,
    Parser0<B> second,
  ) => switch (first) {
    final Fail<dynamic> f => f.widen(),
    final FailWith<dynamic> f => f.widen(),
    _ => switch (second) {
      Pure<B>(a: final pureB) => map(first, (x) => (x, pureB)),
      _ => SoftProd(first, second),
    },
  };

  static Parser<(A, B)> softProduct01<A, B>(
    Parser0<A> first,
    Parser<B> second,
  ) => switch (first) {
    final Fail<dynamic> f => f.widen(),
    final FailWith<dynamic> f => f.widen(),
    Pure<A>(:final a) => map(second, (b) => (a, b)),
    _ => SoftProd(first, second),
  };

  static Parser0<Unit> get start => StartParser();

  static Parser0<Unit> string0(String str) => str.isEmpty ? unit : Str(str);

  static Parser<Unit> string(String str) => Str(str);

  static Parser0<String> stringP0(Parser0<dynamic> pa) {
    return switch (pa) {
      final Parser<dynamic> s1 => stringP(s1),
      final str when _matchesString(str) => str as Parser0<String>,
      _ => switch (_unmap0(pa)) {
        final Pure<dynamic> _ || Index _ || GetCaret _ => emptyStringParser0,
        final nonEmpty => StringP0(nonEmpty),
      },
    };
  }

  static Parser<String> stringP(Parser<dynamic> pa) {
    return switch (pa) {
      final str when _matchesString(str) => str as Parser<String>,
      _ => switch (_unmap(pa)) {
        final StringIn si => si,
        final Length len => len,
        final Str strP => strP.as(strP.message),
        final Fail<dynamic> f => f.widen(),
        final FailWith<dynamic> f => f.widen(),
        final notStr => StringP(notStr),
      },
    };
  }

  static Parser0<String> stringIn0(RIterable<String> strings) {
    if (strings.exists((s) => s.isEmpty)) {
      return Parsers.oneOf0(
        ilist([
          stringIn(strings.filter((str) => str.nonEmpty)),
          emptyStringParser0,
        ]),
      );
    } else {
      return stringIn(strings);
    }
  }

  static Parser<String> stringIn(RIterable<String> strings) {
    final distinct = strings.toIList().distinct();

    if (distinct.isEmpty) {
      return fail();
    } else if (distinct.size == 1) {
      return string(distinct[0]).string;
    } else {
      return StringIn(SplayTreeSet.from(distinct.toList(), (a, b) => a.compareTo(b)));
    }
  }

  static final Parser0<Unit> unit = pure(Unit());

  static Parser0<String> until0(Parser0<dynamic> p) => repUntil0(anyChar, p).string;

  static Parser<String> until(Parser0<dynamic> p) => repUntil(anyChar, p).string;

  static Parser0<Unit> voided0(Parser0<dynamic> pa) {
    switch (pa) {
      case final Parser<dynamic> p1:
        return voided(p1);
      case final Void0<dynamic> v:
        return v;
      default:
        if (_alwaysSucceeds(pa)) {
          return unit;
        } else {
          final unmapped = _unmap0(pa);

          if (_isVoided(unmapped)) {
            return unmapped as Parser0<Unit>;
          } else {
            return Void0(unmapped);
          }
        }
    }
  }

  static Parser<Unit> voided(Parser<dynamic> pa) {
    return switch (pa) {
      final Void<dynamic> v => v,
      _ => switch (_unmap(pa)) {
        final Fail<dynamic> f => f.widen(),
        final FailWith<dynamic> f => f.widen(),
        final notVoid when _isVoided(notVoid) => notVoid as Parser<Unit>,
        final notVoid => Void(notVoid),
      },
    };
  }

  static Parser0<A> withContext0<A>(Parser0<A> p0, String ctx) {
    return switch (p0) {
      final Void0<A> v0 => Void0(withContext0(v0.parser, ctx)) as Parser0<A>,
      _ when _alwaysSucceeds(p0) => p0,
      _ => WithContextP0(ctx, p0),
    };
  }

  static Parser<A> withContext<A>(Parser<A> p, String ctx) {
    return switch (p) {
      final Void<A> v => Void(withContext(v.parser, ctx)) as Parser<A>,
      _ => WithContextP(ctx, p),
    };
  }

  static Parser0<(A, String)> withString0<A>(Parser0<A> pa) {
    return switch (pa) {
      final Parser<A> p1 => withString(p1),
      _ when _alwaysSucceeds(pa) => map0(pa, (a) => (a, '')),
      _ when _matchesString(pa) =>
        (pa as Parser0<String>).map((s) => (s, s)) as Parser0<(A, String)>,
      final not1 => WithStringP0(not1),
    };
  }

  static Parser<(A, String)> withString<A>(Parser<A> pa) {
    return switch (pa) {
      final Fail<dynamic> f => f.widen(),
      final FailWith<dynamic> f => f.widen(),
      _ when _matchesString(pa) => (pa as Parser<String>).map((s) => (s, s)) as Parser<(A, String)>,
      final notFail => WithStringP(notFail),
    };
  }

  /// Returns the single character matched by [p] if it is a [CharIn] with
  /// exactly one range of width 1, otherwise null.
  /// Mirrors Scala cats-parse's `SingleChar` extractor object.
  static String? _singleChar(Parser<dynamic> p) {
    if (p is CharIn) {
      final head = p.ranges.head;
      if (p.ranges.tail.isEmpty && head.start == head.end) {
        return head.start.asString;
      }
    }
    return null;
  }

  // does this parser always succeed without consuming input
  // note: a parser1 does not always succeed
  // and by construction, a oneOf0 never always succeeds
  static bool _alwaysSucceeds(Parser0<dynamic> p) {
    return switch (p) {
      Index _ || GetCaret _ || Pure<dynamic> _ => true,
      Map0(:final parser) => _alwaysSucceeds(parser),
      SoftProd0(:final first, :final second) => _alwaysSucceeds(first) && _alwaysSucceeds(second),
      Prod0(:final first, :final second) => _alwaysSucceeds(first) && _alwaysSucceeds(second),
      WithContextP0(:final under) => _alwaysSucceeds(under),
      WithStringP0(:final parser) => _alwaysSucceeds(parser),
      _ => false,
    };
  }

  // does this parser always eventually succeed (maybe consuming input)
  // note, Parser1 has to consume, but may get an empty string, so can't
  // always succeed
  static bool _eventuallySucceeds(Parser0<dynamic> p) => switch (p) {
    Index() || GetCaret() || Pure<dynamic>() => true,
    Map0(:final parser) => _eventuallySucceeds(parser),
    SoftProd0(:final first, :final second) =>
      _eventuallySucceeds(first) && _eventuallySucceeds(second),
    Prod0(:final first, :final second) => _eventuallySucceeds(first) && _eventuallySucceeds(second),
    WithContextP0(:final under) => _eventuallySucceeds(under),
    OneOf0(:final all) => _eventuallySucceeds(all.last),
    _ => false,
  };

  static Parser0<A> _cheapOneOf0<A>(List<Parser0<A>> flat) {
    if (flat.isEmpty) return Fail();
    if (flat.length == 1) return flat[0];

    final many = IList.fromDart(flat);

    // If all are committing, promote to _oneOfInternal for its optimisations.
    final allCommitting = many.traverseOption<Parser<A>>(
      (Parser0<A> p) => switch (p) {
        final Parser<A> cp => Some(cp),
        _ => none<Parser<A>>(),
      },
    );

    return allCommitting.fold(
      () => OneOf0(many),
      (committingParsers) => _oneOfInternal(committingParsers),
    );
  }

  static bool _doesBacktrackCheat(Parser0<dynamic> p) => _doesBacktrack(p);

  static bool _doesBacktrack(Parser0<dynamic> p0) {
    var p = p0;
    while (true) {
      switch (p) {
        case Backtrack0<dynamic>() ||
            Backtrack<dynamic>() ||
            AnyChar() ||
            CharIn() ||
            Str() ||
            IgnoreCase() ||
            Length() ||
            StartParser() ||
            EndParser() ||
            Index() ||
            GetCaret() ||
            Pure<dynamic>() ||
            Fail<dynamic>() ||
            FailWith<dynamic>() ||
            Not() ||
            StringIn():
          return true;
        case Map0(:final parser):
          p = parser;
        case Map(:final parser):
          p = parser;
        case SoftProd0(:final first, :final second):
          return _doesBacktrackCheat(first) && _doesBacktrack(second);
        case SoftProd(:final first, :final second):
          return _doesBacktrackCheat(first) && _doesBacktrack(second);
        case WithContextP0(:final under):
          p = under;
        case WithContextP(:final under):
          p = under;
        case OneOf0(:final all):
          return all.forall((q) => _doesBacktrackCheat(q));
        case OneOf(:final all):
          return all.forall((q) => _doesBacktrackCheat(q));
        case Void0(:final parser):
          p = parser;
        case Void(:final parser):
          p = parser;
        default:
          return false;
      }
    }
  }

  static Option<A> _hasKnownResult<A>(Parser0<A> p) {
    return switch (p) {
      // Pure(a) => Some(a)
      Pure<A>(:final a) => Some(a),
      // SingleChar(c) => Some(c) — CharIn with a single one-char range
      final Parser<A> p1 when _singleChar(p1) != null => Some(_singleChar(p1)! as A),
      // Prod-like: known result iff both sides have a known result
      SoftProd0(:final first, :final second) ||
      Prod0(:final first, :final second) ||
      SoftProd(:final first, :final second) ||
      Prod(:final first, :final second) => _hasKnownResult<dynamic>(first).fold(
        () => none<A>(),
        (ra) => _hasKnownResult<dynamic>(second).fold(
          () => none<A>(),
          (rb) => Some((ra, rb) as A),
        ),
      ),
      // OneOf: known result if all parsers share the same known result
      OneOf0(:final all) => _hasKnownResultOfAll(all),
      OneOf(:final all) => _hasKnownResultOfAll(all),
      // Transparent wrappers — delegate to inner parser
      WithContextP0(:final under) => _hasKnownResult(under),
      WithContextP(:final under) => _hasKnownResult(under),
      Backtrack0(:final parser) => _hasKnownResult(parser),
      Backtrack(:final parser) => _hasKnownResult(parser),
      // These always produce Unit
      Not _ ||
      Peek _ ||
      Void0<dynamic> _ ||
      Void<dynamic> _ ||
      StartParser _ ||
      EndParser _ ||
      Str _ ||
      IgnoreCase _ => Some(Unit() as A),
      _ => none(),
    };
  }

  static Option<A> _hasKnownResultOfAll<A>(IList<Parser0<A>> all) {
    final ra = _hasKnownResult(all.head);

    return ra.fold(
      () => none<A>(),
      (a) {
        final allMatch = all.tail.forall(
          (q) => _hasKnownResult(q).fold(() => false, (b) => b == a),
        );

        return allMatch ? ra : none<A>();
      },
    );
  }

  static bool _isOneOf(Parser0<dynamic> p) => p is OneOf0<dynamic> || p is OneOf<dynamic>;

  static Parser0<A> _merge0<A>(Parser0<A> left, Parser0<A> right) {
    // case (l1: Parser[A], r1: Parser[A]) => merge(l1, r1)
    if (left is Parser<A> && right is Parser<A>) return _merge(left, right);

    // case (_, _) if eventuallySucceeds(left) => left
    if (_eventuallySucceeds(left)) return left;

    // case (Fail(), _) => right
    if (left is Fail<dynamic> || left is FailWith<dynamic>) return right;

    // case (_, Fail()) => left
    if (right is Fail<dynamic> || right is FailWith<dynamic>) return left;

    // case (OneOf0(_), OneOf(rs)) => merge0(left, OneOf0(rs))
    if (left is OneOf0<A> && right is OneOf<A>) {
      return _merge0(left, OneOf0(right.all));
    }

    // case (OneOf(ls), OneOf0(_)) => merge0(OneOf0(ls), right)
    if (left is OneOf<A> && right is OneOf0<A>) {
      return _merge0(OneOf0(left.all), right);
    }

    // case (OneOf0(ls), OneOf0(rights @ (h :: t))) =>
    if (left is OneOf0<A> && right is OneOf0<A>) {
      final ls = left.all;
      final rights = right.all;
      final rHead = rights.head;
      final twoOrMore = rights.tail; // non-empty: rights.size >= 2
      final innerMerged = _merge0(ls.last, rHead);

      if (_isOneOf(innerMerged)) {
        // No merge: concatenate
        return OneOf0(ls.appendedAll(rights));
      } else {
        final newLeft = OneOf0(ls.init.appended(innerMerged));
        if (twoOrMore.tail.isEmpty) {
          // t = rlast :: Nil
          return _merge0(newLeft, twoOrMore.head);
        } else {
          // t has 2+ elements
          return _merge0(newLeft, OneOf0(twoOrMore));
        }
      }
    }

    // case (left, OneOf0(rs @ (h :: t))) =>
    if (right is OneOf0<A>) {
      final rs = right.all;
      final rHead = rs.head;
      final rTail = rs.tail;
      final innerMerged = _merge0(left, rHead);

      if (_isOneOf(innerMerged)) {
        return OneOf0(rs.prepended(left));
      } else {
        return OneOf0(rTail.prepended(innerMerged));
      }
    }

    // case (left, OneOf(rs @ (h :: t))) =>
    if (right is OneOf<A>) {
      final rs = right.all;
      final IList<Parser0<A>> rsAsP0 = rs;
      final rHead = rs.head;
      final rTail = rs.tail;
      final innerMerged = _merge0(left, rHead);

      if (_isOneOf(innerMerged)) {
        return OneOf0(rsAsP0.prepended(left));
      } else if (innerMerged is Parser<A>) {
        return OneOf(rTail.prepended(innerMerged));
      } else {
        final IList<Parser0<A>> rTailAsP0 = rTail;
        return OneOf0(rTailAsP0.prepended(innerMerged));
      }
    }

    // case (OneOf0(ls), right) =>
    if (left is OneOf0<A>) {
      final ls = left.all;
      final innerMerged = _merge0(ls.last, right);
      if (_isOneOf(innerMerged)) {
        return OneOf0(ls.appended(right));
      } else {
        return OneOf0(ls.init.appended(innerMerged));
      }
    }

    // case (OneOf(ls), right) =>
    if (left is OneOf<A>) {
      final ls = left.all;
      final innerMerged = _merge0(ls.last, right);
      if (_isOneOf(innerMerged)) {
        final IList<Parser0<A>> lsAsP0 = ls;
        return OneOf0(lsAsP0.appended(right));
      } else if (innerMerged is Parser<A>) {
        return OneOf(ls.init.appended(innerMerged));
      } else {
        final IList<Parser0<A>> initAsP0 = ls.init;
        return OneOf0(initAsP0.appended(innerMerged));
      }
    }

    // case (Void0(vl), Void0(vr)) => merge0(vl, vr).void
    if (left is Void0<dynamic> && right is Void0<dynamic>) {
      return Parsers.voided0(
            _merge0<dynamic>(
              (left as Void0<dynamic>).parser,
              (right as Void0<dynamic>).parser,
            ),
          )
          as Parser0<A>;
    }

    // case (Void0(vl), right) if isVoided(right)
    if (left is Void0<dynamic> && _isVoided(right)) {
      return Parsers.voided0(
            _merge0<dynamic>((left as Void0<dynamic>).parser, right),
          )
          as Parser0<A>;
    }

    // case (Void(vl), right) if isVoided(right)
    if (left is Void<dynamic> && _isVoided(right)) {
      return Parsers.voided0(
            _merge0<dynamic>((left as Void<dynamic>).parser, right),
          )
          as Parser0<A>;
    }

    // case (left, Void0(vr)) if isVoided(left)
    if (_isVoided(left) && right is Void0<dynamic>) {
      return Parsers.voided0(
            _merge0<dynamic>(left, (right as Void0<dynamic>).parser),
          )
          as Parser0<A>;
    }

    // case (left, Void(vr)) if isVoided(left)
    if (_isVoided(left) && right is Void<dynamic>) {
      return Parsers.voided0(
            _merge0<dynamic>(left, (right as Void<dynamic>).parser),
          )
          as Parser0<A>;
    }

    // catch-all: OneOf0(left :: right :: Nil)
    return OneOf0(ilist([left, right]));
  }

  static Parser<A> _merge<A>(Parser<A> h1, Parser<A> h2) {
    // case (Fail(), _) => right
    if (h1 is Fail<dynamic> || h1 is FailWith<dynamic>) return h2;

    // case (_, Fail()) => left
    if (h2 is Fail<dynamic> || h2 is FailWith<dynamic>) return h1;

    // case (OneOf(ls), OneOf(rights @ (h :: t))) =>
    if (h1 is OneOf<A> && h2 is OneOf<A>) {
      final ls = h1.all;
      final rights = h2.all;
      final rHead = rights.head;
      final rTail = rights.tail; // non-empty: rights.size >= 2
      final innerMerged = _merge(ls.last, rHead);
      if (_isOneOf(innerMerged)) {
        return OneOf(ls.appendedAll(rights));
      }
      final newLeft = OneOf(ls.init.appended(innerMerged));
      if (rTail.tail.isEmpty) {
        return _merge(newLeft, rTail.head);
      } else {
        return _merge(newLeft, OneOf(rTail));
      }
    }

    // case (left, OneOf(rs @ (h :: t))) =>
    if (h2 is OneOf<A>) {
      final rs = h2.all;
      final rHead = rs.head;
      final rTail = rs.tail;
      final innerMerged = _merge(h1, rHead);
      if (_isOneOf(innerMerged)) {
        return OneOf(rs.prepended(h1));
      }
      if (rTail.tail.nonEmpty) {
        return _merge(innerMerged, OneOf(rTail));
      } else {
        return _merge(innerMerged, rTail.head);
      }
    }

    // case (OneOf(ls), right) =>
    if (h1 is OneOf<A>) {
      final ls = h1.all;
      final innerMerged = _merge(ls.last, h2);
      if (_isOneOf(innerMerged)) {
        return OneOf(ls.appended(h2));
      }
      final li = ls.init;
      if (li.tail.nonEmpty) {
        return _merge(OneOf(li), innerMerged);
      } else {
        return _merge(li.head, innerMerged);
      }
    }

    // case (CharIn(_, _, _), AnyChar) => AnyChar
    if (h1 is CharIn && h2 is AnyChar) return h2;

    // case (AnyChar, CharIn(_, _, _) | Str(_) | StringIn(_)) => AnyChar
    if (h1 is AnyChar && (h2 is CharIn || h2 is Str || h2 is StringIn)) return h1;

    // case (CharIn(m1, b1, _), CharIn(m2, b2, _)) =>
    //   Parser.charIn(BitSetUtil.union((m1, b1) :: (m2, b2) :: Nil))
    if (h1 is CharIn && h2 is CharIn) {
      final allChars = _charsFromRanges(
        (h1 as CharIn).ranges,
      ).concat(_charsFromRanges((h2 as CharIn).ranges));

      return Parsers.charIn(allChars) as Parser<A>;
    }

    // case (Void(vl), Void(vr)) => merge(vl, vr).void
    if (h1 is Void<dynamic> && h2 is Void<dynamic>) {
      return Parsers.voided(
            _merge<dynamic>(
              (h1 as Void<dynamic>).parser,
              (h2 as Void<dynamic>).parser,
            ),
          )
          as Parser<A>;
    }

    // case (StringP(l1), StringP(r1)) => merge(l1, r1).string
    if (h1 is StringP<dynamic> && h2 is StringP<dynamic>) {
      return Parsers.stringP(
            _merge<dynamic>(
              (h1 as StringP<dynamic>).parser,
              (h2 as StringP<dynamic>).parser,
            ),
          )
          as Parser<A>;
    }

    // case (Void(vl), right) if isVoided(right) =>
    if (h1 is Void<dynamic> && _isVoided(h2)) {
      return Parsers.voided(_merge<dynamic>((h1 as Void<dynamic>).parser, h2)) as Parser<A>;
    }

    // case (left, Void(vr)) if isVoided(left) =>
    if (_isVoided(h1) && h2 is Void<dynamic>) {
      return Parsers.voided(_merge<dynamic>(h1, (h2 as Void<dynamic>).parser)) as Parser<A>;
    }

    // catch-all: OneOf([h1, h2]) signals "no merge" to _oneOfInternal
    return OneOf(ilist<Parser<A>>([h1, h2]));
  }

  static IList<String> _charsFromRanges(NonEmptyIList<CharsRange> ranges) {
    final bldr = IList.builder<String>();
    var aux = ranges.toIList();

    while (aux.nonEmpty) {
      final range = aux.head;

      for (var c = range.start; c <= range.end; c = c + 1) {
        bldr.addOne(c.asString);
      }

      aux = aux.tail;
    }

    return bldr.toIList();
  }

  static NonEmptyIList<CharsRange> _rangesFor(List<String> charArray) {
    var start = Char.fromString(charArray[0]);
    var end = start;
    var acc = nil<CharsRange>();

    for (var i = 1; i < charArray.length; i++) {
      final c = Char.fromString(charArray[i]);

      if (c == end + 1 || c == end) {
        end = c;
      } else {
        acc = acc.prepended(CharsRange((start, end)));
        start = c;
        end = c;
      }
    }

    return NonEmptyIList.unsafe(acc.prepended(CharsRange((start, end))).reverse());
  }

  // does this parser return the string it matches
  static bool _matchesString(Parser0<dynamic> p) => switch (p) {
    StringP0<dynamic>() ||
    StringP<dynamic>() ||
    StringIn() ||
    Length() ||
    Fail<dynamic>() ||
    FailWith<dynamic>() => true,
    OneOf(:final all) => all.forall(_matchesString),
    OneOf0(:final all) => all.forall(_matchesString),
    WithContextP(:final under) => _matchesString(under),
    WithContextP0(:final under) => _matchesString(under),
    _ => false,
  };

  // This removes any trailing map functions which can cause wasted allocations if we are later
  // going to void or return strings. This stops at StringP or VoidP since those are markers that
  // anything below has already been transformed
  static Parser0<dynamic> _unmap0(Parser0<dynamic> pa) {
    // case p1: Parser[Any] => unmap(p1)
    if (pa is Parser<dynamic>) return _unmap(pa);

    // case GetCaret | Index | Pure(_) => Parser.unit
    if (pa is GetCaret || pa is Index || pa is Pure<dynamic>) return Parsers.unit;

    // case s if alwaysSucceeds(s) => Parser.unit
    if (_alwaysSucceeds(pa)) return Parsers.unit;

    // case Map0(p, _) => unmap0(p)
    if (pa is Map0<dynamic, dynamic>) return _unmap0(pa.parser);

    // case Select0(p, fn) => Select0(p, unmap0(fn))
    if (pa is Select0<dynamic, dynamic, dynamic>) {
      return Select0<dynamic, dynamic, dynamic>(pa.pab, _unmap0(pa.pc));
    }

    // case StringP0(s) => s
    if (pa is StringP0<dynamic>) return pa.parser;

    // case WithStringP0(s) => unmap0(s)
    if (pa is WithStringP0<dynamic>) return _unmap0(pa.parser);

    // case Void0(v) => v
    if (pa is Void0<dynamic>) return pa.parser;

    // case n @ Not(_) => n (already voided)
    if (pa is Not) return pa;

    // case p @ Peek(_) => p (already voided)
    if (pa is Peek) return pa;

    // case Backtrack0(p) => Parser.backtrack0(unmap0(p))
    if (pa is Backtrack0<dynamic>) return Parsers.backtrack0(_unmap0(pa.parser));

    // case OneOf0(ps) =>
    //   val next = oneOf0Internal(ps.map(unmap0))
    //   if (next == pa) pa else unmap0(next)
    if (pa is OneOf0<dynamic>) {
      final unmappedAll = pa.all.map((Parser0<dynamic> p) => _unmap0(p));
      final anyChanged = unmappedAll.zip(pa.all).exists((t) => !identical(t.$1, t.$2));
      if (!anyChanged) return pa;
      final next = _oneOf0Internal<dynamic>(unmappedAll);
      if (next is OneOf0<dynamic> || next is OneOf<dynamic>) return next;
      return _unmap0(next);
    }

    // case Prod0(p1, p2) =>
    //   unmap0(p1) match {
    //     case Prod0(p11, p12) => Prod0(p11, unmap0(Prod0(Void0(p12), p2)))
    //     case u1 if u1 eq Parser.unit => unmap0(p2)
    //     case u1 =>
    //       val u2 = unmap0(p2)
    //       if (u2 eq Parser.unit) u1 else Prod0(u1, u2)
    //   }
    if (pa is Prod0<dynamic, dynamic>) {
      final u1 = _unmap0(pa.first);

      if (u1 is Prod0<dynamic, dynamic>) {
        return Prod0<dynamic, dynamic>(
          u1.first,
          _unmap0(Prod0<dynamic, dynamic>(Void0(u1.second), pa.second)),
        );
      } else if (identical(u1, Parsers.unit)) {
        return _unmap0(pa.second);
      } else {
        final u2 = _unmap0(pa.second);
        if (identical(u2, Parsers.unit)) {
          return u1;
        }
        // If either component is a Parser, the product consumes ≥1 char → upgrade to Prod.
        else if (u1 is Parser<dynamic> || u2 is Parser<dynamic>) {
          return Prod<dynamic, dynamic>(u1, u2);
        } else {
          return Prod0<dynamic, dynamic>(u1, u2);
        }
      }
    }

    // case SoftProd0(p1, p2) =>
    //   unmap0(p1) match {
    //     case SoftProd0(p11, p12) => SoftProd0(p11, unmap0(SoftProd0(Void0(p12), p2)))
    //     case u1 if u1 eq Parser.unit => unmap0(p2)
    //     case u1 =>
    //       val u2 = unmap0(p2)
    //       if (u2 eq Parser.unit) u1 else SoftProd0(u1, u2)
    //   }
    if (pa is SoftProd0<dynamic, dynamic>) {
      final u1 = _unmap0(pa.first);

      if (u1 is SoftProd0<dynamic, dynamic>) {
        return SoftProd0<dynamic, dynamic>(
          u1.first,
          _unmap0(SoftProd0<dynamic, dynamic>(Void0(u1.second), pa.second)),
        );
      } else if (identical(u1, Parsers.unit)) {
        return _unmap0(pa.second);
      } else {
        final u2 = _unmap0(pa.second);
        if (identical(u2, Parsers.unit)) {
          return u1;
        }
        // If either component is a Parser, the product consumes ≥1 char → upgrade to SoftProd.
        else if (u1 is Parser<dynamic> || u2 is Parser<dynamic>) {
          return SoftProd<dynamic, dynamic>(u1, u2);
        } else {
          return SoftProd0<dynamic, dynamic>(u1, u2);
        }
      }
    }

    // Note: UnmapDefer0 doesn't exist in this Dart port; skip transformation.
    // case Defer0(fn) => Defer0(UnmapDefer0(fn))

    // case WithContextP0(ctx, p0) => WithContextP0(ctx, unmap0(p0))
    if (pa is WithContextP0<dynamic>) {
      return WithContextP0<dynamic>(pa.context, _unmap0(pa.under));
    }

    // case StartParser | EndParser | TailRecM0 | FlatMap0 | Defer0 => pa
    return pa;
  }

  // This removes any trailing map functions which can cause wasted allocations if we are later
  // going to void or return strings. This stops at StringP or VoidP since those are markers that
  // anything below has already been transformed
  static Parser<dynamic> _unmap(Parser<dynamic> pa) {
    // case Map(p, _) => unmap(p)
    if (pa is Map<dynamic, dynamic>) return _unmap(pa.parser as Parser<dynamic>);

    // case Select(p, fn) => Select(p, unmap0(fn))
    if (pa is Select<dynamic, dynamic, dynamic>) {
      return Select<dynamic, dynamic, dynamic>(pa.pab, _unmap0(pa.pc));
    }

    // case StringP(s) => s
    if (pa is StringP<dynamic>) return pa.parser;

    // case WithStringP(s) => unmap(s)
    if (pa is WithStringP<dynamic>) return _unmap(pa.parser);

    // case Void(v) => v
    if (pa is Void<dynamic>) return pa.parser;

    // case Backtrack(p) => Parser.backtrack(unmap(p))
    if (pa is Backtrack<dynamic>) return Parsers.backtrack(_unmap(pa.parser));

    // case OneOf(ps) =>
    //   val next = oneOfInternal(ps.map(unmap))
    //   if (next == pa) pa else unmap(next)
    //
    // Dart uses identity checks instead of structural equality.
    // If no element changed after unmapping, return pa unchanged.
    // If _oneOfInternal returns a OneOf, its elements are already unmapped
    // so we return it directly to avoid infinite recursion.
    if (pa is OneOf<dynamic>) {
      final unmappedAll = pa.all.map((Parser<dynamic> p) => _unmap(p));
      final anyChanged = unmappedAll.zip(pa.all).exists((t) => !identical(t.$1, t.$2));
      if (!anyChanged) return pa;
      final next = _oneOfInternal<dynamic>(unmappedAll);
      if (next is OneOf<dynamic>) return next;
      return _unmap(next);
    }

    // case Prod(p1, p2) =>
    //   unmap0(p1) match {
    //     case Prod0(p11, p12) => Prod(p11, unmap0(Parser.product0(p12.void, p2)))
    //     case Prod(p11, p12)  => Prod(p11, unmap0(Parser.product0(p12.void, p2)))
    //     case u1 if u1 eq Parser.unit => unmap(expect1(p2))
    //     case u1 =>
    //       val u2 = unmap0(p2)
    //       if (u2 eq Parser.unit) expect1(u1) else Prod(u1, u2)
    //   }
    if (pa is Prod<dynamic, dynamic>) {
      final u1 = _unmap0(pa.first);

      if (u1 is Prod0<dynamic, dynamic>) {
        return Prod<dynamic, dynamic>(
          u1.first,
          _unmap0(Parsers.product0(Void0(u1.second), pa.second)),
        );
      } else if (u1 is Prod<dynamic, dynamic>) {
        return Prod<dynamic, dynamic>(
          u1.first,
          _unmap0(Parsers.product0(Void0(u1.second), pa.second)),
        );
      } else if (identical(u1, Parsers.unit)) {
        // u1 is unit so pa.second must be a Parser
        return _unmap(pa.second as Parser<dynamic>);
      } else {
        final u2 = _unmap0(pa.second);

        if (identical(u2, Parsers.unit)) {
          return u1 as Parser<dynamic>;
        } else {
          return Prod<dynamic, dynamic>(u1, u2);
        }
      }
    }

    // case SoftProd(p1, p2) =>
    //   unmap0(p1) match {
    //     case SoftProd0(p11, p12) => SoftProd(p11, unmap0(Parser.softProduct0(p12.void, p2)))
    //     case SoftProd(p11, p12)  => SoftProd(p11, unmap0(Parser.softProduct0(p12.void, p2)))
    //     case u1 if u1 eq Parser.unit => unmap(expect1(p2))
    //     case u1 =>
    //       val u2 = unmap0(p2)
    //       if (u2 eq Parser.unit) expect1(u1) else SoftProd(u1, u2)
    //   }
    if (pa is SoftProd<dynamic, dynamic>) {
      final u1 = _unmap0(pa.first);

      if (u1 is SoftProd0<dynamic, dynamic>) {
        return SoftProd<dynamic, dynamic>(
          u1.first,
          _unmap0(Parsers.softProduct0(Void0(u1.second), pa.second)),
        );
      } else if (u1 is SoftProd<dynamic, dynamic>) {
        return SoftProd<dynamic, dynamic>(
          u1.first,
          _unmap0(Parsers.softProduct0(Void0(u1.second), pa.second)),
        );
      } else if (identical(u1, Parsers.unit)) {
        // u1 is unit so pa.second must be a Parser
        return _unmap(pa.second as Parser<dynamic>);
      } else {
        final u2 = _unmap0(pa.second);

        if (identical(u2, Parsers.unit)) {
          return u1 as Parser<dynamic>;
        } else {
          return SoftProd<dynamic, dynamic>(u1, u2);
        }
      }
    }

    // case Defer(fn) =>
    //   fn match {
    //     case UnmapDefer(_) => pa // already unmapped
    //     case _ => Defer(UnmapDefer(fn))
    //   }
    // Note: No UnmapDefer in Dart port; skip lazy unmap for Defer.
    if (pa is Defer<dynamic>) return pa;

    // case Rep(p, min, max, _) => Rep(unmap(p), min, max, Accumulator0.unitAccumulator0)
    // Guard: if the inner parser is already unchanged and the accumulator is
    // already the unit accumulator, return pa as-is to avoid creating a new
    // object that would break identity-based termination checks in OneOf.
    if (pa is Rep<dynamic, dynamic>) {
      final unmappedP1 = _unmap(pa.p1);
      if (identical(unmappedP1, pa.p1) && identical(pa.acc, Accumulator.unit)) {
        return pa;
      } else {
        return Rep<dynamic, Unit>(unmappedP1, pa.min, pa.maxMinusOne, Accumulator.unit);
      }
    }

    // case WithContextP(ctx, p) => WithContextP(ctx, unmap(p))
    if (pa is WithContextP<dynamic>) {
      return WithContextP<dynamic>(pa.context, _unmap(pa.under));
    }

    // case AnyChar | CharIn | Str | StringIn | IgnoreCase | Fail | FailWith | Length | TailRecM | FlatMap => pa
    return pa;
  }

  static bool _isVoided(Parser0<dynamic> p) => switch (p) {
    final Pure<dynamic> p => p.a == Unit(),
    OneOf0(:final all) => all.forall(_isVoided),
    OneOf(:final all) => all.forall(_isVoided),
    WithContextP0(:final under) => _isVoided(under),
    WithContextP(:final under) => _isVoided(under),
    Backtrack0(:final parser) => _isVoided(parser),
    Backtrack(:final parser) => _isVoided(parser),
    StartParser() ||
    EndParser() ||
    Void0<dynamic>() ||
    Void<dynamic>() ||
    IgnoreCase() ||
    Str() ||
    Fail<dynamic>() ||
    FailWith<dynamic>() ||
    Not() ||
    Peek() => true,
    _ => false,
  };
}

extension type With1<A>(Parser0<A> parser) {
  Parser<A> between(Parser<dynamic> b, Parser<dynamic> c) =>
      b.voided.product(parser.product(c.voided)).map((tup) => tup.$2.$1);

  Parser<B> flatMap<B>(Function1<A, Parser<B>> f) => Parsers.flatMap01(parser, f);

  Parser<(A, B)> product<B>(Parser<B> that) => Parsers.product01(parser, that);

  Parser<A> productL<B>(Parser<B> that) =>
      Parsers.product01(parser, Parsers.voided(that)).map((t) => t.$1);

  Parser<B> productR<B>(Parser<B> that) =>
      Parsers.product01(Parsers.voided0(parser), that).map((t) => t.$2);

  Soft01<A> get soft => Soft01(parser);

  Parser<A> surroundedBy(Parser<dynamic> that) => between(that, that);
}

final class Soft0<A> {
  final Parser0<A> parser;

  const Soft0(this.parser);

  Parser0<A> between(Parser0<dynamic> b, Parser0<dynamic> c) =>
      b.voided.soft.product(parser.soft.product(c.voided)).map((t) => t.$2.$1);

  Parser0<(A, B)> product<B>(Parser0<B> that) => Parsers.softProduct0(parser, that);

  Parser0<A> productL<B>(Parser0<B> that) =>
      Parsers.softProduct0(parser, Parsers.voided0(that)).map((t) => t.$1);

  Parser0<B> productR<B>(Parser0<B> that) =>
      Parsers.softProduct0(Parsers.voided0(parser), that).map((t) => t.$2);

  Parser0<A> surroundedBy(Parser0<dynamic> that) => between(that, that);

  Soft01<A> get with1 => Soft01(parser);
}

final class Soft<A> extends Soft0<A> {
  final Parser<A> parser1; // better way to do this?

  const Soft(this.parser1) : super(parser1);

  @override
  Parser<(A, B)> product<B>(Parser0<B> that) => Parsers.softProduct10(parser1, that);

  @override
  Parser<B> productR<B>(Parser0<B> that) =>
      Parsers.softProduct10(Parsers.voided(parser1), that).map((t) => t.$2);

  @override
  Parser<A> productL<B>(Parser0<B> that) =>
      Parsers.softProduct10(parser1, Parsers.voided0(that)).map((t) => t.$1);

  @override
  Parser<A> between(Parser0<dynamic> b, Parser0<dynamic> c) =>
      b.voided.with1.soft.product(parser1.soft.product(c.voided)).map((t) => t.$2.$1);

  @override
  Parser<A> surroundedBy(Parser0<dynamic> that) => between(that, that);
}

extension type Soft01<A>(Parser0<A> parser) {
  Parser<(A, B)> product<B>(Parser<B> that) => Parsers.softProduct01(parser, that);

  Parser<B> productR<B>(Parser<B> that) =>
      Parsers.softProduct01(Parsers.voided0(parser), that).map((t) => t.$2);

  Parser<A> productL<B>(Parser<B> that) =>
      Parsers.softProduct01(parser, Parsers.voided(that)).map((t) => t.$1);

  Parser<A> between(Parser<dynamic> b, Parser<dynamic> c) =>
      b.voided.product(parser.soft.product(c.voided)).map((t) => t.$2.$1);

  Parser<A> surroundedBy(Parser<dynamic> b) => between(b, b);
}
