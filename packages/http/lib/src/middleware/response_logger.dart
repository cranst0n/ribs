import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

class ResponseLogger {
  static Client create(Client client) =>
      Client.create((request) => client.run(request).evalTap(
          (response) => IO.println('[${DateTime.timestamp()}]: $response')));
}
