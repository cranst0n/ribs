import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Describes how to encode a value of type [A] into a SQL parameter slot.
abstract mixin class Put<A> {
  /// Creates a [Put] from an [encoder] function that converts [A] to a
  /// raw SQL parameter value.
  static Put<A> instance<A>(Object? Function(A) encoder) => _PutF(encoder);

  /// Encodes [value] to a raw SQL parameter value.
  Object? encode(A value);

  /// Sets the parameter at position [n] in [params], returning updated params.
  StatementParameters setParameter(StatementParameters params, int n, A value) =>
      params.setParameter(n, value);

  /// Adapts this [Put] to accept a different type [B] by applying [f]
  /// before encoding.
  Put<B> contramap<B>(Function1<B, A> f) => _ContramapPut(this, f);

  /// Encodes a [BigInt] parameter.
  static final Put<BigInt> bigInt = instance((v) => v);

  /// Encodes a binary blob.
  static final Put<ByteVector> blob = instance<List<int>>(
    (v) => v,
  ).contramap<ByteVector>((bv) => bv.toByteArray());

  /// Encodes a boolean parameter (stored as 0/1 integer).
  static final Put<bool> boolean = integer.contramap((b) => b ? 1 : 0);

  /// Encodes a [DateTime] parameter (stored as an ISO 8601 string).
  static final Put<DateTime> dateTime = string.contramap((dt) => dt.toIso8601String());

  /// Encodes a [double] parameter.
  static final Put<double> dubble = instance((v) => v);

  /// Encodes an [int] parameter.
  static final Put<int> integer = instance((v) => v);

  /// Encodes a [Json] value parameter (stored as a JSON string).
  static final Put<Json> json = string.contramap((json) => Printer.noSpaces.print(json));

  /// Encodes a [String] parameter.
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
