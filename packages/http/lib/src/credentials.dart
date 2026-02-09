import 'dart:convert';

import 'package:ribs_http/ribs_http.dart';

enum AuthScheme {
  basic(CIString('Basic')),
  bearer(CIString('Bearer'));

  final CIString value;

  const AuthScheme(this.value);
}

sealed class Credentials {
  AuthScheme get authScheme;

  const Credentials();

  static Credentials token(AuthScheme authScheme, String token) => _Token(authScheme, token);
}

final class _Token extends Credentials {
  @override
  final AuthScheme authScheme;

  final String token;

  const _Token(this.authScheme, this.token);

  @override
  String toString() => '${authScheme.value} $token';
}

class BasicCredentials {
  final String username;
  final String password;

  const BasicCredentials(this.username, this.password);

  String token() => base64Encode(utf8.encode('$username:$password'));
}
