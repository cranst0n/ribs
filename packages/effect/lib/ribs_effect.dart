/// A functional effects library for Dart, providing a
/// purely functional abstraction for managing side-effects, concurrency,
/// resource safety, and asynchronous execution.
///
/// Features powerful primitives like [IO] and [Resource], alongside
/// concurrent data structures like [Queue], [Semaphore], and [Ref].
library;

export 'src/deferred.dart' show Deferred;
export 'src/exit_case.dart' show ExitCase;
export 'src/io.dart';
export 'src/io_retry.dart';
export 'src/io_runtime.dart';
export 'src/outcome.dart';
export 'src/ref.dart' show Ref;
export 'src/resource.dart' show Resource, ResourceIOOps;
export 'src/std/backpressure.dart' show Backpressure;
export 'src/std/count_down_latch.dart' show CountDownLatch;
export 'src/std/cyclic_barrier.dart' show CyclicBarrier;
export 'src/std/dequeue.dart' show Dequeue;
export 'src/std/dispatcher.dart' show Dispatcher;
export 'src/std/hotswap.dart' show Hotswap;
export 'src/std/pqueue.dart' show PQueue;
export 'src/std/queue.dart' show Queue;
export 'src/std/semaphore.dart' show Semaphore;
export 'src/std/supervisor.dart' show Supervisor;
export 'src/sync_io.dart' show SyncIO;
export 'src/syntax/all.dart';
