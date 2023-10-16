import 'package:ribs_http/src/ci_string.dart';
import 'package:test/test.dart';

void main() {
  test('equality', () {
    expect(
      const CIString('Set-Cookie') == const CIString('set-cookie'),
      isTrue,
    );
  });
}
