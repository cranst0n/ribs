import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test.dart';
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
        expect(Rill.empty<int>().compile.fold(0, (a, b) => a + b), succeeds(0));
      });

      test('sums elements', () {
        expect(ints([1, 2, 3, 4]).compile.fold(0, (a, b) => a + b), succeeds(10));
      });

      test('collects into list', () {
        expect(
          ints([1, 2, 3]).compile.fold(<int>[], (acc, x) => [...acc, x]),
          succeeds([1, 2, 3]),
        );
      });
    });

    group('foldChunks', () {
      test('empty stream returns init', () {
        expect(
          Rill.empty<int>().compile.foldChunks(0, (acc, c) => acc + c.size),
          succeeds(0),
        );
      });

      test('receives all chunks', () {
        expect(
          ints([1, 2, 3]).compile.foldChunks(0, (acc, c) => acc + c.size),
          succeeds(3),
        );
      });
    });

    group('last', () {
      test('empty stream returns None', () {
        expect(Rill.empty<int>().compile.last, succeeds(none<int>()));
      });

      test('single-element stream returns Some', () {
        expect(Rill.emit(42).compile.last, succeeds(isSome(42)));
      });

      test('multi-element stream returns last element', () {
        expect(ints([1, 2, 3]).compile.last, succeeds(isSome(3)));
      });
    });

    group('lastOrError', () {
      test('empty stream raises error', () {
        expect(Rill.empty<int>().compile.lastOrError, errors());
      });

      test('returns last element', () {
        expect(ints([10, 20, 30]).compile.lastOrError, succeeds(30));
      });
    });

    group('onlyOrError', () {
      test('empty stream raises error', () {
        expect(Rill.empty<int>().compile.onlyOrError, errors());
      });

      test('single element succeeds', () {
        expect(Rill.emit(99).compile.onlyOrError, succeeds(99));
      });

      test('multiple elements raises error', () {
        expect(ints([1, 2]).compile.onlyOrError, errors());
      });
    });

    group('count', () {
      test('empty stream is 0', () {
        expect(Rill.empty<int>().compile.count, succeeds(0));
      });

      test('counts all elements', () {
        expect(ints([1, 2, 3, 4, 5]).compile.count, succeeds(5));
      });
    });

    group('drain', () {
      test('empty stream completes', () {
        expect(Rill.empty<int>().compile.drain, succeeds(Unit()));
      });

      test('discards all elements', () {
        expect(ints([1, 2, 3]).compile.drain, succeeds(Unit()));
      });
    });

    group('toIList', () {
      test('empty stream returns nil', () {
        expect(Rill.empty<int>().compile.toIList, succeeds(nil<int>()));
      });

      test('preserves order', () {
        expect(ints([3, 1, 2]).compile.toIList, succeeds(ilist([3, 1, 2])));
      });
    });

    group('toIVector', () {
      test('empty stream returns empty vector', () {
        expect(
          Rill.empty<int>().compile.toIVector,
          succeeds(IVector.empty<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([1, 2, 3]).compile.toIVector,
          succeeds(IVector.fromDart([1, 2, 3])),
        );
      });
    });
  });

  group('RillCompilerStringOps', () {
    test('empty stream returns empty string', () {
      expect(Rill.empty<String>().compile.string, succeeds(''));
    });

    test('concatenates all string elements', () {
      expect(
        Rill.emits<String>(['hello', ' ', 'world']).compile.string,
        succeeds('hello world'),
      );
    });

    test('single element', () {
      expect(Rill.emit('foo').compile.string, succeeds('foo'));
    });
  });

  group('RillCompilerIntOps', () {
    test('empty stream returns empty ByteVector', () {
      expect(
        Rill.empty<int>().compile.toByteVector,
        succeeds(ByteVector.empty),
      );
    });

    test('collects bytes into ByteVector', () {
      expect(
        Rill.emits([1, 2, 3]).compile.toByteVector,
        succeeds(ByteVector.fromDart([1, 2, 3])),
      );
    });
  });

  group('RillResourceCompile', () {
    group('fold', () {
      test('empty stream returns init', () {
        expect(
          Rill.empty<int>().compile.resource.fold(0, (a, b) => a + b).use(IO.pure),
          succeeds(0),
        );
      });

      test('sums elements', () {
        expect(
          ints([1, 2, 3]).compile.resource.fold(0, (a, b) => a + b).use(IO.pure),
          succeeds(6),
        );
      });
    });

    group('foldChunks', () {
      test('counts chunk sizes', () {
        expect(
          ints([1, 2, 3]).compile.resource.foldChunks(0, (acc, c) => acc + c.size).use(IO.pure),
          succeeds(3),
        );
      });
    });

    group('count', () {
      test('empty stream is 0', () {
        expect(
          Rill.empty<int>().compile.resource.count.use(IO.pure),
          succeeds(0),
        );
      });

      test('counts all elements', () {
        expect(
          ints([1, 2, 3, 4]).compile.resource.count.use(IO.pure),
          succeeds(4),
        );
      });
    });

    group('drain', () {
      test('empty stream completes', () {
        expect(
          Rill.empty<int>().compile.resource.drain.use(IO.pure),
          succeeds(Unit()),
        );
      });

      test('discards all elements', () {
        expect(
          ints([1, 2, 3]).compile.resource.drain.use(IO.pure),
          succeeds(Unit()),
        );
      });
    });

    group('last', () {
      test('empty stream returns None', () {
        expect(
          Rill.empty<int>().compile.resource.last.use(IO.pure),
          succeeds(none<int>()),
        );
      });

      test('returns last element', () {
        expect(
          ints([10, 20, 30]).compile.resource.last.use(IO.pure),
          succeeds(isSome(30)),
        );
      });
    });

    group('lastOrError', () {
      test('empty stream raises error', () {
        expect(
          Rill.empty<int>().compile.resource.lastOrError.use(IO.pure),
          errors(),
        );
      });

      test('returns last element', () {
        expect(
          ints([5, 10, 15]).compile.resource.lastOrError.use(IO.pure),
          succeeds(15),
        );
      });
    });

    group('onlyOrError', () {
      test('empty stream raises error', () {
        expect(
          Rill.empty<int>().compile.resource.onlyOrError.use(IO.pure),
          errors(),
        );
      });

      test('single element succeeds', () {
        expect(
          Rill.emit(7).compile.resource.onlyOrError.use(IO.pure),
          succeeds(7),
        );
      });

      test('multiple elements raises error', () {
        expect(
          ints([1, 2]).compile.resource.onlyOrError.use(IO.pure),
          errors(),
        );
      });
    });

    group('toIList', () {
      test('empty stream returns nil', () {
        expect(
          Rill.empty<int>().compile.resource.toIList.use(IO.pure),
          succeeds(nil<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([3, 1, 2]).compile.resource.toIList.use(IO.pure),
          succeeds(ilist([3, 1, 2])),
        );
      });
    });

    group('toIVector', () {
      test('empty stream returns empty vector', () {
        expect(
          Rill.empty<int>().compile.resource.toIVector.use(IO.pure),
          succeeds(IVector.empty<int>()),
        );
      });

      test('preserves order', () {
        expect(
          ints([1, 2, 3]).compile.resource.toIVector.use(IO.pure),
          succeeds(IVector.fromDart([1, 2, 3])),
        );
      });
    });

    test('resource finalizers run after compile', () {
      final released = IO.ref(false).flatMap((ref) {
        final r = Resource.make(IO.unit, (_) => ref.setValue(true));
        final rill = Rill.resource(r).evalMap((_) => IO.pure(42));
        return rill.compile.resource.toIList.use(IO.pure).productR(ref.value());
      });

      expect(released, succeeds(true));
    });
  });
}
