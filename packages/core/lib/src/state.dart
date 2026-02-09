import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Data type that models state transitions of type `T`, yielding a value of
/// type `A`.
@immutable
final class State<S, A> with Functor<A>, Applicative<A>, Monad<A> {
  final Function1<S, (S, A)> _run;

  /// Creates a new state that will run according to the given function.
  State(this._run);

  /// Lifts the pure value [t] into [State].
  static State<S, A> pure<S, A>(A t) => State((s) => (s, t));

  @override
  State<S, B> ap<B>(State<S, Function1<A, B>> f) => flatMap((a) => f.map((f) => f(a)));

  @override
  State<S, B> flatMap<B>(State<S, B> Function(A a) f) =>
      State((s) => _run(s)((s0, b) => f(b)._run(s0)));

  @override
  State<S, U> map<U>(U Function(A a) f) => flatMap((t) => State.pure(f(t)));

  /// Applies [f] to the current state.
  State<S, A> modify(Function1<S, S> f) => State((s) => _run(s)((a, b) => (f(a), b)));

  /// Runs the computation with [state] as the intial state. Returns the a tuple
  /// of the final state and the resulting value.
  (S, A) run(S state) => _run(state);

  /// Runs the computation with [state] as the intial state and returns
  /// the resulting value.
  A runA(S state) => run(state).$2;

  /// Runs the computation with [state] as the intial state and returns
  /// the final state.
  S runS(S state) => run(state).$1;

  /// Returns a [State] that will return the input state, without modifying
  /// the state.
  State<S, S> state() => State((s) => _run(s)((s, _) => (s, s)));

  /// Returns a [State] that will apply [f] to it's resulting value and current
  /// state. Like [map], but both components can be modified.
  State<S, B> transform<B>(Function2<S, A, (S, B)> f) => State((s) => _run(s)(f));
}
