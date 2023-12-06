import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  group('StringBasedParser', () {
    test('complex string', () {
      const str =
          '''{"status": "1", "message":"", "\\foutput":"<div class=\\"c1\\"><div class=\\"c2\\">User \\/ generated text \\u2639, \\tso \\r\\ncan be\\b anything</div></div>"}''';

      expect(Json.parse(str).isRight, isTrue);
    });
  });
}
