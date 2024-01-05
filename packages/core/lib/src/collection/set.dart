import 'package:ribs_core/ribs_collection.dart';

mixin Set<A> on RibsIterable<A> {
  bool contains(A elem);

  bool subsetOf(Set<A> that);

  Iterator<Set<A>> subsets();

  Iterator<Set<A>> subsetsOfLength(int len);

  // Set<A> intersect(Set<A> that) => filter(that.contains).toISet();

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
