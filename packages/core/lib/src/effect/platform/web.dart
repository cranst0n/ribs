import 'dart:html' as html;

import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/effect/platform/base.dart';
import 'package:ribs_core/src/unit.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<Unit> print(String message) =>
      IO.exec(() => html.window.console.log(message));

  @override
  IO<Unit> println(String message) =>
      IO.exec(() => html.window.console.log(message));

  @override
  IO<Unit> printErr(String message) =>
      IO.exec(() => html.window.console.error(message));

  @override
  IO<Unit> printErrLn(String message) =>
      IO.exec(() => html.window.console.error(message));

  @override
  IO<String> readLine() =>
      IO.raiseError(RuntimeException('Unavailable: IO.readLine()'));
}
