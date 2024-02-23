import 'package:ribs_core/src/collection/collection.dart';
import 'package:ribs_core/src/function.dart';

final class MutationTrackerIterator<A> extends RIterator<A> {
  final RIterator<A> underlying;
  final int expectedCount;
  final Function0<int> mutationCount;

  const MutationTrackerIterator(
    this.underlying,
    this.expectedCount,
    this.mutationCount,
  );

  @override
  bool get hasNext {
    if (mutationCount() != expectedCount) {
      throw StateError('mutation occurred during iteration');
    }

    return underlying.hasNext;
  }

  @override
  A next() => underlying.next();
}
