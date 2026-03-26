import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A program that requires a [SqlConnection] to produce a value of type [A].
///
/// [ConnectionIO] acts as a Reader monad: `SqlConnection -> IO<A>`. Programs are
/// composed using [map] and [flatMap], and executed using [transact].
///
/// Example:
/// ```dart
/// final program = ConnectionIO.delay(() => 42);
/// final result = await program.transact(xa).unsafeRunFuture();
/// ```
final class ConnectionIO<A> {
  final Function1<SqlConnection, IO<A>> _run;

  const ConnectionIO._(this._run);

  /// Suspends a synchronous computation into [ConnectionIO].
  static ConnectionIO<A> delay<A>(Function0<A> thunk) => ConnectionIO._((_) => IO.delay(thunk));

  /// Creates a [ConnectionIO] from a function that takes a [SqlConnection].
  static ConnectionIO<A> fromConnection<A>(Function1<SqlConnection, IO<A>> f) => ConnectionIO._(f);

  /// Lifts an [IO] into [ConnectionIO], ignoring the connection.
  static ConnectionIO<A> lift<A>(IO<A> io) => ConnectionIO._((_) => io);

  static ConnectionIO<A> never<A>() => ConnectionIO.lift(IO.never());

  /// Lifts a pure value into [ConnectionIO].
  static ConnectionIO<A> pure<A>(A a) => ConnectionIO._((_) => IO.pure(a));

  static ConnectionIO<A> raiseError<A>(Object error, [StackTrace? stackTrace]) =>
      ConnectionIO._((_) => IO.raiseError(error, stackTrace));

  static final ConnectionIO<Unit> unit = ConnectionIO.pure(Unit.instance);

  ConnectionIO<B> map<B>(Function1<A, B> f) => ConnectionIO._((conn) => _run(conn).map(f));

  ConnectionIO<B> flatMap<B>(Function1<A, ConnectionIO<B>> f) =>
      ConnectionIO._((conn) => _run(conn).flatMap((a) => f(a)._run(conn)));

  ConnectionIO<B> productR<B>(Function0<ConnectionIO<B>> that) => flatMap((_) => that());

  /// Runs this program using [conn], producing a value wrapped in [IO].
  IO<A> run(SqlConnection conn) => _run(conn);

  IO<A> transact(Transactor xa) => xa.transact(this);
}
