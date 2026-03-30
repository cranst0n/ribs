// ignore_for_file: unused_local_variable

import 'package:postgres/postgres.dart' as pg;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_postgres/ribs_postgres.dart';
import 'package:ribs_sql/ribs_sql.dart';

// #region postgres-single
// PostgresTransactor.create opens a single shared connection when the Resource
// is acquired and closes it on release. All transact() and stream() calls share
// this one connection sequentially. For concurrent workloads prefer the pool.
final Resource<Transactor> singleXa = PostgresTransactor.create(
  pg.Endpoint(
    host: 'localhost',
    database: 'mydb',
    username: 'app',
    password: 's3cr3t',
  ),
);

// An optional ConnectionSettings controls SSL mode and other driver options.
final Resource<Transactor> singleXaTls = PostgresTransactor.create(
  pg.Endpoint(host: 'db.example.com', database: 'prod'),
  settings: const pg.ConnectionSettings(sslMode: pg.SslMode.require),
);
// #endregion postgres-single

// #region postgres-pool-endpoints
// PostgresPoolTransactor.withEndpoints creates a pg.Pool backed by one or more
// Endpoints. The pool distributes connections across endpoints using round-robin
// selection. Use PoolSettings to cap pool size, set timeouts, and configure SSL.
final Resource<Transactor> poolXa = PostgresPoolTransactor.withEndpoints(
  [
    pg.Endpoint(
      host: 'localhost',
      database: 'mydb',
      username: 'app',
      password: 's3cr3t',
    ),
  ],
  settings: const pg.PoolSettings(
    maxConnectionCount: 10,
    sslMode: pg.SslMode.disable,
  ),
);
// #endregion postgres-pool-endpoints

// #region postgres-pool-url
// withUrl accepts a standard PostgreSQL connection URL.
// Format: postgresql://[user:password@]host[:port][/database]
final Resource<Transactor> urlXa = PostgresPoolTransactor.withUrl(
  'postgresql://app:s3cr3t@localhost:5432/mydb',
);
// #endregion postgres-pool-url

// #region postgres-placeholders
// The postgres wire protocol uses $1, $2, ... positional placeholders.
// ribs_postgres rewrites the ? placeholders used throughout ribs_sql to the
// $N form automatically, so you write the same SQL regardless of the backend.
ConnectionIO<Option<(String, int)>> findUser(String name) =>
    (Fragment.raw('SELECT name, age FROM person WHERE name = ') + Fragment.param(name, Put.string))
        .query((Read.string, Read.integer).tupled)
        .option();
// #endregion postgres-placeholders

// #region postgres-example
// ── Domain ───────────────────────────────────────────────────────────────────

final class Employee {
  final int? id;
  final String name;
  final String department;

  const Employee({this.id, required this.name, required this.department});
}

final employeeRead = (Read.integer.optional(), Read.string, Read.string).tupled.map(
  (t) => Employee(id: t.$1.toNullable(), name: t.$2, department: t.$3),
);

// ── Schema ───────────────────────────────────────────────────────────────────

ConnectionIO<int> createEmployeeTable() =>
    '''
CREATE TABLE IF NOT EXISTS employee (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  department TEXT NOT NULL
)'''.update0.run();

// ── Writes ───────────────────────────────────────────────────────────────────

ConnectionIO<int> insertEmployee(String name, String dept) =>
    'INSERT INTO employee (name, department) VALUES (?, ?)'
        .update((Write.string, Write.string).tupled)
        .run((name, dept));

// Insert ... RETURNING reads the generated id back in one round-trip.
ConnectionIO<int> insertEmployeeReturning(String name, String dept) =>
    'INSERT INTO employee (name, department) VALUES (?, ?) RETURNING id'
        .updateReturning(
          (Write.string, Write.string).tupled,
          Read.integer,
        )
        .run((name, dept));

// ── Queries ──────────────────────────────────────────────────────────────────

final byDept = ParameterizedQuery(
  'SELECT id, name, department FROM employee WHERE department = ? ORDER BY name',
  employeeRead,
  Write.string,
);

ConnectionIO<IList<Employee>> employeesIn(String dept) => byDept.ilist(dept);

// ── Program ──────────────────────────────────────────────────────────────────

// Build the transactor from a URL and run the entire program inside a single
// Resource scope. The pool is closed automatically when use() completes.
IO<IList<Employee>> program() => PostgresPoolTransactor.withUrl(
  'postgresql://app:s3cr3t@localhost:5432/mydb',
).use((xa) {
  final setup = createEmployeeTable()
      .flatMap((_) => insertEmployee('Alice', 'Engineering'))
      .flatMap((_) => insertEmployee('Bob', 'Engineering'))
      .flatMap((_) => insertEmployee('Carol', 'Product'));

  return setup.flatMap((_) => employeesIn('Engineering')).transact(xa);
});
// #endregion postgres-example
