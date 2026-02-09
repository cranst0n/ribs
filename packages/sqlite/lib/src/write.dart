import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

abstract mixin class Write<A> {
  static Write<A> instance<A>(
    IList<Put<dynamic>> puts,
    Function3<IStatementParameters, int, A, IStatementParameters> f,
  ) => _WriteF(puts, f);

  static Write<A> fromPut<A>(Put<A> put) => Write.instance(ilist([put]), put.setParameter);

  Write<B> contramap<B>(Function1<B, A> f) =>
      Write.instance(puts, (params, n, value) => setParameter(params, n, f(value)));

  int get length => puts.length;

  IList<Put<dynamic>> get puts;

  IStatementParameters setParameter(IStatementParameters params, int n, A a);

  static final unit = Write.instance<Unit>(nil(), (params, _, _) => params);

  static final bigInt = Write.fromPut(Put.bigInt);
  static final blob = Write.fromPut(Put.blob);
  static final boolean = Write.fromPut(Put.boolean);
  static final dateTime = Write.fromPut(Put.dateTime);
  static final dubble = Write.fromPut(Put.dubble);
  static final integer = Write.fromPut(Put.integer);
  static final string = Write.fromPut(Put.string);
  static final json = Write.fromPut(Put.json);
}

extension WriteOptionOps<A> on Write<A> {
  Write<Option<A>> optional() => Write.instance(
    puts,
    (params, n, a) => a.fold(
      () => params.setParameter(n + length - 1, null),
      (some) => setParameter(params, n, some),
    ),
  );
}

final class _WriteF<A> extends Write<A> {
  @override
  final IList<Put<dynamic>> puts;
  final Function3<IStatementParameters, int, A, IStatementParameters> setParameterF;

  _WriteF(this.puts, this.setParameterF);

  @override
  IStatementParameters setParameter(IStatementParameters params, int n, A a) =>
      setParameterF(params, n, a);
}

extension Tuple2WriteOps<A, B> on (Write<A>, Write<B>) {
  Write<(A, B)> get tupled => Write.instance(
    ilist([$1.puts, $2.puts]).flatten(),
    (params, n, tuple) {
      final p0 = $1.setParameter(params, n, tuple.$1);
      return $2.setParameter(p0, n + $1.length, tuple.$2);
    },
  );
}

extension Tuple3WriteOps<A, B, C> on (Write<A>, Write<B>, Write<C>) {
  Write<(A, B, C)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple4WriteOps<A, B, C, D> on (Write<A>, Write<B>, Write<C>, Write<D>) {
  Write<(A, B, C, D)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple5WriteOps<A, B, C, D, E> on (Write<A>, Write<B>, Write<C>, Write<D>, Write<E>) {
  Write<(A, B, C, D, E)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple6WriteOps<A, B, C, D, E, F>
    on (Write<A>, Write<B>, Write<C>, Write<D>, Write<E>, Write<F>) {
  Write<(A, B, C, D, E, F)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple7WriteOps<A, B, C, D, E, F, G>
    on (Write<A>, Write<B>, Write<C>, Write<D>, Write<E>, Write<F>, Write<G>) {
  Write<(A, B, C, D, E, F, G)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple8WriteOps<A, B, C, D, E, F, G, H>
    on (Write<A>, Write<B>, Write<C>, Write<D>, Write<E>, Write<F>, Write<G>, Write<H>) {
  Write<(A, B, C, D, E, F, G, H)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple9WriteOps<A, B, C, D, E, F, G, H, I>
    on (Write<A>, Write<B>, Write<C>, Write<D>, Write<E>, Write<F>, Write<G>, Write<H>, Write<I>) {
  Write<(A, B, C, D, E, F, G, H, I)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple10WriteOps<A, B, C, D, E, F, G, H, I, J>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple11WriteOps<A, B, C, D, E, F, G, H, I, J, K>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
          Write<K>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J, K)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple12WriteOps<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
          Write<K>,
          Write<L>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J, K, L)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple13WriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
          Write<K>,
          Write<L>,
          Write<M>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J, K, L, M)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple14WriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
          Write<K>,
          Write<L>,
          Write<M>,
          Write<N>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}

extension Tuple15WriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
          Write<A>,
          Write<B>,
          Write<C>,
          Write<D>,
          Write<E>,
          Write<F>,
          Write<G>,
          Write<H>,
          Write<I>,
          Write<J>,
          Write<K>,
          Write<L>,
          Write<M>,
          Write<N>,
          Write<O>,
        ) {
  Write<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}
