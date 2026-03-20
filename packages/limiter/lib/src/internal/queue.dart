import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class Queue<A> {
  IO<Queue<A>> create({int? maxSize}) => throw UnimplementedError();

  IO<IO<bool>> enqueue(A a, {int priority = 0});

  IO<bool> delete(IO<bool> id);

  IO<A> dequeue();

  Rill<A> dequeueAll();

  IO<int> get size;
}

final class Rank<A> {
  final Ref<Option<A>> a;
  final int priority;
  final int insertedAt;

  const Rank(this.a, this.priority, this.insertedAt);

  static IO<Rank<A>> create<A>(A a, int priority, int insertedAt) {
    return Ref.of(Some(a)).map((aOpt) => Rank(aOpt, priority, insertedAt));
  }

  IO<Option<A>> get extract => a.getAndSet(none());

  IO<bool> get markAsDeleted => a.getAndSet(none()).map((o) => o.isDefined);

  static final order = Order.whenEqual(
    Order.by<Rank<Object>, int>((r) => r.priority).reverse(),
    Order.by<Rank<Object>, int>((r) => r.insertedAt),
  );
}
