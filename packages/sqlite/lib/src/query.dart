import 'dart:async';

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

  QueryStatement<A, Stream<A>> stream() => QueryStatement.stream(this);

  QueryStatement<A, A> unique() => QueryStatement.unique(this);
}

extension QueryOps on String {
  Query<A> query<A>(Read<A> read) => Query(this, read);
}

class QueryStatement<A, B> {
  final Query<A> query;

  final Function1<RIterator<Row>, B> _runIt;
  final bool _streaming;

  const QueryStatement._(
    this.query,
    this._runIt, [
    this._streaming = false,
  ]);

  static QueryStatement<A, IList<A>> ilist<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      final bldr = IList.builder<A>();

      while (rows.hasNext) {
        bldr.addOne(query.read.unsafeGet(rows.next(), 0));
      }

      return bldr.toIList();
    });
  }

  static QueryStatement<A, NonEmptyIList<A>> nel<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      if (rows.hasNext) {
        final bldr = IList.builder<A>();

        while (rows.hasNext) {
          bldr.addOne(query.read.unsafeGet(rows.next(), 0));
        }

        return NonEmptyIList.unsafe(bldr);
      } else {
        throw Exception('Expected 1 or more rows.');
      }
    });
  }

  static QueryStatement<A, IVector<A>> ivector<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      final bldr = IVector.builder<A>();

      while (rows.hasNext) {
        bldr.addOne(query.read.unsafeGet(rows.next(), 0));
      }

      return bldr.result();
    });
  }

  static QueryStatement<A, Option<A>> option<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      if (rows.hasNext) {
        final res = query.read.unsafeGet(rows.next(), 0);
        if (rows.hasNext) throw Exception('Expected exactly 0 or 1 row.');
        return Option(res);
      } else {
        return none();
      }
    });
  }

  static QueryStatement<A, Stream<A>> stream<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      return Stream<A>.multi((controller) {
        Iterator<A> iterator;
        try {
          iterator = rows.map((row) => query.read.unsafeGet(row, 0)).toDart;
        } catch (e, s) {
          controller.addError(e, s);
          controller.close();
          return;
        }
        final zone = Zone.current;
        var isScheduled = true;

        void next() {
          if (!controller.hasListener || controller.isPaused) {
            // Cancelled or paused since scheduled.
            isScheduled = false;
            return;
          }
          bool hasNext;
          try {
            hasNext = iterator.moveNext();
          } catch (e, s) {
            controller.addErrorSync(e, s);
            controller.closeSync();
            return;
          }
          if (hasNext) {
            try {
              controller.addSync(iterator.current);
            } catch (e, s) {
              controller.addErrorSync(e, s);
            }
            if (controller.hasListener && !controller.isPaused) {
              zone.scheduleMicrotask(next);
            } else {
              isScheduled = false;
            }
          } else {
            controller.closeSync();
          }
        }

        controller.onResume = () {
          if (!isScheduled) {
            isScheduled = true;
            zone.scheduleMicrotask(next);
          }
        };

        zone.scheduleMicrotask(next);
      });
    }, true);
  }

  static QueryStatement<A, A> unique<A>(Query<A> query) {
    return QueryStatement._(query, (rows) {
      if (rows.hasNext) {
        final res = query.read.unsafeGet(rows.next(), 0);

        if (rows.hasNext) throw Exception('Expected exactly 1 row.');

        return res;
      } else {
        throw Exception('Expected exactly 1 row.');
      }
    });
  }

  IO<B> run(Database db) {
    if (_streaming) {
      // TODO: dispose ps when stream is finished ?
      return IO
          .delay(() => db.prepare(query.raw))
          .map((x) => _runIt(RIterator.fromDart(x.selectCursor())));
    } else {
      return IO.delay(() {
        return _runIt(RIterator.fromDart(db.select(query.raw).iterator));
      });
    }
  }
}
