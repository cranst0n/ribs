import 'dart:js_interop';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/platform/base.dart';
import 'package:web/web.dart' as web;

final class PlatformImpl extends PlatformBase {
  @override
  IO<A> isolate<A>(IO<A> io, {String? debugName}) => io;

  @override
  IO<Unit> print(String message) => IO.exec(() => web.console.log(message.toJS));

  @override
  IO<Unit> println(String message) => IO.exec(() => web.console.log(message.toJS));

  @override
  IO<Unit> printErr(String message) => IO.exec(() => web.console.log(message.toJS));

  @override
  IO<Unit> printErrLn(String message) => IO.exec(() => web.console.log(message.toJS));

  @override
  IO<String> readLine() => IO.raiseError('Unavailable: IO.readLine()');
}
