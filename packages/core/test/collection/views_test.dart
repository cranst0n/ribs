import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;
import 'package:test/test.dart';

void main() {
  group('views', () {
    group('Collect', () {
      test('yields transformed elements where f returns Some', () {
        final result =
            ilist([
              1,
              2,
              3,
              4,
              5,
            ]).collect((int n) => n.isOdd ? Some(n * 10) : none<int>()).toIList();
        expect(result, ilist([10, 30, 50]));
      });

      test('yields nothing when no element matches', () {
        final result =
            ilist([1, 2, 3]).collect((int n) => n > 10 ? Some(n) : none<int>()).toIList();
        expect(result, nil<int>());
      });

      test('knownSize is -1 for non-empty unknown-size underlying', () {
        expect(ilist([1, 2, 3]).collect((int n) => Some(n)).knownSize, -1);
      });
    });

    group('Concat', () {
      test('concatenates two non-empty collections', () {
        expect(
          ilist([1, 2]).concat(ilist([3, 4])).toIList(),
          ilist([1, 2, 3, 4]),
        );
      });

      test('concat with empty suffix returns original elements', () {
        expect(ilist([1, 2]).concat(nil<int>()).toIList(), ilist([1, 2]));
      });

      test('concat with empty prefix returns suffix elements', () {
        expect(nil<int>().concat(ilist([3, 4])).toIList(), ilist([3, 4]));
      });

      test('knownSize is sum when both sizes are known', () {
        final c = ivec([1, 2]).concat(ivec([3, 4, 5]));
        expect(c.knownSize, 5);
      });

      test('knownSize is -1 when first is unknown size', () {
        final c = ilist([1, 2]).concat(ivec([3, 4]));
        expect(c.knownSize, -1);
      });

      test('knownSize is -1 when second is unknown size', () {
        // All concrete collection concat overrides eagerly materialize, so
        // instantiate views.Concat directly to exercise the knownSize logic.
        // ivec knownSize=2 (known), ilist Cons knownSize=-1 (unknown).
        final c = views.Concat(ivec([1, 2]), ilist([3, 4]));
        expect(c.knownSize, -1);
      });

      test('isEmpty is false when first is non-empty', () {
        expect(ilist([1]).concat(nil<int>()).isEmpty, isFalse);
      });

      test('isEmpty is true when both are empty (known-size check)', () {
        expect(ivec(<int>[]).concat(ivec(<int>[])).isEmpty, isTrue);
      });
    });

    group('DistinctBy', () {
      test('removes duplicates by key', () {
        expect(
          ilist([1, 2, 3, 2, 1]).distinctBy((int n) => n),
          ilist([1, 2, 3]),
        );
      });

      test('distinct by modulo groups', () {
        // Keeps first element in each mod-2 class: 1 (odd), 2 (even)
        expect(
          ilist([1, 3, 2, 4]).distinctBy((int n) => n % 2),
          ilist([1, 2]),
        );
      });

      test('empty collection stays empty', () {
        expect(nil<int>().distinctBy((int n) => n), nil<int>());
      });
    });

    group('Drop', () {
      test('drops first n elements', () {
        expect(ilist([1, 2, 3, 4]).drop(2).toIList(), ilist([3, 4]));
      });

      test('dropping 0 returns all elements', () {
        expect(ilist([1, 2, 3]).drop(0).toIList(), ilist([1, 2, 3]));
      });

      test('dropping more than size returns empty', () {
        expect(ilist([1, 2]).drop(5).toIList(), nil<int>());
      });

      test('dropping exactly size returns empty', () {
        expect(ilist([1, 2, 3]).drop(3).toIList(), nil<int>());
      });

      test('knownSize is size - n when underlying size is known', () {
        expect(ivec([1, 2, 3, 4]).drop(2).knownSize, 2);
      });

      test('knownSize is 0 when n >= known size', () {
        expect(ivec([1, 2]).drop(5).knownSize, 0);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2, 3]).drop(1).knownSize, -1);
      });

      test('isEmpty is true when n >= known size', () {
        expect(ivec([1, 2]).drop(3).isEmpty, isTrue);
      });
    });

    group('DropRight', () {
      test('drops last n elements from known-size collection', () {
        expect(ivec([1, 2, 3, 4]).dropRight(2).toIList(), ilist([1, 2]));
      });

      test('drops last n elements from unknown-size collection (_DropRightIterator path)', () {
        expect(ilist([1, 2, 3, 4]).dropRight(2).toIList(), ilist([1, 2]));
      });

      test('dropping 0 returns all elements', () {
        expect(ilist([1, 2, 3]).dropRight(0).toIList(), ilist([1, 2, 3]));
      });

      test('dropping more than size returns empty', () {
        expect(ilist([1, 2]).dropRight(5).toIList(), nil<int>());
      });

      test('knownSize is size - n when underlying size is known', () {
        expect(ivec([1, 2, 3, 4]).dropRight(1).knownSize, 3);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2, 3]).dropRight(1).knownSize, -1);
      });

      test('_DropRightIterator: single element after dropping', () {
        expect(ilist([10, 20, 30]).dropRight(2).toIList(), ilist([10]));
      });

      test('_DropRightIterator: drop more than length gives empty', () {
        expect(ilist([1]).dropRight(2).toIList(), nil<int>());
      });
    });

    group('DropWhile', () {
      test('drops elements while predicate holds', () {
        expect(
          ilist([1, 2, 3, 4, 1]).dropWhile((int n) => n < 3).toIList(),
          ilist([3, 4, 1]),
        );
      });

      test('drops all when predicate always true', () {
        expect(ilist([1, 2, 3]).dropWhile((int n) => n > 0).toIList(), nil<int>());
      });

      test('drops nothing when predicate always false', () {
        expect(ilist([1, 2, 3]).dropWhile((int n) => n > 10).toIList(), ilist([1, 2, 3]));
      });

      test('knownSize is 0 when underlying is empty (nil has knownSize=0)', () {
        expect(nil<int>().dropWhile((int n) => n > 0).knownSize, 0);
      });

      test('knownSize is -1 for non-empty unknown-size underlying', () {
        expect(ilist([1, 2, 3]).dropWhile((int n) => n < 2).knownSize, -1);
      });
    });

    group('Filter', () {
      test('filter keeps matching elements', () {
        expect(
          ilist([1, 2, 3, 4, 5]).filter((int n) => n.isEven).toIList(),
          ilist([2, 4]),
        );
      });

      test('filterNot removes matching elements', () {
        expect(
          ilist([1, 2, 3, 4, 5]).filterNot((int n) => n.isEven).toIList(),
          ilist([1, 3, 5]),
        );
      });

      test('filter on empty returns empty', () {
        expect(nil<int>().filter((int n) => n > 0).toIList(), nil<int>());
      });

      test('knownSize is 0 when underlying is empty', () {
        expect(nil<int>().filter((int n) => n > 0).knownSize, 0);
      });

      test('knownSize is -1 for non-empty underlying (filter result size unknown)', () {
        expect(ilist([1, 2, 3]).filter((int n) => n > 1).knownSize, -1);
      });

      test('isEmpty is true when no elements match', () {
        expect(ilist([1, 2, 3]).filter((int n) => n > 10).isEmpty, isTrue);
      });
    });

    group('FlatMap', () {
      test('flatMaps each element to a collection', () {
        expect(
          ilist([1, 2, 3]).flatMap((int n) => ilist([n, n * 10])).toIList(),
          ilist([1, 10, 2, 20, 3, 30]),
        );
      });

      test('flatMap to empty for each element returns empty', () {
        expect(
          ilist([1, 2]).flatMap((int n) => nil<int>()).toIList(),
          nil<int>(),
        );
      });

      test('knownSize is 0 when underlying is empty', () {
        expect(nil<int>().flatMap((int n) => ilist([n])).knownSize, 0);
      });

      test('knownSize is -1 for non-empty underlying', () {
        expect(ilist([1, 2]).flatMap((int n) => ilist([n])).knownSize, -1);
      });
    });

    group('Map', () {
      test('transforms each element', () {
        expect(ilist([1, 2, 3]).map((int n) => n * 2).toIList(), ilist([2, 4, 6]));
      });

      test('map over empty is empty', () {
        expect(nil<int>().map((int n) => n * 2).toIList(), nil<int>());
      });

      test('knownSize mirrors underlying when size is known', () {
        expect(ivec([1, 2, 3]).map((int n) => n * 2).knownSize, 3);
      });

      test('knownSize mirrors underlying when size is unknown', () {
        expect(ilist([1, 2, 3]).map((int n) => n * 2).knownSize, -1);
      });

      test('knownSize is 0 for empty underlying', () {
        expect(nil<int>().map((int n) => n).knownSize, 0);
      });
    });

    group('PadTo', () {
      test('pads short list to target length', () {
        expect(ilist([1, 2]).padTo(5, 0), ilist([1, 2, 0, 0, 0]));
      });

      test('no padding when list is already at target length', () {
        expect(ilist([1, 2, 3]).padTo(3, 0), ilist([1, 2, 3]));
      });

      test('no padding when list is longer than target length', () {
        expect(ilist([1, 2, 3, 4]).padTo(2, 0), ilist([1, 2, 3, 4]));
      });

      test('knownSize is max(size, len) when underlying size is known', () {
        expect(ivec([1, 2]).padTo(5, 0).knownSize, 5);
      });

      test('knownSize is max(size, len) when len <= size (known)', () {
        expect(ivec([1, 2, 3]).padTo(2, 0).knownSize, 3);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2]).padTo(5, 0).knownSize, -1);
      });
    });

    group('Patched', () {
      test('replaces a slice with another collection', () {
        expect(
          ilist([1, 2, 3, 4, 5]).patch(1, ilist([20, 30]), 2),
          ilist([1, 20, 30, 4, 5]),
        );
      });

      test('patch at start', () {
        expect(
          ilist([1, 2, 3]).patch(0, ilist([10]), 1),
          ilist([10, 2, 3]),
        );
      });

      test('patch replaces with empty (deletion)', () {
        expect(
          ilist([1, 2, 3, 4]).patch(1, nil<int>(), 2),
          ilist([1, 4]),
        );
      });

      test('patch inserts without replacing', () {
        expect(
          ilist([1, 2, 3]).patch(1, ilist([10, 20]), 0),
          ilist([1, 10, 20, 2, 3]),
        );
      });

      test('knownSize is -1 for non-empty unknown-size input', () {
        expect(ilist([1, 2, 3]).patch(0, ilist([10]), 1).knownSize, -1);
      });
    });

    group('Appended', () {
      test('appends an element to the end', () {
        expect(ilist([1, 2, 3]).appended(4), ilist([1, 2, 3, 4]));
      });

      test('appends to empty list', () {
        expect(nil<int>().appended(1), ilist([1]));
      });
    });

    group('Prepended', () {
      test('prepends an element to the front', () {
        expect(ilist([2, 3, 4]).prepended(1), ilist([1, 2, 3, 4]));
      });

      test('prepends to empty list', () {
        expect(nil<int>().prepended(1), ilist([1]));
      });
    });

    group('ScanLeft', () {
      test('yields prefix sums starting from z', () {
        expect(
          ilist([1, 2, 3]).scanLeft(0, (int acc, int n) => acc + n).toIList(),
          ilist([0, 1, 3, 6]),
        );
      });

      test('scanLeft on empty yields only initial value', () {
        expect(
          nil<int>().scanLeft(42, (int acc, int n) => acc + n).toIList(),
          ilist([42]),
        );
      });

      test('knownSize is size + 1 when underlying size is known', () {
        expect(ivec([1, 2, 3]).scanLeft(0, (int a, int b) => a + b).knownSize, 4);
      });

      test('knownSize is size + 1 for empty (knownSize=0 + 1 = 1)', () {
        // IList/IVector.scanLeft eagerly materializes. Range.map returns a
        // views.Map; calling scanLeft on it uses View.scanLeft → views.ScanLeft.
        final emptyView = Range.exclusive(0, 0).map((int n) => n); // views.Map, knownSize=0
        expect(emptyView.scanLeft(0, (int a, int b) => a + b).knownSize, 1);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2]).scanLeft(0, (int a, int b) => a + b).knownSize, -1);
      });
    });

    group('Take', () {
      test('takes first n elements', () {
        expect(ilist([1, 2, 3, 4]).take(2).toIList(), ilist([1, 2]));
      });

      test('taking 0 returns empty', () {
        expect(ilist([1, 2, 3]).take(0).toIList(), nil<int>());
      });

      test('taking more than size returns all', () {
        expect(ilist([1, 2]).take(10).toIList(), ilist([1, 2]));
      });

      test('knownSize is min(size, n) when underlying size is known', () {
        expect(ivec([1, 2, 3, 4]).take(2).knownSize, 2);
      });

      test('knownSize is size when n >= size (known)', () {
        expect(ivec([1, 2]).take(10).knownSize, 2);
      });

      test('knownSize is 0 when n=0 (known underlying)', () {
        expect(ivec([1, 2, 3]).take(0).knownSize, 0);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2, 3]).take(2).knownSize, -1);
      });

      test('isEmpty is true when taking 0', () {
        expect(ivec([1, 2]).take(0).isEmpty, isTrue);
      });
    });

    group('TakeRight', () {
      test('takes last n elements from known-size collection', () {
        expect(ivec([1, 2, 3, 4]).takeRight(2).toIList(), ilist([3, 4]));
      });

      test('takes last n elements from unknown-size collection (_TakeRightIterator path)', () {
        expect(ilist([1, 2, 3, 4]).takeRight(2).toIList(), ilist([3, 4]));
      });

      test('taking 0 returns empty', () {
        expect(ilist([1, 2, 3]).takeRight(0).toIList(), nil<int>());
      });

      test('taking more than size returns all', () {
        expect(ilist([1, 2]).takeRight(10).toIList(), ilist([1, 2]));
      });

      test('knownSize is min(size, n) when underlying size is known', () {
        expect(ivec([1, 2, 3, 4]).takeRight(2).knownSize, 2);
      });

      test('knownSize is -1 when underlying size is unknown', () {
        expect(ilist([1, 2, 3]).takeRight(2).knownSize, -1);
      });

      test('_TakeRightIterator: single element', () {
        expect(ilist([10, 20, 30]).takeRight(1).toIList(), ilist([30]));
      });

      test('_TakeRightIterator: all elements when n >= size', () {
        expect(ilist([1, 2]).takeRight(5).toIList(), ilist([1, 2]));
      });
    });

    group('TakeWhile', () {
      test('takes elements while predicate holds', () {
        expect(
          ilist([1, 2, 3, 4, 1]).takeWhile((int n) => n < 3).toIList(),
          ilist([1, 2]),
        );
      });

      test('takes all when predicate always true', () {
        expect(
          ilist([1, 2, 3]).takeWhile((int n) => n > 0).toIList(),
          ilist([1, 2, 3]),
        );
      });

      test('takes none when predicate immediately false', () {
        expect(
          ilist([1, 2, 3]).takeWhile((int n) => n > 10).toIList(),
          nil<int>(),
        );
      });

      test('knownSize is 0 when underlying is empty (nil has knownSize=0)', () {
        expect(nil<int>().takeWhile((int n) => n > 0).knownSize, 0);
      });

      test('knownSize is -1 for non-empty unknown-size underlying', () {
        expect(ilist([1, 2, 3]).takeWhile((int n) => n < 3).knownSize, -1);
      });
    });

    group('Zip', () {
      test('zips two collections element-by-element', () {
        expect(
          ilist([1, 2, 3]).zip(ilist(['a', 'b', 'c'])).toIList(),
          ilist([(1, 'a'), (2, 'b'), (3, 'c')]),
        );
      });

      test('result length is the shorter of the two', () {
        expect(
          ilist([1, 2, 3]).zip(ilist(['a', 'b'])).toIList(),
          ilist([(1, 'a'), (2, 'b')]),
        );
      });

      test('knownSize is min(both) when both sizes are known', () {
        expect(ivec([1, 2, 3]).zip(ivec(['a', 'b'])).knownSize, 2);
      });

      test('knownSize is 0 when first is empty (known)', () {
        expect(ivec(<int>[]).zip(ivec([1, 2])).knownSize, 0);
      });

      test('knownSize is 0 when second is empty (known)', () {
        expect(ivec([1, 2]).zip(ivec(<int>[])).knownSize, 0);
      });

      test('knownSize is -1 when first size is unknown', () {
        expect(ilist([1, 2]).zip(ivec([3, 4])).knownSize, -1);
      });
    });

    group('ZipAll', () {
      test('zips two same-length collections', () {
        expect(
          ilist([1, 2]).zipAll(ilist([10, 20]), 0, 0).toIList(),
          ilist([(1, 10), (2, 20)]),
        );
      });

      test('pads shorter left with thisElem', () {
        expect(
          ilist([1]).zipAll(ilist([10, 20, 30]), 0, 0).toIList(),
          ilist([(1, 10), (0, 20), (0, 30)]),
        );
      });

      test('pads shorter right with thatElem', () {
        expect(
          ilist([1, 2, 3]).zipAll(ilist([10]), 0, 99).toIList(),
          ilist([(1, 10), (2, 99), (3, 99)]),
        );
      });

      test('knownSize is max(both) when both sizes are known', () {
        expect(ivec([1, 2, 3]).zipAll(ivec([10, 20]), 0, 0).knownSize, 3);
      });

      test('knownSize is -1 when first size is unknown', () {
        expect(ilist([1, 2]).zipAll(ivec([3, 4]), 0, 0).knownSize, -1);
      });

      test('knownSize is -1 when second size is unknown', () {
        // All concrete collection zipAll overrides eagerly materialize, so
        // instantiate views.ZipAll directly to exercise the knownSize logic.
        // ivec knownSize=2 (known), ilist Cons knownSize=-1 (unknown).
        final za = views.ZipAll(ivec([1, 2]), ilist([3, 4, 5]), 0, 0);
        expect(za.knownSize, -1);
      });
    });

    group('ZipWithIndex', () {
      test('pairs each element with its 0-based index', () {
        expect(
          ilist(['a', 'b', 'c']).zipWithIndex().toIList(),
          ilist([('a', 0), ('b', 1), ('c', 2)]),
        );
      });

      test('empty collection gives empty result', () {
        expect(nil<String>().zipWithIndex().toIList(), nil<(String, int)>());
      });

      test('knownSize mirrors underlying when size is known', () {
        expect(ivec([1, 2, 3]).zipWithIndex().knownSize, 3);
      });

      test('knownSize mirrors underlying when size is unknown', () {
        expect(ilist([1, 2, 3]).zipWithIndex().knownSize, -1);
      });

      test('knownSize is 0 for empty underlying', () {
        expect(nil<int>().zipWithIndex().knownSize, 0);
      });
    });
  });
}
