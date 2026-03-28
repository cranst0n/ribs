import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class Queue<A> {
  static IO<Queue<A>> create<A>([int? maxSize]) => (
    Ref.of(0),
    PQueue.bounded<Rank<A>>(Rank.order<A>(), maxSize ?? Integer.maxValue),
  ).mapN((lastInsertedAt, q) => QueueImpl._(lastInsertedAt, q));

  IO<IO<bool>> enqueue(A a, {int priority = 0});

  IO<bool> delete(IO<bool> id);

  IO<A> dequeue();

  Rill<A> dequeueAll() => Rill.repeatEval(dequeue());

  IO<int> get size;
}

class QueueImpl<A> extends Queue<A> {
  final Ref<int> lastInsertedAt;
  final PQueue<Rank<A>> q;

  QueueImpl._(this.lastInsertedAt, this.q);

  @override
  IO<bool> delete(IO<bool> id) => id;

  @override
  IO<A> dequeue() {
    return q.take().flatMap((a) {
      return a.extract().flatMap((aOpt) {
        return aOpt.fold(dequeue, IO.pure);
      });
    });
  }

  @override
  IO<IO<bool>> enqueue(A a, {int priority = 0}) {
    return lastInsertedAt.getAndUpdate((n) => n + 1).flatMap((insertedAt) {
      return Rank.create(a, priority, insertedAt).flatMap((rank) {
        return q
            .tryOffer(rank)
            .flatMap(
              (succeeded) => IO.raiseError<Unit>(Exception('Limit Reached')).whenA(!succeeded),
            )
            .as(IO.delay(() => rank.markAsDeleted()));
      });
    }).flatten();
  }

  @override
  IO<int> get size => q.size();
}

final class Rank<A> {
  final Ref<Option<A>> a;
  final int priority;
  final int insertedAt;

  const Rank(this.a, this.priority, this.insertedAt);

  static IO<Rank<A>> create<A>(A a, int priority, int insertedAt) {
    return Ref.of(Option(a)).map((aOpt) => Rank(aOpt, priority, insertedAt));
  }

  IO<Option<A>> extract() => a.getAndSet(none());

  IO<bool> markAsDeleted() => a.getAndSet(none()).map((o) => o.isDefined);

  static Order<Rank<A>> order<A>() => Order.whenEqual(
    Order.by<Rank<A>, int>((r) => r.priority).reverse(),
    Order.by<Rank<A>, int>((r) => r.insertedAt),
  );
}
