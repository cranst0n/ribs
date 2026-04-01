# ribs_sqlite

`ribs_sqlite` is the SQLite backend for `ribs_sql`. It provides a `Transactor` backed by the [`sqlite3`](https://pub.dev/packages/sqlite3) package, with support for in-memory databases, file-based databases, and connection pooling via `sqlite3_connection_pool`.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Getting Started

Add both `ribs_sql` and `ribs_sqlite` to your dependencies, then create a `Transactor` and use the `ribs_sql` DSL to run queries.

## Creating a Transactor

### In-Memory Database

Useful for tests and ephemeral data. The database lives for the lifetime of the `Resource`.

```dart
import 'package:ribs_sqlite/ribs_sqlite.dart';

await SqliteTransactor.memory().use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

### File-Based Database

```dart
await SqliteTransactor.file('path/to/app.db').use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

### Connection Pool

For applications that need concurrent read access, use `SqlitePoolTransactor` with a
`SqliteConnectionPool` (one write connection, multiple read connections):

```dart
import 'package:sqlite3/sqlite3.dart' as sq;
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';

final pool = SqliteConnectionPool.open(
  name: 'app.db',
  openConnections: () {
    sq.Database open(bool write) {
      final db = sq.sqlite3.open('app.db');
      db.execute('PRAGMA journal_mode = WAL;');
      if (!write) db.execute('PRAGMA query_only = true;');
      return db;
    }
    return PoolConnections(open(true), [open(false), open(false)]);
  },
);

await SqlitePoolTransactor.create(pool).use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

## Example

```dart
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

final createTable = '''
  CREATE TABLE IF NOT EXISTS person (
    name TEXT NOT NULL,
    age  INTEGER NOT NULL
  )'''.update0;

final insert = 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled);

final findAll = 'SELECT name, age FROM person ORDER BY name'
    .query((Read.string, Read.integer).tupled);

final program = createTable.run()
    .productR(insert.runMany([('Alice', 30), ('Bob', 25), ('Carol', 35)]))
    .productR(findAll.ilist())
    .flatMap((rows) => ConnectionIO.lift(
      rows.traverse_((r) => IO.print('${r.$1} — age ${r.$2}')),
    ));

void main() async {
  await SqliteTransactor.memory()
      .use((xa) => program.transact(xa))
      .unsafeRunFuture();
}
```

## See Also

- [`ribs_sql`](https://pub.dev/packages/ribs_sql) — the core DSL
- [`ribs_postgres`](https://pub.dev/packages/ribs_postgres) — PostgreSQL backend
