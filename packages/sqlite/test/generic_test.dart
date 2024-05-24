import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

class Todo {
  final int id;
  final String title;
  final Option<String> description;
  final Json raw;

  const Todo(
    this.id,
    this.title,
    this.description,
    this.raw,
  );

  @override
  String toString() => 'Todo($id, $title, $description, $raw)';

  static final rw = (
    ReadWrite.integer,
    ReadWrite.string,
    ReadWrite.string.optional(),
    ReadWrite.json,
  ).tupled.xmap(
        Todo.new.tupled,
        (t) => (t.id, t.title, t.description, t.raw),
      );
}

void main() {
  test('generic', () async {
    final db = sqlite3.openInMemory();

    final insertAll = ilist([
      'create table todo (id integer primary key, title text not null, description text, raw json)',
      '''insert into todo values (0, "sit", "quietly", '[true, null, 2, 3.14, "hello"]')''',
    ]).traverseIO_((sql) => sql.update0.run(db));

    await insertAll.unsafeRunFuture();

    await 'insert into todo values(?, ?, ?, ?)'
        .update(Todo.rw)
        .updateMany(ilist([
          Todo(1, 'Shop', Option('for groceries'),
              Json.arr([Json.True, Json.Null])),
          Todo(
              2,
              'Play',
              Option('baseball'),
              Json.obj([
                ("club", Json.str("Crestwood")),
                ("players", Json.number(4))
              ])),
          Todo(3, 'Study', none(), Json.arr([])),
          Todo(10, 'Test', Option('123'), Json.obj([("one", Json.True)])),
        ]))
        .run(db)
        .unsafeRunFuture();

    final res0 = await 'select id,title,description,raw from todo'
        .query(Todo.rw)
        .ilist()
        .run(db)
        .flatTap((x) => x.traverseIO_((todo) => IO.println(todo.toString())))
        .unsafeRunFuture();

    expect(res0.size, 5);

    final res1 = await 'select id,title,description,raw from todo where id = 2'
        .query(Todo.rw)
        // .query((
        //   (Read.integer, Read.string).tupled,
        //   (Read.string.optional(), Read.json).tupled
        // ).tupled)
        .unique()
        .run(db)
        .unsafeRunFuture();

    expect(res1.id, 2);
    // expect(res1.$1.$1, 2);

    final res2 =
        await 'select id,title,description,raw from todo where id = 1000'
            .query(Todo.rw)
            .option()
            .run(db)
            .unsafeRunFuture();

    expect(res2, isNone());

    final res3 = await '''
                insert into todo values
                  (5000, "Foo", null, '[1.23, [null, true, {}]]'),
                  (5001, "Bar", null, '[]')
                returning id, title, raw'''
        .query((Read.integer, Read.string).tupled)
        .ivector()
        .run(db)
        .unsafeRunFuture();

    expect(res3, ivec([(5000, 'Foo'), (5001, 'Bar')]));
  });
}
