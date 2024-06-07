import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

// Useful for 'insert ... returning'
final class UpdateQuery<A, B> {
  final String raw;
  final Write<A> write;
  final Read<B> read;

  const UpdateQuery(this.raw, this.write, this.read);

  UpdateQueryStatement<A, B, B> update(A a) {
    return UpdateQueryStatement(this, (db) {
      final resultSet = db.select(
          raw,
          write
              .setParameter(IStatementParameters.empty(), 0, a)
              .params
              .toList());

      return IO.delay(() => read.unsafeGet(resultSet.first, 0));
    });
  }

  UpdateQueryStatement<A, B, RIterable<B>> updateMany(RIterable<A> as) {
    return UpdateQueryStatement(this, (db) {
      return IO.delay(() => db.prepare(raw)).bracket(
        (ps) {
          return IO.delay(() {
            return as.map((a) {
              final rs = ps.selectWith(
                write
                    .setParameter(IStatementParameters.empty(), 0, a)
                    .toStatementParameters(),
              );

              return read.unsafeGet(rs.first, 0);
            });
          });
        },
        (ps) => IO.exec(() => ps.dispose()),
      );
    });
  }
}

final class UpdateQueryStatement<A, B, C> {
  final UpdateQuery<A, B> query;
  final Function1<Database, IO<C>> _runIt;

  const UpdateQueryStatement(this.query, this._runIt);

  IO<C> run(Database db) => _runIt(db);
}

extension UpdateQueryOps on String {
  UpdateQuery<A, B> updateQuery<A, B>(Write<A> write, Read<B> read) =>
      UpdateQuery(this, write, read);
}
