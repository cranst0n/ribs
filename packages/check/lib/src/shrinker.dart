import 'package:ribs_core/ribs_core.dart';

class Shrinker<A> {
  final Function1<A, ILazyList<A>> _shrinkF;

  Shrinker(this._shrinkF);

  ILazyList<A> shrink(A a) => _shrinkF(a);

  Shrinker<B> xmap<B>(
    Function1<A, B> f,
    Function1<B, A> g,
  ) => Shrinker((B b) => shrink(g(b)).map(f));

  static Shrinker<double> dubble = Shrinker<double>((d) {
    if (d == 0.0) {
      return ILazyList.empty();
    } else {
      final candidates = <double>[];

      if (d.sign != 0.0) candidates.add(0.0);

      var delta = d.abs() / 2.0;

      while (delta > 1e-12) {
        candidates.add(d - (delta * d.sign));
        delta /= 2.0;
      }

      return ILazyList.from(IList.fromDart(candidates));
    }
  });

  static Shrinker<int> integer = Shrinker<int>((i) {
    if (i == 0) {
      return ILazyList.empty();
    } else {
      final candidates = <int>[];

      if (i.sign != 0) candidates.add(0);

      var delta = i.abs() ~/ 2;

      while (delta > 0) {
        candidates.add(i - (delta * i.sign));
        delta ~/= 2;
      }

      return ILazyList.from(IList.fromDart(candidates));
    }
  });

  static Shrinker<Option<A>> option<A>(
    Shrinker<A>? sa,
  ) => Shrinker<Option<A>>((o) {
    return o.fold(
      () => ILazyList.empty(),
      (value) => (sa?.shrink(value).map((a) => a.some) ?? ILazyList.empty()).prepended(none<A>()),
    );
  });

  static Shrinker<Either<A, B>> either<A, B>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
  ) => Shrinker<Either<A, B>>((e) {
    return e.fold(
      (a) => sa?.shrink(a).map((a) => a.asLeft<B>()) ?? ILazyList.empty(),
      (b) => sb?.shrink(b).map((b) => b.asRight<A>()) ?? ILazyList.empty(),
    );
  });

  static Shrinker<IList<A>> ilist<A>(
    Shrinker<A>? sa,
  ) => Shrinker<IList<A>>((l) {
    if (l.isEmpty) {
      return ILazyList.empty();
    } else {
      final halves =
          ILazyList.unfold<ILazyList<IList<A>>, int>(
            l.length ~/ 2,
            (k) =>
                k > 0
                    ? Some((
                      ILazyList.tabulate(
                        l.length - k + 1,
                        (i) => i,
                      ).map((i) => l.take(i).concat(l.drop(i + k))),
                      k ~/ 2,
                    ))
                    : const None(),
          ).flatten();

      final empty = ILazyList.from(IList.fromDart([nil<A>()]));

      final elements =
          sa == null
              ? ILazyList.empty<IList<A>>()
              : ILazyList.tabulate(l.length, (i) => i).flatMap(
                (i) => sa.shrink(l[i]).map((shrunk) => l.updated(i, shrunk)),
              );

      return halves.concat(empty).concat(elements);
    }
  });

  static Shrinker<IMap<A, B>> imap<A, B>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
  ) => ilist(tuple2(sa, sb)).xmap(
    (l) => IMap.from(l),
    (m) => m.toIList(),
  );

  static Shrinker<List<A>> list<A>(
    Shrinker<A>? elementShrinker,
  ) => ilist(elementShrinker).xmap((l) => l.toList(), (l) => IList.fromDart(l));

  static Shrinker<Map<A, B>> map<A, B>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
  ) => ilist(tuple2(sa, sb)).xmap(
    (l) => IMap.from(l).toMap(),
    (m) => IMap.fromDart(m).toIList(),
  );

  static Shrinker<String> string = list(
    Shrinker<String>((s) => ILazyList.empty()),
  ).xmap((l) => l.join(), (s) => s.split(''));

  static Shrinker<(A, B)> tuple2<A, B>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
  ) => Shrinker<(A, B)>(
    (t) => ILazyList.unfold<(A, B), (RIterator<A>?, RIterator<B>?)>(
      (sa?.shrink(t.$1).iterator, sb?.shrink(t.$2).iterator),
      (state) {
        final (itA, itB) = state;

        if (itA != null && itA.hasNext) {
          return Some(((itA.next(), t.$2), (itA, itB)));
        } else if (itB != null && itB.hasNext) {
          return Some(((t.$1, itB.next()), (null, itB)));
        } else {
          return none();
        }
      },
    ),
  );

  static Shrinker<(A, B, C)> tuple3<A, B, C>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
  ) {
    final s2 = tuple2(sa, sb);

    return Shrinker(
      (t) => s2
          .shrink((t.$1, t.$2))
          .map((ab) => (ab.$1, ab.$2, t.$3))
          .concat(sc?.shrink(t.$3).map((c) => (t.$1, t.$2, c)) ?? ILazyList.empty()),
    );
  }

  static Shrinker<(A, B, C, D)> tuple4<A, B, C, D>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
  ) {
    final s3 = tuple3(sa, sb, sc);

    return Shrinker(
      (t) => s3
          .shrink((t.$1, t.$2, t.$3))
          .map((abc) => (abc.$1, abc.$2, abc.$3, t.$4))
          .concat(sd?.shrink(t.$4).map((d) => (t.$1, t.$2, t.$3, d)) ?? ILazyList.empty()),
    );
  }

  static Shrinker<(A, B, C, D, E)> tuple5<A, B, C, D, E>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
  ) {
    final s4 = tuple4(sa, sb, sc, sd);

    return Shrinker(
      (t) => s4
          .shrink((t.$1, t.$2, t.$3, t.$4))
          .map((abcd) => (abcd.$1, abcd.$2, abcd.$3, abcd.$4, t.$5))
          .concat(se?.shrink(t.$5).map((e) => (t.$1, t.$2, t.$3, t.$4, e)) ?? ILazyList.empty()),
    );
  }

  static Shrinker<(A, B, C, D, E, F)> tuple6<A, B, C, D, E, F>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
    Shrinker<F>? sf,
  ) {
    final s5 = tuple5(sa, sb, sc, sd, se);

    return Shrinker(
      (t) => s5
          .shrink((t.$1, t.$2, t.$3, t.$4, t.$5))
          .map((abcde) => (abcde.$1, abcde.$2, abcde.$3, abcde.$4, abcde.$5, t.$6))
          .concat(
            sf?.shrink(t.$6).map((f) => (t.$1, t.$2, t.$3, t.$4, t.$5, f)) ?? ILazyList.empty(),
          ),
    );
  }

  static Shrinker<(A, B, C, D, E, F, G)> tuple7<A, B, C, D, E, F, G>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
    Shrinker<F>? sf,
    Shrinker<G>? sg,
  ) {
    final s6 = tuple6(sa, sb, sc, sd, se, sf);

    return Shrinker(
      (t) => s6
          .shrink((t.$1, t.$2, t.$3, t.$4, t.$5, t.$6))
          .map((abcdef) => (abcdef.$1, abcdef.$2, abcdef.$3, abcdef.$4, abcdef.$5, abcdef.$6, t.$7))
          .concat(
            sg?.shrink(t.$7).map((g) => (t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, g)) ??
                ILazyList.empty(),
          ),
    );
  }

  static Shrinker<(A, B, C, D, E, F, G, H)> tuple8<A, B, C, D, E, F, G, H>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
    Shrinker<F>? sf,
    Shrinker<G>? sg,
    Shrinker<H>? sh,
  ) {
    final s7 = tuple7(sa, sb, sc, sd, se, sf, sg);

    return Shrinker(
      (t) => s7
          .shrink((t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7))
          .map((t7) => (t7.$1, t7.$2, t7.$3, t7.$4, t7.$5, t7.$6, t7.$7, t.$8))
          .concat(
            sh?.shrink(t.$8).map((h) => (t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, h)) ??
                ILazyList.empty(),
          ),
    );
  }

  static Shrinker<(A, B, C, D, E, F, G, H, I)> tuple9<A, B, C, D, E, F, G, H, I>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
    Shrinker<F>? sf,
    Shrinker<G>? sg,
    Shrinker<H>? sh,
    Shrinker<I>? si,
  ) {
    final s8 = tuple8(sa, sb, sc, sd, se, sf, sg, sh);

    return Shrinker(
      (t) => s8
          .shrink((t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8))
          .map((t8) => (t8.$1, t8.$2, t8.$3, t8.$4, t8.$5, t8.$6, t8.$7, t8.$8, t.$9))
          .concat(
            si?.shrink(t.$9).map((i) => (t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, i)) ??
                ILazyList.empty(),
          ),
    );
  }

  static Shrinker<(A, B, C, D, E, F, G, H, I, J)> tuple10<A, B, C, D, E, F, G, H, I, J>(
    Shrinker<A>? sa,
    Shrinker<B>? sb,
    Shrinker<C>? sc,
    Shrinker<D>? sd,
    Shrinker<E>? se,
    Shrinker<F>? sf,
    Shrinker<G>? sg,
    Shrinker<H>? sh,
    Shrinker<I>? si,
    Shrinker<J>? sj,
  ) {
    final s9 = tuple9(sa, sb, sc, sd, se, sf, sg, sh, si);

    return Shrinker(
      (t) => s9
          .shrink((t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9))
          .map((t9) => (t9.$1, t9.$2, t9.$3, t9.$4, t9.$5, t9.$6, t9.$7, t9.$8, t9.$9, t.$10))
          .concat(
            sj
                    ?.shrink(t.$10)
                    .map((j) => (t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, j)) ??
                ILazyList.empty(),
          ),
    );
  }
}
