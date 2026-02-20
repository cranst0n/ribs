import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

class RequestLogger {
  static Client create(Client client) => Client.create(
    (request) => client.run(request).preAllocate(IO.print('[${DateTime.timestamp()}]: $request')),
  );
}
