import 'package:ribs_sql/ribs_sql.dart';

extension Tuple2ReadWriteOps<A, B> on (ReadWrite<A>, ReadWrite<B>) {
  ReadWrite<(A, B)> get tupled => ReadWrite(($1.read, $2.read).tupled, ($1.write, $2.write).tupled);
}

extension Tuple3ReadWriteOps<A, B, C> on (ReadWrite<A>, ReadWrite<B>, ReadWrite<C>) {
  ReadWrite<(A, B, C)> get tupled =>
      ReadWrite(($1.read, $2.read, $3.read).tupled, ($1.write, $2.write, $3.write).tupled);
}

extension Tuple4ReadWriteOps<A, B, C, D>
    on (ReadWrite<A>, ReadWrite<B>, ReadWrite<C>, ReadWrite<D>) {
  ReadWrite<(A, B, C, D)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read).tupled,
    ($1.write, $2.write, $3.write, $4.write).tupled,
  );
}

extension Tuple5ReadWriteOps<A, B, C, D, E>
    on (ReadWrite<A>, ReadWrite<B>, ReadWrite<C>, ReadWrite<D>, ReadWrite<E>) {
  ReadWrite<(A, B, C, D, E)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read, $5.read).tupled,
    ($1.write, $2.write, $3.write, $4.write, $5.write).tupled,
  );
}

extension Tuple6ReadWriteOps<A, B, C, D, E, F>
    on (ReadWrite<A>, ReadWrite<B>, ReadWrite<C>, ReadWrite<D>, ReadWrite<E>, ReadWrite<F>) {
  ReadWrite<(A, B, C, D, E, F)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read).tupled,
    ($1.write, $2.write, $3.write, $4.write, $5.write, $6.write).tupled,
  );
}

extension Tuple7ReadWriteOps<A, B, C, D, E, F, G>
    on
        (
          ReadWrite<A>,
          ReadWrite<B>,
          ReadWrite<C>,
          ReadWrite<D>,
          ReadWrite<E>,
          ReadWrite<F>,
          ReadWrite<G>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read).tupled,
    ($1.write, $2.write, $3.write, $4.write, $5.write, $6.write, $7.write).tupled,
  );
}

extension Tuple8ReadWriteOps<A, B, C, D, E, F, G, H>
    on
        (
          ReadWrite<A>,
          ReadWrite<B>,
          ReadWrite<C>,
          ReadWrite<D>,
          ReadWrite<E>,
          ReadWrite<F>,
          ReadWrite<G>,
          ReadWrite<H>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read, $8.read).tupled,
    ($1.write, $2.write, $3.write, $4.write, $5.write, $6.write, $7.write, $8.write).tupled,
  );
}

extension Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I>
    on
        (
          ReadWrite<A>,
          ReadWrite<B>,
          ReadWrite<C>,
          ReadWrite<D>,
          ReadWrite<E>,
          ReadWrite<F>,
          ReadWrite<G>,
          ReadWrite<H>,
          ReadWrite<I>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I)> get tupled => ReadWrite(
    ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read, $8.read, $9.read).tupled,
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
    ).tupled,
  );
}

extension Tuple10ReadWriteOps<A, B, C, D, E, F, G, H, I, J>
    on
        (
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
      $10.write,
    ).tupled,
  );
}

extension Tuple11ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K>
    on
        (
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

extension Tuple12ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
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

extension Tuple13ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
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

extension Tuple14ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
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

extension Tuple15ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
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
          ReadWrite<O>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled => ReadWrite(
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

extension Tuple16ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> get tupled => ReadWrite(
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
      $16.read,
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
      $16.write,
    ).tupled,
  );
}

extension Tuple17ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> get tupled => ReadWrite(
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
      $16.read,
      $17.read,
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
      $16.write,
      $17.write,
    ).tupled,
  );
}

extension Tuple18ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
          ReadWrite<R>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> get tupled => ReadWrite(
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
      $16.read,
      $17.read,
      $18.read,
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
      $16.write,
      $17.write,
      $18.write,
    ).tupled,
  );
}

extension Tuple19ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
          ReadWrite<R>,
          ReadWrite<S>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> get tupled => ReadWrite(
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
      $16.read,
      $17.read,
      $18.read,
      $19.read,
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
      $16.write,
      $17.write,
      $18.write,
      $19.write,
    ).tupled,
  );
}

extension Tuple20ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
          ReadWrite<R>,
          ReadWrite<S>,
          ReadWrite<T>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)> get tupled => ReadWrite(
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
      $16.read,
      $17.read,
      $18.read,
      $19.read,
      $20.read,
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
      $16.write,
      $17.write,
      $18.write,
      $19.write,
      $20.write,
    ).tupled,
  );
}

extension Tuple21ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
          ReadWrite<R>,
          ReadWrite<S>,
          ReadWrite<T>,
          ReadWrite<U>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)> get tupled =>
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
          $16.read,
          $17.read,
          $18.read,
          $19.read,
          $20.read,
          $21.read,
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
          $16.write,
          $17.write,
          $18.write,
          $19.write,
          $20.write,
          $21.write,
        ).tupled,
      );
}

extension Tuple22ReadWriteOps<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    on
        (
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
          ReadWrite<O>,
          ReadWrite<P>,
          ReadWrite<Q>,
          ReadWrite<R>,
          ReadWrite<S>,
          ReadWrite<T>,
          ReadWrite<U>,
          ReadWrite<V>,
        ) {
  ReadWrite<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)> get tupled =>
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
          $16.read,
          $17.read,
          $18.read,
          $19.read,
          $20.read,
          $21.read,
          $22.read,
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
          $16.write,
          $17.write,
          $18.write,
          $19.write,
          $20.write,
          $21.write,
          $22.write,
        ).tupled,
      );
}
