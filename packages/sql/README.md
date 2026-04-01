# ribs_sql

`ribs_sql` is a purely functional SQL library for Dart, inspired by [doobie](https://tpolecat.github.io/doobie/) from the Scala ecosystem. It provides a composable, type-safe DSL for building and executing SQL queries, with all database interactions expressed as `ConnectionIO` values that run inside a managed transaction.

`ribs_sql` is a backend-agnostic abstraction — pair it with `ribs_sqlite` or `ribs_postgres` to obtain a concrete `Transactor`.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Key Features

- **Type-safe codecs**: `Read<A>` / `Write<A>` codecs map SQL columns to Dart types and back.
- **Composable fragments**: `Fragment` lets you build SQL strings with typed parameters safely.
- **`ConnectionIO` monad**: Database operations are pure values that are composed before execution.
- **Transactor**: A single entry point (`Transactor`) manages connection lifecycle and transactions.
- **Streaming**: `Query.stream()` lazily streams result rows as a `Rill`.
- **`RETURNING` support**: `UpdateReturning` reads back generated values (e.g. auto-increment IDs).

## Core Concepts

### Read & Write Codecs

`Read<A>` decodes one or more SQL columns into a Dart value. `Write<A>` encodes a Dart value into SQL parameters. Primitive codecs are available as static members:

```dart
Read.string    // Read<String>
Read.integer   // Read<int>
Read.boolean   // Read<bool>
Read.dateTime  // Read<DateTime>
Read.json      // Read<JsonValue>

Write.string   // Write<String>
Write.integer  // Write<int>
// ...and so on
```

Combine codecs for multi-column types using `.tupled` on a tuple of codecs:

```dart
final personRead  = (Read.string, Read.integer).tupled;   // Read<(String, int)>
final personWrite = (Write.string, Write.integer).tupled; // Write<(String, int)>
```

Transform with `.map` / `.contramap`:

```dart
final upperRead = Read.string.map((s) => s.toUpperCase());
final personWrite = (Write.string, Write.integer).tupled
    .contramap<Person>((p) => (p.name, p.age));
```

Use `.optional()` to handle nullable columns:

```dart
final optRead  = Read.string.optional();   // Read<Option<String>>
final optWrite = Write.string.optional();  // Write<Option<String>>
```

### Fragments

`Fragment` combines a SQL string with its typed, bound parameters. Compose fragments with `+`:

```dart
final frag =
    Fragment.raw('SELECT name, age FROM person WHERE age > ') +
    Fragment.param(18, Put.integer) +
    Fragment.raw(' ORDER BY name');
```

The `.fr` extension on `String` is shorthand for `Fragment.raw`:

```dart
final frag = 'SELECT name, age FROM person WHERE age > '.fr +
    Fragment.param(18, Put.integer);
```

### Queries

Turn a `String` or `Fragment` into a `Query<A>` with `.query(read)`, then choose how many rows to expect:

```dart
// All rows
final people = 'SELECT name, age FROM person'
    .query((Read.string, Read.integer).tupled)
    .ilist();  // ConnectionIO<IList<(String, int)>>

// Exactly one row (errors on 0 or >1)
final alice = (Fragment.raw('SELECT name, age FROM person WHERE name = ') +
        Fragment.param('Alice', Put.string))
    .query((Read.string, Read.integer).tupled)
    .unique();  // ConnectionIO<(String, int)>

// Zero or one row
final maybeAlice = ...query..option();  // ConnectionIO<Option<(String, int)>>

// Lazy stream
final stream = ...query..stream();  // ConnectionRill<(String, int)>
```

### Reusable Parameterized Queries

`ParameterizedQuery` binds parameters at call time:

```dart
final byName = ParameterizedQuery(
  'SELECT name, age FROM person WHERE name = ?',
  (Read.string, Read.integer).tupled,
  Write.string,
);

final alice = byName.unique('Alice');   // ConnectionIO<(String, int)>
final bobs  = byName.ilist('Bob');      // ConnectionIO<IList<(String, int)>>
```

### Updates

```dart
// DDL or no-parameter statements
final createTable = 'CREATE TABLE person (name TEXT, age INTEGER)'.update0;
final ct = createTable.run(); // ConnectionIO<int>

// Parameterized insert/update/delete
final insert = 'INSERT INTO person (name, age) VALUES (?, ?)'
    .update((Write.string, Write.integer).tupled);

final one  = insert.run(('Alice', 30));               // ConnectionIO<int>
final many = insert.runMany([('Alice', 30), ('Bob', 25)]); // ConnectionIO<Unit>
```

### `RETURNING`

```dart
final insertReturning = 'INSERT INTO item (label) VALUES (?) RETURNING id'
    .updateReturning(Write.string, Read.integer);

final id  = insertReturning.run('Widget');              // ConnectionIO<int>
final ids = insertReturning.runMany(ilist(['A', 'B'])); // ConnectionIO<IList<int>>
```

### Composing `ConnectionIO`

`ConnectionIO` is a monad — sequence operations with `flatMap` / `productR`:

```dart
final program = createTable.run()
    .productR(insert.run(('Alice', 30)))
    .productR('SELECT name FROM person'.query(Read.string).ilist())
    .flatMap((names) => ConnectionIO.lift(IO.print('Names: $names')));
```

### Executing with a Transactor

Call `.transact(xa)` to turn a `ConnectionIO<A>` into an `IO<A>`:

```dart
final result = await program.transact(xa).unsafeRunFuture();
```

`Transactor` wraps each `transact` call in a transaction (BEGIN/COMMIT/ROLLBACK).

## Example

See [example/example.dart](example/example.dart) for a full demonstration of the DSL.
For concrete backends see `ribs_sqlite` and `ribs_postgres`.
