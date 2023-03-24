import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:ribs_core/ribs_core.dart' as ribs;

extension FpdartOptionOps<A> on fpdart.Option<A> {
  ribs.Option<A> toRibs() => fold(() => ribs.None<A>(), (a) => ribs.Some(a));
}

extension RibsOptionOps<A> on ribs.Option<A> {
  fpdart.Option<A> toFpdart() =>
      fold(() => const fpdart.None(), (a) => fpdart.Some(a));
}
