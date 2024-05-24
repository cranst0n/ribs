import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class ReadWrite<A> extends Read<A> with Write<A> {
  final Read<A> read;
  final Write<A> write;

  ReadWrite(this.read, this.write);

  @override
  IList<Get<dynamic>> get gets => read.gets;

  ReadWrite<Option<A>> optional() =>
      ReadWrite(read.optional(), write.optional());

  @override
  IList<Put<dynamic>> get puts => write.puts;

  @override
  IStatementParameters setParameter(IStatementParameters params, int n, A a) =>
      write.setParameter(params, n, a);

  @override
  A unsafeGet(Row row, int n) => read.unsafeGet(row, n);

  ReadWrite<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      ReadWrite(read.map(f), write.contramap(g));

  ReadWrite<B> xemap<B>(Function1<A, Either<String, B>> f, Function1<B, A> g) =>
      ReadWrite(read.emap(f), write.contramap(g));

  static final bigInt = ReadWrite(Read.bigInt, Write.bigInt);
  static final dateTime = ReadWrite(Read.dateTime, Write.dateTime);
  static final dubble = ReadWrite(Read.dubble, Write.dubble);
  static final integer = ReadWrite(Read.integer, Write.integer);
  static final json = ReadWrite(Read.json, Write.json);
  static final string = ReadWrite(Read.string, Write.string);
}

extension Tuple2ReadWriteOps<A, B> on (ReadWrite<A>, ReadWrite<B>) {
  ReadWrite<(A, B)> get tupled =>
      ReadWrite(($1.read, $2.read).tupled, ($1.write, $2.write).tupled);
}

extension Tuple3ReadWriteOps<A, B, C> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>
) {
  ReadWrite<(A, B, C)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read).tupled,
        ($1.write, $2.write, $3.write).tupled,
      );
}

extension Tuple4ReadWriteOps<A, B, C, D> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>
) {
  ReadWrite<(A, B, C, D)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read, $4.read).tupled,
        ($1.write, $2.write, $3.write, $4.write).tupled,
      );
}
