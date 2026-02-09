import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:sqlite3/sqlite3.dart';

abstract mixin class Get<A> {
  static Get<A> instance<A>(Function2<Row, int, A> f) => _GetF(f);

  A unsafeGet(Row row, int n);

  Get<B> emap<B>(Function1<A, Either<String, B>> f) => _EmapGet(this, f);

  Get<B> map<B>(Function1<A, B> f) => _MapGet(this, f);

  static final Get<BigInt> bigInt = _genericGet();
  static final Get<IList<int>> blob = _genericGet<List<int>>().map(IList.fromDart);
  static final Get<bool> boolean = integer.map((i) => i != 0);
  static final Get<DateTime> dateTime =
      string.emap((str) => Either.catching(() => DateTime.parse(str), (err, _) => err.toString()));
  static final Get<double> dubble = _genericGet();
  static final Get<int> integer = _genericGet();
  static final Get<String> string = _genericGet();
  static final Get<Json> json =
      string.emap((str) => Json.parse(str).leftMap((failure) => failure.message));

  static Get<T> _genericGet<T>() {
    return Get.instance(
      (row, n) {
        if (row.length > n) {
          final value = row.columnAt(n);

          if (value is T) {
            return value;
          } else {
            throw Exception(
              'Unexpected type ${value.runtimeType} at column $n. Expected type |$T|',
            );
          }
        } else {
          throw RangeError('Invalid column index ($n) (max = ${row.length})');
        }
      },
    );
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
