import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('basic example', () {
    final test = Topic.create<String>().flatMap((topic) {
      final publisher = Rill.constant('1').through(topic.publish);
      final subscriber = topic.subscribe(10).take(4);

      return subscriber.concurrently(publisher).compile.toIList;
    });

    expect(test, ioSucceeded(ilist(['1', '1', '1', '1'])));
  });

  group('publish1', () {
    test('returns Right(Unit) when topic is open', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.publish1(42);
          }).unsafeRunFuture();

      expect(result.isRight, isTrue);
    });

    test('returns Left(TopicClosed) when topic is closed', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.close.productR(() => topic.publish1(42));
          }).unsafeRunFuture();

      expect(result.isLeft, isTrue);
      expect(result.fold((a) => a, (_) => null), isA<TopicClosed>());
    });

    test('delivers message to all active subscribers', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final sub1 = topic.subscribe(10).take(1).compile.toIList;
            final sub2 = topic.subscribe(10).take(1).compile.toIList;
            final publish = IO.sleep(20.milliseconds).productR(() => topic.publish1(99));
            return IO.both(IO.both(sub1, sub2), publish).mapN((a, _) => a);
          }).unsafeRunFuture();

      expect(result.$1, ilist([99]));
      expect(result.$2, ilist([99]));
    });
  });

  group('close', () {
    test('returns Right(Unit) on first close', () async {
      final result = await Topic.create<int>().flatMap((t) => t.close).unsafeRunFuture();
      expect(result.isRight, isTrue);
    });

    test('returns Left(TopicClosed) on second close', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.close.productR(() => topic.close);
          }).unsafeRunFuture();

      expect(result.isLeft, isTrue);
      expect(result.fold((a) => a, (_) => null), isA<TopicClosed>());
    });

    test('terminates subscriber rill after close', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final sub = topic.subscribe(10).compile.toIList;
            final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => topic.close);
            return IO.both(sub, closeAfterDelay).mapN((a, _) => a);
          }).unsafeRunFuture();

      expect(result, nil<int>());
    });

    test('subscriber rill delivers buffered elements then terminates on close', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final sub = topic.subscribe(10).compile.toIList;
            final sendAndClose = topic
                .publish1(1)
                .productR(() => topic.publish1(2))
                .productR(() => topic.close);
            return IO.both(sub, sendAndClose).mapN((a, _) => a);
          }).unsafeRunFuture();

      expect(result, ilist([1, 2]));
    });
  });

  group('isClosed', () {
    test('false when topic is open', () {
      expect(
        Topic.create<int>().flatMap((t) => t.isClosed),
        ioSucceeded(isFalse),
      );
    });

    test('true after topic is closed', () {
      expect(
        Topic.create<int>().flatMap((topic) {
          return topic.close.productR(() => topic.isClosed);
        }),
        ioSucceeded(isTrue),
      );
    });
  });

  group('closed', () {
    test('completes after close is called', () async {
      final test = Topic.create<int>().flatMap((topic) {
        final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => topic.close);
        return IO.both(closeAfterDelay, topic.closed).voided();
      });

      await expectLater(test.unsafeRunFuture(), completes);
    });
  });

  group('subscribers', () {
    test('emits 0 before any subscribers join', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.subscribers.take(1).compile.toIList;
          }).unsafeRunFuture();

      expect(result, ilist([0]));
    });

    test('increments when subscriber joins', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.subscribeAwait(10).use((_) {
              return topic.subscribers.take(1).compile.toIList;
            });
          }).unsafeRunFuture();

      expect(result, ilist([1]));
    });

    test('decrements when subscriber is released', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final acquireAndRelease = topic.subscribeAwait(10).use((_) => IO.unit);
            return acquireAndRelease.productR(
              () => topic.subscribers.filter((n) => n == 0).take(1).compile.toIList,
            );
          }).unsafeRunFuture();

      expect(result, ilist([0]));
    });
  });

  group('subscribeUnbounded', () {
    test('receives published messages without backpressure', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final sub = topic.subscribeUnbounded().take(3).compile.toIList;
            final produce = IO
                .sleep(20.milliseconds)
                .productR(() => topic.publish1(1))
                .productR(() => topic.publish1(2))
                .productR(() => topic.publish1(3));
            return IO.both(sub, produce).mapN((a, _) => a);
          }).unsafeRunFuture();

      expect(result, ilist([1, 2, 3]));
    });
  });

  group('subscribeAwait', () {
    test('subscriber receives messages while resource is held', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.subscribeAwait(10).use((sub) {
              final recv = sub.take(2).compile.toIList;
              final send = IO
                  .sleep(20.milliseconds)
                  .productR(() => topic.publish1(10))
                  .productR(() => topic.publish1(20));
              return IO.both(recv, send).mapN((a, _) => a);
            });
          }).unsafeRunFuture();

      expect(result, ilist([10, 20]));
    });

    test('subscribing to a closed topic returns empty rill', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.close.productR(
              () => topic.subscribeAwait(10).use((sub) => sub.compile.toIList),
            );
          }).unsafeRunFuture();

      expect(result, nil<int>());
    });

    test('two independent subscriptions each receive all messages', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.subscribeAwait(10).use((sub1) {
              return topic.subscribeAwait(10).use((sub2) {
                final recv1 = sub1.take(3).compile.toIList;
                final recv2 = sub2.take(3).compile.toIList;
                final send = IO
                    .sleep(20.milliseconds)
                    .productR(() => topic.publish1(1))
                    .productR(() => topic.publish1(2))
                    .productR(() => topic.publish1(3));
                return IO.both(IO.both(recv1, recv2), send).mapN((a, _) => a);
              });
            });
          }).unsafeRunFuture();

      expect(result.$1, ilist([1, 2, 3]));
      expect(result.$2, ilist([1, 2, 3]));
    });
  });

  group('subscribeAwaitUnbounded', () {
    test('receives messages without capacity limit', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            return topic.subscribeAwaitUnbounded().use((sub) {
              final recv = sub.take(2).compile.toIList;
              final send = IO
                  .sleep(20.milliseconds)
                  .productR(() => topic.publish1(7))
                  .productR(() => topic.publish1(8));
              return IO.both(recv, send).mapN((a, _) => a);
            });
          }).unsafeRunFuture();

      expect(result, ilist([7, 8]));
    });
  });

  group('publish (pipe)', () {
    test('closes topic when input stream ends', () async {
      final result =
          await Topic.create<int>().flatMap((topic) {
            final publishing =
                Rill.emits<int>([1, 2, 3]).through<Never>(topic.publish).compile.drain;
            return publishing.productR(() => topic.isClosed);
          }).unsafeRunFuture();

      expect(result, isTrue);
    });

    test('terminates when topic is already closed', () async {
      final test = Topic.create<int>().flatMap((topic) {
        return topic.close.productR(
          () => Rill.constant(1).through<Never>(topic.publish).compile.drain,
        );
      });

      await expectLater(test.unsafeRunFuture(), completes);
    });
  });
}
