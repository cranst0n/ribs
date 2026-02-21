import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class Signal<A> {
  Signal<A> changes({Function2<A, A, bool>? eq}) => _ChangesSignal(this, eq ?? (a, b) => a == b);

  /// Emits the current value repeatedly, regardless of whether it changed.
  Rill<A> get continuous;

  /// Emits the current value, then emits only when the value changes.
  /// Note: If the source updates faster than the consumer reads, intermediate
  /// updates are dropped. It guarantees you always get the *latest* value.
  Rill<A> get discrete;

  Resource<(A, Rill<A>)> getAndDiscreteUpdates() =>
      discrete.pull.uncons1.flatMap(Pull.outputOption1).rillNoScope.compile.resource.onlyOrError;

  IO<A> value();

  IO<Unit> waitUntil(Function1<A, bool> p) => discrete.forall((a) => !p(a)).compile.drain;
}

extension SignalMapOps<A> on Signal<A> {
  Signal<B> map<B>(Function1<A, B> f) => _MappedSignal(this, f);
}

class _ChangesSignal<A> extends Signal<A> {
  final Signal<A> outer;
  final Function2<A, A, bool> eq;

  _ChangesSignal(this.outer, this.eq);

  @override
  Rill<A> get continuous => outer.continuous;

  @override
  Rill<A> get discrete => outer.discrete.changes(eq: eq);

  @override
  IO<A> value() => outer.value();
}

class _MappedSignal<A, B> extends Signal<B> {
  final Signal<A> outer;
  final Function1<A, B> f;

  _MappedSignal(this.outer, this.f);

  @override
  Rill<B> get continuous => outer.continuous.map(f);

  @override
  Rill<B> get discrete => outer.discrete.map(f);

  @override
  IO<B> value() => outer.value().map(f);

  @override
  Resource<(B, Rill<B>)> getAndDiscreteUpdates() =>
      outer.getAndDiscreteUpdates().mapN((a, updates) => (f(a), updates.map(f)));
}

abstract class SignallingRef<A> implements Ref<A>, Signal<A> {
  static IO<SignallingRef<A>> of<A>(A initial) => Ref.of(
    _State<A>(initial, 0, imap({})),
  ).product(Ref.of(1)).mapN((state, ids) => _SignallingRefImpl(state, ids));
}

class _SignallingRefImpl<A> extends SignallingRef<A> {
  final Ref<_State<A>> state;
  final Ref<int> ids;

  _SignallingRefImpl(this.state, this.ids);

  @override
  IO<(A, Function1<A, IO<bool>>)> access() {
    return state.access().mapN((state, set) {
      IO<bool> setter(A newValue) {
        final (newstate, notifyListeners) = updateAndNotify(state, (_) => (newValue, Unit()));

        return set(newstate).flatTap((succeeded) => IO.whenA(succeeded, () => notifyListeners));
      }

      return (state.value, setter);
    });
  }

  @override
  Signal<A> changes({Function2<A, A, bool>? eq}) => _ChangesSignal(this, eq ?? (a, b) => a != b);

  @override
  Rill<A> get continuous => Rill.repeatEval(value());

  @override
  Rill<A> get discrete => Rill.resource(getAndDiscreteUpdates()).flatMap((tuple) {
    final (a, updates) = tuple;

    return Rill.emit(a).append(() => updates);
  });

  @override
  IO<B> flatModify<B>(Function1<A, (A, IO<B>)> f) => IO.uncancelable((_) => modify(f).flatten());

  @override
  IO<B> flatModifyFull<B>(Function1<(Poll, A), (A, IO<B>)> f) =>
      IO.uncancelable((poll) => modify((a) => f((poll, a))).flatten());

  IO<int> newId() => ids.getAndUpdate((n) => n + 1);

  @override
  Resource<(A, Rill<A>)> getAndDiscreteUpdates() {
    Rill<A> go(int id, int lastSeen) {
      final IO<(A, int)> getNext = IO.deferred<(A, int)>().flatMap((wait) {
        return state.modify((st) {
          if (st.lastUpdate != lastSeen) {
            return (st, IO.pure((st.value, st.lastUpdate)));
          } else {
            return (st.copy(listeners: st.listeners.updated(id, wait)), wait.value());
          }
        }).flatten();
      });

      return Rill.eval(getNext).flatMap((tuple) {
        final (a, lastUpdate) = tuple;
        return Rill.emit(a).append(() => go(id, lastUpdate));
      });
    }

    IO<Unit> cleanup(int id) => state.update((s) => s.copy(listeners: s.listeners.removed(id)));

    return Resource.eval(
      state.value().map((s) {
        return (s.value, Rill.bracket(newId(), cleanup).flatMap((id) => go(id, s.lastUpdate)));
      }),
    );
  }

  @override
  IO<A> getAndSet(A a) => getAndUpdate((_) => a);

  @override
  IO<A> getAndUpdate(Function1<A, A> f) => modify((a) => (f(a), a));

  @override
  IO<B> modify<B>(Function1<A, (A, B)> f) => state.flatModify((st) => updateAndNotify(st, f));

  @override
  IO<Unit> setValue(A a) => update((_) => a);

  @override
  IO<Option<B>> tryModify<B>(Function1<A, (A, B)> f) => IO.uncancelable(
    (_) => state.tryModify((st) => updateAndNotify(st, f)).flatMap((x) => x.sequence()),
  );

  @override
  IO<bool> tryUpdate(Function1<A, A> f) => tryModify((a) => (f(a), ())).map((x) => x.isDefined);

  @override
  IO<Unit> update(Function1<A, A> f) => modify((a) => (f(a), Unit()));

  @override
  IO<A> updateAndGet(Function1<A, A> f) => modify((a) {
    final newA = f(a);
    return (newA, newA);
  });

  @override
  IO<A> value() => state.value().map((st) => st.value);

  @override
  IO<Unit> waitUntil(Function1<A, bool> p) => discrete.forall((a) => !p(a)).compile.drain;

  (_State<A>, IO<B>) updateAndNotify<B>(_State<A> state, Function1<A, (A, B)> f) {
    final (newValue, result) = f(state.value);
    final lastUpdate = state.lastUpdate + 1;
    final newState = _State<A>(newValue, lastUpdate, IMap.empty());

    final notifyListeners = state.listeners.values.toIList().traverseIO_((listener) {
      return listener.complete((newValue, lastUpdate));
    });

    return (newState, notifyListeners.as(result));
  }
}

class _State<A> {
  final A value;
  final int lastUpdate;

  // We use Object as a unique key so listeners can easily unregister themselves
  final IMap<int, Deferred<(A, int)>> listeners;

  const _State(this.value, this.lastUpdate, this.listeners);

  _State<A> copy({A? value, int? lastUpdate, IMap<int, Deferred<(A, int)>>? listeners}) {
    return _State(
      value ?? this.value,
      lastUpdate ?? this.lastUpdate,
      listeners ?? this.listeners,
    );
  }
}
