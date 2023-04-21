import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/src/legacy/channel.dart';
import 'package:test/test.dart';

void main() {
  test('simple send/receive', () async {
    final test = Channel.bounded<int>(5).flatMap((chan) {
      final senders = IList.range(0, 10).parTraverseIO_(
          (i) => chan.send(i).delayBy(Duration(milliseconds: i * 5)));

      final drain = IO.sleep(const Duration(milliseconds: 300)).productR(
          () => chan.close().productR(() => chan.rill.compile().toIList()));

      return IO.both(senders, drain).map((a) => a.$2);
    });

    final result = await test.unsafeRunToFuture();

    expect(result, IList.range(0, 10));
  });

  test('trySend does not block', () async {
    final l = ilist([1, 2, 3, 4]);
    const capacity = 3;

    final test = Channel.bounded<int>(capacity).flatMap((chan) => l
        .traverseIO_(chan.trySend)
        .flatMap((_) => chan.close())
        .flatMap((_) => chan.rill.compile().toIList()));

    final result = await test.unsafeRunToFuture();

    expect(result, l.take(capacity));
  });
}
