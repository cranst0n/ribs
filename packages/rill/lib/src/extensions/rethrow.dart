import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension RethrowOps<A> on Rill<Either<Object, A>> {
  Rill<A> get rethrowError {
    return chunks().flatMap((c) {
      Option<Object> errOpt = none();
      final size = c.size;
      var i = 0;

      final bldr = <A>[];

      while (i < size && errOpt.isEmpty) {
        c[i].fold(
          (ex) => errOpt = Some(ex),
          (o) {
            bldr.add(o);
            i++;
          },
        );
      }

      final chunk = Chunk.fromList(bldr);

      return Rill.chunk(chunk).append(
        () => errOpt.fold(
          () => Rill.empty(),
          (err) => Rill.raiseError(err),
        ),
      );
    });
  }
}
