import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:test/test.dart';

// Minimal stub — pure/delay/lift tests never invoke these methods.
class _StubConnection extends SqlConnection {
  @override
  IO<IList<Row>> executeQuery(String sql, StatementParameters params) => throw UnimplementedError();

  @override
  IO<int> executeUpdate(String sql, StatementParameters params) => throw UnimplementedError();

  @override
  Rill<Row> streamQuery(String sql, StatementParameters params, {int chunkSize = 64}) =>
      throw UnimplementedError();

  @override
  IO<Unit> close() => throw UnimplementedError();
}

final _conn = _StubConnection();

Future<A> run<A>(ConnectionIO<A> cio) => cio.run(_conn).unsafeRunFuture();

void main() {
  group('ConnectionIO', () {
    group('pure', () {
      test('lifts a value without touching the connection', () async {
        expect(await run(ConnectionIO.pure(42)), 42);
      });

      test('unit is pure Unit', () async {
        expect(await run(ConnectionIO.unit), isA<Unit>());
      });
    });

    group('delay', () {
      test('evaluates a thunk lazily', () async {
        var called = false;
        final cio = ConnectionIO.delay(() {
          called = true;
          return 7;
        });
        expect(called, isFalse);
        expect(await run(cio), 7);
        expect(called, isTrue);
      });
    });

    group('lift', () {
      test('wraps an IO, ignoring the connection', () async {
        final io = IO.pure('lifted');
        expect(await run(ConnectionIO.lift(io)), 'lifted');
      });
    });

    group('raiseError', () {
      test('produces a failed IO', () async {
        final cio = ConnectionIO.raiseError<int>(Exception('boom'));
        await expectLater(run(cio), throwsA(isA<Exception>()));
      });
    });

    group('map', () {
      test('transforms the result', () async {
        final cio = ConnectionIO.pure(5).map((n) => n * 2);
        expect(await run(cio), 10);
      });

      test('chained maps', () async {
        final cio = ConnectionIO.pure('hello').map((s) => s.length).map((n) => n + 1);
        expect(await run(cio), 6);
      });
    });

    group('flatMap', () {
      test('sequences two programs', () async {
        final cio = ConnectionIO.pure(3).flatMap((n) => ConnectionIO.pure(n * n));
        expect(await run(cio), 9);
      });

      test('both programs share the connection (no throws)', () async {
        // pure/delay don't use the connection, so this just checks sequencing
        final cio = ConnectionIO.pure('a').flatMap(
          (a) => ConnectionIO.delay(() => '$a-b'),
        );
        expect(await run(cio), 'a-b');
      });

      test('error in first propagates', () async {
        final cio = ConnectionIO.raiseError<int>(Exception('first')).flatMap(
          (_) => ConnectionIO.pure(0),
        );
        await expectLater(run(cio), throwsA(isA<Exception>()));
      });

      test('error in second propagates', () async {
        final cio = ConnectionIO.pure(1).flatMap(
          (_) => ConnectionIO.raiseError<int>(Exception('second')),
        );
        await expectLater(run(cio), throwsA(isA<Exception>()));
      });
    });

    group('productR', () {
      test('discards first result and returns second', () async {
        final cio = ConnectionIO.pure('ignored').productR(ConnectionIO.pure(99));
        expect(await run(cio), 99);
      });
    });

    group('monad laws', () {
      // left identity: pure(a).flatMap(f) == f(a)
      test('left identity', () async {
        ConnectionIO<int> f(int n) => ConnectionIO.pure(n + 1);
        final lhs = ConnectionIO.pure(5).flatMap(f);
        final rhs = f(5);
        expect(await run(lhs), await run(rhs));
      });

      // right identity: m.flatMap(pure) == m
      test('right identity', () async {
        final m = ConnectionIO.pure(42);
        final result = m.flatMap(ConnectionIO.pure);
        expect(await run(result), await run(m));
      });

      // associativity: m.flatMap(f).flatMap(g) == m.flatMap((x) => f(x).flatMap(g))
      test('associativity', () async {
        final m = ConnectionIO.pure(1);
        ConnectionIO<int> f(int n) => ConnectionIO.pure(n + 1);
        ConnectionIO<int> g(int n) => ConnectionIO.pure(n * 10);

        final lhs = m.flatMap(f).flatMap(g);
        final rhs = m.flatMap((x) => f(x).flatMap(g));
        expect(await run(lhs), await run(rhs));
      });
    });
  });
}
