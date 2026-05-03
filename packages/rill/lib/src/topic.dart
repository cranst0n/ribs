import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Sentinel value returned when an operation is attempted on a closed [Topic].
final class TopicClosed {
  static const TopicClosed instance = TopicClosed._();

  factory TopicClosed() => instance;

  const TopicClosed._();
}

/// A publish-subscribe hub for concurrent streams.
///
/// Multiple producers publish values via [publish1] or the [publish] pipe;
/// multiple consumers receive their own copy of every published value by
/// subscribing via [subscribe] or [subscribeAwait].
///
/// Close the topic with [close] when no more values will be published;
/// all subscriber streams will drain and then terminate.
abstract class Topic<A> {
  /// Creates a new open [Topic].
  static IO<Topic<A>> create<A>() {
    return Ref.of(TopicState.initial<A>()).flatMap((state) {
      return SignallingRef.of(0).flatMap((subscriberCount) {
        return Deferred.of<Unit>().map((signalClosure) {
          return TopicImpl(state, subscriberCount, signalClosure);
        });
      });
    });
  }

  /// A [Pipe] that publishes all input elements to this topic and closes it
  /// when the input stream ends.
  Pipe<A, Never> get publish;

  /// Publishes a single value to all current subscribers.
  ///
  /// Returns [Left] with [TopicClosed] if the topic is already closed.
  IO<Either<TopicClosed, Unit>> publish1(A a);

  /// Returns a [Rill] that receives every value published after the
  /// subscription is registered, buffering at most [maxQueued] elements.
  Rill<A> subscribe(int maxQueued);

  /// Like [subscribe] with an unbounded buffer.
  Rill<A> subscribeUnbounded() => subscribe(Integer.maxValue);

  /// Like [subscribe] but returns a [Resource] whose acquisition blocks until
  /// the subscriber is fully registered, preventing missed publishes.
  Resource<Rill<A>> subscribeAwait(int maxQueued);

  /// Like [subscribeAwait] with an unbounded buffer.
  Resource<Rill<A>> subscribeAwaitUnbounded() => subscribeAwait(Integer.maxValue);

  /// Signal of active subscribers.
  Rill<int> get subscribers;

  /// Closes the topic, signalling all subscribers that no more values will be
  /// published. Returns [Left] with [TopicClosed] if already closed.
  IO<Either<TopicClosed, Unit>> get close;

  /// An [IO] that evaluates to `true` if the topic has been closed.
  IO<bool> get isClosed;

  /// Semantically blocks until the topic gets closed.
  IO<Unit> get closed;
}

class TopicImpl<A> implements Topic<A> {
  final Ref<TopicState<A>> state;
  final SignallingRef<int> subscriberCount;
  final Deferred<Unit> signalClosure;

  TopicImpl(
    this.state,
    this.subscriberCount,
    this.signalClosure,
  );

  IO<Unit> foreach<B>(IMap<int, B> lm, Function1<B, IO<Unit>> f) =>
      lm.foldLeft(IO.unit, (op, t) => op.flatMap((_) => f(t.$2)));

  @override
  IO<Either<TopicClosed, Unit>> get close {
    return state.flatModify((st) {
      switch (st) {
        case Active(:final subscribers):
          final action = subscribers
              .foldLeft(IO.unit, (op, t) => op.flatMap((_) => t.$2.close().voided()))
              .flatMap((_) => signalClosure.complete(Unit()));

          return (const Closed(), action.as(rightUnit));
        case Closed():
          return (st, IO.pure(topicClosed));
      }
    });
  }

  @override
  IO<Unit> get closed => signalClosure.value();

  @override
  IO<bool> get isClosed => signalClosure.tryValue().map((v) => v.isDefined);

  @override
  Pipe<A, Never> get publish =>
      (inRill) =>
          inRill
              .append(() => Rill.exec(close.voided()))
              .evalMap(publish1)
              .takeWhile((e) => e.isRight)
              .drain();

  @override
  IO<Either<TopicClosed, Unit>> publish1(A a) {
    return state.value().flatMap((st) {
      return switch (st) {
        Closed() => IO.pure(topicClosed),
        Active(:final subscribers) => foreach(
          subscribers,
          (ch) => ch.send(a).voided(),
        ).as(rightUnit),
      };
    });
  }

  @override
  Rill<A> subscribe(int maxQueued) => Rill.resource(subscribeAwait(maxQueued)).flatten();

  @override
  Resource<Rill<A>> subscribeAwait(int maxQueued) =>
      Resource.eval(Channel.bounded<A>(maxQueued)).flatMap(_subscribeAwaitImpl);

  @override
  Resource<Rill<A>> subscribeAwaitUnbounded() =>
      Resource.eval(Channel.unbounded<A>()).flatMap(_subscribeAwaitImpl);

  @override
  Rill<A> subscribeUnbounded() => Rill.resource(subscribeAwaitUnbounded()).flatten();

  @override
  Rill<int> get subscribers => subscriberCount.discrete;

  Resource<Rill<A>> _subscribeAwaitImpl(Channel<A> chan) {
    final IO<Option<int>> subscribe = state.flatModify((st) {
      switch (st) {
        case Active(:final subscribers, :final nextId):
          final newState = Active(subscribers.updated(nextId, chan), nextId + 1);
          final action = subscriberCount.update((c) => c + 1);
          final result = Some(nextId);

          return (newState, action.as(result));
        case Closed():
          return (st, IO.pure(const None()));
      }
    });

    IO<Unit> unsubscribe(int id) {
      return state.flatModify((st) {
        switch (st) {
          case Active(:final subscribers, :final nextId):
            // _After_ we remove the bounded channel for this
            // subscriber, we need to drain it to unblock the
            // publish loop which might have already enqueued
            // something.
            final drainChannel = subscribers
                .get(id)
                .traverseIO_((chan) => chan.close().productR(chan.rill.compile.drain));

            final newState = Active(subscribers - id, nextId);
            final action = drainChannel.productR(subscriberCount.update((c) => c - 1));

            return (newState, action);
          case Closed():
            return (st, IO.unit);
        }
      });
    }

    return Resource.make(
      subscribe,
      (idOpt) => idOpt.fold(() => IO.unit, (id) => unsubscribe(id)),
    ).map(
      (opt) => opt.fold(
        () => Rill.empty<A>(),
        (_) => chan.rill,
      ),
    );
  }
}

sealed class TopicState<A> {
  const TopicState();

  static TopicState<A> initial<A>() => Active(IMap.empty(), 1);
}

class Active<A> extends TopicState<A> {
  final IMap<int, Channel<A>> subscribers;
  final int nextId;

  const Active(this.subscribers, this.nextId);
}

class Closed<A> extends TopicState<A> {
  const Closed();
}

const topicClosed = Left<TopicClosed, Unit>(TopicClosed.instance);
const rightUnit = Right<TopicClosed, Unit>(Unit.instance);
