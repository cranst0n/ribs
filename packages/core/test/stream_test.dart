import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('foo', () async {
    // final intStream = StreamY.emits([0, 1, 2, 3, 4, 5, 6, 7, 8]).drop(4);

    final intStream = Rill.iterate(0, (x) => x + 1);

    final stringStream =
        Pull.fromIList(IList.tabulate(3, (x) => String.fromCharCode(x + 65)))
            .toStream;

    final ss = intStream.take(10).toList;
    final tt = intStream
        .take(10)
        .flatMap((x) => Rill.iterate(x, (x) => x * 2).take(15))
        .toIList;

    print('ss: $ss');
    print('tt [${tt.length}]: $tt');

    final a = intStream.take(5);
    final b = intStream.drop(10).take(5);

    print('a: ${a.toList}');
    print('b: ${b.toList}');

    print('xx: ${a.concat(b).toIList}');
  });

  test('bar', () async {
    final Pipe<int, String> charCodes =
        (ints) => ints.map((i) => String.fromCharCode(i + 65));

    final ints = Rill.iterate(0, (a) => a + 1);
    final strings = ints.through(charCodes);

    print('strings: ${strings.take(26).toIList}');
  });
}
