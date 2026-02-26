import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

@isTest
void _forAll<T>(
  String description,
  Gen<T> gen,
  TestBody<T> testBody, {
  int? numTests,
  int? seed,
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) => Prop(description, gen, testBody).run(
  numTests: numTests,
  seed: seed,
  testOn: testOn,
  timeout: timeout,
  skip: skip,
  tags: tags,
  onPlatform: onPlatform,
  retry: retry,
);

extension PropOps<A> on Gen<A> {
  @isTest
  void forAll(
    String description,
    Function1<A, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll(
    description,
    this,
    testBody,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple2Ops<A, B> on (Gen<A>, Gen<B>) {
  @isTest
  void forAll(
    String description,
    Function2<A, B, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B)>(
    description,
    ($1, $2).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple3Ops<A, B, C> on (Gen<A>, Gen<B>, Gen<C>) {
  @isTest
  void forAll(
    String description,
    Function3<A, B, C, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C)>(
    description,
    ($1, $2, $3).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple4Ops<A, B, C, D> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>) {
  @isTest
  void forAll(
    String description,
    Function4<A, B, C, D, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D)>(
    description,
    ($1, $2, $3, $4).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple5Ops<A, B, C, D, E> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>) {
  @isTest
  void forAll(
    String description,
    Function5<A, B, C, D, E, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E)>(
    description,
    ($1, $2, $3, $4, $5).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple6Ops<A, B, C, D, E, F> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>) {
  @isTest
  void forAll(
    String description,
    Function6<A, B, C, D, E, F, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F)>(
    description,
    ($1, $2, $3, $4, $5, $6).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple7Ops<A, B, C, D, E, F, G>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>) {
  @isTest
  void forAll(
    String description,
    Function7<A, B, C, D, E, F, G, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple8Ops<A, B, C, D, E, F, G, H>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>) {
  @isTest
  void forAll(
    String description,
    Function8<A, B, C, D, E, F, G, H, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple9Ops<A, B, C, D, E, F, G, H, I>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>) {
  @isTest
  void forAll(
    String description,
    Function9<A, B, C, D, E, F, G, H, I, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple10Ops<A, B, C, D, E, F, G, H, I, J>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>, Gen<J>) {
  @isTest
  void forAll(
    String description,
    Function10<A, B, C, D, E, F, G, H, I, J, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple11Ops<A, B, C, D, E, F, G, H, I, J, K>
    on (Gen<A>, Gen<B>, Gen<C>, Gen<D>, Gen<E>, Gen<F>, Gen<G>, Gen<H>, Gen<I>, Gen<J>, Gen<K>) {
  @isTest
  void forAll(
    String description,
    Function11<A, B, C, D, E, F, G, H, I, J, K, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple12Ops<A, B, C, D, E, F, G, H, I, J, K, L>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
        ) {
  @isTest
  void forAll(
    String description,
    Function12<A, B, C, D, E, F, G, H, I, J, K, L, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
        ) {
  @isTest
  void forAll(
    String description,
    Function13<A, B, C, D, E, F, G, H, I, J, K, L, M, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
        ) {
  @isTest
  void forAll(
    String description,
    Function14<A, B, C, D, E, F, G, H, I, J, K, L, M, N, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
        ) {
  @isTest
  void forAll(
    String description,
    Function15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
        ) {
  @isTest
  void forAll(
    String description,
    Function16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
        ) {
  @isTest
  void forAll(
    String description,
    Function17<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
        ) {
  @isTest
  void forAll(
    String description,
    Function18<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
        ) {
  @isTest
  void forAll(
    String description,
    Function19<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)>(
    description,
    ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
        ) {
  @isTest
  void forAll(
    String description,
    Function20<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, FutureOr<void>>
    testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>(
    description,
    (
      $1,
      $2,
      $3,
      $4,
      $5,
      $6,
      $7,
      $8,
      $9,
      $10,
      $11,
      $12,
      $13,
      $14,
      $15,
      $16,
      $17,
      $18,
      $19,
      $20,
    ).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
          Gen<U>,
        ) {
  @isTest
  void forAll(
    String description,
    Function21<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, FutureOr<void>>
    testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>(
    description,
    (
      $1,
      $2,
      $3,
      $4,
      $5,
      $6,
      $7,
      $8,
      $9,
      $10,
      $11,
      $12,
      $13,
      $14,
      $15,
      $16,
      $17,
      $18,
      $19,
      $20,
      $21,
    ).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

extension PropTuple22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>
    on
        (
          Gen<A>,
          Gen<B>,
          Gen<C>,
          Gen<D>,
          Gen<E>,
          Gen<F>,
          Gen<G>,
          Gen<H>,
          Gen<I>,
          Gen<J>,
          Gen<K>,
          Gen<L>,
          Gen<M>,
          Gen<N>,
          Gen<O>,
          Gen<P>,
          Gen<Q>,
          Gen<R>,
          Gen<S>,
          Gen<T>,
          Gen<U>,
          Gen<V>,
        ) {
  @isTest
  void forAll(
    String description,
    Function22<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, FutureOr<void>>
    testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>(
    description,
    (
      $1,
      $2,
      $3,
      $4,
      $5,
      $6,
      $7,
      $8,
      $9,
      $10,
      $11,
      $12,
      $13,
      $14,
      $15,
      $16,
      $17,
      $18,
      $19,
      $20,
      $21,
      $22,
    ).tupled,
    testBody.tupled,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}
