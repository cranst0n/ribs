part of 'rill.dart';

/// Provides high-level inspection methods for a Rills's underlying Pull.
class ToPull<O> {
  final Rill<O> self;

  ToPull(this.self);

  /// Skips the first [n] elements and returns the remainder of the rill.
  Pull<O, Option<Rill<O>>> drop(int n) {
    if (n <= 0) {
      return Pull.pure(Some(self));
    } else {
      return uncons.flatMap((opt) {
        return opt.foldN(
          () => Pull.pure(none()),
          (hd, tl) {
            final m = hd.size;

            if (m < n) {
              return tl.pull.drop(n - m);
            } else if (m == n) {
              return Pull.pure(Some(tl));
            } else {
              return Pull.pure(Some(tl.cons(hd.drop(n))));
            }
          },
        );
      });
    }
  }

  Pull<Never, Option<Rill<O>>> dropThrough(Function1<O, bool> p) => _dropWhile(p, true);

  Pull<Never, Option<Rill<O>>> dropWhile(Function1<O, bool> p) => _dropWhile(p, false);

  Pull<Never, Option<Rill<O>>> _dropWhile(Function1<O, bool> p, bool dropFailure) {
    return uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(none()),
        (hd, tl) {
          return hd.indexWhere((o) => !p(o)).fold(
            () => tl.pull._dropWhile(p, dropFailure),
            (idx) {
              final toDrop = dropFailure ? idx + 1 : idx;
              return Pull.pure(Some(tl.cons(hd.drop(toDrop))));
            },
          );
        },
      );
    });
  }

  /// Runs the underlying pull, effectively "echoing" the rill.
  Pull<O, Unit> get echo => self.underlying;

  Pull<Never, O2> fold<O2>(O2 z, Function2<O2, O, O2> f) => uncons.flatMap((hdtl) {
    return hdtl.foldN(
      () => Pull.pure(z),
      (hd, tl) {
        final acc = hd.foldLeft(z, f);
        return tl.pull.fold(acc, f);
      },
    );
  });

  Pull<Never, Option<O>> fold1(Function2<O, O, O> f) => uncons.flatMap((hdtl) {
    return hdtl.foldN(
      () => Pull.pure(none()),
      (hd, tl) {
        final fst = hd.drop(1).foldLeft(hd[0], f);
        return tl.pull.fold(fst, f).map((o) => Some(o));
      },
    );
  });

  /// Checks a predicate for all elements, short-circuiting on failure.
  Pull<Never, bool> forall(Function1<O, bool> p) {
    return uncons.flatMap((opt) {
      return opt.foldN(
        () => Pull.pure(true),
        (hd, tl) => hd.forall(p) ? tl.pull.forall(p) : Pull.pure(false),
      );
    });
  }

  Pull<Never, Option<O>> get last {
    Pull<Never, Option<O>> go(Option<O> prev, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.pure(prev),
          (hd, tl) => go(hd.lastOption, tl),
        );
      });
    }

    return go(none(), self);
  }

  Pull<O2, S> scanChunks<S, O2>(S initial, Function2<S, Chunk<O>, (S, Chunk<O2>)> f) =>
      scanChunksOpt(initial, (s) => Some((c) => f(s, c)));

  Pull<O2, S> scanChunksOpt<S, O2>(
    S initial,
    Function1<S, Option<Function1<Chunk<O>, (S, Chunk<O2>)>>> f,
  ) {
    Pull<O2, S> go(S acc, Rill<O> s) {
      return f(acc).fold(
        () => Pull.pure(acc),
        (g) {
          return s.pull.uncons.flatMap((hdtl) {
            return hdtl.foldN(
              () => Pull.pure(acc),
              (hd, tl) {
                final (s2, c) = g(hd);
                return Pull.output(c).append(() => go(s2, tl));
              },
            );
          });
        },
      );
    }

    return go(initial, self);
  }

  /// Emits the first [n] elements and returns the remainder of the Rill.
  Pull<O, Option<Rill<O>>> take(int n) {
    if (n <= 0) {
      return Pull.pure(const None());
    } else {
      return uncons.flatMap((opt) {
        return opt.foldN(
          () => Pull.pure(none()),
          (hd, tl) {
            final m = hd.size;

            if (m < n) {
              return Pull.output(hd).flatMap((_) => tl.pull.take(n - m));
            } else if (m == n) {
              return Pull.output(hd).as(Some(tl));
            } else {
              final (pfx, sfx) = hd.splitAt(n);
              return Pull.output(pfx).as(Some(tl.cons(sfx)));
            }
          },
        );
      });
    }
  }

  Pull<Never, Chunk<O>> takeRight(int n) {
    Pull<Never, Chunk<O>> go(Chunk<O> acc, Rill<O> s) {
      return s.pull.unconsN(n, allowFewer: true).flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.pure(acc),
          (hd, tl) => go(acc.drop(hd.size).concat(hd), tl),
        );
      });
    }

    if (n <= 0) {
      return Pull.pure(Chunk.empty());
    } else {
      return go(Chunk.empty(), self);
    }
  }

  Pull<O, Option<Rill<O>>> takeThrough(Function1<O, bool> p) => _takeWhile(p, true);

  Pull<O, Option<Rill<O>>> takeWhile(Function1<O, bool> p, {bool takeFailure = false}) =>
      _takeWhile(p, takeFailure);

  Pull<O, Option<Rill<O>>> _takeWhile(Function1<O, bool> p, bool takeFailure) {
    return uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(none()),
        (hd, tl) {
          return hd.indexWhere((o) => !p(o)).fold(
            () => Pull.output(hd).append(() => tl.pull._takeWhile(p, takeFailure)),
            (idx) {
              final toTake = takeFailure ? idx + 1 : idx;
              final (pfx, sfx) = hd.splitAt(toTake);

              return Pull.output(pfx).append(() => Pull.pure(Some(tl.cons(sfx))));
            },
          );
        },
      );
    });
  }

  /// Peels off the next chunk, wrapping the remainder back into a Rill.
  Pull<Never, Option<(Chunk<O>, Rill<O>)>> get uncons {
    return self.underlying.uncons.map((opt) {
      return opt.mapN((chunk, rest) {
        return (chunk, rest.rillNoScope);
      });
    });
  }

  Pull<Never, Option<(O, Rill<O>)>> get uncons1 {
    return uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(const None()),
        (hd, tl) {
          final ntl = hd.size == 1 ? tl : tl.cons(hd.drop(1));
          return Pull.pure(Some((hd[0], ntl)));
        },
      );
    });
  }

  Pull<Never, Option<(Chunk<O>, Rill<O>)>> unconsLimit(int n) {
    if (n <= 0) {
      return Pull.pure(Some((Chunk.empty(), self)));
    } else {
      return uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.pure(none()),
          (hd, tl) {
            if (hd.size < n) {
              return Pull.pure(Some((hd, tl)));
            } else {
              final (out, rem) = hd.splitAt(n);
              return Pull.pure(Some((out, tl.cons(rem))));
            }
          },
        );
      });
    }
  }

  Pull<Never, Option<(Chunk<O>, Rill<O>)>> unconsMin(
    int n, {
    bool allowFewerTotal = false,
  }) {
    Pull<Never, Option<(Chunk<O>, Rill<O>)>> go(Chunk<O> acc, int n, Rill<O> s) {
      return s.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () {
            if (allowFewerTotal && acc.nonEmpty) {
              return Pull.pure(Some((acc, Rill.empty())));
            } else {
              return Pull.pure(none());
            }
          },
          (hd, tl) {
            if (hd.size < n) {
              return go(acc.concat(hd), n - hd.size, tl);
            } else {
              return Pull.pure(Some((acc.concat(hd), tl)));
            }
          },
        );
      });
    }

    if (n <= 0) {
      return Pull.pure(Some((Chunk.empty(), self)));
    } else {
      return go(Chunk.empty(), n, self);
    }
  }

  Pull<Never, Option<(Chunk<O>, Rill<O>)>> unconsN(
    int n, {
    bool allowFewer = false,
  }) {
    if (n <= 0) {
      return Pull.pure(Some((Chunk.empty(), self)));
    } else {
      return unconsMin(n, allowFewerTotal: allowFewer).map((hdtl) {
        return hdtl.mapN((hd, tl) {
          final (pfx, sfx) = hd.splitAt(n);
          return (pfx, tl.cons(sfx));
        });
      });
    }
  }
}
