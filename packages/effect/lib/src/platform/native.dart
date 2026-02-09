import 'dart:io' show Stdout, stderr, stdin, stdout;
import 'dart:isolate';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/platform/base.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<A> isolate<A>(IO<A> io, {String? debugName}) =>
      IO.fromFutureF(() => Isolate.run(() => io.unsafeRunFuture(), debugName: debugName));

  @override
  IO<Unit> print(String message) => _printTo(stdout, message);

  @override
  IO<Unit> println(String message) => _printlnTo(stdout, message);

  @override
  IO<Unit> printErr(String message) => _printTo(stderr, message);

  @override
  IO<Unit> printErrLn(String message) => _printlnTo(stderr, message);

  @override
  IO<String> readLine() => IO
      .delay(() => stdin.readLineSync())
      .flatMap(
        (l) => Option(l).fold(() => IO.raiseError('stdin line ended'), IO.pure),
      );

  IO<Unit> _printTo(Stdout s, String message) => _opAndFlush(s, (std) => std.write(message));

  IO<Unit> _printlnTo(Stdout s, String message) => _opAndFlush(s, (std) => std.writeln(message));

  IO<Unit> _opAndFlush(Stdout s, Function1<Stdout, void> f) =>
      IO.exec(() => f(s)).productL(() => IO.fromFutureF(() => s.flush()));
}
