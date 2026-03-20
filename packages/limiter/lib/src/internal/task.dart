import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

final class Task<A> {
  final IO<A> task;
  final Deferred<A> result;
  final Deferred<Unit> stopSignal;

  const Task._(
    this.task,
    this.result,
    this.stopSignal,
  );

  static IO<Task<A>> create<A>(IO<A> fa) => throw UnimplementedError();

  IO<Unit> get executable => throw UnimplementedError();

  IO<Unit> get cancel => throw UnimplementedError();

  IO<A> get awaitResult => throw UnimplementedError();
}
