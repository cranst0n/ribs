import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';
import 'package:ribs_json/ribs_json.dart';

void main(List<String> args) async {
  const usersUri = 'https://jsonplaceholder.typicode.com/users';
  String todoUri(int id) => 'https://jsonplaceholder.typicode.com/todos/$id';

  final prog = Client.sdk()
      .use((client) => IO.both(
            client.fetchString(
                usersUri, EntityDecoder.jsonAs(Codec.ilist(User.codec))),
            IList.range(1, 10, 2).map(todoUri).parTraverseIO((uri) =>
                client.fetchString(uri, EntityDecoder.jsonAs(Todo.codec))),
          ))
      .timed()
      .start()
      // .flatTap((fiber) => IO.cede.productR(() => fiber.cancel()))
      .flatMap((fiber) => fiber.join())
      .debug(prefix: 'Outcome');

  await prog.unsafeRunFuture();
}

final class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo(this.userId, this.id, this.title, this.completed);

  @override
  String toString() => 'Todo($userId, $id, $title, $completed)';

  static final codec = Codec.product4(
    'userId'.as(Codec.integer),
    'id'.as(Codec.integer),
    'title'.as(Codec.string),
    'completed'.as(Codec.boolean),
    Todo.new,
    (t) => (t.userId, t.id, t.title, t.completed),
  );
}

final class User {
  final int id;
  final String name;
  final String email;

  const User(this.id, this.name, this.email);

  @override
  String toString() => 'User($id, $name, $email)';

  static final codec = Codec.product3(
    'id'.as(Codec.integer),
    'name'.as(Codec.string),
    'email'.as(Codec.string),
    User.new,
    (u) => (u.id, u.name, u.email),
  );
}
