import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A concurrency primitive for atomically swapping a [Resource]-managed
/// value at runtime.
///
/// [Hotswap] holds a single [Resource] value that can be replaced via [swap].
/// When a new resource is swapped in, the previous resource is finalized
/// before the new one becomes active. The [current] accessor provides safe
/// concurrent access to the active resource.
///
/// Useful for scenarios such as connection pool rotation or configuration
/// reloading, where the underlying resource needs to be replaced without
/// disrupting concurrent readers.
sealed class Hotswap<R> {
  /// Atomically replaces the current resource with [next].
  ///
  /// The previous resource is finalized before [next] becomes active.
  /// If [swap] is canceled during acquisition, the partially acquired
  /// resource is finalized.
  IO<Unit> swap(Resource<R> next);

  /// Returns a [Resource] providing access to the current value.
  ///
  /// The resource's lifecycle is scoped to the access: the underlying value
  /// is guaranteed to remain valid for the duration of use. Concurrent
  /// [swap] operations will block until all active accessors have released.
  Resource<R> get current;

  /// Creates a [Hotswap] initialized with [initial].
  ///
  /// Returns a [Resource] that finalizes the last swapped-in resource when
  /// the [Hotswap] itself is finalized.
  static Resource<Hotswap<R>> create<R>(Resource<R> initial) {
    return Resource.eval(Semaphore.permits(Integer.maxValue)).flatMap((semaphore) {
      Resource<Unit> exclusive() {
        return Resource.makeFull(
          (poll) => poll(semaphore.acquireN(Integer.maxValue)),
          (_) => semaphore.releaseN(Integer.maxValue),
        );
      }

      IO<Unit> finalize(Ref<HotswapState<R>> state) {
        return state.getAndSet(Finalized()).flatMap((st) {
          return switch (st) {
            Acquired(:final fin) => exclusive().surround(fin),
            Finalized() => IO.raiseError('Hotswap already finalized'),
          };
        });
      }

      IO<Ref<HotswapState<R>>> initialize() {
        return IO.uncancelable((poll) {
          return poll(initial.allocated()).flatMapN(
            (r, fin) => exclusive().onCancel(Resource.eval(fin)).surround(IO.ref(Acquired(r, fin))),
          );
        });
      }

      return Resource.make(
        initialize(),
        finalize,
      ).map((state) => HotswapImpl(state, semaphore));
    });
  }

  /// Creates a [Hotswap] initialized with an empty value.
  static Resource<Hotswap<Option<R>>> empty<R>() => create(Resource.pure(none()));
}

class HotswapImpl<R> extends Hotswap<R> {
  final Ref<HotswapState<R>> state;
  final Semaphore semaphore;

  HotswapImpl(this.state, this.semaphore);

  @override
  Resource<R> get current {
    return Resource.makeFull(
      (poll) {
        return poll(semaphore.acquire()).productR(
          state.value().flatMap((st) {
            return switch (st) {
              Acquired(:final r) => IO.pure(r),
              Finalized() => IO.raiseError('Hotswap already finalized'),
            };
          }),
        );
      },
      (_) => semaphore.release(),
    );
  }

  @override
  IO<Unit> swap(Resource<R> next) {
    return IO.uncancelable((poll) {
      return poll(next.allocated()).flatMapN(
        (r, fin) =>
            exclusive().onCancel(Resource.eval(fin)).surround(swapFinalizer(Acquired(r, fin))),
      );
    });
  }

  IO<Unit> swapFinalizer(HotswapState<R> next) {
    return state.flatModify((st) {
      switch (st) {
        case Acquired(:final fin):
          return (next, fin);
        case Finalized():
          final fin = switch (next) {
            Acquired(:final fin) => fin,
            Finalized() => IO.unit,
          };

          return (Finalized(), fin.productR(IO.raiseError('Cannot swap after finalization')));
      }
    });
  }

  Resource<Unit> exclusive() {
    return Resource.makeFull(
      (poll) => poll(semaphore.acquireN(Integer.maxValue)),
      (_) => semaphore.releaseN(Integer.maxValue),
    );
  }
}

sealed class HotswapState<A> {}

class Acquired<R> extends HotswapState<R> {
  final R r;
  final IO<Unit> fin;

  Acquired(this.r, this.fin);
}

final class Finalized<R> extends HotswapState<R> {}
