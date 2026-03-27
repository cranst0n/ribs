// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// signal-basics

IO<Unit> signalBasics() {
  return SignallingRef.of(0).flatMap((SignallingRef<int> counter) {
    // SignallingRef is both a Ref and a Signal — all atomic Ref operations
    // (update, modify, getAndUpdate, etc.) are available alongside stream
    // observation.
    final increment = counter.update((int n) => n + 1);

    // value() reads the current value as a one-shot IO.
    final readOnce = counter.value();

    // map produces a derived Signal without modifying the underlying value.
    // The mapping is lazy: it is applied whenever the signal is observed.
    final Signal<String> label = counter.map((int n) => 'count=$n');

    return increment
        .productR(increment)
        .productR(readOnce)
        .flatMap((int n) => IO.print('value after two increments: $n'));
    // value after two increments: 2
  });
}

// signal-basics

// signal-discrete

IO<IList<int>> signalDiscrete() {
  return SignallingRef.of(0).flatMap((SignallingRef<int> ref) {
    // discrete emits the current value immediately, then emits again only
    // when the value changes. If updates happen faster than the consumer
    // reads, intermediate values are dropped — the consumer always sees
    // the latest available value.
    final observer = ref.discrete.take(4).compile.toIList;

    // Push three updates concurrently.
    final updates = Rill.range(1, 4).evalMap((int n) => ref.setValue(n)).compile.drain;

    return IO.both<IList<int>, Unit>(observer, updates).map((t) => t.$1);
    // => IList(0, 1, 2, 3)  — initial + each update
  });
}

// signal-discrete

// signal-continuous

IO<IList<int>> signalContinuous() {
  return SignallingRef.of(42).flatMap((SignallingRef<int> ref) {
    // continuous emits the current value on every poll — it does not wait
    // for the value to change. Use it for polling-based consumers that
    // always want the freshest snapshot, regardless of whether it changed.
    final snapshots = ref.continuous.take(3).compile.toIList;

    return snapshots;
    // => IList(42, 42, 42)  — same value, sampled three times
  });
}

// signal-continuous

// signal-interrupt

// interruptWhenSignaled is the standard cancellation-token pattern.
// The stream producer does not need to know who signals the stop or when.
IO<Unit> signalInterrupt() {
  return SignallingRef.of(false).flatMap((SignallingRef<bool> stop) {
    // This stream runs indefinitely until stop becomes true.
    final stream =
        Rill.constant<int>(
          0,
        ).scan(0, (int acc, int _) => acc + 1).interruptWhenSignaled(stop).compile.drain;

    // The controller lives in a separate fiber and decides when to stop.
    final controller = stop.setValue(true);

    return IO.both<Unit, Unit>(stream, controller).voided();
  });
}

// signal-interrupt

// signal-realworld

// A streaming processor with external pause and stop controls.
//
// Three concurrent fibers share two signals:
//   - `paused`  (bool)  — when true, processing suspends.
//   - `stop`    (bool)  — when true, processing terminates.
//
// A fourth fiber tracks item counts via a third signal and fires a stop
// once enough items have been processed.
IO<int> pauseableProcessor() {
  return SignallingRef.of(false).flatMap((SignallingRef<bool> paused) {
    return SignallingRef.of(false).flatMap((SignallingRef<bool> stop) {
      return SignallingRef.of(0).flatMap((SignallingRef<int> itemCount) {
        // Main processor: processes items from a large range.
        // pauseWhenSignal suspends the stream while paused == true.
        // interruptWhenSignaled terminates it when stop == true.
        final processor =
            Rill.range(0, 10000)
                .pauseWhenSignal(paused)
                .interruptWhenSignaled(stop)
                .evalMap((int _) => itemCount.update((int n) => n + 1))
                .compile
                .drain;

        // Progress observer: logs every 25 items processed.
        // Also stops when the stop signal fires.
        final logger =
            itemCount.discrete
                .filter((int n) => n > 0 && n % 25 == 0)
                .evalMap((int n) => IO.print('processed $n items'))
                .interruptWhenSignaled(stop)
                .compile
                .drain;

        // Watchdog: fires the stop signal once 100 items have been
        // processed. Uses waitUntil to block until the condition holds.
        final watchdog = itemCount.waitUntil((int n) => n >= 100).productR(stop.setValue(true));

        // Demonstrate pause: briefly pause then resume after 50 items.
        final pauseController = itemCount
            .waitUntil((int n) => n >= 50)
            .productR(paused.setValue(true))
            .productR(paused.setValue(false));

        final work = IO.both<Unit, Unit>(processor, logger).voided();

        final control = IO.both<Unit, Unit>(watchdog, pauseController).voided();

        return IO.both<Unit, Unit>(work, control).productR(itemCount.value());
        // => 100 (or slightly more due to scheduling)
      });
    });
  });
}

// signal-realworld
