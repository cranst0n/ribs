import 'dart:io';

import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

class GZip {
  static Client create(Client client) =>
      Client.create((request) => client.run(request).evalMap((response) {
            if (response.headers
                .find(Header.contentEncoding(ContentCoding.gzip))
                .isDefined) {
              return IO
                  .fromFutureF(() => response.body.fold(
                      List<int>.empty(growable: true),
                      (acc, elem) => acc..addAll(elem)))
                  .map(gzip.decode)
                  .map((bytes) =>
                      response.withBody(EntityBody(Stream.value(bytes))));
            } else {
              return IO.pure(response);
            }
          }));
}
