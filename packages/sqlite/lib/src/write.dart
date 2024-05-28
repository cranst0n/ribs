import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

abstract mixin class Write<A> {
  static Write<A> instance<A>(
    IList<Put<dynamic>> puts,
    Function3<IStatementParameters, int, A, IStatementParameters> f,
  ) =>
      _WriteF(puts, f);

  static Write<A> fromPut<A>(Put<A> put) =>
      Write.instance(ilist([put]), put.setParameter);

  Write<B> contramap<B>(Function1<B, A> f) => Write.instance(
      puts, (params, n, value) => setParameter(params, n, f(value)));

  int get length => puts.length;

  IList<Put<dynamic>> get puts;

  IStatementParameters setParameter(IStatementParameters params, int n, A a);

  static final unit = Write.instance<Unit>(nil(), (params, _, __) => params);

  static final bigInt = Write.fromPut(Put.bigInt);
  static final dateTime = Write.fromPut(Put.dateTime);
  static final dubble = Write.fromPut(Put.dubble);
  static final integer = Write.fromPut(Put.integer);
  static final string = Write.fromPut(Put.string);
  static final json = Write.fromPut(Put.json);
}

extension WriteOptionOps<A> on Write<A> {
  Write<Option<A>> optional() => Write.instance(
        puts,
        (params, n, a) => params.setParameter(n, a.toNullable()),
      );
}

final class _WriteF<A> extends Write<A> {
  @override
  final IList<Put<dynamic>> puts;
  final Function3<IStatementParameters, int, A, IStatementParameters>
      setParameterF;

  _WriteF(this.puts, this.setParameterF);

  @override
  IStatementParameters setParameter(IStatementParameters params, int n, A a) =>
      setParameterF(params, n, a);
}

extension Tuple2WriteOps<A, B> on (Write<A>, Write<B>) {
  Write<(A, B)> get tupled => Write.instance(
        ilist([$1.puts, $2.puts]).flatten(),
        (params, n, tuple) {
          final p0 = $1.setParameter(params, 0, tuple.$1);
          return $2.setParameter(p0, $1.length, tuple.$2);
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

extension Tuple4WriteOps<A, B, C, D> on (
  Write<A>,
  Write<B>,
  Write<C>,
  Write<D>
) {
  Write<(A, B, C, D)> get tupled {
    final initWrite = init().tupled;

    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init());
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}