---
sidebar_position: 1
---


# Overview

Dart's standard approach to SQL — passing query strings and receiving `dynamic`
maps back — pushes every type-safety concern onto the developer. Column names
are stringly-typed, result shapes are unchecked, and failures surface as
runtime exceptions rather than types.

`ribs_sql` is a functional SQL library inspired by Scala's
[Doobie](https://tpolecat.github.io/doobie/). It treats SQL as plain strings
(no query DSL, no reflection) while giving you:

- **Typed rows** — a `Read<A>` describes how to decode a row into `A`, checked
  at compile time
- **Typed parameters** — a `Write<A>` describes how to bind `A` as SQL
  parameters, eliminating positional mistakes
- **`Either`-based errors** — no unexpected exceptions; failures are values
- **Composable transactions** — `ConnectionIO<A>` is a pure description of
  database work; execution is deferred until you hand it a `Transactor`
- **Streaming** — large result sets stream row-by-row via `Rill<A>` rather than
  buffering everything in memory

## Domain model

Start by defining plain Dart classes and describing how to map them to and from
SQL rows using `Read` and `Write`. No annotations, no code generation:

<<< @/../snippets/lib/src/sql/overview.dart#sql-domain

Tuple extensions such as `(Read.string, Read.integer).tupled` compose primitive
column readers into a multi-column `Read<(String, int)>`. `.map` then converts
the tuple to your domain type. `Write` works in the opposite direction via
`.contramap`.

Built-in primitives: `Read`/`Write`/`ReadWrite` for `integer`, `string`,
`boolean`, `double`, `dateTime`, `bigInt`, `blob`, and `json`.

## Transactor

A `Transactor` manages the database connection and transaction lifecycle. For
SQLite, `SqliteTransactor` provides two constructors:

- **`SqliteTransactor.memory()`** — in-memory database, useful for tests and
  prototyping
- **`SqliteTransactor.file(path)`** — persistent file-backed database

Both return `Resource<Transactor>`, which guarantees the connection is closed
on success, error, or cancellation:

<<< @/../snippets/lib/src/sql/overview.dart#sql-transactor

### Strategy

`Strategy` controls the four transaction lifecycle hooks that every `Transactor`
runs around each `ConnectionIO`:

| Hook | Default | Purpose |
|---|---|---|
| `before` | `BEGIN` | Start the transaction |
| `after` | `COMMIT` | Commit on success |
| `oops` | `ROLLBACK` | Roll back on error or cancellation |
| `always` | no-op | Guaranteed cleanup, runs unconditionally |

`Strategy.defaultStrategy()` covers the common case. Pass a custom `Strategy`
to any transactor constructor to override individual hooks:

<<< @/../snippets/lib/src/sql/overview.dart#sql-strategy

## DDL — Update0

`Update0` represents a parameterless SQL statement. The `.update0` extension on
`String` creates one. Use it for `CREATE TABLE`, `DROP TABLE`, and any DDL that
takes no bound values:

<<< @/../snippets/lib/src/sql/overview.dart#sql-ddl

## Insert — Update

`Update<A>` represents a parameterized write statement. The `.update(Write<A>)`
extension on `String` creates one. `run(value)` executes once; `runMany(list)`
executes once per element using the same prepared statement:

<<< @/../snippets/lib/src/sql/overview.dart#sql-insert

## Query

`Query<A>` represents a SELECT statement. The `.query(Read<A>)` extension on
`String` (or `Fragment`) creates one. It offers several result-collection
strategies:

| Method | Returns | Semantics |
|---|---|---|
| `ilist()` | `ConnectionIO<IList<A>>` | All rows |
| `ivector()` | `ConnectionIO<IVector<A>>` | All rows as `IVector` |
| `unique()` | `ConnectionIO<A>` | Exactly one row; error otherwise |
| `option()` | `ConnectionIO<Option<A>>` | `Some` if one row, `None` if zero; error if more than one |
| `nel()` | `ConnectionIO<NonEmptyIList<A>>` | One or more rows; error if empty |
| `stream()` | `ConnectionRill<A>` | Lazy streaming |

<<< @/../snippets/lib/src/sql/overview.dart#sql-query

### Fragment composition

`Fragment` lets you build SQL dynamically by concatenating raw SQL strings and
typed parameters with `+`. `Fragment.raw(sql)` contributes literal SQL;
`Fragment.param(value, Put<A>)` contributes a single `?` placeholder with a
bound value. The `.fr` extension on `String` is shorthand for `Fragment.raw`:

```dart
final frag =
    'SELECT name, age FROM person WHERE age > '.fr +
    Fragment.param(18, Put.integer) +
    Fragment.raw(' AND name LIKE ') +
    Fragment.param('%Alice%', Put.string);
```

All parameters are bound separately and never interpolated into the SQL string,
so `Fragment` is safe from SQL injection by construction.

## ParameterizedQuery

`ParameterizedQuery<P, A>` bundles a SQL template with a `Read<A>` and a
`Write<P>` so the query can be reused with different parameters without
reconstructing the object each time:

<<< @/../snippets/lib/src/sql/overview.dart#sql-parameterized

`ParameterizedQuery` mirrors all of `Query`'s result methods (`unique`,
`option`, `ilist`, `stream`) as convenience shortcuts that accept the parameter
value directly.

## Streaming

`.stream()` on a `Query<A>` (or `ParameterizedQuery`) returns a
`ConnectionRill<A>`. Calling `.transact(xa)` on it returns a `Rill<A>` that
emits rows lazily, keeping the database connection open for the duration of the
stream and releasing it automatically when the stream terminates:

<<< @/../snippets/lib/src/sql/overview.dart#sql-stream

Use streaming when result sets are large enough that buffering the entire
collection in memory would be wasteful.

## Insert Returning

`UpdateReturning<A, B>` handles `INSERT ... RETURNING` (and any statement that
both writes and reads). `run(value)` reads a single row back; `runMany(list)`
collects all returned rows:

<<< @/../snippets/lib/src/sql/overview.dart#sql-returning

## Transactions

`ConnectionIO<A>` is a pure description of database work — it does nothing
until you call `.transact(xa)`. Calling `transact` wraps the operation in a
`BEGIN` / `COMMIT` block. Any error, including fiber cancellation, triggers an
automatic `ROLLBACK`:

<<< @/../snippets/lib/src/sql/overview.dart#sql-transaction

Because `ConnectionIO` forms a monad, operations compose with `flatMap`. The
entire chain runs inside a single transaction, so partial failures roll back all
work completed so far.
