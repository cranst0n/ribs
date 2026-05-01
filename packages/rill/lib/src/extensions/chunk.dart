import 'package:ribs_rill/ribs_rill.dart';

/// Operations on a [Rill] of [Chunk]s.
extension RillChunkOps<A> on Rill<Chunk<A>> {
  /// Flattens a stream of chunks into a stream of individual elements.
  Rill<A> get unchunks => underlying.flatMapOutput((c) => Pull.output(c)).rillNoScope;
}
