import 'dart:isolate';

import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('foo', () async {
    final io = IO(() => fibStream().elementAt(43)).flatTap(
        (value) => IO.println('[${Isolate.current.debugName}] $value'));

    final handle = await io.start().unsafeRun();

    handle
        .cancel()
        .flatTap((_) => IO.println('cancel called...'))
        .delayBy(const Duration(milliseconds: 3000))
        .unsafeRunAndForget();

    final outcome = await handle.join().debug(prefix: 'RESULT: ').unsafeRun();

    expect(outcome, const Succeeded(701408733));
  });

  test('bar', () async {
    IO<Unit> foo(String message) => IO
        .println(message)
        .delayBy(Duration(seconds: message.codeUnitAt(0) - 'A'.codeUnitAt(0)));

    final ios = ilist(['A', 'B', 'C', 'D', 'E']).parTraverseIO(foo);

    final handle = await ios.start().unsafeRun();

    handle
        .cancel()
        .delayBy(const Duration(milliseconds: 2500))
        .unsafeRunAndForget();

    await handle.join().debug(prefix: 'RESULT: ').unsafeRunAndForget();
  });

  test('memoized', () async {
    const n = 35;
    int count = 0;

    final prog = IO
        .async(() {
          count += 1;
          return 1;
        })
        .memoize
        .flatMap((memoizedIO) =>
            IList.fill(n, memoizedIO.delayBy(const Duration(seconds: 1)))
                .parSequence
                .map((a) => a.size));

    final result = await prog.unsafeRun();

    expect(result, n);
    expect(count, 1);
  });
}

int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);
Stream<int> fibStream() async* {
  for (var i = 0;; i++) {
    if (i == 44) throw StateError('boom!');

    yield slowFib(i);
  }
}
