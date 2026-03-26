import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
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
    test('returns Right(Unit) when topic is open', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.publish1(42);
      });

      expect(result, ioSucceeded(isRight()));
    });

    test('returns Left(TopicClosed) when topic is closed', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.close.productR(() => topic.publish1(42));
      });

      expect(result, ioSucceeded(isLeft()));
    });

    test('delivers message to all active subscribers', () {
      final result = Topic.create<int>().flatMap((topic) {
        final sub1 = topic.subscribe(10).take(1).compile.toIList;
        final sub2 = topic.subscribe(10).take(1).compile.toIList;
        final publish = IO.sleep(20.milliseconds).productR(() => topic.publish1(99));
        return IO.both(IO.both(sub1, sub2), publish).mapN((a, _) => a);
      });

      expect(result, ioSucceeded((ilist([99]), ilist([99]))));
    });
  });

  group('close', () {
    test('returns Right(Unit) on first close', () {
      final result = Topic.create<int>().flatMap((t) => t.close);
      expect(result, ioSucceeded(isRight()));
    });

    test('returns Left(TopicClosed) on second close', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.close.productR(() => topic.close);
      });

      expect(result, ioSucceeded(isLeft()));
    });

    test('terminates subscriber rill after close', () {
      final result = Topic.create<int>().flatMap((topic) {
        final sub = topic.subscribe(10).compile.toIList;
        final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => topic.close);
        return IO.both(sub, closeAfterDelay).mapN((a, _) => a);
      });

      expect(result, ioSucceeded(nil<int>()));
    });

    test('subscriber rill delivers buffered elements then terminates on close', () {
      final result = Topic.create<int>().flatMap((topic) {
        final sub = topic.subscribe(10).compile.toIList;
        final sendAndClose = topic
            .publish1(1)
            .productR(() => topic.publish1(2))
            .productR(() => topic.close);
        return IO.both(sub, sendAndClose).mapN((a, _) => a);
      });

      expect(result, ioSucceeded(ilist([1, 2])));
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
    test('completes after close is called', () {
      final test = Topic.create<int>().flatMap((topic) {
        final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => topic.close);
        return IO.both(closeAfterDelay, topic.closed).voided();
      });

      expect(test, ioSucceeded());
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

    test('increments when subscriber joins', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.subscribeAwait(10).use((_) {
          return topic.subscribers.take(1).compile.toIList;
        });
      });

      expect(result, ioSucceeded(ilist([1])));
    });

    test('decrements when subscriber is released', () {
      final result = Topic.create<int>().flatMap((topic) {
        final acquireAndRelease = topic.subscribeAwait(10).use((_) => IO.unit);
        return acquireAndRelease.productR(
          () => topic.subscribers.filter((n) => n == 0).take(1).compile.toIList,
        );
      });

      expect(result, ioSucceeded(ilist([0])));
    });
  });

  group('subscribeUnbounded', () {
    test('receives published messages without backpressure', () {
      final result = Topic.create<int>().flatMap((topic) {
        final sub = topic.subscribeUnbounded().take(3).compile.toIList;
        final produce = IO
            .sleep(20.milliseconds)
            .productR(() => topic.publish1(1))
            .productR(() => topic.publish1(2))
            .productR(() => topic.publish1(3));
        return IO.both(sub, produce).mapN((a, _) => a);
      });

      expect(result, ioSucceeded(ilist([1, 2, 3])));
    });
  });

  group('subscribeAwait', () {
    test('subscriber receives messages while resource is held', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.subscribeAwait(10).use((sub) {
          final recv = sub.take(2).compile.toIList;
          final send = IO
              .sleep(20.milliseconds)
              .productR(() => topic.publish1(10))
              .productR(() => topic.publish1(20));
          return IO.both(recv, send).mapN((a, _) => a);
        });
      });

      expect(result, ioSucceeded(ilist([10, 20])));
    });

    test('subscribing to a closed topic returns empty rill', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.close.productR(
          () => topic.subscribeAwait(10).use((sub) => sub.compile.toIList),
        );
      });

      expect(result, ioSucceeded(nil<int>()));
    });

    test('two independent subscriptions each receive all messages', () {
      final result = Topic.create<int>().flatMap((topic) {
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
      });

      expect(result, ioSucceeded((ilist([1, 2, 3]), ilist([1, 2, 3]))));
    });
  });

  group('subscribeAwaitUnbounded', () {
    test('receives messages without capacity limit', () {
      final result = Topic.create<int>().flatMap((topic) {
        return topic.subscribeAwaitUnbounded().use((sub) {
          final recv = sub.take(2).compile.toIList;
          final send = IO
              .sleep(20.milliseconds)
              .productR(() => topic.publish1(7))
              .productR(() => topic.publish1(8));
          return IO.both(recv, send).mapN((a, _) => a);
        });
      });

      expect(result, ioSucceeded(ilist([7, 8])));
    });
  });

  group('publish (pipe)', () {
    test('closes topic when input stream ends', () {
      final result = Topic.create<int>().flatMap((topic) {
        final publishing = Rill.emits<int>([1, 2, 3]).through<Never>(topic.publish).compile.drain;
        return publishing.productR(() => topic.isClosed);
      });

      expect(result, ioSucceeded(true));
    });

    test('terminates when topic is already closed', () {
      final test = Topic.create<int>().flatMap((topic) {
        return topic.close.productR(
          () => Rill.constant(1).through<Never>(topic.publish).compile.drain,
        );
      });

      expect(test, ioSucceeded());
    });
  });
}
