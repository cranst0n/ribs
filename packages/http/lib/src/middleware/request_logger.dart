import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

class RequestLogger {
  static Client create(Client client) => Client.create((request) => client
      .run(request)
      .preAllocate(IO.println('[${DateTime.timestamp()}]: $request')));
}
