import 'package:ribs_core/ribs_core.dart';

class Ref<A> {
  A _underlying;

  static IO<Ref<A>> of<A>(A a) => IO.delay(() => unsafe(a));

  static Ref<A> unsafe<A>(A a) => Ref._(a);

  Ref._(this._underlying);

  IO<(A, Function1<A, IO<bool>>)> access() => IO.delay(() {
        final snapshot = _underlying;

        IO<bool> setter(A a) => IO.delay(() {
              if (_underlying == snapshot) {
                _underlying = a;
                return true;
              } else {
                return false;
              }
            });

        return (snapshot, setter);
      });

  /// Like [modify], but also schedules the resulting effect right after
  /// modification. The modification and finalizer are both withing an
  /// uncancelable region to prevent out-of-sync issues.
  ///
  /// See [flatModifyFull] to create a finalizer that
  /// can potentially be canceled.
  IO<B> flatModify<B>(Function1<A, (A, IO<B>)> f) =>
      IO.uncancelable((_) => modify(f).flatten());

  IO<B> flatModifyFull<B>(Function1<(Poll, A), (A, IO<B>)> f) =>
      IO.uncancelable((poll) => modify((a) => f((poll, a))).flatten());

  IO<A> getAndUpdate(Function1<A, A> f) => modify((a) => (f(a), a));

  IO<A> getAndSet(A a) => getAndUpdate((_) => a);

  IO<B> modify<B>(Function1<A, (A, B)> f) =>
      IO.delay(() => f(_underlying)((newA, result) {
            _underlying = newA;
            return result;
          }));

  IO<Unit> setValue(A a) => IO.exec(() => _underlying = a);

  IO<bool> tryUpdate(Function1<A, A> f) =>
      tryModify((a) => (f(a), Unit())).map((a) => a.isDefined);

  IO<Option<B>> tryModify<B>(Function1<A, (A, B)> f) => IO.delay(() {
        final c = _underlying;

        return f(c)(
          (u, b) {
            if (c == _underlying) {
              _underlying = u;
              return Some(b);
            } else {
              return none();
            }
          },
        );
      });

  IO<Unit> update(Function1<A, A> f) =>
      IO.exec(() => _underlying = f(_underlying));

  IO<A> updateAndGet(Function1<A, A> f) => modify((a) {
        final newA = f(a);
        return (newA, newA);
      });

  IO<A> value() => IO.delay(() => _underlying);
}