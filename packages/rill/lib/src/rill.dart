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

  static Rill<O> raiseError<O>(IOError err) =>
      Pull.raiseError(err).rillNoScope();

  Rill<O> append(Function0<Rill<O>> that) =>
      _underlying.append(() => that()._underlying).rillNoScope();

  RillCompiled<O> compile() => RillCompiled(_underlying);

  Rill<O2> evalMap<O2>(Function1<O, IO<O2>> f) => _underlying
      .flatMapOutput((o) => Pull.eval(f(o)).flatMap(Pull.output1))
      .rillNoScope();

  Rill<O> evalTap<O2>(Function1<O, IO<O2>> f) => evalMap((o) => f(o).as(o));

  Rill<O2> flatMap<O2>(covariant Function1<O, Rill<O2>> f) =>
      _underlying.flatMapOutput((o) => f(o)._underlying).rillNoScope();

  Rill<O> handleErrorWith(Function1<IOError, Rill<O>> handler) =>
      Pull.scope(_underlying)
          .handleErrorWith((e) => handler(e)._underlying)
          .rillNoScope();

  Rill<O2> map<O2>(Function1<O, O2> f) =>
      _underlying.mapOutput(this, f).rillNoScope();

  Rill<O> onComplete(Function0<Rill<O>> s2) =>
      handleErrorWith((e) => s2().append(() => Rill(Pull.fail(e)))).append(s2);

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

class ToPull<O> {
  final Rill<O> self;

  const ToPull(this.self);

  Pull<O, Option<(IList<O>, Rill<O>)>> uncons() => self._underlying
      .uncons()
      .map((a) => a.map((a) => a((hd, tl) => (hd, tl.rillNoScope()))));

  Pull<O, Option<(O, Rill<O>)>> uncons1() =>
      throw UnimplementedError('ToPull.uncons1');
}
