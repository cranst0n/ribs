import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Operations on a [Rill] of [Option]s.
extension RillOptionOps<A> on Rill<Option<A>> {
  /// Filters out [None] elements and unwraps all [Some] values.
  Rill<A> get unNone => collect(identity);

  /// Unwraps [Some] values and terminates the stream at the first [None].
  Rill<A> get unNoneTerminate {
    Pull<A, Unit> loop(Pull<Option<A>, Unit> p) {
      return p.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) => hd
              .indexWhere((opt) => opt.isEmpty)
              .fold(
                () => Pull.output(hd.map((opt) => opt.get)).append(() => loop(tl)),
                (idx) => idx == 0 ? Pull.done : Pull.output(hd.take(idx).map((opt) => opt.get)),
              ),
        );
      });
    }

    return loop(underlying).rillNoScope;
  }
}
