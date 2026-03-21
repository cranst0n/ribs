// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// cb-basic
/// A barrier of capacity 2 requires 2 concurrent [await] calls before any
/// fiber is released.
IO<Unit> cyclicBarrierBasic() => CyclicBarrier.withCapacity(2).flatMap((barrier) {
  IO<Unit> worker(int id) => IO
      .sleep((id * 30).milliseconds)
      .productR(() => IO.print('worker $id: reached barrier'))
      .productR(() => barrier.await())
      .productR(() => IO.print('worker $id: released'));

  return ilist([worker(1), worker(2)]).parSequence_();
});
// cb-basic

// cb-reuse
/// Unlike [CountDownLatch], a [CyclicBarrier] resets after each cycle.
/// Here three fibers rendezvous twice — once per round.
IO<Unit> cyclicBarrierReuse() => CyclicBarrier.withCapacity(3).flatMap((barrier) {
  IO<Unit> worker(int id) =>
      barrier
          .await()
          .productR(() => IO.print('round 1: worker $id released'))
          .productR(() => barrier.await())
          .productR(() => IO.print('round 2: worker $id released'));

  return ilist([worker(1), worker(2), worker(3)]).parSequence_();
});
// cb-reuse

// cb-cancel
/// A fiber waiting at the barrier can be canceled safely. The barrier count
/// is restored so the remaining fibers are not permanently stuck.
IO<Unit> cyclicBarrierCancel() => CyclicBarrier.withCapacity(2).flatMap((barrier) {
  // This fiber will time out before the second fiber arrives.
  final impatient = barrier.await().timeoutTo(50.milliseconds, IO.unit);

  // After the impatient fiber cancels, the barrier is back to capacity 2,
  // so we need a second fiber to arrive alongside the patient one.
  final patient = IO
      .sleep(100.milliseconds)
      .productR(() => barrier.await());

  final secondArrival = IO
      .sleep(150.milliseconds)
      .productR(() => barrier.await())
      .productR(() => IO.print('both patient fibers released'));

  return ilist([impatient, patient, secondArrival]).parSequence_();
});
// cb-cancel

// cb-pipeline
/// Real-world example: parallel pipeline stages.
///
/// Three processing stages each complete a chunk of work, then wait at a
/// shared barrier before moving to the next chunk. This guarantees that all
/// stages stay in lock-step — no stage races ahead while another is still
/// processing the previous chunk.
IO<Unit> pipelineStages() => CyclicBarrier.withCapacity(3).flatMap((barrier) {
  IO<Unit> stage(String name, Duration workTime) {
    IO<Unit> processChunk(int chunk) => IO
        .sleep(workTime)
        .productR(() => IO.print('[$name] chunk $chunk done — waiting'))
        .productR(() => barrier.await())
        .productR(() => IO.print('[$name] chunk $chunk committed'));

    return processChunk(1)
        .productR(() => processChunk(2))
        .productR(() => processChunk(3));
  }

  return ilist([
    stage('parse',     50.milliseconds),
    stage('transform', 80.milliseconds),
    stage('persist',   60.milliseconds),
  ]).parSequence_();
});
// cb-pipeline
