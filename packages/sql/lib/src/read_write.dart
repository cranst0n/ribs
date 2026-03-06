import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A bidirectional codec that can both read and write values of type [A].
class ReadWrite<A> extends Read<A> with Write<A> {
  /// Codec used to read [Row] data into type [A].
  final Read<A> read;

  /// Codec used to write parameters of type [A] to a query or update statement.
  final Write<A> write;

  ReadWrite(this.read, this.write);

  @override
  IList<Get<dynamic>> get gets => read.gets;

  @override
  IList<Put<dynamic>> get puts => write.puts;

  @override
  StatementParameters setParameter(StatementParameters params, int n, A a) =>
      write.setParameter(params, n, a);

  @override
  A unsafeGet(Row row, int n) => read.unsafeGet(row, n);

  ReadWrite<Option<A>> optional() => ReadWrite(read.optional(), write.optional());

  ReadWrite<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      ReadWrite(read.map(f), write.contramap(g));

  ReadWrite<B> xemap<B>(Function1<A, Either<String, B>> f, Function1<B, A> g) =>
      ReadWrite(read.emap(f), write.contramap(g));

  static final ReadWrite<BigInt> bigInt = ReadWrite(Read.bigInt, Write.bigInt);
  static final ReadWrite<IList<int>> blob = ReadWrite(Read.blob, Write.blob);
  static final ReadWrite<bool> boolean = ReadWrite(Read.boolean, Write.boolean);
  static final ReadWrite<DateTime> dateTime = ReadWrite(Read.dateTime, Write.dateTime);
  static final ReadWrite<double> dubble = ReadWrite(Read.dubble, Write.dubble);
  static final ReadWrite<int> integer = ReadWrite(Read.integer, Write.integer);
  static final ReadWrite<Json> json = ReadWrite(Read.json, Write.json);
  static final ReadWrite<String> string = ReadWrite(Read.string, Write.string);
}
