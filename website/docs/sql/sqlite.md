---
sidebar_position: 2
---


# SQLite

`ribs_sqlite` is the SQLite backend for `ribs_sql`. It provides two concrete
`Transactor` implementations that differ in how they manage connections:

| Implementation | Connections |
|---|---|
| `SqliteTransactor` | Single shared connection |
| `SqlitePoolTransactor` | Writer + reader pool |

Both return `Resource<Transactor>`. The `Resource` wrapper guarantees the
underlying connection (or pool) is closed cleanly on success, error, or fiber
cancellation.

## SqliteTransactor — single connection

`SqliteTransactor` opens one connection and reuses it for every `transact()`
call. Because the connection is shared, concurrent transactions are serialized —
this is fine for most single-process use cases and is the simplest option.

<<< @/../snippets/lib/src/sql/sqlite.dart#sqlite-single

- **`memory()`** — opens an in-memory database. Schema and data live only for
  the lifetime of the `Resource`. Ideal for tests and short-lived programs.
- **`file(path)`** — opens a file-backed database at `path`. Data persists
  across `Resource` acquisitions.

Both constructors accept an optional `strategy` parameter — see
[Strategy](/docs/sql/overview#strategy) in the overview for details.

## SqlitePoolTransactor — reader/writer pool

`SqlitePoolTransactor` wraps a `SqliteConnectionPool` from the
`sqlite3_connection_pool` package. It maintains a single writer connection and
one or more read-only connections, allowing concurrent reads while a write
transaction is in progress.

For this to work the database **must** use WAL (Write-Ahead Logging) journal
mode. WAL allows readers to operate against the last committed snapshot while
the writer is active. Without WAL, SQLite's default journal mode serialises all
connections.

<<< @/../snippets/lib/src/sql/sqlite.dart#sqlite-pool

When `transact()` is called, the pool transactor acquires the **writer**
connection. When `stream()` is called — or when `connectReader()` is used
directly — a **reader** connection is acquired instead, leaving the writer free
for concurrent mutations.

:::note
`SqlitePoolTransactor` is intended for file-based databases. An in-memory
SQLite database is isolated per connection, so using a pool would give each
connection a separate, empty database.
:::

## Example program

The following snippet wires together a schema, several writes, and a query into
a single transaction using an in-memory `SqliteTransactor`. All `ConnectionIO`
operations compose with `flatMap` and run atomically under one `BEGIN`/`COMMIT`.

<<< @/../snippets/lib/src/sql/sqlite.dart#sqlite-example

`program()` returns `IO<IList<Task>>` — a pure description of the entire
database interaction. Nothing is executed until the `IO` is run at the
application boundary.
