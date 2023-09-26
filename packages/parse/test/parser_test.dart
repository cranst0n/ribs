import 'package:ribs_parse/ribs_parse.dart';
import 'package:test/test.dart';

void main() {
  test('anyChar', () {
    final a = String.fromCharCode(0);
    final b = String.fromCharCode(65535);

    print('a: $a');
    print('b: $b');

    final result = Parser.anyChar.parse('5');

    print('result: $result');
  });
}
