import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_sqlite/ribs_sqlite.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

class TodoId {
  final int value;

  const TodoId(this.value);

  @override
  String toString() => 'TodoId($value)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is TodoId && other.value == value;
  }

  @override
  int get hashCode => value;
}

class Todo {
  final TodoId id;
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
    ReadWrite.integer.xmap(TodoId.new, (id) => id.value),
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
        .updateMany(
          ilist([
            Todo(
              const TodoId(1),
              'Shop',
              Option('for groceries'),
              Json.arr([Json.True, Json.Null]),
            ),
            Todo(
              const TodoId(2),
              'Play',
              Option('baseball'),
              Json.obj([("club", Json.str("Crestwood")), ("players", Json.number(4))]),
            ),
            Todo(const TodoId(3), 'Study', none(), Json.arr([])),
            Todo(const TodoId(10), 'Test', Option('123'), Json.obj([("one", Json.True)])),
          ]),
        )
        .run(db)
        .unsafeRunFuture();

    final res0 =
        await 'select id,title,description,raw from todo'
            .query(Todo.rw)
            .ilist()
            .run(db)
            // .flatTap((x) => x.traverseIO_((todo) => IO.println(todo.toString())))
            .unsafeRunFuture();

    expect(res0.size, 5);

    final res1 =
        await 'select id,title,description,raw from todo where id = 2'
            .query(Todo.rw)
            .unique()
            .run(db)
            .unsafeRunFuture();

    expect(res1.id, const TodoId(2));

    final res2 =
        await 'select id,title,description,raw from todo where id = 1000'
            .query(Todo.rw)
            .option()
            .run(db)
            .unsafeRunFuture();

    expect(res2, isNone());

    final res3 =
        await '''
                insert into todo values
                  (5000, "Foo", null, '[1.23, [null, true, {}]]'),
                  (5001, "Bar", null, '[]')
                returning id, title, raw'''
            .query((Read.integer, Read.string).tupled)
            .ivector()
            .run(db)
            .unsafeRunFuture();

    expect(res3, ivec([(5000, 'Foo'), (5001, 'Bar')]));

    final res4 =
        await '''select max(id) from todo'''.query(Read.integer).option().run(db).unsafeRunFuture();

    expect(res4, isSome(5001));

    final res5 =
        await 'select id,title,description,raw from todo where id > 0'
            .query(Todo.rw)
            .nel()
            .run(db)
            .unsafeRunFuture();

    expect(res5.size, 6);

    final res6 =
        await 'select id,title,description,raw from todo where id < 0'
            .query(Todo.rw)
            .nel()
            .run(db)
            .unsafeRunFutureOutcome();

    expect(res6.isError, isTrue);
  });

  test('optional', () async {
    final db = sqlite3.openInMemory();

    await ilist([
      'create table foo (id integer, raw json, title string)',
    ]).traverseIO_((sql) => sql.update0.run(db)).unsafeRunFuture();

    final maxId =
        await 'select max(id) from foo'
            .query(Read.integer.optional())
            .unique()
            .run(db)
            .unsafeRunFuture();

    expect(maxId, isNone());

    final rw =
        (
          ReadWrite.integer,
          ReadWrite.json.optional(),
          ReadWrite.string.optional(),
        ).tupled;

    final stmt = 'insert into foo values (?,?,?)'.update(rw);

    final resNone = await stmt.update((1, none(), 'A'.some)).run(db).unsafeRunFuture();
    expect(resNone, Unit());

    final resSome = await stmt.update((2, Some(Json.True), none())).run(db).unsafeRunFuture();
    expect(resSome, Unit());
  });

  test('tupled optionals', () async {
    final db = sqlite3.openInMemory();

    await ilist([
      'create table foo (a integer, b string, c integer, d string)',
    ]).traverseIO_((sql) => sql.update0.run(db)).unsafeRunFuture();

    final tupRW =
        (
          ReadWrite.integer,
          ReadWrite.string,
        ).tupled.optional();

    final rw = (tupRW, tupRW).tupled;

    final stmt = 'insert into foo values (?,?,?,?)'.update(rw);

    Future<void> testInsert(Option<(int, String)> a, Option<(int, String)> b) async {
      final res = await stmt.update((a, b)).run(db).unsafeRunFuture();

      expect(res, Unit());
    }

    await testInsert((1, '1').some, (2, '2').some);
    await testInsert((1, '1').some, none());
    await testInsert(none(), (2, '2').some);
    await testInsert(none(), none());
  });

  test('blob', () async {
    final db = sqlite3.openInMemory();

    await ilist([
      'create table foo (a integer, b blob)',
    ]).traverseIO_((sql) => sql.update0.run(db)).unsafeRunFuture();

    final rw = (ReadWrite.integer, ReadWrite.blob).tupled;

    final insert = 'insert into foo values (?, ?)'.update(rw);
    final select = 'select a, b from foo'.query(rw);

    final item1 = (1, ilist([1, 2, 3]));
    final item2 = (2, ilist([4, 5, 6]));

    final res0 = await insert.updateMany(ilist([item1, item2])).run(db).unsafeRunFuture();

    expect(res0, Unit());

    final res1 = await select.ilist().run(db).unsafeRunFuture();

    expect(res1, ilist([item1, item2]));
  });

  test('updateQuery', () async {
    final db = sqlite3.openInMemory();

    await 'create table todo (id integer primary key, title text not null, description text, raw json)'
        .update0
        .run(db)
        .unsafeRunFuture();

    final tupleW = (Write.string, Write.string.optional(), Write.json.optional()).tupled;

    final uq = '''
      insert into todo (title, description, raw) values(?, ?, ?) returning id
    '''.updateQuery(tupleW, Read.integer);

    final res0 = await uq.update(('foo', none(), none())).run(db).unsafeRunFuture();

    expect(res0, 1);

    final res1 = await uq.update(('bar', none(), none())).run(db).unsafeRunFuture();

    expect(res1, 2);

    final res2 =
        await uq
            .updateMany(
              ilist([
                ('aaa', none(), none()),
                ('bbb', none(), none()),
                ('ccc', none(), none()),
                ('ddd', none(), none()),
                ('eee', none(), none()),
              ]),
            )
            .run(db)
            .unsafeRunFuture();

    expect(res2.toIList(), ilist([3, 4, 5, 6, 7]));

    final returnMultiple =
        'insert into todo (title, description, raw) values (?,?,?) returning id, title'.updateQuery(
          tupleW,
          (Read.integer, Read.string).tupled,
        );

    final res3 =
        await returnMultiple
            .updateMany(
              ilist([
                ('xxx', none(), none()),
                ('yyy', none(), none()),
                ('zzz', none(), none()),
              ]),
            )
            .run(db)
            .unsafeRunFuture();

    expect(
      res3,
      ilist([
        (8, 'xxx'),
        (9, 'yyy'),
        (10, 'zzz'),
      ]),
    );
  });

  test('boolean', () async {
    final db = sqlite3.openInMemory();
    await 'create table todo (id integer primary key, title text not null, done integer)'.update0
        .run(db)
        .unsafeRunFuture();

    final rw = (ReadWrite.integer, ReadWrite.string, ReadWrite.boolean).tupled;

    final ins = 'insert into todo values (?,?,?)'.update(rw);
    final qur = 'select id, title, done from todo'.query(rw);

    const item = (1, 'Shop', false);

    final res0 = await ins.update(item).run(db).unsafeRunFuture();
    final res1 = await qur.unique().run(db).unsafeRunFuture();

    expect(res0, Unit());
    expect(res1, item);
  });

  test('stream', () async {
    final db = sqlite3.openInMemory();
    await 'create table todo (id integer primary key, title text not null, done integer)'.update0
        .run(db)
        .unsafeRunFuture();

    final rw = (ReadWrite.integer, ReadWrite.string, ReadWrite.boolean).tupled;

    final ins = 'insert into todo values (?,?,?)'.update(rw);
    final qur = 'select id, title, done from todo'.query(rw);

    final items = ilist([
      (1, 'Shop', true),
      (2, 'Eat', false),
      (3, 'Sleep', false),
    ]);

    final res0 = await ins.updateMany(items).run(db).unsafeRunFuture();
    final res1 = await qur.stream().run(db).unsafeRunFuture();

    expect(res0, Unit());
    expect(res1, emitsInOrder(items.toList()));
  });
}
