import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

final class Query<A> {
  final String raw;
  final Read<A> read;

  const Query(this.raw, this.read);

  QueryStatement<A, IList<A>> ilist() => QueryStatement.ilist(this);

  QueryStatement<A, IVector<A>> ivector() => QueryStatement.ivector(this);

  QueryStatement<A, NonEmptyIList<A>> nel() => QueryStatement.nel(this);

  QueryStatement<A, Option<A>> option() => QueryStatement.option(this);

  QueryStatement<A, A> unique() => QueryStatement.unique(this);
}

extension QueryOps on String {
  Query<A> query<A>(Read<A> read) => Query(this, read);
}

class QueryStatement<A, B> {
  final Query<A> query;
  final Function1<ResultSet, B> _runIt;

  const QueryStatement._(this.query, this._runIt);

  static QueryStatement<A, IList<A>> ilist<A>(Query<A> query) {
    return QueryStatement._(query, (resultSet) {
      final bldr = IList.builder<A>();

      final it = RIterator.fromDart(resultSet.iterator);

      while (it.hasNext) {
        bldr.addOne(query.read.unsafeGet(it.next(), 0));
      }

      return bldr.toIList();
    });
  }

  static QueryStatement<A, NonEmptyIList<A>> nel<A>(Query<A> query) {
    return QueryStatement._(query, (resultSet) {
      if (resultSet.isNotEmpty) {
        final bldr = IList.builder<A>();
        final it = RIterator.fromDart(resultSet.iterator);

        while (it.hasNext) {
          bldr.addOne(query.read.unsafeGet(it.next(), 0));
        }

        return NonEmptyIList.unsafe(bldr);
      } else {
        throw Exception('Exepected 1 or more rows. Found ${resultSet.length}');
      }
    });
  }

  static QueryStatement<A, IVector<A>> ivector<A>(Query<A> query) {
    return QueryStatement._(query, (resultSet) {
      final bldr = IVector.builder<A>();

      final it = RIterator.fromDart(resultSet.iterator);

      while (it.hasNext) {
        bldr.addOne(query.read.unsafeGet(it.next(), 0));
      }

      return bldr.result();
    });
  }

  static QueryStatement<A, Option<A>> option<A>(Query<A> query) {
    return QueryStatement._(query, (resultSet) {
      if (resultSet.length <= 1) {
        return Option.when(
          () => resultSet.length == 1,
          () => query.read.unsafeGet(resultSet.first, 0),
        );
      } else {
        throw Exception(
            'Exepected exactly 0 or 1 row. Found ${resultSet.length}');
      }
    });
  }

  static QueryStatement<A, A> unique<A>(Query<A> query) {
    return QueryStatement._(query, (resultSet) {
      if (resultSet.length == 1) {
        return query.read.unsafeGet(resultSet.first, 0);
      } else {
        throw Exception('Exepected exactly 1 row. Found ${resultSet.length}');
      }
    });
  }

  IO<B> run(Database db) {
    return IO.delay(() {
      return _runIt(db.select(query.raw));
    });
  }
}
