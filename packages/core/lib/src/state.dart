import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@immutable
class State<S, A> extends Monad<A> {
  final Tuple2<S, A> Function(S state) _run;

  State(this._run);

  static State<S, A> pure<S, A>(A t) => State((s) => Tuple2(s, t));

  @override
  State<S, B> ap<B>(State<S, Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  @override
  State<S, B> flatMap<B>(State<S, B> Function(A a) f) =>
      State((s) => _run(s)((s0, b) => f(b)._run(s0)));

  @override
  State<S, U> map<U>(U Function(A a) f) => flatMap((t) => State.pure(f(t)));

  State<S, A> modify(Function1<S, S> f) =>
      State((s) => _run(s)((a, b) => Tuple2(f(a), b)));

  Tuple2<S, A> run(S state) => _run(state);

  A runA(S state) => run(state).$2;

  S runS(S state) => run(state).$1;

  State<S, S> get state => State((s) => _run(s)((s, a) => Tuple2(s, s)));

  State<S, B> transform<B>(Function2<S, A, Tuple2<S, B>> f) =>
      State((s) => _run(s)(f));
}
