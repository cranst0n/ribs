import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  group('Decoder', () {
    test('flatMap', () {
      final evenDecoder = Decoder.integer.flatMap(
        (i) => i.isEven ? Decoder.constant(i) : Decoder.constant(i * 2),
      );

      expect(evenDecoder.decode(Json.number(2)), 2.asRight<DecodingFailure>());
      expect(evenDecoder.decode(Json.number(3)), 6.asRight<DecodingFailure>());
    });

    test('handleError', () {
      final d = Decoder.instance<int>(
        (c) => DecodingFailure(CustomReason('boom'), c.history()).asLeft(),
      ).handleErrorWith((_) => Decoder.constant(42));

      expect(d.decode(Json.False), 42.asRight<DecodingFailure>());
      expect(d.decode(Json.Null), 42.asRight<DecodingFailure>());
      expect(d.decode(Json.str('boo')), 42.asRight<DecodingFailure>());
      expect(d.decode(Json.number(1)), 42.asRight<DecodingFailure>());
    });

    test('list', () {
      final d = Decoder.list(Decoder.integer);

      expect(
        d.decode(Json.arr([Json.number(0)])).map((a) => a.toIList()),
        ilist([0]).asRight<DecodingFailure>(),
      );

      expect(
        d.decode(Json.True),
        isLeft<DecodingFailure, List<int>>(),
      );
    });

    test('or', () {
      final one = Json.str('one');
      final two = Json.str('two');
      final three = Json.str('three');

      final a = Decoder.string.ensure((s) => s == 'one', () => 'Not one');
      final b = Decoder.string.ensure((s) => s == 'two', () => 'Not two');
      final c = a.or(b);

      expect(a.decode(one), 'one'.asRight<DecodingFailure>());
      expect(b.decode(one), isLeft<DecodingFailure, String>());
      expect(c.decode(one), 'one'.asRight<DecodingFailure>());

      expect(a.decode(two), isLeft<DecodingFailure, String>());
      expect(b.decode(two), 'two'.asRight<DecodingFailure>());
      expect(c.decode(two), 'two'.asRight<DecodingFailure>());

      expect(a.decode(three), isLeft<DecodingFailure, String>());
      expect(b.decode(three), isLeft<DecodingFailure, String>());
      expect(c.decode(three), isLeft<DecodingFailure, String>());
    });

    test('prepared', () {
      final d = Decoder.integer.prepare((a) => a.downField('key'));
      final json = Json.obj([('key', Json.number(42))]);

      expect(d.decode(json), 42.asRight<DecodingFailure>());
    });

    test('product2', () {
      final json = boolObj(2);

      final decoder = Decoder.product2(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        (a, b) => (a, b),
      );

      expect(decoder.decode(json), (true, false).asRight<DecodingFailure>());
    });

    test('product3', () {
      final json = boolObj(3);

      final decoder = Decoder.product3(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        (a, b, c) => (a, b, c),
      );

      expect(decoder.decode(json), (true, false, true).asRight<DecodingFailure>());
    });

    test('product4', () {
      final json = boolObj(4);

      final decoder = Decoder.product4(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        (a, b, c, d) => (a, b, c, d),
      );

      expect(decoder.decode(json), (true, false, true, false).asRight<DecodingFailure>());
    });

    test('product5', () {
      final json = boolObj(5);

      final decoder = Decoder.product5(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        (a, b, c, d, e) => (a, b, c, d, e),
      );

      expect(decoder.decode(json), (true, false, true, false, true).asRight<DecodingFailure>());
    });

    test('product6', () {
      final json = boolObj(6);

      final decoder = Decoder.product6(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        (a, b, c, d, e, f) => (a, b, c, d, e, f),
      );

      expect(
        decoder.decode(json),
        (true, false, true, false, true, false).asRight<DecodingFailure>(),
      );
    });

    test('product7', () {
      final json = boolObj(7);

      final decoder = Decoder.product7(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        (a, b, c, d, e, f, g) => (a, b, c, d, e, f, g),
      );

      expect(
        decoder.decode(json),
        (true, false, true, false, true, false, true).asRight<DecodingFailure>(),
      );
    });

    test('product8', () {
      final json = boolObj(8);

      final decoder = Decoder.product8(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        (a, b, c, d, e, f, g, h) => (a, b, c, d, e, f, g, h),
      );

      expect(
        decoder.decode(json),
        (true, false, true, false, true, false, true, false).asRight<DecodingFailure>(),
      );
    });

    test('product9', () {
      final json = boolObj(9);

      final decoder = Decoder.product9(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        (a, b, c, d, e, f, g, h, i) => (a, b, c, d, e, f, g, h, i),
      );

      expect(
        decoder.decode(json),
        (true, false, true, false, true, false, true, false, true).asRight<DecodingFailure>(),
      );
    });

    test('product10', () {
      final json = boolObj(10);

      final decoder = Decoder.product10(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        (a, b, c, d, e, f, g, h, i, j) => (a, b, c, d, e, f, g, h, i, j),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
        ).asRight<DecodingFailure>(),
      );
    });

    test('product11', () {
      final json = boolObj(11);

      final decoder = Decoder.product11(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        Decoder.boolean.at('key11'),
        (a, b, c, d, e, f, g, h, i, j, k) => (a, b, c, d, e, f, g, h, i, j, k),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
        ).asRight<DecodingFailure>(),
      );
    });

    test('product12', () {
      final json = boolObj(12);

      final decoder = Decoder.product12(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        Decoder.boolean.at('key11'),
        Decoder.boolean.at('key12'),
        (a, b, c, d, e, f, g, h, i, j, k, l) => (a, b, c, d, e, f, g, h, i, j, k, l),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
        ).asRight<DecodingFailure>(),
      );
    });

    test('product13', () {
      final json = boolObj(13);

      final decoder = Decoder.product13(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        Decoder.boolean.at('key11'),
        Decoder.boolean.at('key12'),
        Decoder.boolean.at('key13'),
        (a, b, c, d, e, f, g, h, i, j, k, l, m) => (a, b, c, d, e, f, g, h, i, j, k, l, m),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
        ).asRight<DecodingFailure>(),
      );
    });

    test('product14', () {
      final json = boolObj(14);

      final decoder = Decoder.product14(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        Decoder.boolean.at('key11'),
        Decoder.boolean.at('key12'),
        Decoder.boolean.at('key13'),
        Decoder.boolean.at('key14'),
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n) => (a, b, c, d, e, f, g, h, i, j, k, l, m, n),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
        ).asRight<DecodingFailure>(),
      );
    });

    test('product15', () {
      final json = boolObj(15);

      final decoder = Decoder.product15(
        Decoder.boolean.at('key1'),
        Decoder.boolean.at('key2'),
        Decoder.boolean.at('key3'),
        Decoder.boolean.at('key4'),
        Decoder.boolean.at('key5'),
        Decoder.boolean.at('key6'),
        Decoder.boolean.at('key7'),
        Decoder.boolean.at('key8'),
        Decoder.boolean.at('key9'),
        Decoder.boolean.at('key10'),
        Decoder.boolean.at('key11'),
        Decoder.boolean.at('key12'),
        Decoder.boolean.at('key13'),
        Decoder.boolean.at('key14'),
        Decoder.boolean.at('key15'),
        (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) => (
          a,
          b,
          c,
          d,
          e,
          f,
          g,
          h,
          i,
          j,
          k,
          l,
          m,
          n,
          o,
        ),
      );

      expect(
        decoder.decode(json),
        (
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
          false,
          true,
        ).asRight<DecodingFailure>(),
      );
    });
  });
}

Json boolObj(int n) =>
    Json.obj(IList.rangeTo(1, n).map((i) => ('key$i', Json.boolean(i.isOdd))).toList());
