import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // DownFieldDecoder
  //
  // decodeC (via decoder.decode(json)) is already exercised in decoder_test.dart.
  // These tests target the uncovered tryDecodeC path, reached via
  // cursor.decode(decoder.at('key')), which calls decoder.tryDecodeC(cursor).
  // ---------------------------------------------------------------------------
  group('DownFieldDecoder.tryDecodeC', () {
    // HCursor wrapping a JObject that contains the key — fast path (lines 21-25).
    test('HCursor on JObject with key present returns value', () {
      final json = Json.obj([('x', Json.number(42))]);
      final result = HCursor.fromJson(json).decode(Decoder.integer.at('x'));
      expect(result, const Right<DecodingFailure, int>(42));
    });

    // HCursor wrapping a JObject that does not contain the key — skips fast
    // path and falls to the tryDecodeC(cursor.downField(key)) fallback.
    test('HCursor on JObject with key absent returns Left', () {
      final json = Json.obj([('x', Json.number(1))]);
      final result = HCursor.fromJson(json).decode(Decoder.integer.at('missing'));
      expect(result.isLeft, isTrue);
    });

    // HCursor wrapping a non-JObject — cursor is HCursor but json is not JObject,
    // so skips the JObject branch entirely and falls to the fallback.
    test('HCursor on non-JObject returns Left', () {
      final result = HCursor.fromJson(Json.number(99)).decode(Decoder.integer.at('x'));
      expect(result.isLeft, isTrue);
    });

    // FailedCursor — cursor is not an HCursor, skips the HCursor branch, falls
    // straight to tryDecodeC(cursor.downField(key)).
    test('FailedCursor returns Left', () {
      final failed = HCursor.fromJson(Json.obj([('a', Json.True)])).downField('missing');
      expect(failed.failed, isTrue);
      final result = failed.decode(Decoder.integer.at('x'));
      expect(result.isLeft, isTrue);
    });

    // Confirm that the tryDecodeC fast path actually decodes the correct value
    // when accessed through a nested cursor.
    test('correct value decoded when accessed via nested HCursor', () {
      final json = Json.obj([
        ('outer', Json.obj([('inner', Json.str('hello'))])),
      ]);
      final result = HCursor.fromJson(json)
          .downField('outer')
          .decode(
            Decoder.string.at('inner'),
          );
      expect(result, const Right<DecodingFailure, String>('hello'));
    });
  });

  // ---------------------------------------------------------------------------
  // EmapDecoder
  //
  // The decode(Json) override is partially covered (success path). Missing:
  //   - decode failure branch (line 15): inner aDecoder fails
  //
  // decodeC and tryDecodeC are entirely uncovered:
  //   - decodeC is reached when FlatMapDecoder.decodeC calls decodeA.decodeC()
  //     on an emap decoder (since FlatMapDecoder.decodeC calls decodeC, not decode).
  //   - tryDecodeC is reached via cursor.decode(emapDecoder).
  // ---------------------------------------------------------------------------
  group('EmapDecoder', () {
    group('decode (Json) — failure branch', () {
      // When the underlying aDecoder fails, the fold takes the Left branch.
      test('inner decoder failure propagates as Left', () {
        final dec = Decoder.integer.emap((i) => Right<String, String>(i.toString()));
        // integer decoder cannot decode a string → aDecoder.decode returns Left.
        expect(dec.decode(Json.str('not-a-number')).isLeft, isTrue);
      });
    });

    group('decode (Json) — f returns Left', () {
      test('Left from f propagates as Left', () {
        final dec = Decoder.integer.emap((i) => Left<String, String>('rejected $i'));
        expect(dec.decode(Json.number(5)).isLeft, isTrue);
      });
    });

    group('decodeC — reached via FlatMapDecoder.decodeC', () {
      // FlatMapDecoder.decodeC calls decodeA.decodeC(cursor). Wrapping an emap
      // decoder as the first step of a flatMap forces that path.
      test('success: correct value decoded', () {
        final dec = Decoder.string
            .emap((s) => Right<String, int>(s.length))
            .flatMap((len) => Decoder.constant(len * 2));
        expect(dec.decode(Json.str('hi')), const Right<DecodingFailure, int>(4));
      });

      test('inner aDecoder failure propagates', () {
        final dec = Decoder.integer
            .emap((i) => Right<String, int>(i))
            .flatMap((i) => Decoder.constant(i));
        // string cannot be decoded as integer → decodeC path fails
        expect(dec.decode(Json.str('oops')).isLeft, isTrue);
      });

      test('f returns Left propagates', () {
        final dec = Decoder.integer
            .emap((i) => Left<String, int>('bad $i'))
            .flatMap((i) => Decoder.constant(i));
        expect(dec.decode(Json.number(7)).isLeft, isTrue);
      });
    });

    group('tryDecodeC — reached via cursor.decode(emapDecoder)', () {
      // cursor.decode(decoder) calls decoder.tryDecodeC(cursor).
      test('HCursor success: correct value decoded', () {
        final dec = Decoder.string.emap((s) => Right<String, int>(s.length));
        final result = HCursor.fromJson(Json.str('hello')).decode(dec);
        expect(result, const Right<DecodingFailure, int>(5));
      });

      test('HCursor: inner aDecoder failure propagates', () {
        final dec = Decoder.integer.emap((i) => Right<String, int>(i));
        final result = HCursor.fromJson(Json.str('boom')).decode(dec);
        expect(result.isLeft, isTrue);
      });

      test('HCursor: f returns Left propagates', () {
        final dec = Decoder.integer.emap((_) => const Left<String, int>('no'));
        final result = HCursor.fromJson(Json.number(1)).decode(dec);
        expect(result.isLeft, isTrue);
      });

      test('FailedCursor: aDecoder.tryDecodeC receives failed cursor', () {
        final dec = Decoder.integer.emap((i) => Right<String, int>(i));
        final failed = HCursor.fromJson(Json.obj([])).downField('missing');
        expect(failed.failed, isTrue);
        final result = failed.decode(dec);
        expect(result.isLeft, isTrue);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // FlatMapDecoder
  //
  // decodeC is already exercised in decoder_test.dart via decoder.decode(json).
  // tryDecodeC is entirely uncovered; reached via cursor.decode(flatMapDecoder).
  // ---------------------------------------------------------------------------
  group('FlatMapDecoder.tryDecodeC', () {
    // HCursor, aDecoder succeeds, chained decoder succeeds.
    test('HCursor success: chained value decoded', () {
      final dec = Decoder.integer.flatMap(
        (i) => i.isEven ? Decoder.constant('even') : Decoder.constant('odd'),
      );
      expect(
        HCursor.fromJson(Json.number(4)).decode(dec),
        const Right<DecodingFailure, String>('even'),
      );
      expect(
        HCursor.fromJson(Json.number(3)).decode(dec),
        const Right<DecodingFailure, String>('odd'),
      );
    });

    // HCursor, aDecoder fails — the fold's Left branch is taken, chained
    // decoder is never called.
    test('HCursor: aDecoder failure propagates', () {
      final dec = Decoder.integer.flatMap((i) => Decoder.constant(i));
      final result = HCursor.fromJson(Json.str('nope')).decode(dec);
      expect(result.isLeft, isTrue);
    });

    // FailedCursor — aDecoder.tryDecodeC(failedCursor) fails, Left propagates.
    test('FailedCursor: failure propagates', () {
      final dec = Decoder.integer.flatMap((i) => Decoder.constant(i));
      final failed = HCursor.fromJson(Json.obj([])).downField('missing');
      expect(failed.failed, isTrue);
      final result = failed.decode(dec);
      expect(result.isLeft, isTrue);
    });

    // Chained decoder also called via tryDecodeC (not decodeC).
    test('chained decoder receives the same cursor', () {
      // Both steps see the same json: the chained decoder re-decodes the root.
      final dec = Decoder.integer.flatMap(
        (i) => Decoder.instance((c) => (i * 10).asRight()),
      );
      expect(
        HCursor.fromJson(Json.number(3)).decode(dec),
        const Right<DecodingFailure, int>(30),
      );
    });
  });
}
