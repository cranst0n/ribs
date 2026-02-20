import 'dart:core' as c show print;
import 'dart:core';

import 'dart:io' show Platform, ProcessSignal, stdin;
import 'dart:isolate';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/platform/base.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<A> isolate<A>(IO<A> io, {String? debugName}) =>
      IO.fromFutureF(() => Isolate.run(() => io.unsafeRunFuture(), debugName: debugName));

  @override
  IO<Unit> print(String message) => IO.exec(() => c.print(message));

  @override
  IO<String> readLine() => IO
      .delay(() => stdin.readLineSync())
      .flatMap(
        (l) => Option(l).fold(() => IO.raiseError('stdin line ended'), IO.pure),
      );

  @override
  void installFiberDumpSignalHandler() {
    // Windows has limited signal support.
    if (Platform.isWindows) {
      print("[Warn] Fiber dump signals (SIGQUIT/SIGUSR1) are not supported on Windows.");
      return;
    }

    void handleSignal(ProcessSignal signal) {
      print("\n[OS Signal] $signal received. Initiating Fiber Dump...");
      IOFiber.dumpFibers();
      print("[OS Signal] Dump complete. Resuming application...\n");
    }

    // 1. SIGQUIT (Ctrl+\) - The standard "Dump Core/Stack" signal
    try {
      ProcessSignal.sigquit.watch().listen(handleSignal);
    } catch (e) {
      print("Could not listen to SIGQUIT: $e");
    }

    // 2. SIGUSR1 (kill -SIGUSR1 <pid>) - A common custom debug signal
    try {
      ProcessSignal.sigusr1.watch().listen(handleSignal);
    } catch (e) {
      print("Could not listen to SIGUSR1: $e");
    }
  }
}
