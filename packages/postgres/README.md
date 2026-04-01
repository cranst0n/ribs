# ribs_postgres

`ribs_postgres` is the PostgreSQL backend for `ribs_sql`. It provides a `Transactor` backed by the [`postgres`](https://pub.dev/packages/postgres) package, with support for both single shared connections and connection pools.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Getting Started

Add both `ribs_sql` and `ribs_postgres` to your dependencies, then create a `Transactor` and use the `ribs_sql` DSL to run queries.

## Creating a Transactor

### Single Connection

Opens one connection and reuses it for all `transact` calls. Suitable for scripts and simple applications.

```dart
import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_postgres/ribs_postgres.dart';

final endpoint = pg.Endpoint(
  host: 'localhost',
  database: 'mydb',
  username: 'user',
  password: 'password',
);

await PostgresTransactor.create(endpoint).use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

### Connection Pool (recommended)

Borrows a connection from the pool for each transaction, suitable for concurrent applications.

```dart
await PostgresPoolTransactor.withEndpoints([endpoint]).use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

### Pool from URL

```dart
await PostgresPoolTransactor.withUrl(
  'postgresql://user:password@localhost:5432/mydb',
).use((xa) {
  return myProgram.transact(xa);
}).unsafeRunFuture();
```

## SQL Syntax

PostgreSQL uses `$1`, `$2`, … placeholders natively, but `ribs_sql` uses `?` — the driver converts them automatically.

## Example

```dart
import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';
import 'package:ribs_postgres/ribs_postgres.dart';

final createTable = '''
  CREATE TABLE IF NOT EXISTS person (
    id   SERIAL PRIMARY KEY,
    name TEXT    NOT NULL,
    age  INTEGER NOT NULL
  )'''.update0;

final insert = 'INSERT INTO person (name, age) VALUES (?, ?) RETURNING id'
    .updateReturning((Write.string, Write.integer).tupled, Read.integer);

final findAll = 'SELECT name, age FROM person ORDER BY name'
    .query((Read.string, Read.integer).tupled);

ConnectionIO<Unit> program() {
  return createTable.run()
      .productR(insert.runMany(ilist([('Alice', 30), ('Bob', 25), ('Carol', 35)])))
      .productR(findAll.ilist())
      .flatMap((rows) => ConnectionIO.lift(
        rows.traverse_((r) => IO.print('${r.$1} — age ${r.$2}')),
      ));
}

void main() async {
  final endpoint = pg.Endpoint(
    host: 'localhost',
    database: 'mydb',
    username: 'user',
    password: 'password',
  );

  await PostgresPoolTransactor.withEndpoints([endpoint])
      .use((xa) => program().transact(xa))
      .unsafeRunFuture();
}
```

## See Also

- [`ribs_sql`](https://pub.dev/packages/ribs_sql) — the core DSL
- [`ribs_sqlite`](https://pub.dev/packages/ribs_sqlite) — SQLite backend
