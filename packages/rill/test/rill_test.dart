import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('emit', () async {
    final r = Rill.emit('a');
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist(['a']));
  });

  test('emits', () async {
    final l = ilist([1, 2, 3]);
    final r = Rill.emits(l);
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, l);
  });

  test('empty', () async {
    final r = Rill.empty<int>();
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, const IList<int>.nil());
  });

  test('eval', () async {
    final r = Rill.eval(IO.pure(42));
    final result = await r.compile().toIList().unsafeRunToFuture();

    expect(result, ilist([42]));
  });
}
