import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

final class Update<A> {
  final String raw;
  final Write<A> write;

  const Update(this.raw, this.write);

  UpdateStatement update(A a) => UpdateStatement((db) => IO.exec(() {
        db.execute(
          raw,
          write
              .setParameter(IStatementParameters.empty(), 0, a)
              .params
              .toList(),
        );
      }));

  UpdateStatement updateMany(RIterable<A> as) {
    return UpdateStatement((db) {
      return IO.delay(() => db.prepare(raw)).bracket(
            (ps) => IO.exec(
              () => as.foreach((a) {
                ps.executeWith(
                  write
                      .setParameter(IStatementParameters.empty(), 0, a)
                      .toStatementParameters(),
                );
              }),
            ),
            (ps) => IO.exec(() => ps.dispose()),
          );
    });
  }
}

final class UpdateStatement {
  final Function1<Database, IO<Unit>> _runIt;

  const UpdateStatement(this._runIt);

  IO<Unit> run(Database db) => _runIt(db);
}

extension UpdateOps on String {
  Update<A> update<A>(Write<A> write) => Update(this, write);
  UpdateStatement get update0 => Update(this, Write.unit).run;
}

extension Update0UnitOps on Update<Unit> {
  UpdateStatement get run => update(Unit());
}
