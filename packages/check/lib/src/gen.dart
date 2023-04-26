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

  static Gen<(A, B)> tuple2<A, B>(Gen<A> a, Gen<B> b) =>
      a.flatMap((a) => b.map((b) => (a, b)));

  static Gen<(A, B, C)> tuple3<A, B, C>(Gen<A> a, Gen<B> b, Gen<C> c) =>
      tuple2(a, b).flatMap((t) => c.map(t.append));

  static Gen<(A, B, C, D)> tuple4<A, B, C, D>(
          Gen<A> a, Gen<B> b, Gen<C> c, Gen<D> d) =>
      tuple3(a, b, c).flatMap((t) => d.map(t.append));

  static Gen<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
          Gen<A> a, Gen<B> b, Gen<C> c, Gen<D> d, Gen<E> e) =>
      tuple4(a, b, c, d).flatMap((t) => e.map(t.append));

  static Gen<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
          Gen<A> a, Gen<B> b, Gen<C> c, Gen<D> d, Gen<E> e, Gen<F> f) =>
      tuple5(a, b, c, d, e).flatMap((t) => f.map(t.append));

  static Gen<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(Gen<A> a,
          Gen<B> b, Gen<C> c, Gen<D> d, Gen<E> e, Gen<F> f, Gen<G> g) =>
      tuple6(a, b, c, d, e, f).flatMap((t) => g.map(t.append));

  static Gen<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
          Gen<A> a,
          Gen<B> b,
          Gen<C> c,
          Gen<D> d,
          Gen<E> e,
          Gen<F> f,
          Gen<G> g,
          Gen<H> h) =>
      tuple7(a, b, c, d, e, f, g).flatMap((t) => h.map(t.append));

  static Gen<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
          Gen<A> a,
          Gen<B> b,
          Gen<C> c,
          Gen<D> d,
          Gen<E> e,
          Gen<F> f,
          Gen<G> g,
          Gen<H> h,
          Gen<I> i) =>
      tuple8(a, b, c, d, e, f, g, h).flatMap((t) => i.map(t.append));

  static Gen<(A, B, C, D, E, F, G, H, I, J)>
      tuple10<A, B, C, D, E, F, G, H, I, J>(
              Gen<A> a,
              Gen<B> b,
              Gen<C> c,
              Gen<D> d,
              Gen<E> e,
              Gen<F> f,
              Gen<G> g,
              Gen<H> h,
              Gen<I> i,
              Gen<J> j) =>
          tuple9(a, b, c, d, e, f, g, h, i).flatMap((t) => j.map(t.append));

  ///////////////
  // Instances //
  ///////////////

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

  static Gen<bool> boolean = Gen(State((r) => r.nextBool()));

  static Gen<double> chooseDouble(
    double min,
    double max, {
    IList<double> specials = const IList.nil(),
  }) =>
      chooseNum(min, max, ilist([min, max, 0.0, 1.0, -1.0]).concat(specials),
          Choose.dubble);

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

  static Gen<DateTime> dateTime = tuple8(
    chooseInt(1970, DateTime.now().year),
    chooseInt(DateTime.january, DateTime.december),
    chooseInt(0, 30),
    chooseInt(0, 23),
    chooseInt(0, 59),
    chooseInt(0, 59),
    chooseInt(0, 9999),
    chooseInt(0, 999999),
  ).map((t) => DateTime(t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8));

  static Gen<Duration> duration = tuple6(
    chooseInt(0, 365),
    chooseInt(0, 23),
    chooseInt(0, 59),
    chooseInt(0, 59),
    chooseInt(0, 9999),
    chooseInt(0, 999999),
  ).map((t) => Duration(
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
        () => throw Exception('No items with positive weights!'), (defaultGen) {
      var sum = 0;
      final tree = SplayTreeMap<int, Gen<A>>();

      // ignore: prefer_final_locals
      for (final (x, gen) in filteredGens.toList()) {
        sum = x + sum;
        tree[sum] = gen;
      }

      return Choose.integer
          .choose(1, sum)
          .flatMap((n) => tree[tree.firstKeyAfter(n)] ?? defaultGen.$2);
    });
  }

  static Gen<String> hexChar = _charSample('01234567890abcdefABCDEF');

  static Gen<String> hexString([int? size]) => stringOf(hexChar, size);

  static Gen<IList<A>> ilistOf<A>(int size, Gen<A> gen) =>
      sequence(IList.fill(size, gen));

  static Gen<List<A>> listOf<A>(int size, Gen<A> gen) =>
      ilistOf(size, gen).map((a) => a.toList());

  static Gen<Map<A, B>> mapOfN<A, B>(
          int size, Gen<A> keyGen, Gen<B> valueGen) =>
      ilistOf(size, tuple2(keyGen, valueGen)).map(
          (a) => Map.fromEntries(a.map((x) => MapEntry(x.$1, x.$2)).toList()));

  static Gen<NonEmptyIList<A>> nonEmptyIList<A>(Gen<A> gen, [int? limit]) =>
      Choose.integer.choose(1, limit ?? 100).flatMap((size) =>
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
