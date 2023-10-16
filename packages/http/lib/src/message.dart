import 'package:ribs_http/ribs_http.dart';

abstract class Message extends Media {
  final HttpVersion version;

  const Message({
    super.body,
    super.headers,
    this.version = HttpVersion.Http1_1,
  });
}
