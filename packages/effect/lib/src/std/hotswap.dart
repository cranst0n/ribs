import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

sealed class Hotswap<R> {
  IO<Unit> swap(Resource<R> next);

  Resource<R> get current;

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
