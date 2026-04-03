import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/src/row.dart';

/// Describes how to read a value of type [A] from a single column position
/// in a database result [Row].
abstract mixin class Get<A> {
  /// Creates a [Get] from a function that extracts a value from a [Row]
  /// at column index [n].
  static Get<A> instance<A>(Function2<Row, int, A> f) => _GetF(f);

  /// Extracts a value of type [A] from [row] at column index [n].
  ///
  /// This is considered "unsafe" because it may throw if the column is
  /// missing or contains an incompatible type.
  A unsafeGet(Row row, int n);

  /// Transforms the decoded value by applying [f].
  Get<B> map<B>(Function1<A, B> f) => _MapGet(this, f);

  /// Transforms the decoded value with [f], which may fail with an error
  /// message (left) or succeed with a new value (right).
  Get<B> emap<B>(Function1<A, Either<String, B>> f) => _EmapGet(this, f);

  /// Reads a [BigInt] from a single column.
  static final Get<BigInt> bigInt = _genericGet();

  /// Reads a binary blob from a single column.
  static final Get<ByteVector> blob = _genericGet<List<int>>().map(ByteVector.fromDart);

  /// Reads a boolean from a single column (stored as 0/1 integer).
  static final Get<bool> boolean = integer.map((i) => i != 0);

  /// Reads a [DateTime] from a single column (stored as an ISO 8601 string).
  static final Get<DateTime> dateTime = string.emap(
    (str) => Either.catching(
      () => DateTime.parse(str),
      (err, _) => err.toString(),
    ),
  );

  /// Reads a [double] from a single column.
  static final Get<double> dubble = _genericGet();

  /// Reads an [int] from a single column.
  static final Get<int> integer = _genericGet();

  /// Reads a [String] from a single column.
  static final Get<String> string = _genericGet();

  /// Reads a [Json] value from a single column (stored as a JSON string).
  static final Get<Json> json = string.emap(
    (str) => Json.parse(str).leftMap((failure) => failure.message),
  );

  static Get<T> _genericGet<T>() {
    return Get.instance((row, n) {
      if (n < row.length) {
        final value = row[n];

        if (value is T) {
          return value;
        } else {
          throw Exception(
            'Unexpected type ${value.runtimeType} at column $n. Expected type |$T|',
          );
        }
      } else {
        throw RangeError('Invalid column index ($n) (max = ${row.length - 1})');
      }
    });
  }
}

final class _GetF<A> extends Get<A> {
  final Function2<Row, int, A> f;

  _GetF(this.f);

  @override
  A unsafeGet(Row row, int n) => f(row, n);
}

final class _MapGet<A, B> extends Get<B> {
  final Get<A> get;
  final Function1<A, B> f;

  _MapGet(this.get, this.f);

  @override
  B unsafeGet(Row row, int n) => f(get.unsafeGet(row, n));
}

final class _EmapGet<A, B> extends Get<B> {
  final Get<A> get;
  final Function1<A, Either<String, B>> f;

  _EmapGet(this.get, this.f);

  @override
  B unsafeGet(Row row, int n) => f(get.unsafeGet(row, n)).fold(
    (err) => throw Exception(err),
    (b) => b,
  );
}
