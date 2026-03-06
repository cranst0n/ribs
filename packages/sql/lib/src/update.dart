import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// An INSERT, UPDATE, or DELETE statement parameterized by [A].
///
/// Example:
/// ```dart
/// final insert = ParameterizedUpdate(
///   (Write.string, Write.integer).tupled,
///   'INSERT INTO person (name, age) VALUES (?, ?)',
/// );
///
/// await insert.run(('Alice', 30)).transact(xa).unsafeRunFuture();
/// ```
final class Update<A> {
  final String sql;

  final Write<A> write;

  const Update(this.sql, this.write);

  /// Executes this update with [value] as the parameters, returning the number
  /// of affected rows.
  ConnectionIO<int> run(A value) => ConnectionIO.fromConnection((SqlConnection conn) {
    return conn.executeUpdate(sql, write.encode(value));
  });

  /// Executes this update once for each value in [values].
  ConnectionIO<Unit> runMany(Iterable<A> values) =>
      ConnectionIO.fromConnection((SqlConnection conn) {
        return values.fold<IO<Unit>>(
          IO.pure(Unit()),
          (io, value) => io.flatMap(
            (_) => conn.executeUpdate(sql, write.encode(value)).map((_) => Unit()),
          ),
        );
      });
}

/// A no-parameter UPDATE/INSERT/DDL statement.
final class Update0 {
  final String sql;

  const Update0(this.sql);

  /// Executes the statement, returning the number of affected rows.
  ConnectionIO<int> run() =>
      ConnectionIO.fromConnection((conn) => conn.executeUpdate(sql, StatementParameters.empty()));
}

/// An INSERT...RETURNING (or similar) statement that writes [A] parameters
/// and reads back [B] value(s).
///
/// Example:
/// ```dart
/// final insertReturning = ParameterizedUpdateReturning(
///   'INSERT INTO person (name) VALUES (?) RETURNING id',
///   Write.string,
///   Read.integer,
/// );
///
/// final id = await insertReturning.run('Alice').transact(xa).unsafeRunFuture();
/// ```
final class UpdateReturning<A, B> {
  final String sql;

  final Write<A> write;
  final Read<B> read;

  const UpdateReturning(this.sql, this.write, this.read);

  /// Executes the statement with [value] and reads back the single returned row.
  ConnectionIO<B> run(A value) => ConnectionIO.fromConnection((SqlConnection conn) {
    return conn.executeQuery(sql, write.encode(value)).flatMap(
      (rows) {
        if (rows.isEmpty) {
          return IO.raiseError('Expected 1 returned row, got 0.');
        } else {
          return IO.pure(read.unsafeGet(rows.head, 0));
        }
      },
    );
  });

  /// Executes the statement for each value and collects all returned rows.
  ConnectionIO<IList<B>> runMany(RIterableOnce<A> values) =>
      ConnectionIO.fromConnection((SqlConnection conn) {
        return values.foldLeft<IO<IList<B>>>(
          IO.pure(nil()),
          (ioAcc, value) => ioAcc.flatMap(
            (acc) => conn.executeQuery(sql, write.encode(value)).flatMap(
              (rows) {
                if (rows.isEmpty) {
                  return IO.raiseError('Expected 1 returned row, got 0.');
                } else {
                  return IO.pure(acc.appended(read.unsafeGet(rows.head, 0)));
                }
              },
            ),
          ),
        );
      });
}

/// Convenience extensions for constructing updates from SQL strings.
extension UpdateStringOps on String {
  Update0 get update0 => Update0(this);

  Update<A> update<A>(Write<A> write) => Update(this, write);

  UpdateReturning<A, B> updateReturning<A, B>(
    Write<A> write,
    Read<B> read,
  ) => UpdateReturning(this, write, read);
}

extension FragmentUpdateOps on Fragment {
  Update0 get update0 => Update0(sql);
}
