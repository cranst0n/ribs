import 'dart:collection';

import 'package:ribs_check/src/sandbox/seed.dart';
import 'package:ribs_core/ribs_core.dart';

sealed class Gen2<T> {
  static Gen2<T> constant<T>(T x) => _gen((_, seed) => genr(Some(x), seed));

  static Gen2<int> integer(
    int min,
    int max, {
    IList<int> specials = const Nil(),
  }) {
    final basics = ilist([min, max, 0, 1, -1]);
    final basicsAndSpecials = specials
        .concat(basics)
        .distinct()
        .filter((t) => min <= t && t <= max)
        .map((t) => (1, constant(t)));

    final other = (basicsAndSpecials.length, Choose.integer.choose(min, max));

    return frequency(basicsAndSpecials.appended(other).toList());
  }

  static Gen2<T> frequency<T>(Iterable<(int, Gen2<T>)> gs) {
    final filteredGens = ilist(gs).filter((t) => t.$1 > 0);

    return filteredGens.headOption.fold(
      () => throw Exception('No items with positive weights!'),
      (defaultGen) {
        var sum = 0;
        final tree = SplayTreeMap<int, Gen2<T>>();

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

  GenR<T> doApply(GenParameters p, Seed seed);

  Option<T> apply(GenParameters p, Seed seed) => doApply(p, seed).retrieve;

  GenR<T> doPureApply(GenParameters p, Seed seed, [int retries = 100]) {
    var r = doApply(p, seed);
    var i = retries;

    while (r.retrieve.isEmpty && i > 0) {
      r = doApply(p, r.seed);
      i -= 1;
    }

    if (r.retrieve.isDefined) {
      return r;
    } else {
      throw Exception('GenR.RetrievalError');
    }
  }

  T pureApply(GenParameters p, Seed seed, [int retries = 100]) =>
      doPureApply(p, seed)
          .retrieve
          .fold(() => throw Exception('GenR.RetreivalError'), identity);

  Gen2<T> filter(Function1<T, bool> p) => suchThat(p);

  Gen2<T> filterNot(Function1<T, bool> p) => suchThat((x) => !p(x));

  Gen2<U> flatMap<U>(Function1<T, Gen2<U>> f) => _gen((p, seed) {
        final rt = doApply(p, seed);
        return rt.flatMap((t) => f(t).doApply(p, rt.seed));
      });

  Gen2<T> label(String l) => _gen((p, seed) {
        return p.useInitialSeed(seed, (p0, s0) {
          final r = doApply(p0, s0);
          return r.withLabels(r.labels.incl(l));
        });
      });

  Gen2<U> map<U>(Function1<T, U> f) =>
      _gen((p, seed) => doApply(p, seed).map(f));

  Gen2<T> retryUntil(Function1<T, bool> p, [int maxTries = 10000]) {
    return _gen((params, seed) {
      var tries = 1;
      var r = doApply(params, seed);

      while (!r.retrieve.exists(p) && tries <= maxTries) {
        if (tries > maxTries) {
          throw Exception('Gen.retryUntil: tries exceeded');
        } else {
          r = doApply(params, seed);
        }

        tries += 1;
      }

      return r;
    });
  }

  Option<T> get sample =>
      doApply(GenParameters.create(), Seed.random()).retrieve;

  Gen2<T> suchThat(Function1<T, bool> p) => _gen((params, seed) {
        return params.useInitialSeed(seed, (p0, s0) {
          final r = doApply(p0, s0);
          return r.withResult(r.retrieve.filter(p));
        });
      });
}

final class _Gen2F<T> extends Gen2<T> {
  final Function2<GenParameters, Seed, GenR<T>> f;

  _Gen2F(this.f);

  @override
  GenR<T> doApply(GenParameters p, Seed seed) => f(p, seed);
}

Gen2<T> _gen<T>(Function2<GenParameters, Seed, GenR<T>> f) =>
    _Gen2F((p, seed) => p.useInitialSeed(seed, f));

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

abstract mixin class GenR<T> {
  ISet<String> get labels;
  Seed get seed;
  Option<T> get retrieve => _result;

  Option<T> get _result;

  GenR<T> withLabels(ISet<String> labels) => _GenRImpl(labels, seed, _result);

  GenR<T> withResult(Option<T> result) => _GenRImpl(labels, seed, result);

  GenR<T> withSeed(Seed sd) => _GenRImpl(labels, sd, _result);

  GenR<U> map<U>(Function1<T, U> f) =>
      genr(retrieve.map(f), seed).withLabels(labels);

  GenR<U> flatMap<U>(Function1<T, GenR<U>> f) {
    return retrieve.fold(
      () => genr(none<U>(), seed).withLabels(labels),
      (t) {
        final r = f(t);
        return r.withLabels(labels.union(r.labels));
      },
    );
  }
}

GenR<T> genr<T>(Option<T> r, Seed sd) => _GenRImpl(ISet.empty(), sd, r);

final class _GenRImpl<T> extends GenR<T> {
  @override
  final ISet<String> labels;
  @override
  final Seed seed;
  @override
  final Option<T> _result;

  _GenRImpl(this.labels, this.seed, this._result);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

final class GenParameters {
  final Option<Seed> initialSeed;
  final int size;

  GenParameters._(this.initialSeed, this.size);

  static GenParameters create() => GenParameters._(none(), 100);

  GenParameters copy({
    Option<Seed>? initialSeed,
    int? size,
  }) =>
      GenParameters._(
        initialSeed ?? this.initialSeed,
        size ?? this.size,
      );

  A useInitialSeed<A>(Seed seed, Function2<GenParameters, Seed, A> f) {
    return initialSeed.fold(
      () => f(this, seed),
      (s) => f(withoutInitialSeed, s),
    );
  }

  GenParameters withInitialSeed(Seed seed) => GenParameters._(Some(seed), size);
  GenParameters get withoutInitialSeed => copy(initialSeed: none());

  GenParameters withsize(int size) => GenParameters._(initialSeed, size);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

abstract class Choose<T> {
  static Choose<int> integer = _ChooseImpl(
      (min, max) => _gen((params, seed) => chInt(min, max, params, seed)));

  Gen2<T> choose(T min, T max);

  static GenR<int> chInt(int l, int h, GenParameters p, Seed seed) {
    if (h < l) {
      throw ArgumentError('invalid chInt parameters: $l, $h');
    } else if (h == l) {
      return Gen2.constant(l).doApply(p, seed);
    } else if (l == Integer.MinValue && h == Integer.MaxValue) {
      final (n, s) = seed.integer;
      return genr(Some(n), s);
    } else {
      final d = h - l + 1;

      if (d <= 0) {
        var tpl = seed.integer;
        var n = tpl.$1;
        var s = tpl.$2;

        while (n < l || n > h) {
          tpl = s.integer;
          n = tpl.$1;
          s = tpl.$2;
        }

        return genr(Some(n), s);
      } else {
        final (n, s) = seed.integer;
        final foo = l + (n & Integer.MaxValue) % d;

        return genr(Some(foo), s);
      }
    }
  }

  GenR<double> chDouble(double l, double h, GenParameters p, Seed seed) {
    final d = h - l;
    if (d < 0) {
      throw ArgumentError('invalid chDouble parameters: $l, $h');
    } else if (d > double.maxFinite) {
      final (x, seed2) = seed.integer;
      if (x < 0) {
        return chDouble(l, 0, p, seed2);
      } else {
        return chDouble(0, h, p, seed2);
      }
    } else if (d == 0) {
      return genr(Some(l), seed);
    } else {
      final (n, s) = seed.dubble;
      return genr(Some(n * (h - l) + l), s);
    }
  }

  GenR<BigInt> chBigInteger(BigInt lower, BigInt span, Seed seed0) {
    final bitLen = span.bitLength;
    final byteLen = (bitLen + 7) ~/ 8;
    final bytes = Array.fill(byteLen, 0);
    var seed = seed0;
    var i = 0;
    while (i < bytes.length) {
      // generate a random long value (i.e. 8 random bytes)
      final (x0, seed1) = seed.integer;
      var x = x0;
      seed = seed1;

      // extract each byte in turn and add them to our byte array
      var j = 0;
      while (j < 8 && i < bytes.length) {
        final b = x & 0xff;
        bytes[i] = b;
        x = x >>> 8;
        i += 1;
        j += 1;
      }
    }

    // we may not need all 8 bits of our most significant byte. if
    // not, mask off any unneeded upper bits.
    final bitRem = bitLen & 7;
    if (bitRem != 0) {
      final mask = 0xff >>> (8 - bitRem);
      bytes[0] = bytes[0]! & mask;
    }

    // construct a BigInteger and see if its valid. if so, we're
    // done. otherwise, we need to restart using our new seed.
    BigInt big = BigInt.zero;
    bytes.foreach((byte) => big = (big << 8) | BigInt.from(byte! & 0xff));

    if (big.compareTo(span) < 0) {
      return genr(Some(big + lower), seed);
    } else {
      return chBigInteger(lower, span, seed);
    }
  }
}

final class _ChooseImpl<T> extends Choose<T> {
  final Function2<T, T, Gen2<T>> chooseF;

  _ChooseImpl(this.chooseF);

  @override
  Gen2<T> choose(T min, T max) => chooseF(min, max);
}
