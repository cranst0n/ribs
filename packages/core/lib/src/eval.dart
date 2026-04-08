import 'package:ribs_core/ribs_core.dart';

/// A data type for controlling evaluation semantics: eager, lazy-memoized,
/// or always-recomputed.
///
/// [Eval] has three primary subtypes, analogous to `final`, `late`,
/// and a function:
///
/// - [Eval.now] — value computed immediately (eager), like `final`.
/// - [Eval.later] — value computed once on first access and memoized, like
///   `late`.
/// - [Eval.always] — value recomputed on every access, like a function invocation.
///
/// [flatMap] chains are evaluated using a trampoline, making them stack-safe
/// even for deeply recursive computations.
///
/// Example:
/// ```dart
/// final result = Eval.always(() => expensiveComputation())
///     .map((n) => n * 2)
///     .flatMap((n) => Eval.now(n + 1));
/// print(result.value);
/// ```
sealed class Eval<A> {
  const Eval._();

  /// Creates an [Eval] whose value is already computed.
  ///
  /// Analogous to `final` — no deferred work, [value] returns immediately.
  static Eval<A> now<A>(A a) => _Now(a);

  /// Creates an [Eval] that computes [f] on first access and memoizes the
  /// result.
  ///
  /// Analogous to `late` — [f] is called at most once.
  static Eval<A> later<A>(Function0<A> f) => _Later(f);

  /// Creates an [Eval] that calls [f] on every access.
  ///
  /// Analogous to function call — [f] is called every time [value] is read.
  static Eval<A> always<A>(Function0<A> f) => _Always(f);

  /// Creates an [Eval] whose evaluation is deferred to another [Eval] produced
  /// by [f].
  ///
  /// Useful for building recursive [Eval] values without stack overflow:
  /// ```dart
  /// Eval<int> countdown(int n) =>
  ///     n <= 0 ? Eval.now(0) : Eval.defer(() => countdown(n - 1));
  /// ```
  static Eval<A> defer<A>(Function0<Eval<A>> f) => _Defer(Fn0(f));

  /// Creates an [Eval] whose value is already computed. Alias for [now].
  static Eval<A> pure<A>(A a) => now(a);

  /// An already-evaluated [Eval] of [Unit].
  static final Eval<Unit> unit = now(Unit());

  /// Extracts the value, triggering any pending computation.
  ///
  /// - [now]: returns immediately.
  /// - [later]: evaluates once and memoizes.
  /// - [always]: evaluates every time.
  /// - [flatMap] / [defer] chains: evaluated with a stack-safe trampoline.
  A get value => _run(this) as A;

  /// Returns an [Eval] whose value is the result of applying [f] to this value.
  Eval<B> map<B>(Function1<A, B> f) => flatMap((a) => _Now(f(a)));

  /// Returns an [Eval] that evaluates this, then passes the result to [f].
  ///
  /// Chains are evaluated stack-safely via trampolining.
  Eval<B> flatMap<B>(Function1<A, Eval<B>> f) => _Bind<A, B>(this, Fn1(f));

  /// Returns a memoized version of this [Eval].
  ///
  /// If this is already memoized ([now] or [later]), returns [this].
  /// Otherwise wraps in a [later] so [f] / the chain is evaluated at most once.
  Eval<A> memoize();

  /// Evaluates this and then [other], discarding the result of [other].
  Eval<A> productL<B>(Eval<B> other) => flatMap((a) => other.map((_) => a));

  /// Evaluates this and then [other], discarding the result of this.
  Eval<B> productR<B>(Eval<B> other) => flatMap((_) => other);

  // Uses nominal Fn0/Fn1 wrappers (from fn.dart) so continuations can live
  // safely in a heterogeneous List without Dart's function-variance checks
  // rejecting the cast.
  static dynamic _run(Eval<dynamic> start) {
    Eval<dynamic> cur = start;
    final stack = <Fn1<dynamic, Eval<dynamic>>>[];

    while (true) {
      if (cur is _Bind) {
        // Unroll the Bind onto the stack and descend into the source.
        stack.add(cur._f);
        cur = cur._source;
      } else if (cur is _Defer) {
        cur = cur._thunk();
      } else {
        // Leaf nodes: _Now, _Later, _Always
        final dynamic a;

        if (cur is _Now) {
          a = cur._value;
        } else if (cur is _Later) {
          a = cur._computed; // triggers lazy init on first access
        } else {
          a = (cur as _Always)._thunk();
        }

        if (stack.isEmpty) return a;

        cur = stack.removeLast()(a);
      }
    }
  }
}

/// Already-evaluated value.
final class _Now<A> extends Eval<A> {
  final A _value;

  const _Now(this._value) : super._();

  @override
  Eval<A> memoize() => this;
}

/// Lazy memoized value — [_computed] is initialized at most once.
final class _Later<A> extends Eval<A> {
  final Function0<A> _f;

  // Dart's `late final` with an initializer expression is evaluated exactly
  // once on first read, giving us lazy semantics.
  late final A _computed = _f();

  _Later(this._f) : super._();

  @override
  Eval<A> memoize() => this;
}

/// Always-recomputed value.
final class _Always<A> extends Eval<A> {
  final Function0<A> _thunk;

  _Always(this._thunk) : super._();

  @override
  Eval<A> memoize() => _Later(_thunk);
}

/// Defers evaluation to another [Eval] produced by [_thunk].
final class _Defer<A> extends Eval<A> {
  final Fn0<Eval<A>> _thunk;

  _Defer(this._thunk) : super._();

  @override
  Eval<A> memoize() => _Later(() => value);
}

/// Represents a [flatMap] step — the trampoline node.
final class _Bind<S, A> extends Eval<A> {
  final Eval<S> _source;
  final Fn1<S, Eval<A>> _f;

  _Bind(this._source, this._f) : super._();

  @override
  Eval<A> memoize() => _Later(() => value);
}

/// Additional operations on nested [Eval]s.
extension EvalNestedOps<A> on Eval<Eval<A>> {
  /// Flattens a nested [Eval] into a single [Eval].
  Eval<A> flatten() => flatMap(identity);
}
