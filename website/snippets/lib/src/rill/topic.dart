// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// topic-basic

// Subscribe to a topic and collect the first 5 items.
IO<IList<String>> topicBasic() {
  return Topic.create<String>().flatMap((Topic<String> topic) {
    // subscribe(maxQueued) returns a Rill that receives a copy of every
    // published item. maxQueued is the per-subscriber buffer size.
    final subscriber = topic.subscribe(16).take(5).compile.toIList;

    // publish is a Pipe<A, Never> that forwards a Rill into all subscribers
    // and closes the topic when the source stream completes.
    final publisher =
        Rill.range(1, 6).map((int n) => 'event-$n').through(topic.publish).compile.drain;

    // Run publisher and subscriber concurrently; collect subscriber output.
    return IO.both<IList<String>, Unit>(subscriber, publisher).map((t) => t.$1);
    // => IList('event-1', 'event-2', 'event-3', 'event-4', 'event-5')
  });
}

// topic-basic

// topic-multi-subscriber

// Fan out: two independent subscribers each receive every published item.
IO<(IList<String>, IList<String>)> topicMultiSubscriber() {
  return Topic.create<String>().flatMap((Topic<String> topic) {
    final messages = Rill.emits(['alpha', 'beta', 'gamma']);

    // subscribeAwait returns a Resource<Rill<A>>. The subscription is
    // registered inside the Resource acquire phase, guaranteeing the
    // subscriber is ready before any publish call can run.
    return topic
        .subscribeAwait(16)
        .flatMap(
          (Rill<String> sub1) => topic.subscribeAwait(16).map((Rill<String> sub2) => (sub1, sub2)),
        )
        .use((subs) {
          final (sub1, sub2) = subs;

          final collect1 = sub1.take(3).compile.toIList;
          final collect2 = sub2.take(3).compile.toIList;

          final publish = messages.through(topic.publish).compile.drain;

          return IO.both<IList<String>, IList<String>>(collect1, collect2).productL(() => publish);
          // Both sub1 and sub2 receive: IList('alpha', 'beta', 'gamma')
        });
  });
}

// topic-multi-subscriber

// topic-publish1

// publish1 sends a single value imperatively — useful when the source of
// events is IO-based rather than a Rill.
IO<Unit> topicPublish1() {
  return Topic.create<int>().flatMap((Topic<int> topic) {
    final subscriber = topic.subscribe(16).take(3).compile.toIList;

    final producer = IList.range(1, 4).traverseIO_((int n) {
      return topic
          .publish1(n)
          .flatMap(
            (Either<TopicClosed, Unit> result) => result.fold(
              (TopicClosed _) => IO.print('topic closed, dropping $n'),
              (Unit _) => IO.unit,
            ),
          );
    });

    return IO
        .both<IList<int>, Unit>(subscriber, producer.productR(() => topic.close.voided()))
        .voided();
  });
}

// topic-publish1

// topic-realworld

// A simple event bus: a temperature sensor broadcasts readings to an
// independent logger and alerter running in separate fibers.
IO<(IList<String>, IList<String>)> temperatureMonitor() {
  final readings = ilist([18.5, 19.0, 22.3, 31.7, 29.1]);
  final count = readings.length;

  return Topic.create<double>().flatMap((Topic<double> topic) {
    // Logger: formats every reading as a string.
    final logger = topic.subscribe(32).take(count).map((double t) => 'temp: $t°C').compile.toIList;

    // Alerter: only emits when temperature exceeds the threshold.
    final alerter =
        topic
            .subscribe(32)
            .take(count)
            .filter((double t) => t > 25.0)
            .map((double t) => 'ALERT: high temp $t°C')
            .compile
            .toIList;

    // Publisher: streams the sensor readings, closes topic when done.
    final publisher = Rill.emits(readings.toList()).through(topic.publish).compile.drain;

    // Run all three concurrently and collect both subscriber outputs.
    return IO.both<IList<String>, IList<String>>(logger, alerter).productL<Unit>(() => publisher);
    // logger  => IList('temp: 18.5°C', 'temp: 19.0°C', ...)
    // alerter => IList('ALERT: high temp 31.7°C', 'ALERT: high temp 29.1°C')
  });
}

// topic-realworld
