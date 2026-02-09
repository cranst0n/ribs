import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class IORuntime {
  DateTime get now;

  void schedule(Function0<void> task);

  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake);

  static final IORuntime defaultRuntime = RealIORuntime();
}

class RealIORuntime implements IORuntime {
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

final class TestIORuntime extends IORuntime {
  int _currentID = 0;
  int _currentMicros = 0;
  final List<_Task> _tasks = <_Task>[];

  TestIORuntime();

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
    final runsAt = Duration(microseconds: clock) + delay >= Duration.zero ? delay : Duration.zero;

    final task = _Task(newId, onWake, runsAt);
    return _addTask(task);
  }

  Duration nextInterval() {
    if (_tasks.isEmpty) {
      return Duration.zero;
    } else {
      final diff = _tasks.first.runsAt - Duration(microseconds: _currentMicros);
      return diff.isNegative ? Duration.zero : diff;
    }
  }

  void advance(Duration amount) {
    if (!amount.isNegative) _currentMicros += amount.inMicroseconds;
  }

  void advanceAndTick(Duration amount) {
    advance(amount);
    tick();
  }

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

  void tick() {
    while (tickOne()) {}
  }

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

final class Ticker<A> {
  final TestIORuntime _runtime;
  final Future<Outcome<A>> _outcome;

  Ticker._(this._runtime, this._outcome);

  static Ticker<A> ticked<A>(IO<A> io) {
    final runtime = TestIORuntime();

    return Ticker._(runtime, io.unsafeRunFutureOutcome(runtime: runtime, autoCedeN: 1));
  }

  Future<Outcome<A>> get outcome => _outcome;

  void advance(Duration amount) => _runtime.advance(amount);

  void advanceAndTick(Duration amount) => _runtime.advanceAndTick(amount);

  Duration nextInterval() => _runtime.nextInterval();

  void tick() => _runtime.tick();

  void tickAll() => _runtime.tickAll();

  bool tickOne() => _runtime.tickOne();
}
