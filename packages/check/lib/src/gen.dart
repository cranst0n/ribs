import 'dart:async';
import 'dart:collection';

import 'package:ribs_check/src/seeded_random.dart';
import 'package:ribs_core/ribs_core.dart';

final class Gen<A> extends Monad<A> {
  final State<StatefulRandom, A> sample;
  final Shrinker<A>? shrinker;

  Gen(this.sample, {this.shrinker});

  @override
  Gen<B> flatMap<B>(covariant Function1<A, Gen<B>> f) =>
      Gen(sample.flatMap((t) => f(t).sample));

  @override
  Gen<B> map<B>(Function1<A, B> f) => flatMap((a) => Gen(sample.map(f)));

  Stream<A> shrink(A a) => shrinker?.shrink(a) ?? Stream<A>.empty();

  Gen<A> withShrinker(Shrinker<A> shrinker) => Gen(sample, shrinker: shrinker);

  Stream<A> stream(StatefulRandom rand) => Streams.unfold<(StatefulRandom, A)>(
        sample.run(rand),
        (x) => Some(sample.run(x.$1)),
      ).map((x) => x.$2);

  Gen<(A, A)> get tuple2 => (this, this).tupled;

  Gen<(A, A, A)> get tuple3 => (this, this, this).tupled;

  Gen<(A, A, A, A)> get tuple4 => (this, this, this, this).tupled;

  Gen<(A, A, A, A, A)> get tuple5 => (this, this, this, this, this).tupled;

  Gen<(A, A, A, A, A, A)> get tuple6 =>
      (this, this, this, this, this, this).tupled;

  Gen<(A, A, A, A, A, A, A)> get tuple7 =>
      (this, this, this, this, this, this, this).tupled;

  Gen<(A, A, A, A, A, A, A, A)> get tuple8 =>
      (this, this, this, this, this, this, this, this).tupled;

  Gen<(A, A, A, A, A, A, A, A, A)> get tuple9 =>
      (this, this, this, this, this, this, this, this, this).tupled;

  Gen<(A, A, A, A, A, A, A, A, A, A)> get tuple10 =>
      (this, this, this, this, this, this, this, this, this, this).tupled;

  ///////////////
  // Instances //
  ///////////////

  static Gen<String> alphaDigit = Choose.integer
      .choose('0'.codeUnitAt(0), '9'.codeUnitAt(0) + 1)
      .map(String.fromCharCode);

  static Gen<String> alphaLowerChar = Choose.integer
      .choose('a'.codeUnitAt(0), 'z'.codeUnitAt(0) + 1)
      .map(String.fromCharCode);

  static Gen<String> alphaLowerString([int? size]) =>
      stringOf(alphaLowerChar, size);

  static Gen<String> alphaNumChar = frequency(ilist([
    (26, Gen.alphaLowerChar),
    (26, Gen.alphaUpperChar),
    (10, numChar),
  ]));

  static Gen<String> alphaNumString([int? size]) =>
      stringOf(alphaNumChar, size);

  static Gen<String> alphaUpperChar =
      alphaLowerChar.map((c) => c.toUpperCase());

  static Gen<String> alphaUpperString([int? size]) =>
      stringOf(alphaLowerChar, size);

  static Gen<IList<A>> atLeastOne<A>(IList<A> as) =>
      chooseInt(1, as.size - 1).flatMap((size) => ilistOf(size, oneOf(as)));

  static Gen<BigInt> bigInt = Gen.chooseInt(1, 20).flatMap(
      (n) => Gen.listOf(n, Gen.alphaDigit).map((a) => BigInt.parse(a.join())));

  static Gen<bool> boolean = Gen(State((r) => r.nextBool()));

  static Gen<double> chooseDouble(
    double min,
    double max, {
    IList<double> specials = const IList.nil(),
  }) =>
      chooseNum(min, max, ilist([min, max, 0.0, 1.0, -1.0]).concat(specials),
          Choose.dubble);

  static Gen<T> chooseEnum<T extends Enum>(List<T> enumeration) =>
      chooseInt(0, enumeration.length - 1).map((ix) => enumeration[ix]);

  static Gen<int> chooseInt(
    int min,
    int max, {
    IList<int> specials = const IList.nil(),
  }) =>
      chooseNum(min, max, ilist([min, max, 0, 1, -1]).concat(specials),
          Choose.integer);

  static Gen<A> chooseNum<A extends num>(
    A min,
    A max,
    IList<A> specials,
    Choose<A> choose,
  ) {
    final basicsAndSpecials = specials
        .filter((x) => min <= x && x <= max)
        .map((t) => (1, constant(t)));
    final others = (basicsAndSpecials.size, choose.choose(min, max));

    return frequency(basicsAndSpecials.append(others));
  }

  static Gen<A> constant<A>(A a) => Gen(State.pure(a));

  static Gen<DateTime> dateTime = (
    chooseInt(1970, DateTime.now().year),
    chooseInt(DateTime.january, DateTime.december),
    chooseInt(0, 30),
    chooseInt(0, 23),
    chooseInt(0, 59),
    chooseInt(0, 59),
    chooseInt(0, 9999),
    chooseInt(0, 999999),
  ).tupled.map((t) => DateTime(t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8));

  static Gen<Duration> duration = (
    chooseInt(0, 365),
    chooseInt(0, 23),
    chooseInt(0, 59),
    chooseInt(0, 59),
    chooseInt(0, 9999),
    chooseInt(0, 999999),
  ).tupled.map((t) => Duration(
        days: t.$1,
        hours: t.$2,
        minutes: t.$3,
        seconds: t.$4,
        milliseconds: t.$5,
        microseconds: t.$6,
      ));

  static Gen<Either<A, B>> either<A, B>(Gen<A> genA, Gen<B> genB) =>
      boolean.flatMap((a) => a
          ? genA.map((x) => Either.left<A, B>(x))
          : genB.map((x) => Either.right<A, B>(x)));

  static Gen<A> frequency<A>(IList<(int, Gen<A>)> gs) {
    final filteredGens = gs.filter((t) => t.$1 > 0);

    return filteredGens.headOption.fold(
      () => throw Exception('No items with positive weights!'),
      (defaultGen) {
        var sum = 0;
        final tree = SplayTreeMap<int, Gen<A>>();

        for (final (x, gen) in filteredGens.toList()) {
          sum = x + sum;
          tree[sum] = gen;
        }

        return Choose.integer
            .choose(0, sum)
            .flatMap((n) => tree[tree.firstKeyAfter(n)] ?? defaultGen.$2);
      },
    );
  }

  static Gen<String> hexChar = _charSample('01234567890abcdefABCDEF');

  static Gen<String> hexString([int? size]) => stringOf(hexChar, size);

  static Gen<IList<A>> ilistOf<A>(int size, Gen<A> gen) =>
      sequence(IList.fill(size, gen));

  static Gen<List<A>> listOf<A>(int size, Gen<A> gen) =>
      ilistOf(size, gen).map((a) => a.toList());

  static Gen<Map<A, B>> mapOfN<A, B>(
          int size, Gen<A> keyGen, Gen<B> valueGen) =>
      ilistOf(size, (keyGen, valueGen).tupled).map(
          (a) => Map.fromEntries(a.map((x) => MapEntry(x.$1, x.$2)).toList()));

  static Gen<NonEmptyIList<A>> nonEmptyIList<A>(Gen<A> gen, [int? limit]) =>
      Choose.integer.choose(1, limit ?? 1000).flatMap((size) =>
          Gen.listOf(size, gen).map(NonEmptyIList.fromIterableUnsafe));

  static Gen<int> nonNegativeInt = chooseInt(0, _intMaxValue);

  static Gen<String> numChar = _charSample('01234567890');

  static Gen<A> oneOf<A>(IList<A> xs) =>
      Choose.integer.choose(0, xs.size).map((ix) => xs
          .lift(ix)
          .getOrElse(() => throw Exception('oneOf called on empty list')));

  static Gen<A> oneOfGen<A>(IList<Gen<A>> xs) =>
      Choose.integer.choose(0, xs.size).flatMap((ix) => xs
          .lift(ix)
          .getOrElse(() => throw Exception('oneOfGen called on empty list')));

  static Gen<Option<A>> option<A>(Gen<A> a) =>
      frequency(ilist([(1, constant(none<A>())), (9, some(a))]));

  static Gen<int> positiveInt = chooseInt(1, _intMaxValue);

  static Gen<Option<A>> some<A>(Gen<A> a) => a.map((a) => Some(a));

  static Gen<IList<A>> sequence<A>(IList<Gen<A>> gs) => gs.foldLeft(
      constant(nil<A>()),
      (acc, elem) => acc.flatMap((x) => elem.map((a) => x.append(a))));

  static Gen<String> stringOf(Gen<String> char, [int? size]) =>
      listOf(size ?? 20, char).map((a) => a.join());

  static Gen<String> _charSample(String chars) => oneOf(ilist(chars.split('')));

  static const int _intMaxValue = 4294967296;
}

final class Streams {
  static Stream<A> unfold<A>(A initial, Function1<A, Option<A>> f) {
    final controller = StreamController<A>();

    var closeController = false;
    controller.onCancel = () => closeController = true;

    void step(A a) {
      f(a).filter((_) => !closeController).fold(
          () => controller.close(),
          (a) => controller
              .addStream(Stream.value(a))
              .whenComplete(() => step(a)));
    }

    step(initial);

    return controller.stream;
  }
}

class Shrinker<A> {
  final Function1<A, Option<A>> _shrinkerF;

  Shrinker(this._shrinkerF);

  Stream<A> shrink(A a) => Streams.unfold(a, _shrinkerF);

  static Shrinker<double> dubble =
      Shrinker<double>((i) => Option.when(() => i > 0, () => i / 2));

  static Shrinker<int> integer =
      Shrinker<int>((i) => Option.when(() => i > 0, () => i ~/ 2));
}

final class Choose<A> {
  final Function2<A, A, Gen<A>> _chooseF;

  const Choose(this._chooseF);

  Gen<A> choose(A min, A max) => _chooseF(min, max);

  Choose<B> xmap<B>(Function1<A, B> from, Function1<B, A> to) =>
      Choose((B min, B max) => choose(to(min), to(max)).map(from));

  static Choose<double> dubble = Choose((double min, double max) => Gen(
        State((r) => r
            .nextDouble()
            .call((rand, value) => (rand, value * (max - min) + min))),
        shrinker: Shrinker.dubble,
      ));

  static Choose<int> integer = Choose((int min, int max) => Gen(
        State((r) =>
            r.nextInt(max - min).call((rand, value) => (rand, value + min))),
        shrinker: Shrinker.integer,
      ));
}

extension GenTuple2Ops<A, B> on (Gen<A>, Gen<B>) {
  Gen<(A, B)> get tupled => $1.flatMap((a) => $2.map((b) => (a, b)));
}

extension GenTuple3Ops<A, B, C> on (Gen<A>, Gen<B>, Gen<C>) {
  Gen<(A, B, C)> get tupled => init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple4Ops<A, B, C, D> on (Gen<A>, Gen<B>, Gen<C>, Gen<D>) {
  Gen<(A, B, C, D)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple5Ops<A, B, C, D, E> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>
) {
  Gen<(A, B, C, D, E)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple6Ops<A, B, C, D, E, F> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>,
  Gen<F>
) {
  Gen<(A, B, C, D, E, F)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple7Ops<A, B, C, D, E, F, G> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>,
  Gen<F>,
  Gen<G>
) {
  Gen<(A, B, C, D, E, F, G)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple8Ops<A, B, C, D, E, F, G, H> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>,
  Gen<F>,
  Gen<G>,
  Gen<H>
) {
  Gen<(A, B, C, D, E, F, G, H)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple9Ops<A, B, C, D, E, F, G, H, I> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>,
  Gen<F>,
  Gen<G>,
  Gen<H>,
  Gen<I>
) {
  Gen<(A, B, C, D, E, F, G, H, I)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple10Ops<A, B, C, D, E, F, G, H, I, J> on (
  Gen<A>,
  Gen<B>,
  Gen<C>,
  Gen<D>,
  Gen<E>,
  Gen<F>,
  Gen<G>,
  Gen<H>,
  Gen<I>,
  Gen<J>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple11Ops<A, B, C, D, E, F, G, H, I, J, K> on (
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
  Gen<K>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple12Ops<A, B, C, D, E, F, G, H, I, J, K, L> on (
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
  Gen<L>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple13Ops<A, B, C, D, E, F, G, H, I, J, K, L, M> on (
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
  Gen<M>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple14Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N> on (
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
  Gen<N>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple15Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O> on (
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
  Gen<O>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple16Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P> on (
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
  Gen<P>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple17Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q> on (
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
  Gen<Q>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple18Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>
    on (
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
  Gen<R>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple19Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>
    on (
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
  Gen<S>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)> get tupled =>
      init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple20Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T> on (
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
  Gen<T>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)>
      get tupled => init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple21Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T, U> on (
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
  Gen<U>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)>
      get tupled => init().tupled.flatMap((t) => last.map(t.append));
}

extension GenTuple22Ops<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S,
    T, U, V> on (
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
  Gen<V>
) {
  Gen<(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)>
      get tupled => init().tupled.flatMap((t) => last.map(t.append));
}
