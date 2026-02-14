import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

mixin Channel<A> {
  static IO<Channel<A>> bounded<A>(int capacity) => _BoundedChannel.create(capacity);

  static IO<Channel<A>> synchronous<A>() => bounded(0);

  static IO<Channel<A>> unbounded<A>() => bounded(Integer.MaxValue);

  Pipe<A, Never> get sendAll;

  IO<Either<ChannelClosed, Unit>> send(A a);

  IO<Either<ChannelClosed, bool>> trySend(A a);

  Rill<A> get stream;

  IO<Either<ChannelClosed, Unit>> close();

  IO<Either<ChannelClosed, Unit>> closeWithElement(A a);

  IO<bool> get isClosed;

  IO<Unit> get closed;
}

final class ChannelClosed {
  static final ChannelClosed _singleton = ChannelClosed._();

  factory ChannelClosed() => _singleton;

  ChannelClosed._();

  @override
  String toString() => 'ChannelClosed';
}

final class _State<A> {
  final IList<A> values;
  final int size;
  final Option<Deferred<Unit>> waiting;
  final IList<(A, Deferred<Unit>)> producers;
  final bool closed;

  _State(
    this.values,
    this.size,
    this.waiting,
    this.producers,
    this.closed,
  );

  static _State<A> open<A>() => _State(nil(), 0, none(), nil(), false);

  _State<A> copy({
    IList<A>? values,
    int? size,
    Option<Deferred<Unit>>? waiting,
    IList<(A, Deferred<Unit>)>? producers,
    bool? closed,
  }) => _State(
    values ?? this.values,
    size ?? this.size,
    waiting ?? this.waiting,
    producers ?? this.producers,
    closed ?? this.closed,
  );
}

final class _BoundedChannel<A> with Channel<A> {
  final int capacity;
  final Ref<_State<A>> state;
  final Deferred<Unit> closedGate;

  final _State<A> open;

  final _closed = Left<ChannelClosed, Never>(ChannelClosed());
  final _rightUnit = Right<ChannelClosed, Unit>(Unit());
  final _rightTrue = const Right<ChannelClosed, bool>(true);
  final _rightFalse = const Right<ChannelClosed, bool>(false);

  _BoundedChannel._(this.capacity, this.state, this.closedGate) : open = _State.open();

  static IO<_BoundedChannel<A>> create<A>(int capacity) {
    return (IO.ref(_State.open<A>()), IO.deferred<Unit>()).mapN((state, closedGate) {
      return _BoundedChannel._(capacity, state, closedGate);
    });
  }

  _State<A> _empty(bool isClosed) => isClosed ? _State(nil(), 0, none(), nil(), true) : open;

  @override
  IO<Either<ChannelClosed, Unit>> close() {
    return state.flatModify((s) {
      if (s.closed) {
        return (s, IO.pure(_closed));
      } else {
        return (
          _State(s.values, s.size, none(), s.producers, true),
          notifyStream(s.waiting).as(_rightUnit).productL(() => signalClosure()),
        );
      }
    });
  }

  @override
  IO<Either<ChannelClosed, Unit>> closeWithElement(A a) => _sendImpl(a, true);

  @override
  IO<Unit> get closed => closedGate.value();

  @override
  IO<bool> get isClosed => closedGate.tryValue().map((v) => v.isDefined);

  @override
  IO<Either<ChannelClosed, Unit>> send(A a) => _sendImpl(a, false);

  @override
  Pipe<A, Never> get sendAll {
    return (ins) =>
        ins
            .flatMap((_) => Rill.exec<A>(close().voided()))
            .evalMap((a) => send(a))
            .takeWhile((a) => a.isRight)
            .drain();
  }

  @override
  Rill<A> get stream => consumeLoop().rill;

  @override
  IO<Either<ChannelClosed, bool>> trySend(A a) {
    return state.flatModify((s) {
      if (s.closed) {
        return (s, IO.pure(_closed));
      } else {
        if (s.size < capacity) {
          return (
            _State(s.values.prepended(a), s.size + 1, none(), s.producers, false),
            notifyStream(s.waiting).as(_rightTrue),
          );
        } else {
          return (s, IO.pure(_rightFalse));
        }
      }
    });
  }

  IO<Either<ChannelClosed, Unit>> _sendImpl(A a, bool close) {
    return IO.deferred<Unit>().flatMap((producer) {
      return state.flatModifyFull((tuple) {
        final (poll, s) = tuple;
        final signalClose = IO.whenA(close, () => signalClosure().voided());

        if (s.closed) {
          return (s, IO.pure(_closed));
        } else if (s.size < capacity) {
          return (
            _State(s.values.prepended(a), s.size + 1, s.waiting, s.producers, close),
            signalClose.productR(() => notifyStream(s.waiting).as(_rightUnit)),
          );
        } else {
          return (
            _State(s.values, s.size, none(), s.producers.prepended((a, producer)), close),
            signalClose
                .productR(() => notifyStream(s.waiting).as(_rightUnit))
                .productL(() => IO.unlessA(close, () => waitOnBound(producer, poll))),
          );
        }
      });
    });
  }

  Pull<A, Unit> consumeLoop() {
    return Pull.eval(
      IO.deferred<Unit>().flatMap((waiting) {
        return IO.uncancelable(
          (_) => state
              .modify((state) {
                if (shouldEmit(state)) {
                  return (_empty(state.closed), state);
                } else {
                  return (state.copy(waiting: Some(waiting)), state);
                }
              })
              .flatMap((s) {
                if (shouldEmit(s)) {
                  final initValues = s.values;
                  final producers = s.producers;

                  final tailValues = <A>[];
                  var unblock = IO.unit;

                  producers.foreachN((value, producer) {
                    tailValues.add(value);
                    unblock = unblock.productL(() => producer.complete(Unit()));
                  });

                  final toEmit = Chunk.from(initValues).concat(Chunk.fromDart(tailValues));

                  return unblock.as(Pull.output(toEmit).append(() => consumeLoop()));
                } else {
                  return IO.pure(
                    s.closed
                        ? Pull.done<A>()
                        : Pull.eval(waiting.value()).flatMap((_) => consumeLoop()),
                  );
                }
              }),
        );
      }),
    ).flatten();
  }

  IO<Option<bool>> notifyStream(Option<Deferred<Unit>> waitForChanges) =>
      waitForChanges.traverseIO((def) => def.complete(Unit()));

  IO<Unit> waitOnBound(Deferred<Unit> producer, Poll poll) {
    return poll(producer.value()).onCancel(
      state.update((s) {
        return s.copy(producers: s.producers.filter((p) => p.$2 != producer));
      }),
    );
  }

  IO<bool> signalClosure() => closedGate.complete(Unit());

  bool shouldEmit(_State<A> s) => s.values.nonEmpty || s.producers.nonEmpty;
}
