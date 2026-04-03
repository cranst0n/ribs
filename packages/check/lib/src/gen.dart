import 'dart:collection';

import 'package:ribs_check/src/generated/gen_syntax.dart';
import 'package:ribs_check/src/shrinker.dart';
import 'package:ribs_check/src/stateful_random.dart';
import 'package:ribs_core/ribs_core.dart';

/// A random generator for values of type [A], optionally paired with a
/// [Shrinker] for counter-example minimisation.
///
/// [Gen] is a monad: use [map] and [flatMap] to build complex generators from
/// simpler ones, and the static factory methods (e.g. [chooseInt], [ilistOf],
/// [option]) for the most common cases.
final class Gen<A> with Functor<A>, Applicative<A>, Monad<A> {
  /// The underlying stateful computation that produces a value.
  final State<StatefulRandom, A> sample;

  /// Optional shrinker used to minimise failing counter-examples.
  final Shrinker<A>? shrinker;

  /// Creates a [Gen] from a [sample] computation and an optional [shrinker].
  Gen(this.sample, {this.shrinker});

  @override
  Gen<B> flatMap<B>(Function1<A, Gen<B>> f) => Gen(sample.flatMap((t) => f(t).sample));

  @override
  Gen<B> map<B>(Function1<A, B> f) => flatMap((a) => Gen(sample.map(f)));

  /// Returns a generator that retries until the predicate [p] holds.
  ///
  /// Throws an [Exception] after 1000 consecutive rejections to prevent
  /// infinite loops when [p] is too restrictive.
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

  /// Returns shrink candidates for [a] using this generator's [shrinker],
  /// or an empty list when no shrinker is attached.
  ILazyList<A> shrink(A a) => shrinker?.shrink(a) ?? ILazyList.empty();

  /// Returns a copy of this generator with [shrinker] attached.
  Gen<A> withShrinker(Shrinker<A> shrinker) => Gen(sample, shrinker: shrinker);

  /// Returns an infinite lazy stream of sampled values using [rand] as the
  /// random source.
  ILazyList<A> stream(StatefulRandom rand) => ILazyList.unfold(
    rand,
    (r) {
      final result = sample.run(r);
      return Some((result.$2, result.$1));
    },
  );

  /// Generates a pair of independent values from this generator.
  Gen<(A, A)> get tuple2 => (this, this).tupled;

  /// Generates a 3-tuple of independent values from this generator.
  Gen<(A, A, A)> get tuple3 => tuple2.flatMap((t) => map(t.appended));

  /// Generates a 4-tuple of independent values from this generator.
  Gen<(A, A, A, A)> get tuple4 => tuple3.flatMap((t) => map(t.appended));

  /// Generates a 5-tuple of independent values from this generator.
  Gen<(A, A, A, A, A)> get tuple5 => tuple4.flatMap((t) => map(t.appended));

  /// Generates a 6-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A)> get tuple6 => tuple5.flatMap((t) => map(t.appended));

  /// Generates a 7-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A)> get tuple7 => tuple6.flatMap((t) => map(t.appended));

  /// Generates a 8-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A)> get tuple8 => tuple7.flatMap((t) => map(t.appended));

  /// Generates a 9-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A)> get tuple9 => tuple8.flatMap((t) => map(t.appended));

  /// Generates a 10-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A)> get tuple10 => tuple9.flatMap((t) => map(t.appended));

  /// Generates a 11-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A)> get tuple11 => tuple10.flatMap((t) => map(t.appended));

  /// Generates a 12-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A, A)> get tuple12 => tuple11.flatMap((t) => map(t.appended));

  /// Generates a 13-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple13 =>
      tuple12.flatMap((t) => map(t.appended));

  /// Generates a 14-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple14 =>
      tuple13.flatMap((t) => map(t.appended));

  /// Generates a 15-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple15 =>
      tuple14.flatMap((t) => map(t.appended));

  /// Generates a 16-tuple of independent values from this generator.
  Gen<(A, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A)> get tuple16 =>
      tuple15.flatMap((t) => map(t.appended));

  /// Generator for lowercase ASCII letters (`a`–`z`).
  static final Gen<String> alphaLowerChar = Choose.integer
      .choose('a'.codeUnitAt(0), 'z'.codeUnitAt(0) + 1)
      .map(String.fromCharCode);

  /// Generator for strings of lowercase ASCII letters with an optional maximum
  /// [size] (default 100).
  static Gen<String> alphaLowerString([int? size]) => stringOf(alphaLowerChar, size);

  /// Generator for a single alphanumeric character (a–z, A–Z, 0–9).
  static Gen<String> alphaNumChar = frequency([
    (26, Gen.alphaLowerChar),
    (26, Gen.alphaUpperChar),
    (10, numChar),
  ]);

  /// Generator for alphanumeric strings with an optional maximum [limit]
  /// (default 100).
  static Gen<String> alphaNumString([int? limit]) => stringOf(alphaNumChar, limit);

  /// Generator for uppercase ASCII letters (`A`–`Z`).
  static final Gen<String> alphaUpperChar = alphaLowerChar.map((c) => c.toUpperCase());

  /// Generator for strings of uppercase ASCII letters with an optional maximum
  /// [size] (default 100).
  static Gen<String> alphaUpperString([int? size]) => stringOf(alphaUpperChar, size);

  /// Generator for a single ASCII character (code points 0–127).
  static final Gen<String> asciiChar = chooseInt(0, 127).map(String.fromCharCode);

  /// Generator for a non-empty [IList] whose size is drawn from `[1, as.length]`
  /// and whose elements are drawn from [as].
  static Gen<IList<A>> atLeastOne<A>(List<A> as) =>
      chooseInt(1, as.length - 1).flatMap((size) => ilistOfN(size, oneOf(as)));

  /// Generator for positive [BigInt] values made up of 1–20 decimal digits.
  static final Gen<BigInt> bigInt = Gen.listOf(
    Gen.chooseInt(1, 20),
    Gen.numChar,
  ).map((a) => BigInt.parse(a.join()));

  /// Generator for a single binary digit character (`0` or `1`).
  static final Gen<String> binChar = charSample('01');

  /// Generator for [bool] values.
  static final Gen<bool> boolean = Gen(State((r) => r.nextBool()));

  /// Generator for byte values in `[0, 255]`.
  static final Gen<int> byte = chooseInt(0, 255);

  /// Generator for [double] values in `[min, max]`.
  ///
  /// [specials] are extra boundary values that are sampled with higher
  /// probability.  The built-in specials are `min`, `max`, `0.0`, `1.0`,
  /// and `-1.0`.
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

  /// Generator for a random value from [enumeration].
  static Gen<T> chooseEnum<T extends Enum>(List<T> enumeration) =>
      chooseInt(0, enumeration.length - 1).map((ix) => enumeration[ix]);

  /// Generator for [int] values in `[min, max]`.
  ///
  /// [specials] are extra boundary values that are sampled with higher
  /// probability.  The built-in specials are `min`, `max`, `0`, `1`, and `-1`.
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

  /// Generator for numeric values in `[min, max]` with weighted special cases.
  ///
  /// Special values that fall within `[min, max]` are each given weight 1;
  /// the remaining range is covered by [choose] with a weight equal to the
  /// number of specials.
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

  /// Generator that always produces [a].
  static Gen<A> constant<A>(A a) => Gen(State.pure(a));

  /// Generator for [DateTime] values representing calendar dates from 1970 to
  /// 100 years in the future.
  static final Gen<DateTime> date = (
    chooseInt(1970, DateTime.now().year + 100),
    chooseInt(DateTime.january, DateTime.december),
    chooseInt(0, 30),
  ).tupled.map((t) => DateTime(t.$1, t.$2, t.$3));

  /// Generator for [DateTime] values with full time-of-day precision from 1970
  /// to 100 years in the future.
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

  /// Generator for [Duration] values spanning roughly ±1 year with
  /// microsecond precision.
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

  /// Generator for [Either] values.
  ///
  /// Produces [Left] and [Right] with equal probability, shrinking via the
  /// shrinkers attached to [genA] and [genB].
  static Gen<Either<A, B>> either<A, B>(Gen<A> genA, Gen<B> genB) => boolean
      .flatMap(
        (a) => a ? genA.map((x) => Either.left<A, B>(x)) : genB.map((x) => Either.right<A, B>(x)),
      )
      .withShrinker(Shrinker.either(genA.shrinker, genB.shrinker));

  /// Generator that picks from [gs] according to their integer weights.
  ///
  /// Each element of [gs] is a `(weight, gen)` pair.  Pairs with a weight
  /// ≤ 0 are ignored.  Throws if no pair has a positive weight.
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

  /// Generator for a single hexadecimal digit character (`0`–`9`, `a`–`f`,
  /// `A`–`F`).
  static final Gen<String> hexChar = charSample('01234567890abcdefABCDEF');

  /// Generator for hexadecimal strings with an optional maximum [size]
  /// (default 100).
  static Gen<String> hexString([int? size]) => stringOf(hexChar, size);

  /// Generator for [IMap] values whose size is drawn from [sizeGen].
  static Gen<IMap<A, B>> imapOf<A, B>(Gen<int> sizeGen, Gen<A> keyGen, Gen<B> valueGen) => sizeGen
      .flatMap((size) => imapOfN(size, keyGen, valueGen))
      .withShrinker(Shrinker.imap(keyGen.shrinker, valueGen.shrinker));

  /// Generator for [IMap] values with exactly [size] entries.
  static Gen<IMap<A, B>> imapOfN<A, B>(int size, Gen<A> keyGen, Gen<B> valueGen) => mapOfN(
    size,
    keyGen,
    valueGen,
  ).map(IMap.fromDart).withShrinker(Shrinker.imap(keyGen.shrinker, valueGen.shrinker));

  /// Generator for [IList] values whose size is drawn from [sizeGen].
  static Gen<IList<A>> ilistOf<A>(Gen<int> sizeGen, Gen<A> gen) =>
      sizeGen.flatMap((size) => ilistOfN(size, gen)).withShrinker(Shrinker.ilist(gen.shrinker));

  /// Generator for [IList] values with exactly [size] elements.
  static Gen<IList<A>> ilistOfN<A>(int size, Gen<A> gen) =>
      listOfN(size, gen).map(IList.fromDart).withShrinker(Shrinker.ilist(gen.shrinker));

  /// Generator for [int] values across the full 32-bit signed range.
  static final Gen<int> integer = Gen.chooseInt(-2147483648, 2147483647);

  /// Generator for [List] values whose size is drawn from [sizeGen].
  static Gen<List<A>> listOf<A>(Gen<int> sizeGen, Gen<A> gen) =>
      sizeGen.flatMap((size) => listOfN(size, gen)).withShrinker(Shrinker.list(gen.shrinker));

  /// Generator for [List] values with exactly [size] elements.
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

  /// Generator for [Map] values whose size is drawn from [sizeGen].
  static Gen<Map<A, B>> mapOf<A, B>(Gen<int> sizeGen, Gen<A> keyGen, Gen<B> valueGen) => sizeGen
      .flatMap((size) => mapOfN(size, keyGen, valueGen))
      .withShrinker(Shrinker.map(keyGen.shrinker, valueGen.shrinker));

  /// Generator for [Map] values with exactly [size] entries.
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

  /// Generator for non-empty alphanumeric strings with an optional maximum
  /// [limit] (default 100).
  static Gen<String> nonEmptyAlphaNumString([int? limit]) => nonEmptyStringOf(alphaNumChar, limit);

  /// Generator for non-empty hexadecimal strings with an optional maximum
  /// [size] (default 100).
  static Gen<String> nonEmptyHexString([int? size]) => nonEmptyStringOf(hexChar, size);

  /// Generator for non-empty [IList] values with sizes drawn from `[1, limit]`
  /// (default limit 1000).
  static Gen<NonEmptyIList<A>> nonEmptyIList<A>(Gen<A> gen, [int? limit]) => Choose.integer
      .choose(1, limit ?? 1000)
      .flatMap((size) => Gen.ilistOfN(size, gen).map(NonEmptyIList.unsafe));

  /// Generator for non-negative [int] values up to [Integer.maxValue].
  static final Gen<int> nonNegativeInt = chooseInt(0, Integer.maxValue);

  /// Generator for a single decimal digit character (`0`–`9`).
  static final Gen<String> numChar = charSample('01234567890');

  /// Generator that picks a random element from [xs].
  ///
  /// Throws if [xs] is empty.
  static Gen<A> oneOf<A>(Iterable<A> xs) => Choose.integer
      .choose(0, xs.length)
      .map(
        (ix) => ilist(xs).lift(ix).getOrElse(() => throw Exception('oneOf called on empty list')),
      );

  /// Generator that picks a random generator from [xs] and samples from it.
  ///
  /// Throws if [xs] is empty.
  static Gen<A> oneOfGen<A>(List<Gen<A>> xs) => Choose.integer
      .choose(0, xs.length)
      .flatMap(
        (ix) =>
            ilist(xs).lift(ix).getOrElse(() => throw Exception('oneOfGen called on empty list')),
      );

  /// Generator for [Option] values.
  ///
  /// Produces [None] with probability 1/10 and [Some] with probability 9/10.
  static Gen<Option<A>> option<A>(Gen<A> a) =>
      frequency([(1, constant(none<A>())), (9, some(a))]).withShrinker(Shrinker.option(a.shrinker));

  /// Generator for positive [int] values up to [Integer.maxValue].
  static final Gen<int> positiveInt = chooseInt(1, Integer.maxValue);

  /// Generator that wraps every sampled value from [a] in [Some].
  static Gen<Option<A>> some<A>(Gen<A> a) => a.map((a) => Some(a));

  /// Runs each generator in [gs] in sequence and collects the results into an
  /// [IList].
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

  /// Generator for strings built from [char] with lengths in `[0, limit]`
  /// (default limit 100).
  static Gen<String> stringOf(Gen<String> char, [int? limit]) => listOf(
    Gen.chooseInt(0, limit ?? 100),
    char,
  ).map((a) => a.join()).withShrinker(Shrinker.string);

  /// Generator for non-empty strings built from [char] with lengths in
  /// `[1, limit]` (default limit 100).
  static Gen<String> nonEmptyStringOf(Gen<String> char, [int? limit]) => listOf(
    Gen.chooseInt(1, limit ?? 100),
    char,
  ).map((a) => a.join()).withShrinker(Shrinker.string);

  /// Generator for a single character drawn from [chars].
  static Gen<String> charSample(String chars) => oneOf(chars.split(''));
}

/// Knows how to generate a value of type [A] uniformly at random within a
/// closed interval `[min, max]`.
///
/// Use [xmap] to derive a [Choose] for any type that is isomorphic to [A].
final class Choose<A> {
  final Function2<A, A, Gen<A>> _chooseF;

  /// Creates a [Choose] from a function that produces a generator for
  /// `[min, max]`.
  const Choose(this._chooseF);

  /// Returns a generator for values in `[min, max]`.
  Gen<A> choose(A min, A max) => _chooseF(min, max);

  /// Derives a [Choose] for [B] via an isomorphism between [A] and [B].
  ///
  /// [from] converts an [A] sample to [B]; [to] maps [B] bounds back to [A]
  /// so that the underlying chooser can be reused.
  Choose<B> xmap<B>(Function1<A, B> from, Function1<B, A> to) =>
      Choose((B min, B max) => choose(to(min), to(max)).map(from));

  /// [Choose] for [double] values using a uniform distribution.
  static final Choose<double> dubble = Choose(
    (double min, double max) => Gen(
      State((r) => r.nextDouble().call((rand, value) => (rand, value * (max - min) + min))),
      shrinker: Shrinker.dubble,
    ),
  );

  /// [Choose] for [int] values using a uniform distribution.
  static final Choose<int> integer = Choose((int min, int max) {
    return Gen(
      State((r) => r.nextInt(max - min).call((rand, value) => (rand, value + min))),
      shrinker: Shrinker.integer,
    );
  });
}
