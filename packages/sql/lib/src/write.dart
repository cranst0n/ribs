import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// Describes how to encode a value of type [A] into SQL parameter slots.
/// A [Write] may occupy multiple parameter positions.
abstract mixin class Write<A> {
  /// Creates a [Write] from a single-column [Put].
  static Write<A> fromPut<A>(Put<A> put) => Write.instance(
    ilist([put]),
    (params, n, value) => put.setParameter(params, n, value),
  );

  /// Creates a [Write] from a list of [Put] encoders and a function that
  /// sets parameter values in [StatementParameters] starting at index [n].
  static Write<A> instance<A>(
    IList<Put<dynamic>> puts,
    Function3<StatementParameters, int, A, StatementParameters> f,
  ) => _WriteF(puts, f);

  /// The individual column [Put] encoders that make up this [Write].
  IList<Put<dynamic>> get puts;

  /// Sets the parameter at position [n] in [params] to the encoded form
  /// of [a], returning updated parameters.
  StatementParameters setParameter(StatementParameters params, int n, A a);

  /// The number of parameter slots occupied by this [Write].
  int get length => puts.length;

  /// Adapts this [Write] to accept a different type [B] by applying [f]
  /// before encoding.
  Write<B> contramap<B>(Function1<B, A> f) => Write.instance(
    puts,
    (params, n, value) => setParameter(params, n, f(value)),
  );

  /// Encodes [value] to a [StatementParameters].
  StatementParameters encode(A value) => setParameter(StatementParameters.empty(), 0, value);

  /// A [Write] that occupies no parameter slots. Useful as an identity
  /// for composing writes.
  static final Write<Unit> unit = Write.instance(nil(), (params, _, _) => params);

  /// Encodes a [BigInt] parameter.
  static final Write<BigInt> bigInt = Write.fromPut(Put.bigInt);

  /// Encodes a binary blob.
  static final Write<ByteVector> blob = Write.fromPut(Put.blob);

  /// Encodes a boolean parameter.
  static final Write<bool> boolean = Write.fromPut(Put.boolean);

  /// Encodes a [DateTime] parameter.
  static final Write<DateTime> dateTime = Write.fromPut(Put.dateTime);

  /// Encodes a [double] parameter.
  static final Write<double> dubble = Write.fromPut(Put.dubble);

  /// Encodes an [int] parameter.
  static final Write<int> integer = Write.fromPut(Put.integer);

  /// Encodes a [String] parameter.
  static final Write<String> string = Write.fromPut(Put.string);

  /// Encodes a [Json] value parameter.
  static final Write<Json> json = Write.fromPut(Put.json);
}

/// Adds nullable column support to [Write].
extension WriteOptionOps<A> on Write<A> {
  /// Returns a [Write] that encodes [None] as `null` and [Some] with the
  /// underlying encoder.
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
