import 'package:ribs_http/ribs_http.dart';

class ClientLogger {
  static Client create(
    Client client, {
    bool logRequests = true,
    bool logResponses = true,
  }) {
    final reqLogged = logRequests ? RequestLogger.create(client) : client;
    final resLogged =
        logResponses ? ResponseLogger.create(reqLogged) : reqLogged;

    return resLogged;
  }
}
