import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

abstract mixin class Read<A> {
  static Read<A> fromGet<A>(Get<A> get) =>
      Read.instance(ilist([get]), get.unsafeGet);

  static Read<A> instance<A>(
    IList<Get<dynamic>> gets,
    Function2<Row, int, A> unsafeGet,
  ) =>
      _ReadF(gets, unsafeGet);

  IList<Get<dynamic>> get gets;

  A unsafeGet(Row row, int n);

  Read<B> emap<B>(Function1<A, Either<String, B>> f) =>
      Read.instance(gets, (row, n) {
        final a = unsafeGet(row, n);

        return f(a).fold(
          (err) => throw Exception('Invalid value [$a]: $err'),
          identity,
        );
      });

  int get length => gets.length;

  Read<B> map<B>(Function1<A, B> f) =>
      Read.instance(gets, (row, n) => f(unsafeGet(row, n)));

  static Read<BigInt> bigInt = Read.fromGet(Get.bigInt);
  static Read<DateTime> dateTime = Read.fromGet(Get.dateTime);
  static Read<double> dubble = Read.fromGet(Get.dubble);
  static Read<int> integer = Read.fromGet(Get.integer);
  static Read<String> string = Read.fromGet(Get.string);
  static Read<Json> json = Read.fromGet(Get.json);
}

final class _ReadF<A> extends Read<A> {
  @override
  final IList<Get<dynamic>> gets;

  final Function2<Row, int, A> unsafeGetF;

  _ReadF(this.gets, this.unsafeGetF);

  @override
  A unsafeGet(Row row, int n) => unsafeGetF(row, n);
}

extension ReadOptionOps<A> on Read<A> {
  Read<Option<A>> optional() => Read.instance(
        gets,
        (row, n) => Option.unless(
          () => row.columnAt(n) == null,
          () => unsafeGet(row, n),
        ),
      );
}

extension Tuple2ReadOps<A, B> on (Read<A>, Read<B>) {
  Read<(A, B)> get tupled => Read.instance(
        $1.gets.concat($2.gets),
        (row, n) => ($1.unsafeGet(row, n), $2.unsafeGet(row, n + $1.length)),
      );
}

extension Tuple3ReadOps<A, B, C> on (Read<A>, Read<B>, Read<C>) {
  Read<(A, B, C)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple4ReadOps<A, B, C, D> on (Read<A>, Read<B>, Read<C>, Read<D>) {
  Read<(A, B, C, D)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple5ReadOps<A, B, C, D, E> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>
) {
  Read<(A, B, C, D, E)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple6ReadOps<A, B, C, D, E, F> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>
) {
  Read<(A, B, C, D, E, F)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple7ReadOps<A, B, C, D, E, F, G> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>
) {
  Read<(A, B, C, D, E, F, G)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple8ReadOps<A, B, C, D, E, F, G, H> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>
) {
  Read<(A, B, C, D, E, F, G, H)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple9ReadOps<A, B, C, D, E, F, G, H, I> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>
) {
  Read<(A, B, C, D, E, F, G, H, I)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple10ReadOps<A, B, C, D, E, F, G, H, I, J> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>
) {
  Read<(A, B, C, D, E, F, G, H, I, J)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple11ReadOps<A, B, C, D, E, F, G, H, I, J, K> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>,
  Read<K>
) {
  Read<(A, B, C, D, E, F, G, H, I, J, K)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple12ReadOps<A, B, C, D, E, F, G, H, I, J, K, L> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>,
  Read<K>,
  Read<L>
) {
  Read<(A, B, C, D, E, F, G, H, I, J, K, L)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple13ReadOps<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>,
  Read<K>,
  Read<L>,
  Read<M>
) {
  Read<(A, B, C, D, E, F, G, H, I, J, K, L, M)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple14ReadOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>,
  Read<K>,
  Read<L>,
  Read<M>,
  Read<N>
) {
  Read<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple15ReadOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  Read<A>,
  Read<B>,
  Read<C>,
  Read<D>,
  Read<E>,
  Read<F>,
  Read<G>,
  Read<H>,
  Read<I>,
  Read<J>,
  Read<K>,
  Read<L>,
  Read<M>,
  Read<N>,
  Read<O>
) {
  Read<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}
