import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  // Helpers
  Rill<int> ints(List<int> values) => Rill.emits<int>(values);

  group('RillCompile (IO)', () {
    group('fold', () {
      test('empty stream returns init', () {
        expect(Rill.empty<int>().compile.fold(0, (a, b) => a + b), ioSucceeded(0));
      });

      test('sums elements', () {
        expect(ints([1, 2, 3, 4]).compile.fold(0, (a, b) => a + b), ioSucceeded(10));
      });

      test('collects into list', () {
        expect(
          ints([1, 2, 3]).compile.fold(<int>[], (acc, x) => [...acc, x]),
          ioSucceeded([1, 2, 3]),
        );
      });
    });

    group('foldChunks', () {
      test('empty stream returns init', () {
        expect(
          Rill.empty<int>().compile.foldChunks(0, (acc, c) => acc + c.size),
          ioSucceeded(0),
        );
      });

      test('receives all chunks', () {
        expect(
          ints([1, 2, 3]).compile.foldChunks(0, (acc, c) => acc + c.size),
          ioSucceeded(3),
        );
      });
    });

    group('last', () {
      test('empty stream returns None', () {
        expect(Rill.empty<int>().compile.last, ioSucceeded(none<int>()));
      });

      test('single-element stream returns Some', () {
        expect(Rill.emit(42).compile.last, ioSucceeded(isSome(42)));
      });

      test('multi-element stream returns last element', () {
        expect(ints([1, 2, 3]).compile.last, ioSucceeded(isSome(3)));
      });
    });

    group('lastOrError', () {
      test('empty stream raises error', () {
        expect(Rill.empty<int>().compile.lastOrError, ioErrored());
      });

      test('returns last element', () {
        expect(ints([10, 20, 30]).compile.lastOrError, ioSucceeded(30));
      });
    });

    group('onlyOrError', () {
      test('empty stream raises error', () {
        expect(Rill.empty<int>().compile.onlyOrError, ioErrored());
      });

      test('single element succeeds', () {
        expect(Rill.emit(99).compile.onlyOrError, ioSucceeded(99));
      });

      test('multiple elements raises error', () {
        expect(ints([1, 2]).compile.onlyOrError, ioErrored());
      });
    });

    group('count', () {
      test('empty stream is 0', () {
        expect(Rill.empty<int>().compile.count, ioSucceeded(0));
      });

      test('counts all elements', () {
        expect(ints([1, 2, 3, 4, 5]).compile.count, ioSucceeded(5));
      });
    });

    group('drain', () {
      test('empty stream completes', () {
        expect(Rill.empty<int>().compile.drain, ioSucceeded(Unit()));
      });

      test('discards all elements', () {
        expect(ints([1, 2, 3]).compile.drain, ioSucceeded(Unit()));
      });
    });

    group('toIList', () {
      test('empty stream returns nil', () {
        expect(Rill.empty<int>().compile.toIList, ioSucceeded(nil<int>()));
      });

      test('preserves order', () {
        expect(ints([3, 1, 2]).compile.toIList, ioSucceeded(ilist([3, 1, 2])));
      });
    });

    group('toIVector', () {
      test('empty stream returns empty vector', () {
        expect(
          Rill.empty<int>().compile.toIVector,
          ioSucceeded(IVector.empty<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([1, 2, 3]).compile.toIVector,
          ioSucceeded(IVector.fromDart([1, 2, 3])),
        );
      });
    });
  });

  group('RillCompilerStringOps', () {
    test('empty stream returns empty string', () {
      expect(Rill.empty<String>().compile.string, ioSucceeded(''));
    });

    test('concatenates all string elements', () {
      expect(
        Rill.emits<String>(['hello', ' ', 'world']).compile.string,
        ioSucceeded('hello world'),
      );
    });

    test('single element', () {
      expect(Rill.emit('foo').compile.string, ioSucceeded('foo'));
    });
  });

  group('RillCompilerIntOps', () {
    test('empty stream returns empty ByteVector', () {
      expect(
        Rill.empty<int>().compile.toByteVector,
        ioSucceeded(ByteVector.empty),
      );
    });

    test('collects bytes into ByteVector', () {
      expect(
        Rill.emits([1, 2, 3]).compile.toByteVector,
        ioSucceeded(ByteVector.fromDart([1, 2, 3])),
      );
    });
  });

  group('RillResourceCompile', () {
    group('fold', () {
      test('empty stream returns init', () {
        expect(
          Rill.empty<int>().compile.resource.fold(0, (a, b) => a + b).use(IO.pure),
          ioSucceeded(0),
        );
      });

      test('sums elements', () {
        expect(
          ints([1, 2, 3]).compile.resource.fold(0, (a, b) => a + b).use(IO.pure),
          ioSucceeded(6),
        );
      });
    });

    group('foldChunks', () {
      test('counts chunk sizes', () {
        expect(
          ints([1, 2, 3]).compile.resource.foldChunks(0, (acc, c) => acc + c.size).use(IO.pure),
          ioSucceeded(3),
        );
      });
    });

    group('count', () {
      test('empty stream is 0', () {
        expect(
          Rill.empty<int>().compile.resource.count.use(IO.pure),
          ioSucceeded(0),
        );
      });

      test('counts all elements', () {
        expect(
          ints([1, 2, 3, 4]).compile.resource.count.use(IO.pure),
          ioSucceeded(4),
        );
      });
    });

    group('drain', () {
      test('empty stream completes', () {
        expect(
          Rill.empty<int>().compile.resource.drain.use(IO.pure),
          ioSucceeded(Unit()),
        );
      });

      test('discards all elements', () {
        expect(
          ints([1, 2, 3]).compile.resource.drain.use(IO.pure),
          ioSucceeded(Unit()),
        );
      });
    });

    group('last', () {
      test('empty stream returns None', () {
        expect(
          Rill.empty<int>().compile.resource.last.use(IO.pure),
          ioSucceeded(none<int>()),
        );
      });

      test('returns last element', () {
        expect(
          ints([10, 20, 30]).compile.resource.last.use(IO.pure),
          ioSucceeded(isSome(30)),
        );
      });
    });

    group('lastOrError', () {
      test('empty stream raises error', () {
        expect(
          Rill.empty<int>().compile.resource.lastOrError.use(IO.pure),
          ioErrored(),
        );
      });

      test('returns last element', () {
        expect(
          ints([5, 10, 15]).compile.resource.lastOrError.use(IO.pure),
          ioSucceeded(15),
        );
      });
    });

    group('onlyOrError', () {
      test('empty stream raises error', () {
        expect(
          Rill.empty<int>().compile.resource.onlyOrError.use(IO.pure),
          ioErrored(),
        );
      });

      test('single element succeeds', () {
        expect(
          Rill.emit(7).compile.resource.onlyOrError.use(IO.pure),
          ioSucceeded(7),
        );
      });

      test('multiple elements raises error', () {
        expect(
          ints([1, 2]).compile.resource.onlyOrError.use(IO.pure),
          ioErrored(),
        );
      });
    });

    group('toIList', () {
      test('empty stream returns nil', () {
        expect(
          Rill.empty<int>().compile.resource.toIList.use(IO.pure),
          ioSucceeded(nil<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([3, 1, 2]).compile.resource.toIList.use(IO.pure),
          ioSucceeded(ilist([3, 1, 2])),
        );
      });
    });

    group('toIVector', () {
      test('empty stream returns empty vector', () {
        expect(
          Rill.empty<int>().compile.resource.toIVector.use(IO.pure),
          ioSucceeded(IVector.empty<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([1, 2, 3]).compile.resource.toIVector.use(IO.pure),
          ioSucceeded(IVector.fromDart([1, 2, 3])),
        );
      });
    });

    test('resource finalizers run after compile', () {
      final released = IO.ref(false).flatMap((ref) {
        final r = Resource.make(IO.unit, (_) => ref.setValue(true));
        final rill = Rill.resource(r).evalMap((_) => IO.pure(42));
        return rill.compile.resource.toIList.use(IO.pure).productR(() => ref.value());
      });

      expect(released, ioSucceeded(true));
    });
  });
}
