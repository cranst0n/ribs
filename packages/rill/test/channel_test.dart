import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  group('Channel', () {
    test('receives elements above capacity and closes', () {
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

      expect(
        test.map((result) => result.sorted(Order.ints)),
        succeeds(IList.range(0, 10)),
      );
    });

    test('send to closed channel returns ChannelClosed', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.send(42));
      });

      expect(test, succeeds(isLeft()));
    });

    test('rill terminates after close with no elements', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.rill.compile.toIList);
      });

      expect(test, succeeds(nil<int>()));
    });

    test('rill yields elements then terminates after close', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final send = IList.range(0, 3).traverseIO_((i) => chan.send(i));
        final close = chan.close();

        return send.productR(() => close).productR(() => chan.rill.compile.toIList);
      });

      expect(
        test.map((result) => result.sorted(Order.ints)),
        succeeds(IList.range(0, 3)),
      );
    });

    test('trySend returns Right(true) when capacity available', () {
      final test = Channel.bounded<int>(5).flatMap((chan) => chan.trySend(1));

      expect(test, succeeds(isRight(true)));
    });

    test('trySend returns Right(false) when channel is full', () {
      final test = Channel.bounded<int>(2).flatMap((chan) {
        return chan.trySend(1).productR(() => chan.trySend(2)).productR(() => chan.trySend(3));
      });

      expect(test, succeeds(isRight(false)));
    });

    test('trySend returns Left(ChannelClosed) when channel is closed', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.trySend(42));
      });

      expect(test, succeeds(isLeft()));
    });

    test('close is idempotent — second close returns ChannelClosed', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.close().productR(() => chan.close());
      });

      expect(test, succeeds(isLeft()));
    });

    test('isClosed reflects open and closed states', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.isClosed.flatMap((before) {
          return chan.close().productR(() => chan.isClosed).map((after) => (before, after));
        });
      });

      expect(test, succeeds((false, true)));
    });

    test('closed completes after close is called', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final closeAfterDelay = IO.sleep(50.milliseconds).productR(() => chan.close());
        return IO.both(closeAfterDelay, chan.closed).voided();
      });

      expect(test, succeeds());
    });

    test('closeWithElement sends element and closes', () {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        return chan.closeWithElement(99).productR(() => chan.rill.compile.toIList);
      });

      expect(test, succeeds(ilist([99])));
    });

    test('synchronous channel — send blocks until consumer reads', () {
      final test = Channel.synchronous<int>().flatMap((chan) {
        final sender = chan.send(42);
        final receiver = chan.rill.take(1).compile.toIList;

        return IO.both(sender, receiver).mapN((_, b) => b);
      });

      expect(test, succeeds(ilist([42])));
    });

    test('unbounded channel accepts many elements without backpressure', () {
      final test = Channel.unbounded<int>().flatMap((chan) {
        final sends = IList.range(0, 100).traverseIO_((i) => chan.send(i));
        return sends.productR(() => chan.close()).productR(() => chan.rill.compile.toIList);
      });

      expect(
        test.map((result) => result.sorted(Order.ints)),
        succeeds(IList.range(0, 100)),
      );
    });

    test('sendAll pipe delivers all elements and closes channel', () {
      final test = Channel.bounded<int>(10).flatMap((chan) {
        final sending = Rill.emits<int>([1, 2, 3]).through<Never>(chan.sendAll).compile.drain;
        final receiving = chan.rill.compile.toIList;

        return IO.both(sending, receiving).mapN((_, b) => b);
      });

      expect(
        test.map((result) => result.sorted(Order.ints)),
        succeeds(ilist([1, 2, 3])),
      );
    });

    test('backpressure — producer is suspended when channel is full', () {
      final test = Channel.bounded<int>(2).flatMap((chan) {
        // Fill the channel, then read to unblock producer
        final slowConsumer = IO
            .sleep(50.milliseconds)
            .productR(() => chan.rill.take(3).compile.toIList);
        final producer = IList.range(0, 3).traverseIO_((i) => chan.send(i));

        return IO.both(producer, slowConsumer).mapN((_, b) => b);
      });

      expect(
        test.map((result) => result.sorted(Order.ints)),
        succeeds(ilist([0, 1, 2])),
      );
    });
  });
}
