import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/src/get.dart';
import 'package:ribs_sql/src/row.dart';

/// Describes how to read a value of type [A] from a database result [Row].
/// A [Read] may consume multiple columns.
abstract mixin class Read<A> {
  /// Creates a [Read] from a single-column [Get].
  static Read<A> fromGet<A>(Get<A> get) => Read.instance(ilist([get]), get.unsafeGet);

  /// Creates a [Read] from a list of [Get] decoders and an extraction
  /// function that reads from [Row] at a starting column index.
  static Read<A> instance<A>(
    IList<Get<dynamic>> gets,
    Function2<Row, int, A> unsafeGet,
  ) => _ReadF(gets, unsafeGet);

  /// The individual column [Get] decoders that make up this [Read].
  IList<Get<dynamic>> get gets;

  /// Extracts a value of type [A] from [row] starting at column index [n].
  ///
  /// May throw if columns are missing or contain incompatible types.
  A unsafeGet(Row row, int n);

  /// The number of columns consumed by this [Read].
  int get length => gets.length;

  /// Transforms the decoded value by applying [f].
  Read<B> map<B>(Function1<A, B> f) => Read.instance(gets, (row, n) => f(unsafeGet(row, n)));

  /// Transforms the decoded value with [f], which may fail with an error
  /// message (left) or succeed with a new value (right).
  Read<B> emap<B>(Function1<A, Either<String, B>> f) => Read.instance(gets, (row, n) {
    final a = unsafeGet(row, n);
    return f(a).fold(
      (err) => throw Exception('Invalid value [$a]: $err'),
      identity,
    );
  });

  /// Reads a [BigInt] from a single column.
  static final Read<BigInt> bigInt = Read.fromGet(Get.bigInt);

  /// Reads a binary blob from a single column.
  static final Read<ByteVector> blob = Read.fromGet(Get.blob);

  /// Reads a boolean from a single column.
  static final Read<bool> boolean = Read.fromGet(Get.boolean);

  /// Reads a [DateTime] from a single column.
  static final Read<DateTime> dateTime = Read.fromGet(Get.dateTime);

  /// Reads a [double] from a single column.
  static final Read<double> dubble = Read.fromGet(Get.dubble);

  /// Reads an [int] from a single column.
  static final Read<int> integer = Read.fromGet(Get.integer);

  /// Reads a [String] from a single column.
  static final Read<String> string = Read.fromGet(Get.string);

  /// Reads a [Json] value from a single column.
  static final Read<Json> json = Read.fromGet(Get.json);
}

final class _ReadF<A> extends Read<A> {
  @override
  final IList<Get<dynamic>> gets;

  final Function2<Row, int, A> unsafeGetF;

  _ReadF(this.gets, this.unsafeGetF);

  @override
  A unsafeGet(Row row, int n) => unsafeGetF(row, n);
}

/// Adds nullable column support to [Read].
extension ReadOptionOps<A> on Read<A> {
  /// Returns a [Read] that produces [None] when the column is `null` or
  /// out of range, and [Some] with the decoded value otherwise.
  Read<Option<A>> optional() => Read.instance(
    gets,
    (row, n) => Option.unless(
      () => n >= row.length || row[n] == null,
      () => unsafeGet(row, n),
    ),
  );
}
