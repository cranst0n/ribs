import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_json/ribs_json.dart';

// POC...not for use
class TokenJar {
  static IO<Client> create(Client client) {
    return Ref.of(none<Token>()).map((ref) {
      IO<Unit> extractToken(Response res) => res
          .attemptAs(EntityDecoder.jsonAs(LoginResponse.codec))
          .rethrowError()
          .flatMap((x) => ref.setValue(Some(x.authToken)));

      IO<Request> enrichRequest(Request req) =>
          ref.value().map((tokenOpt) => tokenOpt
              .map((token) => req.addHeader(Header.authorization.bearer(token)))
              .getOrElse(() => req));

      return Client.create((request) {
        if (request.uri == Uri.parse('http://site.com/login')) {
          return client
              .run(request)
              .evalTap((response) => extractToken(response));
        } else if (request.uri == Uri.parse('http://site.com/logout')) {
          return client.run(request).evalTap((_) => ref.setValue(none()));
        } else {
          return Resource.eval(enrichRequest(request)).flatMap(client.run);
        }
      });
    });
  }
}

typedef Token = String;

final class LoginResponse {
  final int id;
  final String authToken;

  const LoginResponse(this.id, this.authToken);

  static final codec = Codec.product2(
    'id'.as(Codec.integer),
    'authToken'.as(Codec.string),
    LoginResponse.new,
    (r) => (r.id, r.authToken),
  );
}
