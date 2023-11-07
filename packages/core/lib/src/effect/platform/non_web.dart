import 'dart:io' show stderr, stdin, stdout;

import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/effect/platform/base.dart';
import 'package:ribs_core/src/option.dart';
import 'package:ribs_core/src/unit.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<Unit> print(String message) => IO.exec(() => stdout.write(message));

  @override
  IO<Unit> println(String message) => IO.exec(() => stdout.writeln(message));

  @override
  IO<Unit> printErr(String message) => IO.exec(() => stderr.write(message));

  @override
  IO<Unit> printErrLn(String message) => IO.exec(() => stderr.writeln(message));

  @override
  IO<String> readLine() =>
      IO.delay(() => stdin.readLineSync()).flatMap((l) => Option(l).fold(
          () => IO.raiseError(RuntimeException('stdin line ended')), IO.pure));
}
