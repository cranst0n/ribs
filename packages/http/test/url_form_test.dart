import 'package:ribs_http/src/url_form.dart';
import 'package:test/test.dart';

void main() {
  test('encode', () {
    final f = UrlForm.single('key1', 'value1').add('key2', 'value2').add('key1', 'valueX') +
        ('key3', 'value3');

    expect(
      UrlForm.encodeString(f),
      'key1=value1&key1=valueX&key2=value2&key3=value3',
    );
  });
}
