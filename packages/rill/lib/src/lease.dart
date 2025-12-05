import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Lease {
  static Lease of(IO<Either<RuntimeException, Unit>> cancel) => _GenericLease(cancel);

  IO<Either<RuntimeException, Unit>> cancel();
}

final class _GenericLease extends Lease {
  final IO<Either<RuntimeException, Unit>> _cancel;

  _GenericLease(this._cancel);

  @override
  IO<Either<RuntimeException, Unit>> cancel() => _cancel;
}
