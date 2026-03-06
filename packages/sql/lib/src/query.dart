import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A SELECT query that reads rows of type [A] using the given [Fragment] and
/// [Read] codec.
///
/// Use the result combinators ([ilist], [option], [stream], etc.) to specify
/// how many rows are expected, then execute via [ConnectionIO.transact].
///
/// Example:
/// ```dart
/// final query =
///     (Fragment.sql('SELECT id, name FROM person WHERE age > ') +
///         Fragment.param(18, Put.integer))
///         .query(personRead);
///
/// final people = await query.ilist().transact(xa).unsafeRunFuture();
/// ```
final class Query<A> {
  final Fragment fragment;
  final Read<A> read;

  const Query(this.fragment, this.read);

  /// Returns all result rows as an [IList].
  ConnectionIO<IList<A>> ilist() => ConnectionIO.fromConnection((conn) {
    return conn
        .executeQuery(fragment.sql, fragment.params)
        .map((rows) => rows.map((row) => read.unsafeGet(row, 0)));
  });

  /// Returns all result rows as an [IVector].
  ConnectionIO<IVector<A>> ivector() => ConnectionIO.fromConnection((conn) {
    return conn.executeQuery(fragment.sql, fragment.params).map(
      (rows) {
        final bldr = IVector.builder<A>();

        rows.foreach((row) {
          bldr.addOne(read.unsafeGet(row, 0));
        });

        return bldr.result();
      },
    );
  });

  /// Returns all result rows as a [NonEmptyIList], failing if there are none.
  ConnectionIO<NonEmptyIList<A>> nel() => ConnectionIO.fromConnection((conn) {
    return conn.executeQuery(fragment.sql, fragment.params).flatMap(
      (rows) {
        if (rows.isEmpty) {
          return IO.raiseError('Expected 1 or more rows');
        } else {
          return IO.pure(NonEmptyIList.unsafe(rows.map((row) => read.unsafeGet(row, 0))));
        }
      },
    );
  });

  /// Returns [Some] if 1 rows is returned, [None] if 0,
  /// and errors if more than 1 row is returned.
  ConnectionIO<Option<A>> option() => ConnectionIO.fromConnection((conn) {
    return conn.executeQuery(fragment.sql, fragment.params).flatMap(
      (rows) {
        if (rows.isEmpty) {
          return IO.pure(none());
        } else if (rows.length > 1) {
          return IO.raiseError('Expected 0 or 1 rows, got ${rows.length}.');
        } else {
          return IO.some(read.unsafeGet(rows.head, 0));
        }
      },
    );
  });

  /// Returns exactly 1 row, erroring if there are 0 or more than 1.
  ConnectionIO<A> unique() => ConnectionIO.fromConnection((conn) {
    return conn.executeQuery(fragment.sql, fragment.params).flatMap(
      (rows) {
        if (rows.isEmpty) {
          return IO.raiseError('Expected exactly 1 row, got 0.');
        } else if (rows.length > 1) {
          return IO.raiseError('Expected exactly 1 row, got ${rows.length}.');
        } else {
          return IO.pure(read.unsafeGet(rows.head, 0));
        }
      },
    );
  });

  /// Returns a [ConnectionRill] that streams result rows lazily.
  ///
  /// Call `.transact(xa)` on the result to obtain a [Rill] that keeps the
  /// database connection open for the duration of the stream.
  ///
  /// Example:
  /// ```dart
  /// final rill = query.stream().transact(xa);
  /// await rill.compile.toList().unsafeRunFuture();
  /// ```
  ConnectionRill<A> stream() => ConnectionRill(this);
}

/// Extension to construct a [Query] from a plain SQL string with no parameters.
extension QueryStringOps on String {
  /// Creates a [Query] from this SQL string.
  ///
  /// For parameterized queries, use [Fragment] composition instead.
  Query<A> query<A>(Read<A> read) => Query(Fragment.raw(this), read);
}

/// Extension to construct a [Query] from a [Fragment].
extension QueryFragmentOps on Fragment {
  Query<A> query<A>(Read<A> read) => Query(this, read);
}

/// A parameterized query template. Binds parameters at call time.
///
/// Example:
/// ```dart
/// final byName = ParameterizedQuery(
///   'SELECT id, name FROM person WHERE name = ?', personRead, Write.string);
///
/// final alice = await byName.unique('Alice').transact(xa).unsafeRunFuture();
/// ```
final class ParameterizedQuery<P, A> {
  final String sql;

  final Read<A> read;
  final Write<P> write;

  const ParameterizedQuery(this.sql, this.read, this.write);

  /// Apply [params] to this query, resulting in a [Query] that can be transacted.
  Query<A> apply(P params) => Query(Fragment.fromParts(sql, write.encode(params)), read);

  /// Applies the given [params] to the query and returns all result rows as an [IList].
  ConnectionIO<IList<A>> ilist(P params) => apply(params).ilist();

  /// Applies the given [params] to the query and returns all result rows as an [IVector].
  ConnectionIO<IVector<A>> ivector(P params) => apply(params).ivector();

  /// Applies the given [params] to the query and returns all result rows as a [NonEmptyIList],
  /// failing if there are none.
  ConnectionIO<NonEmptyIList<A>> nel(P params) => apply(params).nel();

  /// Applies the given [params] to the query and returns [Some] if 1 rows is returned,
  /// [None] if 0, and fails if more than 1 row is returned.
  ConnectionIO<Option<A>> option(P params) => apply(params).option();

  /// Applies the given [params] to the query and returns exactly 1 row,
  /// failing if there are 0 or more than 1.
  ConnectionIO<A> unique(P params) => apply(params).unique();

  /// Applies the given [params] to the query and returns a [ConnectionRill]
  /// that streams result rows lazily.
  ///
  /// Call `.transact(xa)` on the result to obtain a [Rill] that keeps the
  /// database connection open for the duration of the stream.
  ///
  /// Example:
  /// ```dart
  /// final rill = byName.stream('Alice').transact(xa);
  /// ```
  ConnectionRill<A> stream(P params) => apply(params).stream();
}

/// Extension to construct a [ParameterizedQuery] from a plain SQL string with no parameters.
extension ParameterizedQueryStringOps on String {
  /// Creates a [ParameterizedQuery] from this SQL string.
  ParameterizedQuery<P, A> parmeteriedQuery<P, A>(Read<A> read, Write<P> write) =>
      ParameterizedQuery(this, read, write);
}
