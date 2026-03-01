import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class TopicClosed {
  static const TopicClosed instance = TopicClosed._();

  factory TopicClosed() => instance;

  const TopicClosed._();
}

abstract class Topic<A> {
  static IO<Topic<A>> create<A>() {
    return Ref.of(TopicState.initial<A>()).flatMap((state) {
      return SignallingRef.of(0).flatMap((subscriberCount) {
        return Deferred.of<Unit>().map((signalClosure) {
          return TopicImpl(state, subscriberCount, signalClosure);
        });
      });
    });
  }

  Pipe<A, Never> get publish;

  IO<Either<TopicClosed, Unit>> publish1(A a);

  Rill<A> subscribe(int maxQueued);

  Rill<A> subscribeUnbounded() => subscribe(Integer.MaxValue);

  Resource<Rill<A>> subscribeAwait(int maxQueued);

  Resource<Rill<A>> subscribeAwaitUnbounded() => subscribeAwait(Integer.MaxValue);

  /// Signal of active subscribers.
  Rill<int> get subscribers;

  IO<Either<TopicClosed, Unit>> get close;

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
            // subscriber, we need to drain it to unblock to
            // publish loop which might have already enqueued
            // something.
            final drainChannel = subscribers
                .get(id)
                .traverseIO_((chan) => chan.close().productR(() => chan.rill.compile.drain));

            final newState = Active(subscribers - id, nextId);
            final action = drainChannel.productR(() => subscriberCount.update((c) => c - 1));

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
