import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sql/ribs_sql.dart';

/// A bidirectional codec that can both read and write values of type [A].
class ReadWrite<A> extends Read<A> with Write<A> {
  /// Codec used to read [Row] data into type [A].
  final Read<A> read;

  /// Codec used to write parameters of type [A] to a query or update statement.
  final Write<A> write;

  /// Creates a [ReadWrite] by pairing a [Read] and [Write] codec.
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

  /// Returns a [ReadWrite] that treats `null` columns as [None] and
  /// encodes [None] as `null`.
  ReadWrite<Option<A>> optional() => ReadWrite(read.optional(), write.optional());

  /// Maps the read side with [f] and contramaps the write side with [g],
  /// producing a [ReadWrite] for a different type [B].
  ReadWrite<B> xmap<B>(Function1<A, B> f, Function1<B, A> g) =>
      ReadWrite(read.map(f), write.contramap(g));

  /// Like [xmap], but the read-side mapping [f] may fail with an error
  /// message (left) or succeed (right).
  ReadWrite<B> xemap<B>(Function1<A, Either<String, B>> f, Function1<B, A> g) =>
      ReadWrite(read.emap(f), write.contramap(g));

  /// Reads and writes a [BigInt] column.
  static final ReadWrite<BigInt> bigInt = ReadWrite(Read.bigInt, Write.bigInt);

  /// Reads and writes a binary blob column.
  static final ReadWrite<ByteVector> blob = ReadWrite(Read.blob, Write.blob);

  /// Reads and writes a boolean column.
  static final ReadWrite<bool> boolean = ReadWrite(Read.boolean, Write.boolean);

  /// Reads and writes a [DateTime] column.
  static final ReadWrite<DateTime> dateTime = ReadWrite(Read.dateTime, Write.dateTime);

  /// Reads and writes a [double] column.
  static final ReadWrite<double> dubble = ReadWrite(Read.dubble, Write.dubble);

  /// Reads and writes an [int] column.
  static final ReadWrite<int> integer = ReadWrite(Read.integer, Write.integer);

  /// Reads and writes a [Json] column.
  static final ReadWrite<Json> json = ReadWrite(Read.json, Write.json);

  /// Reads and writes a [String] column.
  static final ReadWrite<String> string = ReadWrite(Read.string, Write.string);
}
