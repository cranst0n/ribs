import 'dart:html' as html;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/platform/base.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<A> isolate<A>(IO<A> io, {String? debugName}) => io;

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
