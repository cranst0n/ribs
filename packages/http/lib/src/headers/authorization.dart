import 'package:ribs_http/ribs_http.dart';

class Authorization {
  static const name = CIString('Authorization');

  static final Authorization _singleton = Authorization._();

  factory Authorization() => _singleton;

  Authorization._();

  Header basic(BasicCredentials credentials) =>
      Header(name, Credentials.token(AuthScheme.basic, credentials.token()).toString());

  Header bearer(String token) =>
      Header(name, Credentials.token(AuthScheme.bearer, token).toString());
}
