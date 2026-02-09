import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension RillBooleanOps on Rill<bool> {
  Rill<O2> ifM<O2>(Function0<Rill<O2>> ifTrue, Function0<Rill<O2>> ifFalse) =>
      flatMap((b) => b ? ifTrue() : ifFalse());
}
