import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/src/get.dart';
import 'package:ribs_sql/src/row.dart';

/// Describes how to read a value of type [A] from a database result [Row].
/// A [Read] may consume multiple columns.
abstract mixin class Read<A> {
  static Read<A> fromGet<A>(Get<A> get) => Read.instance(ilist([get]), get.unsafeGet);

  static Read<A> instance<A>(
    IList<Get<dynamic>> gets,
    Function2<Row, int, A> unsafeGet,
  ) => _ReadF(gets, unsafeGet);

  IList<Get<dynamic>> get gets;

  A unsafeGet(Row row, int n);

  int get length => gets.length;

  Read<B> map<B>(Function1<A, B> f) => Read.instance(gets, (row, n) => f(unsafeGet(row, n)));

  Read<B> emap<B>(Function1<A, Either<String, B>> f) => Read.instance(gets, (row, n) {
    final a = unsafeGet(row, n);
    return f(a).fold(
      (err) => throw Exception('Invalid value [$a]: $err'),
      identity,
    );
  });

  static final Read<BigInt> bigInt = Read.fromGet(Get.bigInt);
  static final Read<IList<int>> blob = Read.fromGet(Get.blob);
  static final Read<bool> boolean = Read.fromGet(Get.boolean);
  static final Read<DateTime> dateTime = Read.fromGet(Get.dateTime);
  static final Read<double> dubble = Read.fromGet(Get.dubble);
  static final Read<int> integer = Read.fromGet(Get.integer);
  static final Read<String> string = Read.fromGet(Get.string);
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

extension ReadOptionOps<A> on Read<A> {
  Read<Option<A>> optional() => Read.instance(
    gets,
    (row, n) => Option.unless(
      () => n >= row.length || row[n] == null,
      () => unsafeGet(row, n),
    ),
  );
}
