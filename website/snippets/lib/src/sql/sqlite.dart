// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart' as sq;
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';

// #region sqlite-single
// SqliteTransactor.memory() — in-memory database, single shared connection.
// Useful for tests or short-lived programs that need no persistence.
final Resource<Transactor> memoryXa = SqliteTransactor.memory();

// SqliteTransactor.file(path) — file-based database, single connection.
// The connection is opened once and reused across all transact() calls.
final Resource<Transactor> fileXa = SqliteTransactor.file('/var/app/data.db');

// Both return Resource<Transactor>. Use .use((xa) => ...) to acquire the
// transactor, run your program, and release the connection automatically.
IO<Unit> withMemory() => SqliteTransactor.memory().use((xa) {
  return 'SELECT 1'.query(Read.integer).unique().transact(xa).voided();
});
// #endregion sqlite-single

// #region sqlite-pool
// SqlitePoolTransactor uses the sqlite3_connection_pool package to maintain
// separate writer and reader connections, enabling concurrent reads while a
// write transaction is in progress.
//
// Requires WAL journal mode so readers do not block the writer.
Resource<Transactor> openPool(String path) {
  final pool = SqliteConnectionPool.open(
    name: path,
    openConnections: () {
      sq.Database open(bool write) {
        final db = sq.sqlite3.open(path);
        // WAL mode is required for reader/writer concurrency.
        db.execute('PRAGMA journal_mode = WAL;');
        if (!write) db.execute('PRAGMA query_only = true;');
        return db;
      }

      // One writer connection, two read-only connections.
      return PoolConnections(open(true), [open(false), open(false)]);
    },
  );

  return SqlitePoolTransactor.create(pool);
}
// #endregion sqlite-pool

// #region sqlite-example
// ── Domain ───────────────────────────────────────────────────────────────────

final class Task {
  final int? id;
  final String title;
  final bool done;

  const Task({this.id, required this.title, required this.done});
}

// Read<Task> decodes three consecutive columns.
final taskRead = (Read.integer.optional(), Read.string, Read.boolean).tupled.map(
  (t) => Task(id: t.$1.toNullable(), title: t.$2, done: t.$3),
);

// ── Schema ───────────────────────────────────────────────────────────────────

ConnectionIO<int> createSchema() =>
    '''
CREATE TABLE IF NOT EXISTS task (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT    NOT NULL,
  done  INTEGER NOT NULL DEFAULT 0
)'''.update0.run();

// ── Writes ───────────────────────────────────────────────────────────────────

ConnectionIO<int> insertTask(String title) =>
    'INSERT INTO task (title, done) VALUES (?, 0)'.update(Write.string).run(title);

ConnectionIO<int> markDone(int id) =>
    'UPDATE task SET done = 1 WHERE id = ?'.update(Write.integer).run(id);

// ── Queries ──────────────────────────────────────────────────────────────────

ConnectionIO<IList<Task>> pendingTasks() =>
    'SELECT id, title, done FROM task WHERE done = 0 ORDER BY id'.query(taskRead).ilist();

// ── Program ──────────────────────────────────────────────────────────────────

// All ConnectionIO operations compose with flatMap inside a single transaction.
// SqliteTransactor.memory() provides the Transactor for this example.
IO<IList<Task>> program() => SqliteTransactor.memory().use((xa) {
  final setup = createSchema()
      .flatMap((_) => insertTask('Write docs'))
      .flatMap((_) => insertTask('Add tests'))
      .flatMap((_) => insertTask('Ship it'));

  final work = setup.flatMap((_) => markDone(1)).flatMap((_) => pendingTasks());

  return work.transact(xa);
});
// #endregion sqlite-example
