import 'package:ribs_core/ribs_core.dart';

abstract class Lease {
  static Lease of(IO<Either<IOError, Unit>> cancel) => _GenericLease(cancel);

  IO<Either<IOError, Unit>> cancel();
}

final class _GenericLease extends Lease {
  final IO<Either<IOError, Unit>> _cancel;

  _GenericLease(this._cancel);

  @override
  IO<Either<IOError, Unit>> cancel() => _cancel;
}
