import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@immutable
class NonEmptyIList<A> implements Monad<A>, Foldable<A> {
  final A head;
  final IList<A> tail;

  const NonEmptyIList(this.head, this.tail);

  static Option<NonEmptyIList<A>> fromIterable<A>(Iterable<A> as) =>
      Option.when(
        () => as.isNotEmpty,
        () => NonEmptyIList(as.first, as.toIList().tail()),
      );

  static NonEmptyIList<A> fromIterableUnsafe<A>(Iterable<A> as) =>
      NonEmptyIList(as.first, as.toIList().tail());

  static NonEmptyIList<A> of<A>(A head, Iterable<A> tail) =>
      NonEmptyIList(head, IList.of(tail));

  static NonEmptyIList<A> one<A>(A head) => of(head, []);

  A operator [](int ix) => ix == 0 ? head : tail[ix - 1];

  @override
  NonEmptyIList<B> ap<B>(NonEmptyIList<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  NonEmptyIList<A> append(A a) => NonEmptyIList(head, tail.append(a));

  NonEmptyIList<A> concat(IList<A> l) => NonEmptyIList(head, tail.concat(l));

  NonEmptyIList<A> concatNel(NonEmptyIList<A> l) =>
      NonEmptyIList(head, tail.append(l.head).concat(l.tail));

  bool contains(A elem) => head == elem || tail.contains(elem);

  IList<A> distinct() => toIList().distinct();

  IList<A> drop(int n) => toIList().drop(n);

  IList<A> dropRight(int n) => toIList().dropRight(n);

  IList<A> dropWhile(Function1<A, bool> p) => toIList().dropWhile(p);

  bool exists(Function1<A, bool> p) => p(head) || tail.exists(p);

  IList<A> filter(Function1<A, bool> p) => toIList().filter(p);

  IList<A> filterNot(Function1<A, bool> p) => toIList().filterNot(p);

  Option<A> find(Function1<A, bool> p) => toIList().find(p);

  Option<A> findLast(Function1<A, bool> p) =>
      tail.findLast(p).orElse(() => Option.when(() => p(head), () => head));

  @override
  NonEmptyIList<B> flatMap<B>(covariant Function1<A, NonEmptyIList<B>> f) =>
      f(head).concat(tail.flatMap((a) => f(a).toIList()));

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) => toIList().foldLeft(init, op);

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      toIList().foldRight(init, op);

  bool forall(Function1<A, bool> p) => p(head) && tail.forall(p);

  void forEach<B>(Function1<A, B> f) {
    f(head);
    tail.forEach(f);
  }

  IList<A> get init => toIList().init();

  A get last => tail.lastOption.getOrElse(() => head);

  int get length => size;

  Option<A> lift(int ix) => ix < 0
      ? none<A>()
      : ix == 0
          ? head.some
          : tail.lift(ix - 1);

  @override
  NonEmptyIList<B> map<B>(Function1<A, B> f) =>
      NonEmptyIList(f(head), tail.map(f));

  String mkString({String? start, required String sep, String? end}) =>
      toIList().mkString(start: start, sep: sep, end: end);

  NonEmptyIList<A> padTo(int len, A elem) =>
      size >= len ? this : NonEmptyIList(head, tail.padTo(len - 1, elem));

  NonEmptyIList<A> prepend(A elem) => NonEmptyIList(elem, toIList());

  NonEmptyIList<A> replace(int index, A elem) => updated(index, (_) => elem);

  NonEmptyIList<A> reverse() => tail.isEmpty
      ? this
      : NonEmptyIList(tail.lastOption.getOrElse(() => head),
          tail.init().reverse().append(head));

  bool startsWith(IList<A> that) => toIList().startsWith(that);

  bool startsWithNel(NonEmptyIList<A> that) =>
      head == that.head && tail.startsWith(that.tail);

  IList<A> take(int n) => toIList().take(n);

  IList<A> takeRight(int n) => toIList().takeRight(n);

  IList<A> takeWhile(Function1<A, bool> p) => toIList().takeWhile(p);

  IList<A> toIList() => tail.prepend(head);

  List<A> toList() => toIList().toList();

  Either<B, NonEmptyIList<C>> traverseEither<B, C>(
          Function1<A, Either<B, C>> f) =>
      f(head).flatMap(
          (h) => tail.traverseEither(f).map((t) => NonEmptyIList(h, t)));

  IO<NonEmptyIList<B>> traverseIO<B>(Function1<A, IO<B>> f) => f(head)
      .flatMap((h) => tail.traverseIO(f).map((t) => NonEmptyIList(h, t)));

  Option<NonEmptyIList<B>> traverseOption<B>(Function1<A, Option<B>> f) =>
      f(head).flatMap(
          (h) => tail.traverseOption(f).map((t) => NonEmptyIList(h, t)));

  NonEmptyIList<A> updated(int index, Function1<A, A> f) => index < 0
      ? this
      : index == 0
          ? NonEmptyIList(f(head), tail)
          : NonEmptyIList(head, tail.updated(index - 1, f));

  NonEmptyIList<(A, int)> zipWithIndex() => NonEmptyIList(
      (head, 0), tail.zipWithIndex().map((a) => (a.$1, a.$2 + 1)));

  NonEmptyIList<(A, B)> zip<B>(NonEmptyIList<B> bs) =>
      NonEmptyIList((head, bs.head), tail.zip(bs.tail));

  @override
  String toString() => mkString(start: 'NonEmptyIList(', sep: ', ', end: ')');

  @override
  bool operator ==(Object other) =>
      other is NonEmptyIList<A> && other.head == head && other.tail == tail;

  @override
  int get hashCode => head.hashCode ^ tail.hashCode;
}
