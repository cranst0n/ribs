import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A concurrent channel that supports sending and receiving values across
/// fibers, with configurable back-pressure.
///
/// A [Channel] behaves like a bounded queue: producers call [send] to enqueue
/// values and consumers read them via [rill]. When the channel is full,
/// [send] semantically blocks the calling fiber until space is available.
/// When the channel is empty, [rill] suspends until a value arrives.
///
/// Create a channel with one of the factory constructors:
/// ```dart
/// final ch = await Channel.bounded<int>(16).run();
/// final ch = await Channel.synchronous<int>().run(); // rendezvous
/// final ch = await Channel.unbounded<int>().run();
/// ```
///
/// Close the channel when no more values will be sent; the consumer [rill]
/// will terminate after draining any remaining buffered values.
mixin Channel<A> {
  /// Creates a channel with a fixed-size buffer of [capacity] elements.
  ///
  /// Senders block when the buffer is full and are unblocked in FIFO order
  /// as consumers drain elements.
  static IO<Channel<A>> bounded<A>(int capacity) => _BoundedChannel.create(capacity);

  /// Creates a synchronous (rendezvous) channel with no internal buffer.
  ///
  /// Every [send] blocks until a consumer is ready to receive, and vice versa.
  /// Equivalent to `bounded(0)`.
  static IO<Channel<A>> synchronous<A>() => bounded(0);

  /// Creates an unbounded channel that never blocks senders.
  ///
  /// Use with care — an unbounded channel can grow without limit if producers
  /// outpace consumers.
  static IO<Channel<A>> unbounded<A>() => bounded(Integer.maxValue);

  /// A [Pipe] that forwards all elements of the input [Rill] into this channel
  /// and closes the channel when the input stream ends.
  ///
  /// The pipe terminates as soon as the channel is closed (either by the input
  /// ending or by an external [close] call), discarding any remaining input.
  Pipe<A, Never> get sendAll;

  /// Sends [a] to the channel, blocking if the channel buffer is full.
  ///
  /// Returns [Right] on success, or [Left] with [ChannelClosed] if the channel
  /// was already closed before or during the send.
  IO<Either<ChannelClosed, Unit>> send(A a);

  /// Attempts to send [a] to the channel without blocking.
  ///
  /// Returns [Right<true>] if the value was enqueued, [Right<false>] if the
  /// buffer was full, or [Left] with [ChannelClosed] if the channel is closed.
  IO<Either<ChannelClosed, bool>> trySend(A a);

  /// A [Rill] that emits every value sent to this channel.
  ///
  /// The stream suspends when the channel is empty and terminates after the
  /// channel is closed and all buffered values have been emitted.
  Rill<A> get rill;

  /// Closes the channel, preventing any further sends.
  ///
  /// Consumers will continue to receive buffered values before [rill]
  /// terminates. Returns [Left] with [ChannelClosed] if already closed.
  IO<Either<ChannelClosed, Unit>> close();

  /// Sends [a] and then closes the channel atomically.
  ///
  /// Equivalent to sending [a] followed by [close], but guaranteed to be
  /// atomic — no other send can interleave between the two operations.
  /// Returns [Left] with [ChannelClosed] if the channel was already closed.
  IO<Either<ChannelClosed, Unit>> closeWithElement(A a);

  /// An [IO] that evaluates to `true` if the channel has been closed.
  IO<bool> get isClosed;

  /// An [IO] that blocks until the channel is closed.
  IO<Unit> get closed;
}

/// Sentinel value returned when an operation is attempted on a closed [Channel].
final class ChannelClosed {
  static final ChannelClosed _singleton = ChannelClosed._();

  /// Returns the singleton [ChannelClosed] instance.
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
          notifyStream(s.waiting).as(_rightUnit).productL(signalClosure()),
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
            .append(() => Rill.exec(close().voided()))
            .evalMap((a) => send(a))
            .takeWhile((a) => a.isRight)
            .drain();
  }

  @override
  Rill<A> get rill => consumeLoop().rillNoScope;

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
        final signalClose = signalClosure().whenA(close);

        if (s.closed) {
          return (s, IO.pure(_closed));
        } else if (s.size < capacity) {
          return (
            _State(s.values.prepended(a), s.size + 1, s.waiting, s.producers, close),
            signalClose.productR(notifyStream(s.waiting).as(_rightUnit)),
          );
        } else {
          return (
            _State(s.values, s.size, none(), s.producers.prepended((a, producer)), close),
            signalClose
                .productR(notifyStream(s.waiting).as(_rightUnit))
                .productL(IO.unlessA(close, () => waitOnBound(producer, poll))),
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
                  var size = s.size;
                  final initValues = s.values;
                  final producers = s.producers;

                  final tailValues = IList.builder<A>();
                  var unblock = IO.unit;

                  producers.foreachN((value, producer) {
                    size += 1;
                    tailValues.addOne(value);
                    unblock = unblock.productL(producer.complete(Unit()));
                  });

                  final toEmit = makeChunk(initValues, tailValues.toIList(), size);

                  return unblock.as(Pull.output(toEmit).append(() => consumeLoop()));
                } else {
                  return IO.pure(
                    s.closed ? Pull.done : Pull.eval(waiting.value()).flatMap((_) => consumeLoop()),
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

  Chunk<A> makeChunk(IList<A> init, IList<A> tail, int size) {
    final arr = <A>[];

    var i = size - 1;
    var values = tail;

    while (i >= 0) {
      if (values.isEmpty) values = init;
      arr.add(values.head);
      values = values.tail;
      i -= 1;
    }

    return Chunk.fromList(arr.reversed.toList());
  }
}
