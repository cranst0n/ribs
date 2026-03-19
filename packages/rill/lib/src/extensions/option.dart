import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension RillOptionOps<A> on Rill<Option<A>> {
  Rill<A> get unNone => collect(identity);

  A _getopt(Option<A> option) => option.getOrElse(() => throw StateError('Option.get'));

  // Terminate at the first None encountered
  Rill<A> get unNoneTerminate {
    Pull<A, Unit> loop(Pull<Option<A>, Unit> p) {
      return p.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) => hd
              .indexWhere((opt) => opt.isEmpty)
              .fold(
                () => Pull.output(hd.map(_getopt)).append(() => loop(tl)),
                (idx) => idx == 0 ? Pull.done : Pull.output(hd.take(idx).map(_getopt)),
              ),
        );
      });
    }

    return loop(underlying).rillNoScope;
  }
}
