import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/src/channel.dart';
import 'package:test/test.dart';

void main() {
  group('Channel', () {
    test('receives elements above capacity and closes', () async {
      final test = Channel.bounded<int>(5).flatMap((chan) {
        final senders = IList.range(0, 10).parTraverseIO_((i) {
          return IO.sleep(Duration(milliseconds: i)).productR(() => chan.send(i));
        });

        final cleanup = IO
            .sleep(15.milliseconds)
            .productR(() => chan.close())
            .productR(() => chan.stream.compile.toList);

        return IO.both(senders, cleanup).map((t) => t.$2);
      });

      final result = await test.unsafeRunFuture();

      expect(result.sorted(Order.ints), IList.range(0, 10));
    });
  });
}
