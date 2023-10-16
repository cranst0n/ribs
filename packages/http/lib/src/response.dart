import 'package:ribs_http/ribs_http.dart';

final class Response extends Message {
  final Status status;

  const Response({
    this.status = Status.Ok,
    super.version,
    super.headers,
    super.body,
  });

  Response copy({
    Status? status,
    HttpVersion? version,
    Headers? headers,
    EntityBody? body,
  }) =>
      Response(
        status: status ?? this.status,
        version: version ?? this.version,
        headers: headers ?? this.headers,
        body: body ?? this.body,
      );

  Response withBody(EntityBody body) => copy(body: body);

  @override
  String toString() =>
      'Response(status=$status, version=$version, headers=${headers.redactSensitive()})';
}
