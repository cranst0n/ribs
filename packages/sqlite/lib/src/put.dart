import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';

abstract mixin class Put<A> {
  static Put<A> instance<A>(
    Function3<IStatementParameters, int, A, IStatementParameters> f,
  ) =>
      _PutF(f);

  IStatementParameters setParameter(IStatementParameters params, int n, A a);

  Put<B> contramap<B>(Function1<B, A> f) => _PutFContramap(this, f);

  static final Put<BigInt> bigInt = _genericPut();
  static final Put<DateTime> dateTime =
      string.contramap((dt) => dt.toIso8601String());
  static final Put<double> dubble = _genericPut();
  static final Put<int> integer = _genericPut();
  static final Put<Json> json =
      string.contramap((json) => Printer.noSpaces.print(json));
  static final Put<String> string = _genericPut();

  static Put<T> _genericPut<T>() =>
      Put.instance((params, n, value) => params.setParameter(n, value));
}

final class _PutF<A> extends Put<A> {
  final Function3<IStatementParameters, int, A, IStatementParameters> update;

  _PutF(this.update);

  @override
  IStatementParameters setParameter(IStatementParameters params, int n, A a) =>
      update(params, n, a);
}

final class _PutFContramap<A, B> extends Put<B> {
  final Put<A> put;
  final Function1<B, A> f;

  _PutFContramap(this.put, this.f);

  @override
  IStatementParameters setParameter(IStatementParameters params, int n, B a) =>
      put.setParameter(params, n, f(a));
}
