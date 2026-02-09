import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_http/src/middleware/backpressure.dart';
import 'package:ribs_http/src/url_form.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  test('request', () {
    Request(
      method: Method.POST,
      headers: Headers([
        Header.accept(MediaType.application.json),
        Header.authorization.bearer('token123'),
        Header.cacheControl(
          CacheDirective.noCache(['foo', 'bar']),
          CacheDirective.mustRevalidate,
        ),
        Header.cookie(
          const RequestCookie('a', 'aaa'),
          const RequestCookie('b', 'bbb'),
        ),
        Header.set_cookie(const RequestCookie('c', 'ccc')),
      ]),
      uri: Uri.parse('https://postman-echo.com/post/hi/there?hand=wave'),
      body: EntityBody.string('hello!'),
    );
  });

  test('basic', () async {
    await Client.sdk().use((client) {
      return client.requestString('https://postman-echo.com/get?foo1=bar1&foo2=bar2');
    }).unsafeRunFuture();
  }, skip: true);

  test('post json', () async {
    await Client.sdk().use((client) {
      return client
          .request(Request(
            method: Method.POST,
            headers: Headers([
              Header.accept(MediaType.application.json),
            ]),
            uri: Uri.parse('https://postman-echo.com/post'),
            body: EntityBody.string('hello!'),
          ))
          .flatTap((r) => EntityDecoder.string.decode(r, false));
    }).unsafeRunFuture();
  }, skip: true);

  test('post form', () async {
    await Client.sdk().use((client) {
      return client
          .request(Request(
        method: Method.POST,
        headers: Headers([
          Header.accept(MediaType.application.json),
        ]),
        uri: Uri.parse('https://postman-echo.com/post'),
        body: EntityBody.urlForm(UrlForm(imap({
          'foo1': ilist(['bar1']),
          'foo2': ilist(['bar2']),
        }))),
      ))
          .flatTap((r) {
        return EntityDecoder.string.decode(r, false);
      });
    }).unsafeRunFuture();
  }, skip: true);

  test('json', () async {
    await Client.sdk().use((client) {
      return client
          .fetchJsonString('https://postman-echo.com/get?foo1=bar1&foo2=bar2')
          .map((a) => a.printWith(Printer.spaces2));
    }).unsafeRunFuture();
  }, skip: true);

  test('backpressured', () async {
    Request req() => Request(
          method: Method.POST,
          headers: Headers([
            Header.accept(MediaType.application.json),
          ]),
          uri: Uri.parse('https://postman-echo.com/post'),
        );

    final test = Client.sdk().use((client) {
      return Backpressured.create(client, 1).flatMap((client) {
        return IList.tabulate(5, (_) => req()).parTraverseIO(
            (req) => client.request(req).flatTap((resp) => IO.println('Response: $resp')));
      });
    });

    final result = await test.unsafeRunFuture();

    expect(result.length, 5);
  }, skip: true);
}
