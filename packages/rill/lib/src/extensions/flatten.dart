import 'package:ribs_rill/ribs_rill.dart';

/// Operations on a [Rill] of [Rill]s.
extension RillFlattenOps<O> on Rill<Rill<O>> {
  /// Concatenates the inner rills sequentially into a single stream.
  Rill<O> flatten() => flatMap((r) => r);
}
