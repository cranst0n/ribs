import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';

class Backpressured {
  static IO<Client> create(Client client, int bound) =>
      Semaphore.permits(bound).map((sem) => Client.create(
          (request) => sem.permit().flatMap((_) => client.run(request))));
}
