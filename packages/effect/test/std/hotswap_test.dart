import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:test/test.dart';

void main() {
  group('Hotswap', () {
    group('create', () {
      test('initial resource value is accessible via current', () {
        expect(
          Hotswap.create(Resource.pure(42)).use((hotswap) {
            return hotswap.current.use(IO.pure);
          }),
          ioSucceeded(42),
        );
      });

      test('initial resource finalizer runs when hotswap is closed', () {
        final test = IO.ref(false).flatMap((finalized) {
          final resource = Resource.make(IO.pure(1), (_) => finalized.setValue(true));
          return Hotswap.create(resource).use((_) => IO.unit).productR(() => finalized.value());
        });

        expect(test, ioSucceeded(isTrue));
      });
    });

    group('empty', () {
      test('starts with None as the current value', () {
        expect(
          Hotswap.empty<int>().use((hotswap) => hotswap.current.use(IO.pure)),
          ioSucceeded(none<int>()),
        );
      });

      test('can be swapped to Some(value)', () {
        expect(
          Hotswap.empty<int>().use((hotswap) {
            return hotswap
                .swap(Resource.pure(const Some(99)))
                .productR(() => hotswap.current.use(IO.pure));
          }),
          ioSucceeded(const Some(99)),
        );
      });
    });

    group('current', () {
      test('reflects the value set at creation', () {
        expect(
          Hotswap.create(Resource.pure('hello')).use((hotswap) => hotswap.current.use(IO.pure)),
          ioSucceeded('hello'),
        );
      });

      test('reflects updated value after swap', () {
        expect(
          Hotswap.create(Resource.pure(1)).use((hotswap) {
            return hotswap.swap(Resource.pure(2)).productR(() => hotswap.current.use(IO.pure));
          }),
          ioSucceeded(2),
        );
      });

      test('multiple sequential current reads work correctly', () {
        expect(
          Hotswap.create(Resource.pure(10)).use((hotswap) {
            return hotswap.current
                .use(IO.pure)
                .flatMap((a) => hotswap.current.use(IO.pure).map((b) => (a, b)));
          }),
          ioSucceeded((10, 10)),
        );
      });

      test('raises error when hotswap is already finalized', () async {
        late Hotswap<int> captured;

        await Hotswap.create(Resource.pure(1)).use((hotswap) {
          captured = hotswap;
          return IO.unit;
        }).unsafeRunFuture();

        // The hotswap resource is now finalized
        expect(captured.current.use(IO.pure), ioErrored());
      });
    });

    group('swap', () {
      test('replaces current resource value', () {
        expect(
          Hotswap.create(Resource.pure('a')).use((hotswap) {
            return hotswap.swap(Resource.pure('b')).productR(() => hotswap.current.use(IO.pure));
          }),
          ioSucceeded('b'),
        );
      });

      test('old resource finalizer runs when swapped out', () {
        final test = IO.ref(false).flatMap((oldFinalized) {
          final r1 = Resource.make(IO.pure(1), (_) => oldFinalized.setValue(true));

          return Hotswap.create(r1).use((hotswap) {
            return hotswap.swap(Resource.pure(2)).productR(() => oldFinalized.value());
          });
        });

        expect(test, ioSucceeded(isTrue));
      });

      test('new resource finalizer runs when hotswap closes', () {
        final test = IO.ref(false).flatMap((newFinalized) {
          final r2 = Resource.make(IO.pure(2), (_) => newFinalized.setValue(true));

          return Hotswap.create(
            Resource.pure(1),
          ).use((hotswap) => hotswap.swap(r2)).productR(() => newFinalized.value());
        });

        expect(test, ioSucceeded(isTrue));
      });

      test('multiple swaps run each intermediate finalizer', () {
        final test = IO.ref(nil<int>()).flatMap((log) {
          Resource<int> tracked(int n) =>
              Resource.make(IO.pure(n), (i) => log.update((l) => l.appended(i)));

          return Hotswap.create(tracked(1)).use((hotswap) {
            return hotswap
                .swap(tracked(2))
                .productR(() => hotswap.swap(tracked(3)))
                .productR(() => log.value());
          });
        });

        // 1 finalized when swapped out for 2, 2 finalized when swapped out for 3
        // 3 is finalized when hotswap closes but we check before close
        expect(test, ioSucceeded(ilist([1, 2])));
      });

      test('new resource finalizer runs after last swap when hotswap closes', () {
        final test = IO.ref(nil<int>()).flatMap((log) {
          Resource<int> tracked(int n) =>
              Resource.make(IO.pure(n), (i) => log.update((l) => l.appended(i)));

          return Hotswap.create(tracked(1))
              .use((hotswap) => hotswap.swap(tracked(2)).productR(() => hotswap.swap(tracked(3))))
              .productR(() => log.value());
        });

        // 1 finalized on first swap, 2 on second swap, 3 finalized when hotswap closes
        expect(test, ioSucceeded(ilist([1, 2, 3])));
      });

      test('raises error when called after finalization', () async {
        late Hotswap<int> captured;

        await Hotswap.create(Resource.pure(1)).use((hotswap) {
          captured = hotswap;
          return IO.unit;
        }).unsafeRunFuture();

        expect(captured.swap(Resource.pure(2)), ioErrored());
      });

      test('swap to same value works correctly', () {
        expect(
          Hotswap.create(Resource.pure(7)).use((hotswap) {
            return hotswap.swap(Resource.pure(7)).productR(() => hotswap.current.use(IO.pure));
          }),
          ioSucceeded(7),
        );
      });
    });

    group('concurrent access', () {
      test('current can be opened by multiple consumers simultaneously', () {
        expect(
          Hotswap.create(Resource.pure(1)).use((hotswap) {
            return IO.both(
              hotswap.current.use(IO.pure),
              hotswap.current.use(IO.pure),
            );
          }),
          ioSucceeded((1, 1)),
        );
      });

      test('swap completes after concurrent current readers finish', () async {
        final swapCompleted =
            await IO.ref(false).flatMap((swapped) {
              return Hotswap.create(Resource.pure(1)).use((hotswap) {
                // Acquire current resource and hold it open briefly
                return hotswap.current.allocated().flatMapN((_, release) {

                  // Start swap concurrently; it must wait for the held current to release
                  final swapFiber = IO.sleep(50.milliseconds).productR(() => release).start();
                  return IO
                      .both(
                        swapFiber,
                        hotswap.swap(Resource.pure(2)).productR(() => swapped.setValue(true)),
                      )
                      .productR(() => swapped.value());
                });
              });
            }).unsafeRunFuture();

        expect(swapCompleted, isTrue);
      });
    });
  });
}
