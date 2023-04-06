import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class Rill<O> {
  final Pull<O, Unit> _underlying;

  Rill(this._underlying);

  static Rill<O> emit<O>(O o) => Pull.output1(o).rillNoScope();

  static Rill<O> emits<O>(IList<O> os) => Pull.output(os).rillNoScope();

  static Rill<Never> empty<O>() => Pull.done().rillNoScope();

  static Rill<O> eval<O>(IO<O> io) =>
      Pull.eval(io).flatMap((a) => Pull.output1(a)).rillNoScope();

  RillCompiled<O> compile() => RillCompiled(_underlying);

  Pull<O, Unit> toPull() => _underlying;
}

final class StepLeg<O> {
  final IList<O> head;

  final UniqueToken scopeId;
  final Pull<O, Unit> next;

  StepLeg(this.head, this.scopeId, this.next);
}

class RillCompiled<O> {
  final Pull<O, Unit> _pull;

  const RillCompiled(this._pull);

  IO<int> count() => foldChunks(0, (acc, chunk) => acc + chunk.size);

  IO<Unit> drain() => foldChunks(Unit(), (a, _) => a);

  IO<A> fold<A>(A init, Function2<A, O, A> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

  IO<A> foldChunks<A>(
    A init,
    Function2<A, IList<O>, A> fold,
  ) =>
      Resource.makeCase(
        Scope.newRoot(),
        (scope, ec) => scope.close(ec).rethrowError(),
      ).use((scope) => Pull.compile(_pull, scope, false, init, fold));

  IO<Option<O>> last() =>
      foldChunks(none(), (acc, elem) => elem.lastOption.orElse(() => acc));

  IO<IList<O>> toIList() =>
      foldChunks(IList.empty(), (acc, chunk) => acc.concat(chunk));
}
