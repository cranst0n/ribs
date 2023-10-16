import 'package:ribs_core/ribs_core.dart';

final class UrlForm {
  final IMap<String, IList<String>> values;

  const UrlForm(this.values);

  const UrlForm.empty() : values = const IMap.empty();

  UrlForm.single(String key, String value)
      : values = IMap.fromIterable([
          (key, ilist([value])),
        ]);

  UrlForm operator +((String, String) kv) => add(kv.$1, kv.$2);

  UrlForm add(String key, String value) => UrlForm(
        values.updatedWith(
          key,
          (values) => Some(values.fold(
            () => ilist([value]),
            (existing) => existing.append(value),
          )),
        ),
      );

  static String encodeString(UrlForm urlForm) {
    String encode(String s) => Uri.encodeQueryComponent(s);

    final sb = StringBuffer();

    urlForm.values.forEach((k, vs) {
      if (sb.isNotEmpty) sb.write('&');

      final encodedKey = encode(k);

      if (vs.isEmpty) {
        sb.write(encodedKey);
      } else {
        var first = true;
        vs.forEach((v) {
          if (!first) {
            sb.write('&');
          } else {
            first = false;
          }

          sb
            ..write(encodedKey)
            ..write('=')
            ..write(encode(v));
        });
      }
    });

    return sb.toString();
  }
}
