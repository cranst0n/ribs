import 'package:ribs_core/ribs_core.dart';

sealed class Channel<A> {
  static IO<Channel<A>> bounded<A>(int capacity) =>
      (Ref.of(_ChannelState.empty<A>(false)), Deferred.of<Unit>())
          .sequence()
          .map((requirements) => requirements(
              (state, gate) => _BoundedChannel(capacity, state, gate)));

  static IO<Channel<A>> synchronous<A>() => bounded(0);

  static IO<Channel<A>> unbounded<A>() => bounded(0x7fffffff);

  Pipe<A, Never> get sendAll;

  IO<Either<ChannelClosed, Unit>> send(A a);

  IO<Either<ChannelClosed, bool>> trySend(A a);

  Rill<A> get rill;

  IO<Either<ChannelClosed, Unit>> close();

  IO<bool> get isClosed;

  /// Semantically block until the channel is closed
  IO<Unit> closed();
}

final class ChannelClosed {
  static final ChannelClosed _singleton = ChannelClosed._();

  factory ChannelClosed() => _singleton;

  ChannelClosed._();
}

final class _BoundedChannel<A> extends Channel<A> {
  final int capacity;

  final Ref<_ChannelState<A>> state;
  final Deferred<Unit> closedGate;

  _BoundedChannel(this.capacity, this.state, this.closedGate);

  @override
  IO<Either<ChannelClosed, Unit>> close() => state.flatModify((state) {
        if (state.closed) {
          return (state, IO.pure(ChannelClosed().asLeft<Unit>()));
        } else {
          return (
            state.copy(waiting: none(), closed: true),
            notifyStream(state.waiting)
                .as(rightUnit)
                .productL(() => signalClosure()),
          );
        }
      });

  @override
  IO<Unit> closed() => closedGate.value();

  @override
  IO<bool> get isClosed => closedGate.tryValue().map((a) => a.isDefined);

  @override
  Rill<A> get rill => consumeLoop().rill;

  @override
  IO<Either<ChannelClosed, Unit>> send(A a) => Deferred.of<Unit>().flatMap(
        (producer) => state.flatModifyFull(
          (tuple) => tuple(
            (poll, state) {
              if (state.closed) {
                return (state, IO.pure(ChannelClosed().asLeft<Unit>()));
              } else if (state.size < capacity) {
                return (
                  state.copy(
                    values: state.values.append(a),
                    size: state.size + 1,
                    waiting: none(),
                  ),
                  notifyStream(state.waiting).as(rightUnit),
                );
              } else {
                return (
                  state.copy(
                    waiting: none(),
                    producers: state.producers.append((a, producer)),
                  ),
                  notifyStream(state.waiting)
                      .as(rightUnit)
                      .productL(() => waitOnBound(producer, poll)),
                );
              }
            },
          ),
        ),
      );

  @override
  Pipe<A, Never> get sendAll => (rillIn) => rillIn
      .concat(Rill.exec(close().voided()))
      .mapEval((a) => send(a))
      .takeWhile((a) => a.isRight)
      .drain();

  @override
  IO<Either<ChannelClosed, bool>> trySend(A a) => state.flatModify(
        (state) {
          if (state.closed) {
            return (state, IO.pure(ChannelClosed().asLeft<bool>()));
          } else if (state.size < capacity) {
            return (
              state.copy(
                values: state.values.append(a),
                size: state.size + 1,
                waiting: none(),
              ),
              notifyStream(state.waiting).as(rightTrue)
            );
          } else {
            return (state, IO.pure(rightFalse));
          }
        },
      );

  Pull<A, Unit> consumeLoop() {
    return Pull.eval(
      Deferred.of<Unit>().flatMap((waiting) {
        return IO.uncancelable(
          (_) => state.modify((state) {
            if (shouldEmit(state)) {
              return (_ChannelState.empty(state.closed), state);
            } else {
              return (state.copy(waiting: waiting.some), state);
            }
          }).flatMap((s) {
            if (shouldEmit(s)) {
              final tailValues = List<A>.empty(growable: true);
              var unblock = IO.unit;

              s.producers.forEach(
                (tuple) => tuple(
                  (value, producer) {
                    tailValues.add(value);
                    unblock = unblock.productL(() => producer.complete(Unit()));
                  },
                ),
              );

              return unblock.as(
                  Pull.fromIList(s.values.concat(ilist(tailValues)))
                      .flatMap((_) => consumeLoop()));
            } else if (s.closed) {
              return IO.pure(Pull.done);
            } else {
              return IO.pure(
                Pull.eval(waiting.value()).flatMap((_) => consumeLoop()),
              );
            }
          }),
        );
      }),
    ).flatten();
  }

  IO<Option<bool>> notifyStream(Option<Deferred<Unit>> waitForChanges) =>
      waitForChanges.traverseIO((a) => a.complete(Unit()));

  IO<Unit> waitOnBound(Deferred<Unit> producer, Poll poll) =>
      poll(producer.value()).onCancel(state.update((s) =>
          s.copy(producers: s.producers.filter((t) => t.$2 != producer))));

  IO<bool> signalClosure() => closedGate.complete(Unit());

  bool shouldEmit(_ChannelState<A> s) =>
      s.values.nonEmpty || s.producers.nonEmpty;

  final rightUnit = Unit().asRight<ChannelClosed>();
  final rightTrue = true.asRight<ChannelClosed>();
  final rightFalse = false.asRight<ChannelClosed>();
}

final class _ChannelState<A> {
  final IList<A> values;
  final int size;
  final Option<Deferred<Unit>> waiting;
  final IList<(A, Deferred<Unit>)> producers;
  final bool closed;

  _ChannelState(
    this.values,
    this.size,
    this.waiting,
    this.producers,
    this.closed,
  );

  static _ChannelState<A> empty<A>(bool closed) =>
      _ChannelState(IList.empty(), 0, none(), IList.empty(), closed);

  _ChannelState<A> copy({
    IList<A>? values,
    int? size,
    Option<Deferred<Unit>>? waiting,
    IList<(A, Deferred<Unit>)>? producers,
    bool? closed,
  }) =>
      _ChannelState(
        values ?? this.values,
        size ?? this.size,
        waiting ?? this.waiting,
        producers ?? this.producers,
        closed ?? this.closed,
      );
}
