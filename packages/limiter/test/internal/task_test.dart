import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:ribs_limiter/src/internal/task.dart';
import 'package:test/test.dart';

void main() {
  IO<(IO<A>, IO<Unit>)> execute<A>(IO<A> task) {
    return Task.create(task).flatMap((task) {
      return task.executable.start().as((task.awaitResult, task.cancel));
    });
  }

  IO<A> executeAndWait<A>(IO<A> task) => execute(task).flatMap((t) => t.$1);

  test('Task executable cannot fail', () {
    final test = Task.create(IO.raiseError<Unit>(Exception('BOOM'))).flatMap((t) => t.executable);
    expect(test.ticked, succeeds());
  });

  test('Task propogates results', () {
    final test = executeAndWait(IO.sleep(1.second).as(42));
    expect(test.ticked, succeeds(42));
  });

  test('Task propogates error', () {
    final test = executeAndWait(IO.raiseError<Unit>(Exception('BOOM')));
    expect(test.ticked, errors());
  });

  test('Task propogates cancelation', () {
    final test = executeAndWait(IO.sleep(1.second).productR(IO.canceled));
    expect(test.ticked, cancels);
  });

  test('cancel cancels the Task executable', () {
    final test = execute(IO.never<Unit>()).flatMapN((wait, cancel) => cancel.productR(wait));
    expect(test.ticked, cancels);
  });

  test('cancel backpressures on finalizers', () {
    final test = execute(IO.never<Unit>().onCancel(IO.sleep(1.second))).flatMapN((_, cancel) {
      return IO.sleep(10.milliseconds).productR(cancel.timed().map((t) => t.$1));
    });

    expect(test.ticked, succeeds(1.second));
  });
}
