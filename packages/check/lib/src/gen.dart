import 'dart:collection';

import 'package:ribs_check/src/gen_syntax.dart';
import 'package:ribs_check/src/shrinker.dart';
import 'package:ribs_check/src/stateful_random.dart';
import 'package:ribs_core/ribs_core.dart';

final class Gen<A> with Functor<A>, Applicative<A>, Monad<A> {
  final State<StatefulRandom, A> sample;
  final Shrinker<A>? shrinker;

  Gen(this.sample, {this.shrinker});

  @override
  Gen<B> flatMap<B>(Function1<A, Gen<B>> f) => Gen(sample.flatMap((t) => f(t).sample));

  @override
  Gen<B> map<B>(Function1<A, B> f) => flatMap((a) => Gen(sample.map(f)));

  Gen<A> retryUntil(Function1<A, bool> p) {
    Gen<A> go(int retriesSoFar) {
      if (retriesSoFar >= 1000) {
        throw Exception('Gen.retryUntil exceeded max retries: 1000');
      } else {
        return flatMap((a) => p(a) ? Gen.constant(a) : go(retriesSoFar + 1));
      }
    }

    return go(0);
  }

  ILazyList<A> shrink(A a) => shrinker?.shrink(a) ?? ILazyList.empty();

  Gen<A> withShrinker(Shrinker<A> shrinker) => Gen(sample, shrinker: shrinker);

  ILazyList<A> stream(StatefulRandom rand) => ILazyList.unfold(
    rand,
    (r) {
      final result = sample.run(r);
      return Some((result.$2, result.$1));
    },
  );

  Gen<(A, A)> get tuple2 => (this, this).tupled;

  Gen<(A, A, A)> get tuple3 => tuple2.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A)> get tuple4 => tuple3.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A)> get tuple5 => tuple4.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A)> get tuple6 => tuple5.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A)> get tuple7 => tuple6.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A)> get tuple8 => tuple7.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A)> get tuple9 => tuple8.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A)> get tuple10 => tuple9.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A)> get tuple11 => tuple10.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A, A)> get tuple12 => tuple11.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple13 =>
      tuple12.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple14 =>
      tuple13.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple15 =>
      tuple14.flatMap((t) => map(t.appended));

  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple16 =>
      tuple15.flatMap((t) => map(t.appended));

  ///////////////
  // Instances //
  ///////////////

  static final Gen<String> alphaLowerChar = Choose.integer
      .choose('a'.codeUnitAt(0), 'z'.codeUnitAt(0) + 1)
      .map(String.fromCharCode);

  static Gen<String> alphaLowerString([int? size]) => stringOf(alphaLowerChar, size);

  static Gen<String> alphaNumChar = frequency([
    (26, Gen.alphaLowerChar),
    (26, Gen.alphaUpperChar),
    (10, numChar),
  ]);

  static Gen<String> alphaNumString([int? limit]) => stringOf(alphaNumChar, limit);

  static final Gen<String> alphaUpperChar = alphaLowerChar.map((c) => c.toUpperCase());

  static Gen<String> alphaUpperString([int? size]) => stringOf(alphaUpperChar, size);

  static final Gen<String> asciiChar = chooseInt(0, 127).map(String.fromCharCode);

  static Gen<IList<A>> atLeastOne<A>(List<A> as) =>
      chooseInt(1, as.length - 1).flatMap((size) => ilistOfN(size, oneOf(as)));

  static final Gen<BigInt> bigInt = Gen.listOf(
    Gen.chooseInt(1, 20),
    Gen.numChar,
  ).map((a) => BigInt.parse(a.join()));

  static final Gen<String> binChar = charSample('01');

  static final Gen<bool> boolean = Gen(State((r) => r.nextBool()));

  static final Gen<int> byte = chooseInt(0, 255);

  static Gen<double> chooseDouble(
    double min,
    double max, {
    IList<double> specials = const Nil(),
  }) => chooseNum(
    min,
    max,
    ilist([min, max, 0.0, 1.0, -1.0]).concat(specials),
    Choose.dubble,
  ).withShrinker(Shrinker.dubble);

  static Gen<T> chooseEnum<T extends Enum>(List<T> enumeration) =>
      chooseInt(0, enumeration.length - 1).map((ix) => enumeration[ix]);

  static Gen<int> chooseInt(
    int min,
    int max, {
    IList<int> specials = const Nil(),
  }) => chooseNum(
    min,
    max,
    ilist([min, max, 0, 1, -1]).concat(specials),
    Choose.integer,
  ).withShrinker(Shrinker.integer);

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

    return frequency(basicsAndSpecials.appended(others).toList());
  }

  static Gen<A> constant<A>(A a) => Gen(State.pure(a));

  static final Gen<DateTime> date = (
    chooseInt(1970, DateTime.now().year + 100),
    chooseInt(DateTime.january, DateTime.december),
    chooseInt(0, 30),
  ).tupled.map((t) => DateTime(t.$1, t.$2, t.$3));

  static final Gen<DateTime> dateTime = (
    chooseInt(1970, DateTime.now().year + 100),
    chooseInt(DateTime.january, DateTime.december),
    chooseInt(0, 30),
    chooseInt(0, 23),
    chooseInt(0, 59),
    chooseInt(0, 59),
    chooseInt(0, 9999),
    chooseInt(0, 999999),
  ).tupled.map((t) => DateTime(t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8));

  static Gen<Duration> duration = (
    chooseInt(-365, 365),
    chooseInt(-23, 23),
    chooseInt(-59, 59),
    chooseInt(-59, 59),
    chooseInt(-9999, 9999),
    chooseInt(-999999, 999999),
  ).tupled.map(
    (t) => Duration(
      days: t.$1,
      hours: t.$2,
      minutes: t.$3,
      seconds: t.$4,
      milliseconds: t.$5,
      microseconds: t.$6,
    ),
  );

  static Gen<Either<A, B>> either<A, B>(Gen<A> genA, Gen<B> genB) => boolean
      .flatMap(
        (a) => a ? genA.map((x) => Either.left<A, B>(x)) : genB.map((x) => Either.right<A, B>(x)),
      )
      .withShrinker(Shrinker.either(genA.shrinker, genB.shrinker));

  static Gen<A> frequency<A>(Iterable<(int, Gen<A>)> gs) {
    final filteredGens = ilist(gs).filter((t) => t.$1 > 0);

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

  static final Gen<String> hexChar = charSample('01234567890abcdefABCDEF');

  static Gen<String> hexString([int? size]) => stringOf(hexChar, size);

  static Gen<IMap<A, B>> imapOf<A, B>(Gen<int> sizeGen, Gen<A> keyGen, Gen<B> valueGen) => sizeGen
      .flatMap((size) => imapOfN(size, keyGen, valueGen))
      .withShrinker(Shrinker.imap(keyGen.shrinker, valueGen.shrinker));

  static Gen<IMap<A, B>> imapOfN<A, B>(int size, Gen<A> keyGen, Gen<B> valueGen) => mapOfN(
    size,
    keyGen,
    valueGen,
  ).map(IMap.fromDart).withShrinker(Shrinker.imap(keyGen.shrinker, valueGen.shrinker));

  static Gen<IList<A>> ilistOf<A>(Gen<int> sizeGen, Gen<A> gen) =>
      sizeGen.flatMap((size) => ilistOfN(size, gen)).withShrinker(Shrinker.ilist(gen.shrinker));

  static Gen<IList<A>> ilistOfN<A>(int size, Gen<A> gen) =>
      listOfN(size, gen).map(IList.fromDart).withShrinker(Shrinker.ilist(gen.shrinker));

  static final Gen<int> integer = Gen.chooseInt(-2147483648, 2147483647);

  static Gen<List<A>> listOf<A>(Gen<int> sizeGen, Gen<A> gen) =>
      sizeGen.flatMap((size) => listOfN(size, gen)).withShrinker(Shrinker.list(gen.shrinker));

  static Gen<List<A>> listOfN<A>(int size, Gen<A> gen) => Gen(
    State((rand) {
      var currentRand = rand;
      final list = <A>[];
      for (var i = 0; i < size; i++) {
        final result = gen.sample.run(currentRand);
        currentRand = result.$1;
        list.add(result.$2);
      }
      return (currentRand, list);
    }),
    shrinker: Shrinker.list(gen.shrinker),
  );

  static Gen<Map<A, B>> mapOf<A, B>(Gen<int> sizeGen, Gen<A> keyGen, Gen<B> valueGen) => sizeGen
      .flatMap((size) => mapOfN(size, keyGen, valueGen))
      .withShrinker(Shrinker.map(keyGen.shrinker, valueGen.shrinker));

  static Gen<Map<A, B>> mapOfN<A, B>(int size, Gen<A> keyGen, Gen<B> valueGen) => Gen(
    State((rand) {
      var currentRand = rand;

      final map = <A, B>{};

      for (var i = 0; i < size; i++) {
        final keyResult = keyGen.sample.run(currentRand);
        currentRand = keyResult.$1;

        final valResult = valueGen.sample.run(currentRand);
        currentRand = valResult.$1;

        map[keyResult.$2] = valResult.$2;
      }

      return (currentRand, map);
    }),
    shrinker: Shrinker.map(keyGen.shrinker, valueGen.shrinker),
  );

  static Gen<String> nonEmptyAlphaNumString([int? limit]) => nonEmptyStringOf(alphaNumChar, limit);

  static Gen<String> nonEmptyHexString([int? size]) => nonEmptyStringOf(hexChar, size);

  static Gen<NonEmptyIList<A>> nonEmptyIList<A>(Gen<A> gen, [int? limit]) => Choose.integer
      .choose(1, limit ?? 1000)
      .flatMap((size) => Gen.ilistOfN(size, gen).map(NonEmptyIList.unsafe));

  static final Gen<int> nonNegativeInt = chooseInt(0, Integer.MaxValue);

  static final Gen<String> numChar = charSample('01234567890');

  static Gen<A> oneOf<A>(Iterable<A> xs) => Choose.integer
      .choose(0, xs.length)
      .map(
        (ix) => ilist(xs).lift(ix).getOrElse(() => throw Exception('oneOf called on empty list')),
      );

  static Gen<A> oneOfGen<A>(List<Gen<A>> xs) => Choose.integer
      .choose(0, xs.length)
      .flatMap(
        (ix) =>
            ilist(xs).lift(ix).getOrElse(() => throw Exception('oneOfGen called on empty list')),
      );

  static Gen<Option<A>> option<A>(Gen<A> a) =>
      frequency([(1, constant(none<A>())), (9, some(a))]).withShrinker(Shrinker.option(a.shrinker));

  static final Gen<int> positiveInt = chooseInt(1, Integer.MaxValue);

  static Gen<Option<A>> some<A>(Gen<A> a) => a.map((a) => Some(a));

  static Gen<IList<A>> sequence<A>(IList<Gen<A>> gs) => Gen(
    State((rand) {
      var currentRand = rand;
      final list = <A>[];
      for (final gen in gs.toList()) {
        final result = gen.sample.run(currentRand);
        currentRand = result.$1;
        list.add(result.$2);
      }
      return (currentRand, IList.fromDart(list));
    }),
  );

  static Gen<String> stringOf(Gen<String> char, [int? limit]) => listOf(
    Gen.chooseInt(0, limit ?? 100),
    char,
  ).map((a) => a.join()).withShrinker(Shrinker.string);

  static Gen<String> nonEmptyStringOf(Gen<String> char, [int? limit]) => listOf(
    Gen.chooseInt(1, limit ?? 100),
    char,
  ).map((a) => a.join()).withShrinker(Shrinker.string);

  static Gen<String> charSample(String chars) => oneOf(chars.split(''));
}

final class Choose<A> {
  final Function2<A, A, Gen<A>> _chooseF;

  const Choose(this._chooseF);

  Gen<A> choose(A min, A max) => _chooseF(min, max);

  Choose<B> xmap<B>(Function1<A, B> from, Function1<B, A> to) =>
      Choose((B min, B max) => choose(to(min), to(max)).map(from));

  static Choose<double> dubble = Choose(
    (double min, double max) => Gen(
      State((r) => r.nextDouble().call((rand, value) => (rand, value * (max - min) + min))),
      shrinker: Shrinker.dubble,
    ),
  );

  static Choose<int> integer = Choose((int min, int max) {
    return Gen(
      State((r) => r.nextInt(max - min).call((rand, value) => (rand, value + min))),
      shrinker: Shrinker.integer,
    );
  });
}
