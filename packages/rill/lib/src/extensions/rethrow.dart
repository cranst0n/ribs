import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension RethrowOps<A> on Rill<Either<Object, A>> {
  Rill<A> get rethrowError {
    return flatMap((either) {
      return either.fold(
        (err) => Rill.raiseError(err),
        (o) => Rill.emit(o),
      );
    });
  }
}
