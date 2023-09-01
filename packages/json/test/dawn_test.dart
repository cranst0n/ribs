import 'dart:io';

import 'package:path/path.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart';
import 'package:test/test.dart';

void main() {
  final dir = Directory('test_resources');

  _testGroup('Success', dir, 'y_', (res) => expect(res.isRight, isTrue));
  _testGroup('Failure', dir, 'n_', (res) => expect(res.isLeft, isTrue));
  _testGroup('Success or Failure', dir, 'i_', (_) => expect(true, isTrue));
}

void _testGroup(
  String description,
  Directory dir,
  String prefix,
  Function1<Either<ParsingFailure, Json>, void> f,
) {
  group('Expected $description', () {
    ilist(dir.listSync())
        .filter((f) => basename(f.path).startsWith(prefix))
        .sortWith((a, b) => basename(a.path).compareTo(basename(b.path)) < 0)
        .map((f) => File(f.path))
        .forEach((fileEntity) {
      final desc = basename(fileEntity.path).replaceAll('.json', '');
      final bytes = File(fileEntity.path).readAsBytesSync();

      test(desc, () {
        f(Parser.parseFromBytes(bytes));
      });
    });
  });
}
