import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Operations on a [Rill] of [Either] values.
extension RethrowOps<A> on Rill<Either<Object, A>> {
  /// Unwraps [Right] values and raises the first [Left] value as an error.
  ///
  /// Elements before the first [Left] are emitted normally; everything after
  /// is discarded once the error is raised.
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
