abstract class Ordered<A> implements Comparable<A> {
  const Ordered();

  @override
  int compareTo(A other);

  bool operator <(A that) => compareTo(that) < 0;

  bool operator <=(A that) => compareTo(that) <= 0;

  bool operator >(A that) => compareTo(that) > 0;

  bool operator >=(A that) => compareTo(that) >= 0;
}
