import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

extension IOOptionOps<A> on Option<A> {
  /// If this is a [Some], returns the result of applying [f] to the value,
  /// otherwise an [IO] with a [None] is returned.
  IO<Option<B>> traverseIO<B>(Function1<A, IO<B>> f) =>
      fold(() => IO.none(), (a) => f(a).map((a) => Some(a)));

  /// Same behavior as [traverseIO] but the resulting value is discarded.
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) =>
      fold(() => IO.unit, (a) => f(a).map((_) => Unit()));
}

extension OptionIOOps<A> on Option<IO<A>> {
  /// Returns an [IO] that will return [None] if this is a [None], or the
  /// evaluation of the [IO] lifted into an [Option], specifically a [Some].
  /// /// {@macro option_tupled}
  IO<Option<A>> sequence() => fold(() => IO.pure(none()), (io) => io.map((a) => Some(a)));
}
