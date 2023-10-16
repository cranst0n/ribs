import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class ResponseLogger {
  static Client create(Client client) =>
      Client.create((request) => client.run(request).evalTap(
          (response) => IO.println('[${DateTime.timestamp()}]: $response')));
}
