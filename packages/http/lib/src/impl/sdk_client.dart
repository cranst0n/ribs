import 'dart:io';

import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

class SdkClient {
  static Resource<Client> create() => Resource.make(
        IO.delay(() => HttpClient()),
        (client) => IO.exec(client.close),
      ).map(
        (client) => Client.create(
          (req) => Resource.eval(_convertRequest(client, req)
              .flatMap((req) => IO.fromFutureF(req.close))
              .flatMap(_convertResponse)),
        ),
      );

  static Client unsafeCreate() {
    final client = HttpClient();
    return Client.create(
      (req) => Resource.eval(_convertRequest(client, req)
          .flatMap((req) => IO.fromFutureF(req.close))
          .flatMap(_convertResponse)),
    );
  }

  static Headers _convertHeaders(HttpHeaders headers) {
    final raw = List<Header>.empty(growable: true);

    headers.forEach((name, values) =>
        values.forEach((value) => raw.add(Header(CIString(name), value))));

    return Headers(raw);
  }

  static IO<HttpClientRequest> _convertRequest(
    HttpClient client,
    Request req,
  ) =>
      IO
          .fromFutureF(() => client.openUrl(req.method.name, req.uri))
          .flatTap((r) => IO.exec(() => req.headers
              .concat(req.body.headers)
              .headers
              .foreach((hdr) => r.headers.add(hdr.name.value, hdr.value))))
          .flatTap((a) => IO.exec(() => req.body.bodyLength
              .foreach((len) => a.headers.add('Content-Length', len))))
          .flatTap((a) => IO.fromFutureF(() => a.addStream(req.body)))
          .flatMap((req) => IO.pure(req).onCancel(IO.exec(req.abort)));

  static IO<Response> _convertResponse(HttpClientResponse resp) =>
      IO.fromEither(Status.fromInt(resp.statusCode)).map((status) => Response(
            status: status,
            headers: _convertHeaders(resp.headers),
            body: EntityBody(resp),
          ));
}
