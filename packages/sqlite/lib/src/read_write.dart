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

extension Tuple5ReadWriteOps<A, B, C, D, E> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>
) {
  ReadWrite<(A, B, C, D, E)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read, $4.read, $5.read).tupled,
        ($1.write, $2.write, $3.write, $4.write, $5.write).tupled,
      );
}

extension Tuple6ReadWriteOps<A, B, C, D, E, F> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>
) {
  ReadWrite<(A, B, C, D, E, F)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read).tupled,
        ($1.write, $2.write, $3.write, $4.write, $5.write, $6.write).tupled,
      );
}

extension Tuple7ReadWriteOps<A, B, C, D, E, F, G> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>
) {
  ReadWrite<(A, B, C, D, E, F, G)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read).tupled,
        ($1.write, $2.write, $3.write, $4.write, $5.write, $6.write, $7.write)
            .tupled,
      );
}

extension Tuple8ReadWriteOps<A, B, C, D, E, F, G, H> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>
) {
  ReadWrite<(A, B, C, D, E, F, G, H)> get tupled => ReadWrite(
        ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read, $8.read)
            .tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write
        ).tupled,
      );
}

extension Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write
        ).tupled,
      );
}

extension Tuple10ReadWriteOps<A, B, C, D, E, F, G, H, I, J> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write
        ).tupled,
      );
}

extension Tuple11ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>,
  ReadWrite<K>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
          $11.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write,
          $11.write,
        ).tupled,
      );
}

extension Tuple12ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>,
  ReadWrite<K>,
  ReadWrite<L>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
          $11.read,
          $12.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write,
          $11.write,
          $12.write,
        ).tupled,
      );
}

extension Tuple13ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>,
  ReadWrite<K>,
  ReadWrite<L>,
  ReadWrite<M>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
          $11.read,
          $12.read,
          $13.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write,
          $11.write,
          $12.write,
          $13.write,
        ).tupled,
      );
}

extension Tuple14ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>,
  ReadWrite<K>,
  ReadWrite<L>,
  ReadWrite<M>,
  ReadWrite<N>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> get tupled => ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
          $11.read,
          $12.read,
          $13.read,
          $14.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write,
          $11.write,
          $12.write,
          $13.write,
          $14.write,
        ).tupled,
      );
}

extension Tuple15ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
  ReadWrite<A>,
  ReadWrite<B>,
  ReadWrite<C>,
  ReadWrite<D>,
  ReadWrite<E>,
  ReadWrite<F>,
  ReadWrite<G>,
  ReadWrite<H>,
  ReadWrite<I>,
  ReadWrite<J>,
  ReadWrite<K>,
  ReadWrite<L>,
  ReadWrite<M>,
  ReadWrite<N>,
  ReadWrite<O>
) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled =>
      ReadWrite(
        (
          $1.read,
          $2.read,
          $3.read,
          $4.read,
          $5.read,
          $6.read,
          $7.read,
          $8.read,
          $9.read,
          $10.read,
          $11.read,
          $12.read,
          $13.read,
          $14.read,
          $15.read,
        ).tupled,
        (
          $1.write,
          $2.write,
          $3.write,
          $4.write,
          $5.write,
          $6.write,
          $7.write,
          $8.write,
          $9.write,
          $10.write,
          $11.write,
          $12.write,
          $13.write,
          $14.write,
          $15.write,
        ).tupled,
      );
}
