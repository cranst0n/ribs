import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

abstract mixin class Read<A> {
  static Read<A> fromGet<A>(Get<A> get) =>
      Read.instance(ilist([get]), get.unsafeGet);

  static Read<A> instance<A>(
    IList<Get<dynamic>> gets,
    Function2<Row, int, A> unsafeGet,
  ) =>
      _ReadF(gets, unsafeGet);

  IList<Get<dynamic>> get gets;

  A unsafeGet(Row row, int n);

  Read<B> emap<B>(Function1<A, Either<String, B>> f) =>
      Read.instance(gets, (row, n) {
        final a = unsafeGet(row, n);

        return f(a).fold(
          (err) => throw Exception('Invalid value [$a]: $err'),
          identity,
        );
      });

  int get length => gets.length;

  Read<B> map<B>(Function1<A, B> f) =>
      Read.instance(gets, (row, n) => f(unsafeGet(row, n)));

  static Read<BigInt> bigInt = Read.fromGet(Get.bigInt);
  static Read<DateTime> dateTime = Read.fromGet(Get.dateTime);
  static Read<double> dubble = Read.fromGet(Get.dubble);
  static Read<int> integer = Read.fromGet(Get.integer);
  static Read<String> string = Read.fromGet(Get.string);
  static Read<Json> json = Read.fromGet(Get.json);
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
          () => row.columnAt(n) == null,
          () => unsafeGet(row, n),
        ),
      );
}

extension Tuple2ReadOps<A, B> on (Read<A>, Read<B>) {
  Read<(A, B)> get tupled => Read.instance(
        $1.gets.concat($2.gets),
        (row, n) => ($1.unsafeGet(row, n), $2.unsafeGet(row, n + $1.length)),
      );
}

extension Tuple3ReadOps<A, B, C> on (Read<A>, Read<B>, Read<C>) {
  Read<(A, B, C)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}

extension Tuple4ReadOps<A, B, C, D> on (Read<A>, Read<B>, Read<C>, Read<D>) {
  Read<(A, B, C, D)> get tupled {
    final initRead = init().tupled;

    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead
          .unsafeGet(row, n)
          .append(last.unsafeGet(row, n + initRead.length)),
    );
  }
}
