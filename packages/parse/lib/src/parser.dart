import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/ribs_parse.dart';

final class ParserError {
  final Option<String> input;
  final int failedAtOffset;
  final NonEmptyIList<Expectation> expected;

  const ParserError(this.input, this.failedAtOffset, this.expected);

  @override
  String toString() {
    final msg = _stripMargin('''
        expectation${expected.size > 1 ? 's' : ''}:
        ${expected.map((e) => '* $e').mkString(sep: '\n')}''');
    // TODO: port cats-parse to make this better, include locationmap...

    return msg;
  }

  String _stripMargin(String s) {
    return s
        .splitMapJoin(
          RegExp('^', multiLine: true),
          onMatch: (_) => '\n',
          onNonMatch: (n) => n.trim(),
        )
        .trim();
  }
}

final class _ParserState {
  final String str;

  _ParserState(this.str);

  int offset = 0;
  Function0<IList<Expectation>>? error;
  bool capture = true;
  late LocationMap locationMap = LocationMap(str);
}

sealed class Parser0<A> {
  Either<ParserError, (String, A)> parse(String str) {
    final state = _ParserState(str);
    final result = _parseMut(state);
    final err = state.error;
    final offset = state.offset;

    if (err == null) {
      return Right((str.substring(offset), result));
    } else {
      return Left(
        ParserError(
          Some(str),
          offset,
          Expectation.unify(NonEmptyIList.fromIterableUnsafe(err().toList())),
        ),
      );
    }
  }

  Either<ParserError, A> parseAll(String str) {
    final state = _ParserState(str);
    final result = _parseMut(state);
    final err = state.error;
    final offset = state.offset;

    if (err == null) {
      if (offset == str.length) {
        return Right(result);
      } else {
        return Left(
          ParserError(
            Some(str),
            offset,
            NonEmptyIList.one(Expectation.endOfString(offset, str.length)),
          ),
        );
      }
    } else {
      return Left(
        ParserError(
          Some(str),
          offset,
          Expectation.unify(NonEmptyIList.fromIterableUnsafe(err().toList())),
        ),
      );
    }
  }

  Parser0<B> as<B>(B b) => Parsers.as0(this, b);

  Parser0<B> map<B>(Function1<A, B> f) => Parsers.map0(this, f);

  Parser0<Option<A>> opt() => Parsers.oneOf0(
      ilist([Parsers.map0(this, (x) => Option(x))]).concat(Parsers.optTail));

  Parser0<Unit> voided() => Parsers.voided0(this);

  A _parseMut(_ParserState state);
}

sealed class Parser<A> extends Parser0<A> {
  static final Parser<String> anyChar = _Impl.anyChar;
  static Parser<String> charIn(Iterable<String> cs) => _Impl.charIn(cs);

  @override
  Parser<B> as<B>(B b) => Parsers.as(this, b);

  @override
  Parser<Unit> voided() => Parsers.voided(this);
}

final class Parsers {
  static Parser0<B> as0<B>(Parser0<dynamic> pa, B b) {
    if (pa is Parser) {
      return as(pa, b);
    } else {
      final voided = pa.voided();

      if (_Impl.isUnit(b)) {
        return voided as Parser0<B>;
      } else if (_Impl.alwaysSucceeds(voided)) {
        return pure(b);
      } else {
        return _Impl.map0(voided, (_) => b);
      }
    }
  }

  static Parser<B> as<B>(Parser<dynamic> pa, B b) {
    final v = pa.voided();

    if (_Impl.isUnit(b)) {
      return v as Parser<B>;
    } else {
      return switch (v) {
        _ => _Map(v, (_) => b),
      };
    }
  }

  static Parser0<B> map0<A, B>(Parser0<A> p, Function1<A, B> fn) {
    if (p is Parser<A>) {
      return map(p, fn);
    } else {
      return _Impl.hasKnownResult(p).fold(
        () => switch (p) {
          _Map0(parser: final p0, fn: final fn0) => _Map0(p0, fn0.andThen(fn)),
          _ => _Map0(p, fn),
        },
        (a) => p.as(fn(a)),
      );
    }
  }

  static Parser<B> map<A, B>(Parser<A> p, Function1<A, B> fn) =>
      _Impl.hasKnownResult(p).fold(
        () {
          throw UnimplementedError();
        },
        (a) => p.as(fn(a)),
      );

  static Parser0<A> oneOf0<A>(IList<Parser0<A>> ps) {
    final res = _Impl.oneOf0Internal(ps);
    return _Impl.hasKnownResult(res).fold(() => res, (a) => res.as(a));
  }

  static final IList<Parser0<Option<Never>>> optTail =
      ilist([Parsers.pure(const None())]);

  static Parser0<A> pure<A>(A a) => _Impl.pure(a);

  static Parser0<Unit> voided0(Parser0<dynamic> pa) => switch (pa) {
        _ => throw UnimplementedError('Parsers.voided0'),
      };

  static Parser<Unit> voided(Parser<dynamic> pa) => switch (pa) {
        _ => throw UnimplementedError('Parsers.voided'),
      };
}

final class _Impl {
  static bool alwaysSucceeds(Parser0<dynamic> p) => switch (p) {
        _Pure<dynamic> _ => true,
        _ => throw UnimplementedError('_Impl.alwaysSucceeds'),
      };

  static final Parser<String> anyChar = _GenParser((state) {
    final offset = state.offset;

    if (offset < state.str.length) {
      final char = state.str[offset];
      state.offset += 1;
      return char;
    } else {
      state.error = () => ilist([
            Expectation.inRange(
              offset,
              String.fromCharCode(0),
              String.fromCharCode(65535),
            )
          ]);
      return String.fromCharCode(0);
    }
  });

  static Parser<String> charIn(Iterable<String> cs) {
    throw UnimplementedError('_Impl.charIn');
  }

  static Option<A> hasKnownResult<A>(Parser0<A> p) => switch (p) {
        _Pure(result: final r) => Some(r),
        _ => throw UnimplementedError('_Impl.hasKnownResult: $p'),
      };

  static bool isUnit(dynamic a) => a == Unit();

  static bool isVoided(Parser0<dynamic> p) => switch (p) {
        _Pure(result: final r) => isUnit(r),
        _ => throw UnimplementedError('_Impl.isVoided: $p'),
      };

  static Parser0<B> map0<A, B>(Parser0<A> pa, Function1<A, B> fn) =>
      _Map0(pa, fn);

  static B map<A, B>(
    Parser0<A> parser,
    Function1<A, B> fn,
    _ParserState state,
  ) {
    final a = parser._parseMut(state);

    if (state.error == null && state.capture) {
      return fn(a);
    } else {
      return null as B;
    }
  }

  static Parser<A> oneOfInternal<A>(IList<Parser<A>> ps) {
    throw UnimplementedError('_Impl.oneOfInternal');
  }

  static Parser0<A> oneOf0Internal<A>(IList<Parser0<A>> ps) {
    if (ps.forall((a) => a is Parser)) {
      return oneOfInternal(ps as IList<Parser<A>>);
    } else {
      // TODO: tailrec
      Parser0<A> loop(IList<Parser0<A>> ps, IList<Parser0<A>> acc) {
        if (ps.isEmpty) {
        } else if (ps.size == 1) {
        } else {}

        throw UnimplementedError();
      }

      return loop(ps, nil());
    }
  }

  static Parser0<A> pure<A>(A a) => _Pure(a);

  static Unit voided(Parser0<dynamic> pa, _ParserState state) {
    final s0 = state.capture;
    state.capture = false;
    pa._parseMut(state);
    state.capture = s0;

    return Unit();
  }
}

final class _Map0<A, B> extends Parser0<B> {
  final Parser0<A> parser;
  final Function1<A, B> fn;

  _Map0(this.parser, this.fn);

  @override
  B _parseMut(_ParserState state) => _Impl.map(parser, fn, state);
}

final class _Map<A, B> extends Parser<B> {
  final Parser<A> parser;
  final Function1<A, B> fn;

  _Map(this.parser, this.fn);

  @override
  B _parseMut(_ParserState state) => _Impl.map(parser, fn, state);
}

final class _Pure<A> extends Parser0<A> {
  final A result;

  _Pure(this.result);

  @override
  A _parseMut(_ParserState state) => result;
}

final class _Void0<A> extends Parser0<Unit> {
  final Parser0<A> parser;

  _Void0(this.parser);

  @override
  Unit _parseMut(_ParserState state) => _Impl.voided(parser, state);
}

final class _Void<A> extends Parser<Unit> {
  final Parser<A> parser;

  _Void(this.parser);

  @override
  Unit _parseMut(_ParserState state) => _Impl.voided(parser, state);
}

final class _GenParser<A> extends Parser<A> {
  final Function1<_ParserState, A> f;

  _GenParser(this.f);

  @override
  A _parseMut(_ParserState state) => f(state);
}
