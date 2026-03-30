// ignore_for_file: unused_local_variable, avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// #region tracing-enable
void enableTracing() {
  // Tracing is disabled by default. Enable it once at application startup,
  // before any IO runs.
  IOTracingConfig.tracingEnabled = true;

  // The trace buffer is a ring buffer that keeps the last N operations per
  // fiber. The default is 64. Raise it for deeper traces; lower it to
  // reduce memory overhead on memory-constrained targets.
  IOTracingConfig.traceBufferSize = 128;
}
// #endregion tracing-enable

// #region tracing-error
// When tracing is enabled, error outcomes carry an IOFiberTrace instead of
// a native Dart stack trace. The trace shows the labeled operations that
// ran before the failure, most recent first.
Future<void> tracingError() async {
  IOTracingConfig.tracingEnabled = true;

  final outcome =
      await IO
          .delay<int>(() => throw Exception('database unavailable'))
          .flatMap((int n) => IO.pure(n * 2))
          .unsafeRunFutureOutcome();

  outcome.fold(
    () => print('cancelled'),
    (Object err, StackTrace? trace) {
      print('Error: $err');

      // When tracing is on, trace is an IOFiberTrace — a labeled breadcrumb
      // trail of the IO operations that ran before the failure.
      //
      // Example output:
      //
      //   IOFiberTrace:
      //     flatMap @ package:myapp/main.dart:12:10
      //       delay @ package:myapp/main.dart:11:8
      if (trace is IOFiberTrace) {
        print(trace);
      }
    },
    (int result) => print('result: $result'),
  );
}
// #endregion tracing-error

// #region tracing-dump
// Call IOFiber.dumpFibers() at any point to print a snapshot of every active
// fiber — its status and the operations in its current trace buffer.
//
// Example output:
//
//   ===== FIBER DUMP (3 active) ===================
//   Fiber #0 [RUNNING (or scheduled)]
//     ├  at      race @ package:myapp/main.dart:42:5
//     ├  at   flatMap @ package:myapp/main.dart:38:3
//     ╰  at     start @ package:myapp/main.dart:35:3
//
//   Fiber #1 [SUSPENDED: Sleep]
//     (No trace)
//
//   Fiber #2 [SUSPENDED: Async(waiting for callback)]
//     ╰  at    async @ package:myapp/main.dart:29:7
//
//   ================================================
IO<Unit> manualDump() {
  return IO.delay<Unit>(() {
    IOFiber.dumpFibers();
    return Unit();
  });
}
// #endregion tracing-dump

// #region tracing-signal
// On native Dart targets, install OS-level signal handlers so a dump can be
// triggered from a terminal without modifying the running application:
//
//   Ctrl+\           → sends SIGQUIT
//   kill -SIGUSR1 <pid>  → sends SIGUSR1
//
// Both signals print the fiber dump and resume execution immediately.
IO<Unit> setupSignalHandler() {
  return IO.delay<Unit>(() {
    IO.installFiberDumpSignalHandler();
    return Unit();
  });
}

// #endregion tracing-signal
