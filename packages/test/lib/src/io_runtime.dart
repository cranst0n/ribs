import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A deterministic [IORuntime] for testing [IO] programs.
///
/// Unlike [RealIORuntime], time does not advance automatically. Instead,
/// the test controls time via [advance], [tick], [tickOne], [tickAll], and
/// [advanceAndTick]. Scheduled tasks are stored in a priority queue ordered
/// by their scheduled execution time.
///
/// This allows tests to exercise time-dependent logic (e.g. [IO.sleep],
/// timeouts, retry delays) without real wall-clock delays.
final class TestIORuntime extends IORuntime {
  int _currentID = 0;
  int _currentMicros = 0;
  final List<_Task> _tasks = <_Task>[];

  TestIORuntime({super.autoCedeN});

  @override
  DateTime get now => DateTime(1970).copyWith(microsecond: _currentMicros);

  @override
  void schedule(Function0<void> task) {
    _addTask(_Task(_currentID++, task, Duration(microseconds: _currentMicros)));
  }

  @override
  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake) {
    final newId = _currentID++;
    final clock = _currentMicros;
    final offset = delay >= Duration.zero ? delay : Duration.zero;
    final runsAt = Duration(microseconds: clock) + offset;

    final task = _Task(newId, onWake, runsAt);
    return _addTask(task);
  }

  /// Returns the duration until the next scheduled task, or [Duration.zero]
  /// if the task queue is empty or the next task is already due.
  Duration nextInterval() {
    if (_tasks.isEmpty) {
      return Duration.zero;
    } else {
      final diff = _tasks.first.runsAt - Duration(microseconds: _currentMicros);
      return diff.isNegative ? Duration.zero : diff;
    }
  }

  /// Advances the internal clock by [amount] without executing any tasks.
  void advance(Duration amount) {
    if (!amount.isNegative) _currentMicros += amount.inMicroseconds;
  }

  /// Advances the clock by [amount] and then executes all tasks that are
  /// now due.
  void advanceAndTick(Duration amount) {
    advance(amount);
    tick();
  }

  /// Executes the earliest scheduled task if its scheduled time has arrived.
  ///
  /// Returns `true` if a task was executed, `false` otherwise.
  bool tickOne() {
    return Option(_tasks.firstOrNull).fold(
      () => false,
      (head) {
        if (head.runsAt <= Duration(microseconds: _currentMicros)) {
          final task = _tasks.removeAt(0);

          try {
            task.task();
            return true;
          } catch (_) {
            return false;
          }
        } else {
          return false;
        }
      },
    );
  }

  /// Executes all tasks whose scheduled time has arrived, in order.
  void tick() {
    while (tickOne()) {}
  }

  /// Repeatedly advances the clock to the next scheduled task and executes
  /// it until no tasks remain.
  void tickAll() {
    tick();

    while (_tasks.isNotEmpty) {
      advance(nextInterval());
      tick();
    }
  }

  Function0<void> _addTask(_Task task) {
    _tasks.add(task);
    _tasks.sort((t0, t1) => t0.runsAt.compareTo(t1.runsAt));

    return () => _tasks.removeWhere((t) => t.id == task.id);
  }
}

final class _Task {
  final int id;
  final Function0<void> task;
  final Duration runsAt;

  _Task(this.id, this.task, this.runsAt);
}

/// A test harness that pairs an [IO] program with a [TestIORuntime],
/// providing fine-grained control over time advancement and task execution.
///
/// Created via [Ticker.ticked] or the [IOTickedOps.ticked] extension.
final class Ticker<A> {
  final TestIORuntime _runtime;
  final Completer<Outcome<A>> _completer;

  Ticker._(this._runtime, this._completer);

  /// Creates a [Ticker] by starting [io] on a fresh [TestIORuntime].
  static Ticker<A> ticked<A>(IO<A> io) {
    final runtime = TestIORuntime();
    final completer = Completer<Outcome<A>>();

    io.unsafeRunAsync((oc) => completer.complete(oc), runtime: runtime);

    return Ticker._(runtime, completer);
  }

  /// The [Future] that completes with the [Outcome] of the [IO] program.
  Future<Outcome<A>> get outcome => _completer.future;

  /// Advances the test clock by [amount] without executing tasks.
  void advance(Duration amount) => _runtime.advance(amount);

  /// Advances the test clock by [amount] and executes all due tasks.
  void advanceAndTick(Duration amount) => _runtime.advanceAndTick(amount);

  /// Ticks all tasks to completion and returns `true` if the [IO] has
  /// not completed (i.e. it is non-terminating).
  bool nonTerminating() {
    tickAll();
    return !_completer.isCompleted;
  }

  /// Returns the duration until the next scheduled task.
  Duration nextInterval() => _runtime.nextInterval();

  /// Executes all tasks whose scheduled time has arrived.
  void tick() => _runtime.tick();

  /// Drains all scheduled tasks, advancing time as needed.
  void tickAll() => _runtime.tickAll();

  /// Executes a single due task, returning `true` if one was run.
  bool tickOne() => _runtime.tickOne();
}

/// Extension on [IO] to create a [Ticker] for deterministic testing.
extension IOTickedOps<A> on IO<A> {
  /// Creates a [Ticker] for this [IO], starting it on a [TestIORuntime].
  Ticker<A> get ticked => Ticker.ticked(this);
}
