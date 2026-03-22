import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  group('Channel', () {
    test('receives elements above capacity and closes', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final senders = IList.range(0, 10).parTraverseIO_((i) {
          return IO.sleep(Duration(milliseconds: i)).productR(() => chan.send(i));
        });

        final cleanup = IO
            .sleep(200.milliseconds)
            .productR(() => chan.close())
            .productR(() => chan.rill.compile.toIList);

        return IO.both(senders, cleanup).mapN((_, b) => b);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), IList.range(0, 10));
    });

    test('send to closed channel returns ChannelClosed', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.send(42));
      });

      final result = await test.unsafeRunFuture();

      expect(result.isLeft, isTrue);
      expect(result.fold((a) => a, (_) => null), isA<ChannelClosed>());
    });

    test('rill terminates after close with no elements', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.rill.compile.toIList);
      });

      final result = await test.unsafeRunFuture();

      expect(result, nil<int>());
    });

    test('rill yields elements then terminates after close', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final send = IList.range(0, 3).traverseIO_((i) => chan.send(i));
        final close = chan.close();

        return send.productR(() => close).productR(() => chan.rill.compile.toIList);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), IList.range(0, 3));
    });

    test('trySend returns Right(true) when capacity available', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) => chan.trySend(1));
      final result = await test.unsafeRunFuture();

      expect(result, const Right<ChannelClosed, bool>(true));
    });

    test('trySend returns Right(false) when channel is full', () async {
      final test = Channel.bounded<int>(2).flatMap((chan) {
        return chan.trySend(1).productR(() => chan.trySend(2)).productR(() => chan.trySend(3));
      });

      final result = await test.unsafeRunFuture();

      expect(result, const Right<ChannelClosed, bool>(false));
    });

    test('trySend returns Left(ChannelClosed) when channel is closed', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.trySend(42));
      });

      final result = await test.unsafeRunFuture();

      expect(result.isLeft, isTrue);
      expect(result.fold((a) => a, (_) => null), isA<ChannelClosed>());
    });

    test('close is idempotent — second close returns ChannelClosed', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.close());
      });

      final result = await test.unsafeRunFuture();

      expect(result.isLeft, isTrue);
      expect(result.fold((a) => a, (_) => null), isA<ChannelClosed>());
    });

    test('isClosed reflects open and closed states', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.isClosed.flatMap((before) {
          return chan.close().productR(() => chan.isClosed).map((after) => (before, after));
        });
      });

      final result = await test.unsafeRunFuture();

      expect(result.$1, isFalse);
      expect(result.$2, isTrue);
    });

    test('closed completes after close is called', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => chan.close());
        return IO.both(closeAfterDelay, chan.closed).voided();
      });

      // Should complete without timing out
      await expectLater(test.unsafeRunFuture(), completes);
    });

    test('closeWithElement sends element and closes', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.closeWithElement(99).productR(() => chan.rill.compile.toIList);
      });

      final result = await test.unsafeRunFuture();

      expect(result, ilist([99]));
    });

    test('synchronous channel — send blocks until consumer reads', () async {
      final test = Channel.synchronous<int>().flatMap((chan) {
        final sender = chan.send(42);
        final receiver = chan.rill.take(1).compile.toIList;

        return IO.both(sender, receiver).mapN((_, b) => b);
      });

      final result = await test.unsafeRunFuture();

      expect(result, ilist([42]));
    });

    test('unbounded channel accepts many elements without backpressure', () async {
      final test = Channel.unbounded<int>().flatMap((chan) {
        final sends = IList.range(0, 100).traverseIO_((i) => chan.send(i));
        return sends.productR(() => chan.close()).productR(() => chan.rill.compile.toIList);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), IList.range(0, 100));
    });

    test('sendAll pipe delivers all elements and closes channel', () async {
      final test = Channel.bounded<int>(10).flatMap((chan) {
        final sending = Rill.emits<int>([1, 2, 3]).through<Never>(chan.sendAll).compile.drain;
        final receiving = chan.rill.compile.toIList;

        return IO.both(sending, receiving).mapN((_, b) => b);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), ilist([1, 2, 3]));
    });

    test('backpressure — producer is suspended when channel is full', () async {
      final test = Channel.bounded<int>(2).flatMap((chan) {
        // Fill the channel, then read to unblock producer
        final slowConsumer = IO
            .sleep(50.milliseconds)
            .productR(() => chan.rill.take(3).compile.toIList);
        final producer = IList.range(0, 3).traverseIO_((i) => chan.send(i));

        return IO.both(producer, slowConsumer).mapN((_, b) => b);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), ilist([0, 1, 2]));
    });
  });
}
