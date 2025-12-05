import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A safe mutable reference.
///
/// Ref provides safe access and modification of a value using [IO].
class Ref<A> {
  /// The current value.
  A _underlying;

  /// Creates a new ref, wrapping the instance in [IO] to preserve referential
  /// transparency.
  static IO<Ref<A>> of<A>(A a) => IO.delay(() => unsafe(a));

  /// Creates a new Ref, seeded with an initial value of [a].
  ///
  /// This is marked as 'unsafe' since it allocates mutable state and thus
  /// isn't referentially transparent.
  static Ref<A> unsafe<A>(A a) => Ref._(a);

  Ref._(this._underlying);

  /// Obtains a snapshot of the current value, and a setter for updating it.
  ///
  /// The setter attempts to modify the contents from the snapshot to the new
  /// value (and return `true`). If it cannot do this (because the contents
  /// changed since taking the snapshot), the setter is a noop and returns
  /// `false`.
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
  /// modification. The modification and finalizer are both within an
  /// uncancelable region to prevent out-of-sync issues.
  ///
  /// See [flatModifyFull] to create a finalizer that
  /// can potentially be canceled.
  IO<B> flatModify<B>(Function1<A, (A, IO<B>)> f) => IO.uncancelable((_) => modify(f).flatten());

  IO<B> flatModifyFull<B>(Function1<(Poll, A), (A, IO<B>)> f) =>
      IO.uncancelable((poll) => modify((a) => f((poll, a))).flatten());

  /// Updates the value of this ref using [f] and returns the previous value.
  IO<A> getAndUpdate(Function1<A, A> f) => modify((a) => (f(a), a));

  /// Sets the value of this ref to [a] and returns the previous value.
  IO<A> getAndSet(A a) => getAndUpdate((_) => a);

  /// Modifies the value of this ref according to [f] and returns the new value.
  IO<B> modify<B>(Function1<A, (A, B)> f) => IO.delay(() => f(_underlying)((newA, result) {
        _underlying = newA;
        return result;
      }));

  /// Sets the value of this ref to [a].
  IO<Unit> setValue(A a) => IO.exec(() => _underlying = a);

  /// Attempts to update the value of this ref according to [f]. If the update
  /// succeeds, `true` is returned, otherwise `false` is returned.
  IO<bool> tryUpdate(Function1<A, A> f) => tryModify((a) => (f(a), Unit())).map((a) => a.isDefined);

  /// Attempts to modify the value of this ref according to [f]. If the
  /// modification succeeds, the new value is returned as a [Some]. If it
  /// fails, [None] is returned.
  IO<Option<B>> tryModify<B>(Function1<A, (A, B)> f) => IO.delay(() {
        final initial = _underlying;

        return f(initial)(
          (u, b) {
            if (initial == _underlying) {
              _underlying = u;
              return Some(b);
            } else {
              return none();
            }
          },
        );
      });

  /// Updates the value of this ref by applying [f] to the current value.
  IO<Unit> update(Function1<A, A> f) => IO.exec(() => _underlying = f(_underlying));

  /// Updates the value of this ref by applying [f] to the current value and
  /// returns the new value.
  IO<A> updateAndGet(Function1<A, A> f) => modify((a) {
        final newA = f(a);
        return (newA, newA);
      });

  /// Returns the current value of this ref.
  IO<A> value() => IO.delay(() => _underlying);
}
