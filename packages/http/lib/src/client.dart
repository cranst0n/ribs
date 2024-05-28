import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_http/src/impl/sdk_client.dart';
import 'package:ribs_json/ribs_json.dart';

abstract class Client {
  static Resource<Client> sdk() => SdkClient.create();

  static Client create(Function1<Request, Resource<Response>> run) =>
      _ClientF(run);

  Resource<Response> run(Request req);

  // ///////////////////////////////////////////////////////////////////////////

  IO<Response> request(Request req) => run(req).use(IO.pure);

  IO<Response> requestUri(Uri uri) => request(Request(uri: uri));

  IO<Response> requestString(String uri) =>
      IO.fromEither(_uri(uri)).flatMap(requestUri);

  // ///////////////////////////////////////////////////////////////////////////

  IO<A> fetch<A>(Request req, EntityDecoder<A> decoder) =>
      run(req).use((r) => decoder.decode(r, false).rethrowError());

  IO<A> fetchUri<A>(Uri uri, EntityDecoder<A> decoder) =>
      fetch(Request(uri: uri), decoder);

  IO<A> fetchString<A>(String uri, EntityDecoder<A> decoder) =>
      IO.fromEither(_uri(uri)).flatMap((uri) => fetchUri(uri, decoder));

  // ///////////////////////////////////////////////////////////////////////////

  IO<Json> fetchJson(Request req) => fetch(req, EntityDecoder.json);

  IO<Json> fetchJsonUri(Uri uri) => fetchJson(Request(uri: uri));

  IO<Json> fetchJsonString(String uri) =>
      IO.fromEither(_uri(uri)).flatMap(fetchJsonUri);

  // ///////////////////////////////////////////////////////////////////////////

  IO<A> fetchJsonAs<A>(Request req, Decoder<A> decoder) =>
      fetch(req, EntityDecoder.jsonAs(decoder));

  IO<A> fetchJsonUriAs<A>(Uri uri, Decoder<A> decoder) =>
      fetch(Request(uri: uri), EntityDecoder.jsonAs(decoder));

  IO<A> fetchJsonStringAs<A>(String uri, Decoder<A> decoder) =>
      IO.fromEither(_uri(uri)).flatMap((uri) => fetchJsonUriAs(uri, decoder));

  // ///////////////////////////////////////////////////////////////////////////

  IO<Status> status(Request req) => run(req).use((r) => IO.pure(r.status));

  IO<Status> statusFromUri(Uri uri) => status(Request(uri: uri));

  IO<Status> statusFromString(String uri) =>
      IO.fromEither(_uri(uri)).flatMap(statusFromUri);

  // ///////////////////////////////////////////////////////////////////////////

  IO<Response> delete(
    Uri uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      request(Request.delete(uri).withHeaders(headers).withBody(body));

  IO<Response> deleteString(
    String uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      IO
          .fromEither(_uri(uri))
          .flatMap((uri) => delete(uri, headers: headers, body: body));

  IO<Response> get(
    Uri uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      request(Request.get(uri).withHeaders(headers).withBody(body));

  IO<Response> getString(
    String uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      IO
          .fromEither(_uri(uri))
          .flatMap((uri) => get(uri, headers: headers, body: body));

  IO<Response> post(
    Uri uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      request(Request.post(uri).withHeaders(headers).withBody(body));

  IO<Response> postString(
    String uri, {
    Headers headers = Headers.empty,
    EntityBody body = EntityBody.Empty,
  }) =>
      IO
          .fromEither(_uri(uri))
          .flatMap((uri) => post(uri, headers: headers, body: body));

  Either<FormatException, Uri> _uri(String s) {
    try {
      return Uri.parse(s).asRight();
    } on FormatException catch (ex) {
      return ex.asLeft();
    }
  }
}

class _ClientF extends Client {
  final Function1<Request, Resource<Response>> _runF;

  _ClientF(this._runF);

  @override
  Resource<Response> run(Request req) => _runF(req);
}
