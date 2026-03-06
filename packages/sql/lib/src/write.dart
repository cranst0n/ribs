import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Describes how to encode a value of type [A] into SQL parameter slots.
/// A [Write] may occupy multiple parameter positions.
abstract mixin class Write<A> {
  static Write<A> fromPut<A>(Put<A> put) => Write.instance(
    ilist([put]),
    (params, n, value) => put.setParameter(params, n, value),
  );

  static Write<A> instance<A>(
    IList<Put<dynamic>> puts,
    Function3<StatementParameters, int, A, StatementParameters> f,
  ) => _WriteF(puts, f);

  IList<Put<dynamic>> get puts;

  StatementParameters setParameter(StatementParameters params, int n, A a);

  int get length => puts.length;

  Write<B> contramap<B>(Function1<B, A> f) => Write.instance(
    puts,
    (params, n, value) => setParameter(params, n, f(value)),
  );

  /// Encodes [value] to a [StatementParameters].
  StatementParameters encode(A value) => setParameter(StatementParameters.empty(), 0, value);

  static final Write<Unit> unit = Write.instance(nil(), (params, _, _) => params);

  static final Write<BigInt> bigInt = Write.fromPut(Put.bigInt);
  static final Write<IList<int>> blob = Write.fromPut(Put.blob);
  static final Write<bool> boolean = Write.fromPut(Put.boolean);
  static final Write<DateTime> dateTime = Write.fromPut(Put.dateTime);
  static final Write<double> dubble = Write.fromPut(Put.dubble);
  static final Write<int> integer = Write.fromPut(Put.integer);
  static final Write<String> string = Write.fromPut(Put.string);
  static final Write<Json> json = Write.fromPut(Put.json);
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
  final Function3<StatementParameters, int, A, StatementParameters> setParameterF;

  _WriteF(this.puts, this.setParameterF);

  @override
  StatementParameters setParameter(StatementParameters params, int n, A a) =>
      setParameterF(params, n, a);
}
