import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  test('JsonTransformer.unwrapArray (bytes)', () async {
    final stream = File('test_resources/streaming/large-array.json')
        .openRead()
        .transform(JsonTransformer.bytes(AsyncParserMode.unwrapArray));

    int count = 0;

    await for (final _ in stream) {
      count += 1;
    }

    expect(count, 200);
  });

  test('JsonTransformer.unwrapArray (string)', () async {
    final stream = File('test_resources/streaming/large-array.json')
        .openRead()
        .map(utf8.decode)
        .transform(JsonTransformer.strings(AsyncParserMode.unwrapArray));

    int count = 0;

    await for (final _ in stream) {
      count += 1;
    }

    expect(count, 200);
  });

  test('JsonTransformer.valueStream (bytes)', () async {
    final stream = File('test_resources/streaming/line-delimited.json')
        .openRead()
        .transform(JsonTransformer.bytes(AsyncParserMode.valueStream));

    int count = 0;

    await for (final _ in stream) {
      count += 1;
    }

    expect(count, 9);
  });

  test('JsonTransformer.valueStream (strings)', () async {
    final stream = File('test_resources/streaming/line-delimited.json')
        .openRead()
        .map(utf8.decode)
        .transform(JsonTransformer.strings(AsyncParserMode.valueStream));

    int count = 0;

    await for (final _ in stream) {
      count += 1;
    }

    expect(count, 9);
  });

  group('JsonTransformer.singleValue (bytes):', () {
    ilist(Directory('test_resources').listSync())
        .sortWith((a, b) => basename(a.path).compareTo(basename(b.path)) < 0)
        .map((f) => File(f.path))
        .forEach((fileEntity) {
      final fileName = basename(fileEntity.path);

      final desc = fileName.replaceAll('.json', '');
      final bytes = File(fileEntity.path)
          .openRead()
          .transform(JsonTransformer.bytes(AsyncParserMode.singleValue));

      test(desc, () async {
        if (fileName.startsWith('y_')) {
          final res = await bytes.last;
          expect(res, isA<Json>());
        } else if (fileName.startsWith('n_')) {
          try {
            final res = await bytes.last;
            fail('FAIL: $desc should not succeed: $res');
          } catch (e) {
            expect(e, anyOf([isException, isStateError]));
          }
        } else if (fileName.startsWith('i_')) {
          try {
            final res = await bytes.last;
            expect(res, isA<Json>());
          } catch (e) {
            expect(e, anyOf([isException, isStateError]));
          }
        }
      });
    });
  });

  group('JsonTransformer.singleValue (strings):', () {
    ilist(Directory('test_resources').listSync())
        .sortWith((a, b) => basename(a.path).compareTo(basename(b.path)) < 0)
        .map((f) => File(f.path))
        .forEach((fileEntity) {
      final fileName = basename(fileEntity.path);

      final desc = fileName.replaceAll('.json', '');
      final bytes = File(fileEntity.path)
          .openRead()
          .map(utf8.decode)
          .transform(JsonTransformer.strings(AsyncParserMode.singleValue));

      test(desc, () async {
        if (fileName.startsWith('y_')) {
          final res = await bytes.last;
          expect(res, isA<Json>());
        } else if (fileName.startsWith('n_')) {
          try {
            final res = await bytes.last;
            fail('FAIL: $desc should not succeed: $res');
          } catch (e) {
            expect(e, anyOf([isException, isStateError]));
          }
        } else if (fileName.startsWith('i_')) {
          try {
            final res = await bytes.last;
            expect(res, isA<Json>());
          } catch (e) {
            expect(e, anyOf([isException, isStateError]));
          }
        }
      });
    });
  });
}
