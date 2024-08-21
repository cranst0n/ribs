import 'package:ribs_check/src/sandbox/gen2.dart';
import 'package:ribs_check/src/sandbox/seed.dart';
import 'package:ribs_core/ribs_core.dart';

sealed class Prop2 {
  PropResult apply(GenParameters params);

  static Prop2 simple<U>(Function0<U> body) => instance((_) {
        try {
          body();
          return PropResult.trued;
        } on Exception catch (ex) {
          return PropResult.exceptional(ex);
        }
      });

  static Prop2 boolean(Function0<bool> b) => b() ? proved : falsified;

  static Prop2 result(PropResult result) => instance((_) => result);

  static Prop2 exceptional(Exception ex) => status(Exceptional(ex));
  static Prop2 falsified = status(False());
  static Prop2 passed = status(True());
  static Prop2 proved = status(Proof());
  static Prop2 undecided = status(Undecided());

  static Prop2 status(PropStatus status) => Prop2.result(
      PropResult(status, nil(), ISet.empty(), ISet.empty(), none()));

  Prop2 combine(Function0<Prop2> p,
          Function2<PropResult, PropResult, PropResult> f) =>
      flatMap((r1) => p().map((r2) => f(r1, r2)));

  Prop2 flatMap(Function1<PropResult, Prop2> f) => _Prop2Imp((prms0) {
        final res = apply(prms0);
        final prms1 = slideSeed(prms0);
        return f(res).apply(prms1);
      });

  Prop2 map(Function1<PropResult, PropResult> f) =>
      _Prop2Imp((params) => f(apply(params)));

  Prop2 useSeed(Seed seed) =>
      _Prop2Imp((params) => apply(params.withInitialSeed(seed)));

  static Prop2 forAll<T>(
    String name,
    Gen2<T> g,
    Function1<T, ILazyList<T>> shrink,
    Function1<T, Prop2> f,
    Function1<T, String> pp,
  ) {
    return _Prop2Imp((prms0) {
      final (prms, seed) = startSeed(prms0);
      final gr = g.doApply(prms, seed);
      final labels = gr.labels.mkString(sep: ',');

      PropResult result(T x) {
        final p = secure(() => f(x));
        return provedToTrue(p.apply(slideSeed(prms0)));
      }

      Either<(T, PropResult), (T, PropResult)> getFirstFailure(
        ILazyList<T> xs,
        Option<Type> exceptionFilter,
      ) {
        final results = xs.map((x) => (x, result(x)));

        return results
            .dropWhile((tuple) {
              final (_, result) = tuple;

              return switch (result.status) {
                Exceptional(e: final ex) =>
                  !exceptionFilter.exists((tipe) => ex.runtimeType == tipe),
                _ => !result.failure,
              };
            })
            .headOption
            .fold(() => results.head.asRight(), (xr) => xr.asLeft());
      }

      PropResult replOrig(PropResult r0, PropResult r1) {
        if (r0.args.nonEmpty && r1.args.nonEmpty) {
          return r1.copy(
            args: r1.args.tail().prepended(r1.args.head.copy(
                  origArg: r0.args.head.origArg,
                  prettyOrigArg: r0.args.head.prettyOrigArg,
                )),
          );
        } else {
          return r1;
        }
      }

      PropResult shrinker(T x, PropResult r, int shrinks, T orig) {
        final xs = shrink(x);
        final res = r.addArg(Arg<T>(labels, x, shrinks, orig, pp, pp));
        final originalException = Some(r.status).collect((status) =>
            Option.when(() => status is Exceptional,
                () => (status as Exceptional).e.runtimeType));

        if (xs.isEmpty) {
          return res;
        } else {
          return getFirstFailure(xs, originalException).fold(
            (tup) {
              final (x2, r2) = tup;
              return shrinker(x2, replOrig(r, r2), shrinks + 1, orig);
            },
            (_) => res,
          );
        }
      }

      return gr.retrieve.fold(
        () =>
            PropResult(Undecided(), nil(), ISet.empty(), ISet.empty(), none()),
        (x) {
          final r = result(x);
          final res = shrinker(x, r, 0, x);

          if (res.failure) {
            return res.copy(failingSeed: seed);
          } else {
            return res;
          }
        },
      );
    });
  }

  static PropResult mergeRes(PropResult x, PropResult y, PropStatus st) =>
      PropResult(
        st,
        x.args.concat(y.args),
        x.collected.concat(y.collected),
        x.labels.concat(y.labels),
        x.failingSeed.orElse(() => y.failingSeed),
      );

  static PropResult provedToTrue(PropResult r) => switch (r.status) {
        Proof() => r.copy(status: True()),
        _ => r,
      };

  static (GenParameters, Seed) startSeed(GenParameters prms) {
    return prms.initialSeed.fold(
      () => (prms, Seed.random()),
      (seed) => (prms.withoutInitialSeed, seed),
    );
  }

  static GenParameters slideSeed(GenParameters prms) {
    return prms.initialSeed.fold(
      () => prms,
      (seed) => prms.withInitialSeed(seed.slide()),
    );
  }

  static Prop2 secure(Function0<Prop2> p) {
    try {
      return p();
    } on Exception catch (ex) {
      return Prop2.exceptional(ex);
    }
  }

  static Prop2 instance(Function1<GenParameters, PropResult> f) =>
      _Prop2Imp((prms) {
        try {
          return f(prms);
        } on Exception catch (ex) {
          return PropResult(Exceptional(ex), nil(), ISet.empty(), ISet.empty(),
              prms.initialSeed);
        }
      });
}

final class _Prop2Imp extends Prop2 {
  final Function1<GenParameters, PropResult> applyF;

  _Prop2Imp(this.applyF);

  @override
  PropResult apply(GenParameters params) => applyF(params);
}

final class PropResult {
  final PropStatus status;
  final IList<Arg<dynamic>> args;
  final ISet<dynamic> collected;
  final ISet<String> labels;
  final Option<Seed> failingSeed;

  PropResult(
    this.status,
    this.args,
    this.collected,
    this.labels,
    this.failingSeed,
  );

  static PropResult proof = ofStatus(Proof());
  static PropResult trued = ofStatus(True());
  static PropResult falsed = ofStatus(False());
  static PropResult undecided = ofStatus(Undecided());
  static PropResult exceptional(Exception ex) => ofStatus(Exceptional(ex));

  static PropResult ofStatus(PropStatus status) =>
      PropResult(status, nil(), ISet.empty(), ISet.empty(), none());

  bool get success => switch (status) {
        True() => true,
        Proof() => true,
        _ => false,
      };

  bool get failure => switch (status) {
        False() => true,
        Exceptional(e: _) => true,
        _ => false,
      };

  bool get proved => this is Proof;

  PropResult addArg(Arg<dynamic> arg) => copy(args: args.prepended(arg));

  PropResult copy({
    PropStatus? status,
    IList<Arg<dynamic>>? args,
    ISet<dynamic>? collected,
    ISet<String>? labels,
    Seed? failingSeed,
  }) =>
      PropResult(
        status ?? this.status,
        args ?? this.args,
        collected ?? this.collected,
        labels ?? this.labels,
        Option(failingSeed ?? this.failingSeed.toNullable()),
      );

  @override
  String toString() => 'PropResult($status, $args, $collected, $labels)';
}

sealed class PropStatus {}

final class Proof extends PropStatus {}

final class True extends PropStatus {}

final class False extends PropStatus {}

final class Undecided extends PropStatus {}

final class Exceptional extends PropStatus {
  final Exception e;

  Exceptional(this.e);

  @override
  String toString() => 'Exceptional: $e';
}

final class Arg<T> {
  final String label;
  final T arg;
  final int shrinks;
  final T origArg;
  final Function1<T, String> prettyArg;
  final Function1<T, String> prettyOrigArg;

  Arg(
    this.label,
    this.arg,
    this.shrinks,
    this.origArg,
    this.prettyArg,
    this.prettyOrigArg,
  );

  String get argString => prettyArg(arg);
  String get origArgString => prettyOrigArg(origArg);

  Arg<T> copy({
    String? label,
    T? arg,
    int? shrinks,
    T? origArg,
    Function1<T, String>? prettyArg,
    Function1<T, String>? prettyOrigArg,
  }) =>
      Arg(
        label ?? this.label,
        arg ?? this.arg,
        shrinks ?? this.shrinks,
        origArg ?? this.origArg,
        prettyArg ?? this.prettyArg,
        prettyOrigArg ?? this.prettyOrigArg,
      );

  @override
  String toString() =>
      'Arg($label, ${prettyArg(arg)}, $shrinks, ${prettyOrigArg(origArg)})';
}
