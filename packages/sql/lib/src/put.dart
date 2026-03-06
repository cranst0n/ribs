import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Describes how to encode a value of type [A] into a SQL parameter slot.
abstract mixin class Put<A> {
  static Put<A> instance<A>(Object? Function(A) encoder) => _PutF(encoder);

  /// Encodes [value] to a raw SQL parameter value.
  Object? encode(A value);

  /// Sets the parameter at position [n] in [params], returning updated params.
  StatementParameters setParameter(StatementParameters params, int n, A value) =>
      params.setParameter(n, value);

  Put<B> contramap<B>(Function1<B, A> f) => _ContramapPut(this, f);

  static final Put<BigInt> bigInt = instance((v) => v);
  static final Put<IList<int>> blob = instance<List<int>>(
    (v) => v,
  ).contramap<IList<int>>((il) => il.toList());
  static final Put<bool> boolean = integer.contramap((b) => b ? 1 : 0);
  static final Put<DateTime> dateTime = string.contramap((dt) => dt.toIso8601String());
  static final Put<double> dubble = instance((v) => v);
  static final Put<int> integer = instance((v) => v);
  static final Put<Json> json = string.contramap((json) => Printer.noSpaces.print(json));
  static final Put<String> string = instance((v) => v);
}

final class _PutF<A> extends Put<A> {
  final Object? Function(A) encoder;

  _PutF(this.encoder);

  @override
  Object? encode(A value) => encoder(value);
}

final class _ContramapPut<A, B> extends Put<B> {
  final Put<A> put;
  final Function1<B, A> f;

  _ContramapPut(this.put, this.f);

  @override
  Object? encode(B value) => put.encode(f(value));
}
