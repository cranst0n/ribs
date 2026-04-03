import 'dart:async';

import 'package:ribs_core/ribs_core.dart';

/// The runtime environment for executing [IO] effects.
///
/// An [IORuntime] provides the scheduling primitives that the [IO] fiber
/// interpreter uses to run asynchronous work, yield control, and manage
/// timers. The [defaultRuntime] uses Dart's built-in [Timer] API.
///
/// Custom runtimes can be created for testing or specialized scheduling
/// requirements.
abstract class IORuntime {
  /// The default number of run loop iterations before the interpreter auto-cedes.
  static const DefaultAutoCedeN = 512;

  /// The number of run loop iterations the interpreter will execute before
  /// automatically ceding control back to the event loop.
  ///
  /// Lower values improve fairness between fibers at the cost of throughput.
  /// Must be greater than 0.
  final int autoCedeN;

  IORuntime({this.autoCedeN = DefaultAutoCedeN}) {
    if (autoCedeN < 1) throw ArgumentError('IORuntime.autoCedeN must be > 0');
  }

  /// Returns the current time.
  DateTime get now;

  /// Schedules [task] for asynchronous execution on the event loop.
  void schedule(Function0<void> task);

  /// Schedules [onWake] after [delay] and returns a cancellation function.
  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake);

  /// The global default runtime backed by [Timer.run] and [Timer].
  static final IORuntime defaultRuntime = RealIORuntime();
}

/// The default [IORuntime] implementation backed by Dart's [Timer] API.
class RealIORuntime extends IORuntime {
  RealIORuntime({super.autoCedeN});

  @override
  DateTime get now => DateTime.now();

  @override
  void schedule(Function0<void> task) => Timer.run(task);

  @override
  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake) {
    final t = Timer(delay, onWake);

    return () => t.cancel();
  }
}
