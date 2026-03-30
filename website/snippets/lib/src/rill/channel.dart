// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// #region channel-create
IO<Unit> channelCreate() {
  // bounded(n): producers suspend when n items are waiting — natural backpressure.
  final bounded = Channel.bounded<String>(16);

  // synchronous(): equivalent to bounded(0). Every send blocks until a consumer
  // is ready, providing strict hand-off semantics between fibers.
  final synchronous = Channel.synchronous<String>();

  // unbounded(): never suspends producers. Use carefully — a burst of sends can
  // queue arbitrarily many items before the consumer catches up.
  final unbounded = Channel.unbounded<String>();

  return bounded.flatMap((_) => synchronous).flatMap((_) => unbounded).voided();
}
// #endregion channel-create

// #region channel-send
IO<Unit> channelSend() {
  return Channel.bounded<int>(4).flatMap((Channel<int> channel) {
    // send() suspends the calling fiber when the channel is at capacity.
    // It resumes automatically once the consumer drains at least one slot.
    // Returns Left(ChannelClosed) if the channel has already been closed.
    final sendOne = channel
        .send(42)
        .flatMap(
          (Either<ChannelClosed, Unit> result) => result.fold(
            (ChannelClosed _) => IO.print('channel was closed before send'),
            (Unit _) => IO.print('42 sent successfully'),
          ),
        );

    // closeWithElement sends a final value and closes in one atomic step.
    final sendFinal = channel
        .closeWithElement(99)
        .flatMap(
          (Either<ChannelClosed, Unit> result) => result.fold(
            (ChannelClosed _) => IO.print('already closed'),
            (Unit _) => IO.print('99 sent and channel closed'),
          ),
        );

    // Consume both values, then we are done.
    final consume = channel.rill.take(2).compile.drain;

    return sendOne.productR(sendFinal).productR(consume);
  });
}
// #endregion channel-send

// #region channel-try-send
IO<Unit> channelTrySend() {
  return Channel.bounded<int>(2).flatMap((Channel<int> channel) {
    // trySend never suspends. Returns Right(true) if the value was queued,
    // Right(false) if the channel is full, or Left(ChannelClosed) if closed.
    return IList.range(0, 5).traverseIO_((int i) {
      return channel
          .trySend(i)
          .flatMap(
            (Either<ChannelClosed, bool> result) => result.fold(
              (ChannelClosed _) => IO.print('$i: channel closed'),
              (bool queued) => IO.print('$i: ${queued ? "sent" : "dropped (full)"}'),
            ),
          );
    });
    // output:
    // 0: sent
    // 1: sent
    // 2: dropped (full)
    // 3: dropped (full)
    // 4: dropped (full)
  });
}
// #endregion channel-try-send

// #region channel-send-all
IO<Unit> channelSendAll() {
  return Channel.bounded<int>(8).flatMap((Channel<int> channel) {
    // sendAll is a Pipe<A, Never> that feeds every element of a Rill into
    // the channel. The channel is automatically closed when the source
    // stream completes — no manual close() call required.
    final producer = Rill.range(1, 6).through(channel.sendAll).compile.drain;

    // Consumer runs concurrently with the producer.
    final consumer = channel.rill.compile.toIList;

    return IO
        .both<Unit, IList<int>>(producer, consumer)
        .flatMap(
          (t) => IO.print('received: ${t.$2}'),
        ); // received: IList(1, 2, 3, 4, 5)
  });
}
// #endregion channel-send-all

// #region channel-realworld
// Collect log events from three concurrent services into a single list.
//
// Each service sends its events independently via `channel.send`. The bounded
// channel (capacity 4) provides backpressure: a service that gets ahead of the
// consumer will suspend rather than flood memory. When all services finish,
// the channel is closed and the consumer returns everything it received.
IO<IList<String>> aggregateLogs() {
  final authEvents = ilist(['auth: login', 'auth: token refreshed']);
  final apiEvents = ilist(['api: GET /users', 'api: POST /orders', 'api: GET /items']);
  final dbEvents = ilist(['db: SELECT executed', 'db: cache miss', 'db: INSERT executed']);

  return Channel.bounded<String>(4).flatMap((Channel<String> channel) {
    // Producers: each service sends its events concurrently.
    // parTraverseIO_ starts all three fibers and waits for all to finish.
    final producers = IList.fromDart([authEvents, apiEvents, dbEvents]).parTraverseIO_(
      (IList<String> events) => events.traverseIO_((String e) => channel.send(e)),
    );

    // Consumer: materialise the channel's Rill into a list.
    // The Rill completes once the channel is closed.
    final consumer = channel.rill.compile.toIList;

    // Run producers and consumer together. Close the channel as soon as
    // all producers finish so the consumer knows when to stop.
    return IO.both(producers.productR(channel.close()), consumer).map((t) => t.$2);
    // Returns all 8 log lines (order varies by scheduling).
  });
}
// #endregion channel-realworld
