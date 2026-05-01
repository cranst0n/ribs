import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Operations on a [Rill] of booleans.
extension RillBooleanOps on Rill<bool> {
  /// For each emitted `true` element runs [ifTrue], for each `false` runs [ifFalse].
  ///
  /// The chosen sub-rill is spliced into the output at each element position.
  Rill<O2> ifM<O2>(Function0<Rill<O2>> ifTrue, Function0<Rill<O2>> ifFalse) =>
      flatMap((b) => b ? ifTrue() : ifFalse());
}
