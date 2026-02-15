import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('Pull.done runtime type check', () async {
    final Pull<Never, Unit> doneValue = Pull.done;
    final Pull<int, Unit> p = doneValue;

    await p.rill.compile.drain.unsafeRunFuture();
  });
}
