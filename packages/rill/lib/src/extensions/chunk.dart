import 'package:ribs_rill/ribs_rill.dart';

extension RillChunkOps<A> on Rill<Chunk<A>> {
  Rill<A> get unchunks => underlying.flatMapOutput((c) => Pull.output(c)).rill;
}
