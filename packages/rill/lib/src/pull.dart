// ignore_for_file: strict_raw_type

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

sealed class Pull<O, R> {
  static _Terminal<Unit> get _unit => _Succeeded(Unit());

  static Pull<Never, Unit> done() => _unit;

  static Pull<Never, R> eval<R>(IO<R> fr) => _Eval(fr);

  static Pull<O, Unit> output<O>(IList<O> os) => _Output(os);

  static Pull<O, Unit> output1<O>(O o) => _Output(ilist([o]));

  static Pull<Unit, R> pure<R>(R r) => _Succeeded(r);

  static Pull<Never, Never> raiseError(IOError err) => _Fail(err);

  static Pull<O, Unit> scope<O>(Pull<O, Unit> s) => _InScope(s, false);

  static Pull<Never, Unit> sleep(Duration duration) =>
      Pull.eval(IO.sleep(duration));

  Pull<O, R2> as<R2>(R2 r2) => map((_) => r2);

  Pull<O2, R2> flatMap<O2, R2>(covariant Function1<R, Pull<O2, R2>> f) =>
      // TODO: sus
      _BindF(this as Pull<O2, R>, (e) {
        return e.fold(
          (s) {
            try {
              return f(s.r as R);
            } catch (e, s) {
              return _Fail(IOError(e, s));
            }
          },
          (e) => e,
          (i) => i,
        );
      });

  Pull<O, R2> map<R2>(Function1<R, R2> f) => _BindF(this, (r) => r.map(f));

  Pull<O, Unit> voided() => as(Unit());

  // ///////////////////////////////////////////////////////////////////////////

  static IO<B> compile<O, B>(
    Pull<O, Unit> stream,
    Scope initScope,
    bool extendLastTopLevelScope,
    B init,
    Function2<B, IList<O>, B> foldChunk,
  ) {
    late _ContP<dynamic, dynamic, Unit> contP;

    _Cont<dynamic, Never> getCont() => contP as _Cont<dynamic, Never>;

    _ViewL<X> viewL<X>(Pull<X, Unit> free) {
      if (free is _Action<X, Unit>) {
        // contP = _IdContP();
        contP = _idContP<X>();
        return free;
      } else if (free is _Bind<X, dynamic, Unit>) {
        final b = free;
        if (free.step is _Bind<X, dynamic, dynamic>) {
          final c = free.step as _Bind<X, dynamic, dynamic>;
          return viewL(_BindBind(c.step, c.delegate, b.delegate));
        } else if (free.step is _Action<X, dynamic>) {
          final e = free.step as _Action<X, dynamic>;
          contP = b.delegate;
          return e;
        } else if (free.step is _Terminal) {
          final r = free.step as _Terminal;
          return viewL(b.call(r));
        } else {
          throw UnimplementedError('Pull.compile.viewL.bind: ${free.step}');
        }
      } else if (free is _Terminal<Unit>) {
        return free;
      } else {
        throw UnimplementedError('Pull.compile.viewL: $free');
      }
    }

    Pull<X, Unit> interruptBoundary<X>(
      Pull<X, Unit> stream,
      _Interrupted interruption,
    ) {
      final v = viewL(stream);

      if (v is _CloseScope) {
        final cl = _CanceledScope(v.scopeId, interruption);
        return _transformWith(cl, getCont());
      } else if (v is _Action) {
        return getCont()(interruption);
      } else if (v is _Interrupted) {
        return v;
      } else if (v is _Succeeded) {
        return interruption;
      } else if (v is _Fail) {
        final errs = interruption.deferredError.toIList().append(v.error);
        return _Fail(CompositeError.fromIList(errs).getOrElse(() => v.error));
      } else {
        throw UnimplementedError('Pull.compile.interruptBoundary: $v');
      }
    }

    IO<End> go<X, End>(
      Scope scope,
      Option<Scope> extendedTopLevelScope,
      _Run<X, IO<End>> runner,
      Pull<X, Unit> stream,
    ) {
      IO<End> interruptGuard(
              Scope scope, _Cont<Never, dynamic> view, IO<End> next) =>
          scope.isInterrupted.flatMap(
            (oc) => oc.fold(
              () => next,
              (outcome) {
                final result = outcome.fold(
                  () => _Interrupted(scope.id, none()),
                  (err) => _Fail(err),
                  (scopeId) => _Interrupted(scopeId, none()),
                );

                return go(scope, extendedTopLevelScope, runner, view(result));
              },
            ),
          );

      IO<End> goErr(IOError err, _Cont<Never, X> view) =>
          go(scope, extendedTopLevelScope, runner, view(_Fail(err)));

      IO<End> goEval<V>(_Eval<V> eval, _Cont<V, X> view) =>
          scope.interruptibleEval(eval.value).flatMap((eitherOutcome) {
            final _Terminal<V> result = eitherOutcome.fold(
              (oc) => oc.fold(
                () => _Interrupted(scope.id, none()),
                (err) => _Fail(err),
                (token) => _Interrupted(token, none()),
              ),
              (r) => _Succeeded(r),
            );

            return go(scope, extendedTopLevelScope, runner, view(result));
          });

      IO<End> goAcquire<R>(_Acquire<R> acquire, _Cont<R, X> view) {
        final onScope = scope.acquireResource(
            (poll) =>
                acquire.cancelable ? poll(acquire.resource) : acquire.resource,
            (resource, exit) => acquire.release(resource, exit));

        final cont = onScope.flatMap((outcome) {
          final _Terminal<R> result = outcome.fold(
            () => _Interrupted(scope.id, none()),
            (err) => _Fail(err),
            (a) => a.fold(
              (scopeId) => _Interrupted(scopeId, none()),
              (r) => _Succeeded(r),
            ),
          );

          return go(scope, extendedTopLevelScope, runner, view(result));
        });

        return interruptGuard(scope, view, cont);
      }

      IO<End> goInterruptWhen(
        IO<Either<IOError, Unit>> haltOnSignal,
        _Cont<Unit, X> view,
      ) {
        final onScope = scope.acquireResource(
            (_) => scope.interruptWhen(haltOnSignal), (f, _) => f.cancel());

        final cont = onScope.flatMap((outcome) {
          final _Terminal<Unit> result = outcome.fold(
            () => _Interrupted(scope.id, none()),
            (err) => _Fail(err),
            (a) => a.fold(
                (scopeId) => _Interrupted(scopeId, none()), (_) => _unit),
          );

          return go(scope, extendedTopLevelScope, runner, view(result));
        });

        return interruptGuard(scope, view, cont);
      }

      _Run<X, IO<End>> viewRunner(
        _Cont<Unit, X> view,
        _Run<X, IO<End>> prevRunner,
      ) {
        return _ViewRunner(
          view: view,
          prevRunner: runner,
          doneF: (doneScope) =>
              go(doneScope, extendedTopLevelScope, prevRunner, view(_unit)),
          failF: (err) => goErr(err, view),
          interruptedF: (inter) =>
              go(scope, extendedTopLevelScope, prevRunner, view(inter)),
          outF: (a, b, c) => IO.never(), // not used...
        );
      }

      IO<End> goInScope(
        Pull<X, Unit> stream,
        bool useInterruption,
        _Cont<Unit, X> view,
      ) {
        Pull<X, Unit> endScope(UniqueToken scopeId, _Terminal<Unit> result) =>
            result.fold(
              (s) => _SucceedScope(scopeId),
              (f) => _FailedScope(scopeId, f.error),
              (i) => _CanceledScope(scopeId, i),
            );

        final maybeCloseExtendedScope =
            scope.isRoot && extendedTopLevelScope.isDefined
                ? extendedTopLevelScope
                    .traverseIO_(
                        (a) => a.close(ExitCase.succeeded()).rethrowError())
                    .as(none<Scope>())
                : IO.pure(extendedTopLevelScope);

        final tail = maybeCloseExtendedScope.flatMap((newExtendedScope) {
          return scope
              .open(useInterruption)
              .rethrowError()
              .flatMap((childScope) {
            final bb = _BindF(stream, (r) => endScope(childScope.id, r));

            return go(
              childScope,
              newExtendedScope,
              viewRunner(view, runner),
              bb,
            );
          });
        });

        return interruptGuard(scope, view, tail);
      }

      IO<End> goCloseScope(
        _CloseScope close,
        _Cont<Unit, X> view,
      ) {
        _Terminal<Unit> addError(IOError err, _Terminal<Unit> res) => res.fold(
              (s) => _Fail(err),
              (f) => _Fail(CompositeError.from(err, f.error)),
              (i) => throw StateError('Impossible, cannot interrupt here!'),
            );

        Pull<X, Unit> viewCont(_Terminal<Unit> res) => close.exitCase.fold(
              () => view(res),
              (err) => view(addError(err, res)),
              () => view(res),
            );

        _Terminal<Unit> closeTerminal(Either<IOError, Unit> r, Scope ancestor) {
          return close.interruption.fold(
            () => r.fold((err) => _Fail(err), (a) => _Succeeded(a)),
            (i) {
              final err1 = CompositeError.fromIList(
                  r.swap().toIList().concat(i.deferredError.toIList()));

              if (ancestor.descendsFrom(i.context)) {
                return _Interrupted(i.context, err1);
              } else {
                return err1.fold(() => _unit, (err) => _Fail(err));
              }
            },
          );
        }

        return scope.findInLineage(close.scopeId).flatMap((s) {
          return s.fold(
            () {
              final result = close.interruption.fold(() => _unit, id);
              return go(scope, extendedTopLevelScope, runner, viewCont(result));
            },
            (toClose) {
              if (toClose.isRoot) {
                return go(
                    scope, extendedTopLevelScope, runner, viewCont(_unit));
              } else if (extendLastTopLevelScope && toClose.level == 1) {
                return extendedTopLevelScope
                    .traverseIO_(
                        (a) => a.close(ExitCase.succeeded()).rethrowError())
                    .productR(() => toClose.openAncestor().flatMap((ancestor) =>
                        go(ancestor, Some(toClose), runner, viewCont(_unit))));
              } else {
                return toClose.close(close.exitCase).flatMap(
                      (r) => toClose.openAncestor().flatMap(
                        (ancestor) {
                          final res = closeTerminal(r, ancestor);
                          return go(ancestor, extendedTopLevelScope, runner,
                              viewCont(res));
                        },
                      ),
                    );
              }
            },
          );
        });
      }

      // ///////////////////////////////////////////////////////////////////////

      _Run<Y, IO<End>> flatMapR<Y>(
        _Cont<Unit, X> view,
        Fn1<Y, Pull<X, Unit>> fun,
      ) {
        Pull<X, Unit> unconsed(IList<Y> chunk, Pull<Y, Unit> tail) {
          if (chunk.size == 1 && tail is _Succeeded) {
            try {
              return fun(chunk[0]);
            } catch (e, s) {
              return _Fail(IOError(e, s));
            }
          } else {
            Pull<X, Unit> go(int idx) {
              if (idx == chunk.size) {
                return tail.flatMapOutput(fun);
              } else {
                try {
                  int j = idx;

                  // TODO: Not stack safe
                  Pull<X, Unit> loop() {
                    final p = fun(chunk[idx]);

                    if (p is _Succeeded && j < chunk.size - 1) {
                      j += 1;
                      return loop();
                    } else {
                      return p;
                    }
                  }

                  final next = loop();

                  return _transformWith(next, (t) {
                    if (t is _Succeeded) {
                      return go(j + 1);
                    } else if (t is _Fail) {
                      return _Fail(t.error);
                    } else if (t is _Interrupted) {
                      return interruptBoundary(tail, t).flatMapOutput(fun);
                    } else {
                      throw UnimplementedError(
                          'Pull.compile.go.flatMapR.unconsed: $t');
                    }
                  });
                } catch (e, s) {
                  return _Fail(IOError(e, s));
                }
              }
            }

            return go(0);
          }
        }

        return _RunF<Y, End>(
          doneF: (scope) => interruptGuard(
            scope,
            view,
            go(scope, extendedTopLevelScope, runner, view(_unit)),
          ),
          failF: (err) => goErr(err, view),
          interruptedF: (inter) =>
              go(scope, extendedTopLevelScope, runner, view(inter)),
          outF: (head, outScope, tail) {
            final next = _bindView(unconsed(head, tail), view);
            return go(outScope, extendedTopLevelScope, runner, next);
          },
        );
      }

      _Run<Y, IO<End>> unconsRunR<Y>(
        _Cont<Option<(IList<Y>, Pull<Y, Unit>)>, X> view,
      ) =>
          _RunF(
            doneF: (scope) => interruptGuard(
              scope,
              view,
              go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(const None()))),
            ),
            failF: (err) => goErr(err, view),
            interruptedF: (inter) =>
                go(scope, extendedTopLevelScope, runner, view(inter)),
            outF: (head, outScope, tail) => interruptGuard(
              scope,
              view,
              go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(Some((head, tail))))),
            ),
          );

      _Run<Y, IO<End>> stepLegRunR<Y>(_Cont<Option<StepLeg<Y>>, X> view) =>
          _RunF(
            doneF: (scope) => interruptGuard(
              scope,
              view,
              go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(const None()))),
            ),
            failF: (err) => goErr(err, view),
            interruptedF: (inter) =>
                go(scope, extendedTopLevelScope, runner, view(inter)),
            outF: (head, outScope, tail) => interruptGuard(
              scope,
              view,
              go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(Some(StepLeg(head, outScope.id, tail))))),
            ),
          );

      // ///////////////////////////////////////////////////////////////////////

      final vl = viewL(stream);

      switch (vl) {
        case final _Output<X> output:
          final view = contP as Fn1F<_Terminal<Unit>, Pull<X, Unit>>;

          return interruptGuard(
            scope,
            view,
            runner.out(output.values, scope, view(_unit)),
          );
        case final _FlatMapOutput fmout:
          final fmRunr =
              flatMapR(getCont(), fmout.fun as Fn1<dynamic, Pull<X, Unit>>);

          return IO.unit.productR(
              () => go(scope, extendedTopLevelScope, fmRunr, fmout.stream));
        case final _Uncons u:
          final view = getCont();
          final runr = u.buildR<End>();

          return IO.unit
              .productR(() =>
                  go(scope, extendedTopLevelScope, runr, u.stream).attempt())
              .flatMap(
                (a) => a.fold(
                  (err) => goErr(err, view),
                  (a) => a(unconsRunR(view)),
                ),
              );
        case final _StepLeg s:
          final view = getCont();
          final runr = s.buildR<End>();

          return scope
              .shiftScope(s.scope, s.toString())
              .flatMap(
                  (a) => go(a, extendedTopLevelScope, runr, s.stream).attempt())
              .flatMap((a) => a.fold(
                    (err) => goErr(err, view),
                    (a) => a(stepLegRunR(view)),
                  ));
        case final _GetScope _:
          return go(
            scope,
            extendedTopLevelScope,
            runner,
            getCont()(_Succeeded(scope)),
          );
        case final _Eval eval:
          // final view = contP as Fn1F<_Terminal<dynamic>, Pull<X, Unit>>;
          return goEval(eval, getCont());
        case final _Acquire acquire:
          return goAcquire(acquire, getCont());
        case final _InScope<X> inScope:
          final view = contP as Fn1F<_Terminal<Unit>, Pull<Never, Unit>>;
          return goInScope(inScope.stream, inScope.useInterruption, view);
        case final _InterruptWhen inter:
          return goInterruptWhen(inter.haltOnSignal, getCont());
        case final _CloseScope close:
          return goCloseScope(close, getCont());
        case final _Succeeded _:
          return runner.done(scope);
        case final _Fail failed:
          return runner.fail(failed.error);
        case final _Interrupted inter:
          return runner.interrupted(inter);
        default:
          throw UnimplementedError('Pull.compile.go: $vl');
      }
    }

    final runner = _OuterRun<O, B>(foldChunk, init, getCont, viewL, go);
    return go(initScope, none(), runner, stream);
  }
}

extension PullOps<O> on Pull<O, Unit> {
  Pull<O2, Unit> flatMapOutput<O2>(Fn1<O, Pull<O2, Unit>> f) {
    switch (this) {
      case final _AlgEffect<Unit> a:
        return a;
      case final _Terminal<Unit> r:
        return r;
      default:
        return _FlatMapOutput(this, f);
    }
  }

  Rill<O> rill() => Rill(Pull.scope(this));

  Rill<O> rillNoScope() => Rill(this);
}

Pull<O, S> _transformWith<O, R, S>(
  Pull<O, R> p,
  Function1<_Terminal<R>, Pull<O, S>> f,
) {
  if (p is _Terminal<R>) {
    try {
      return f(p);
    } catch (e, s) {
      return _Fail(IOError(e, s));
    }
  } else {
    return _BindF(p, (r) {
      try {
        return f(r);
      } catch (e, s) {
        return _Fail(IOError(e, s));
      }
    });
  }
}

mixin class _ViewL<O> {}

sealed class _Terminal<R> extends Pull<Never, R> with _ViewL<Never> {
  B fold<B>(Function1<_Succeeded, B> succeeded, Function1<_Fail, B> failed,
      Function1<_Interrupted, B> interrupted) {
    switch (this) {
      case final _Succeeded<R> s:
        return succeeded(s);
      case final _Fail f:
        return failed(f);
      case final _Interrupted i:
        return interrupted(i);
    }
  }
}

final class _Succeeded<R> extends _Terminal<R> {
  final R r;

  _Succeeded(this.r);
}

final class _Fail extends _Terminal<Never> {
  final IOError error;

  _Fail(this.error);
}

final class _Interrupted extends _Terminal<Never> {
  final UniqueToken context;
  final Option<IOError> deferredError;

  _Interrupted(this.context, this.deferredError);
}

typedef _Cont<Y, O> = Function1<_Terminal<Y>, Pull<O, Unit>>;
typedef _ContP<Y, O, X> = Fn1<_Terminal<Y>, Pull<O, X>>;

_ContP<Unit, A, Unit> _idContP<A>() => Fn1.of((a) => a);

abstract class _Bind<O, X, R> extends Pull<O, R> with _ContP<X, O, R> {
  final Pull<O, X> step;

  _Bind(this.step);

  _Bind<O, X, R> get delegate => this;
}

final class _BindF<O, X, R> extends _Bind<O, X, R> {
  final Function1<_Terminal<X>, Pull<O, R>> f;

  _BindF(super.step, this.f);

  @override
  Pull<O, R> call(_Terminal<X> r) => f(r);
}

final class _DelegateBind<O, Y> extends _Bind<O, Y, Unit> {
  final _Bind<O, Y, Unit> _delegate;

  _DelegateBind(super.step, this._delegate);

  @override
  _Bind<O, Y, Unit> get delegate => _delegate;

  @override
  Pull<O, Unit> call(_Terminal<Y> yr) => delegate(yr);
}

Pull<O, Unit> _bindView<O>(Pull<O, Unit> fmoc, _Cont<Unit, O> view) {
  // if (view is _IdContP) {
  //   return fmoc;
  // } else
  if (view is _Bind<O, Unit, Unit>) {
    if (fmoc is _Terminal<Unit>) {
      try {
        return view(fmoc);
      } catch (e, s) {
        return _Fail(IOError(e, s));
      }
    } else {
      return _DelegateBind(fmoc, (view as _Bind<O, Unit, Unit>).delegate);
    }
  } else {
    return _BindF(fmoc, (r) => view(r));
  }
}

class _BindBind<O, X, Y> extends _Bind<O, X, Unit> {
  final _Bind<O, X, Y> bb;
  final _Bind<O, Y, Unit> del;

  _BindBind(super.step, this.bb, this.del);

  @override
  Pull<O, Unit> call(_Terminal<X> tx) {
    try {
      return _bindBindAux(bb.call(tx), del);
    } catch (e, s) {
      return _Fail(IOError(e, s));
    }
  }
}

Pull<O, Unit> _bindBindAux<O, X>(Pull<O, X> py, _Bind<O, X, Unit> del) {
  if (py is _Terminal<X>) {
    if (del is _BindBind<O, dynamic, X>) {
      final cici = del as _BindBind<O, dynamic, X>;
      return _bindBindAux(cici.bb.call(py), cici.del);
    } else {
      return del.call(py);
    }
  } else {
    return _DelegateBind(py, del);
  }
}

sealed class _Action<O, R> extends Pull<O, R> with _ViewL<O> {}

final class _Output<O> extends _Action<O, Unit> {
  final IList<O> values;

  _Output(this.values);
}

final class _FlatMapOutput<O, O2> extends _Action<O2, Unit> {
  final Pull<O, Unit> stream;
  final Fn1<O, Pull<O2, Unit>> fun;

  _FlatMapOutput(this.stream, this.fun);
}

final class _Uncons<O> extends _Action<O, Unit> {
  final Pull<O, Unit> stream;

  _Uncons(this.stream);

  _Run<O, IO<_CallRun<O, IO<End>>>> buildR<End>() =>
      _TheBuildR() as _Run<O, IO<_CallRun<O, IO<End>>>>;
}

final class _StepLeg<O> extends _Action<Never, Option<StepLeg<O>>> {
  final Pull<O, Unit> stream;
  final UniqueToken scope;

  _StepLeg(this.stream, this.scope);

  _Run<O, IO<_CallRun<O, IO<End>>>> buildR<End>() =>
      _TheBuildR() as _Run<O, IO<_CallRun<O, IO<End>>>>;
}

sealed class _AlgEffect<R> extends _Action<Never, R> {}

final class _Eval<R> extends _AlgEffect<R> {
  final IO<R> value;

  _Eval(this.value);
}

final class _Acquire<R> extends _AlgEffect<R> {
  final IO<R> resource;
  final Function2<R, ExitCase, IO<Unit>> release;
  final bool cancelable;

  _Acquire(this.resource, this.release, this.cancelable);
}

final class _InScope<O> extends _Action<O, Unit> {
  final Pull<O, Unit> stream;
  final bool useInterruption;

  _InScope(this.stream, this.useInterruption);
}

final class _InterruptWhen extends _AlgEffect<Unit> {
  final IO<Either<IOError, Unit>> haltOnSignal;

  _InterruptWhen(this.haltOnSignal);
}

abstract class _CloseScope extends _AlgEffect<Unit> {
  UniqueToken get scopeId;
  Option<_Interrupted> get interruption;
  ExitCase get exitCase;
}

final class _SucceedScope extends _CloseScope {
  @override
  UniqueToken scopeId;

  _SucceedScope(this.scopeId);

  @override
  ExitCase get exitCase => ExitCase.succeeded();

  @override
  Option<_Interrupted> get interruption => none();
}

final class _CanceledScope extends _CloseScope {
  @override
  final UniqueToken scopeId;

  final _Interrupted inter;

  _CanceledScope(this.scopeId, this.inter);

  @override
  ExitCase get exitCase => ExitCase.canceled();

  @override
  Option<_Interrupted> get interruption => Some(inter);
}

final class _FailedScope extends _CloseScope {
  @override
  final UniqueToken scopeId;

  final IOError err;

  _FailedScope(this.scopeId, this.err);

  @override
  ExitCase get exitCase => ExitCase.errored(err);

  @override
  Option<_Interrupted> get interruption => none();
}

final class _GetScope extends _AlgEffect<Scope> {}

Pull<Never, Option<StepLeg<O>>> _stepLeg<O>(StepLeg<O> leg) =>
    _StepLeg(leg.next, leg.scopeId);

Pull<O, Unit> scope<O>(Pull<O, Unit> s) => _InScope(s, false);

Pull<O, Unit> interruptScope<O>(Pull<O, Unit> s) => _InScope(s, true);

Pull<O, Unit> interruptWhen<O>(IO<Either<IOError, Unit>> haltOnSignal) =>
    _InterruptWhen(haltOnSignal);

sealed class _Run<X, End> {
  End done(Scope scope);

  End out(IList<X> head, Scope scope, Pull<X, Unit> tail);

  End interrupted(_Interrupted inter);

  End fail(IOError error);
}

typedef _CallRun<X, End> = Function1<_Run<X, End>, End>;

final class _TheBuildR extends _Run<Never, IO<_CallRun<Never, IO<Never>>>> {
  @override
  IO<_CallRun<Never, IO<Never>>> done(Scope scope) =>
      IO.pure((run) => run.done(scope));

  @override
  IO<_CallRun<Never, IO<Never>>> fail(IOError error) => IO.raiseError(error);

  @override
  IO<_CallRun<Never, IO<Never>>> interrupted(_Interrupted inter) =>
      IO.pure((run) => run.interrupted(inter));

  @override
  IO<_CallRun<Never, IO<Never>>> out(
    IList<Never> head,
    Scope scope,
    Pull<Never, Unit> tail,
  ) =>
      IO.pure((run) => run.out(head, scope, tail));
}

class _OuterRun<O, B> extends _Run<O, IO<B>> {
  final Function2<B, IList<O>, B> foldChunk;
  final B initB;

  final Function0<_Cont<dynamic, Never>> getCont;
  final Function1<Pull<O, Unit>, _ViewL<O>> viewL;

  final Function4<Scope, Option<Scope>, _Run<O, IO<B>>, Pull<O, Unit>, IO<B>>
      go;

  B _accB;

  _OuterRun(
    this.foldChunk,
    this.initB,
    this.getCont,
    this.viewL,
    this.go,
  ) : _accB = initB;

  @override
  IO<B> done(Scope scope) => IO.pure(_accB);

  @override
  IO<B> fail(IOError error) => IO.raiseError(error);

  @override
  IO<B> interrupted(_Interrupted inter) => inter.deferredError
      .fold(() => IO.pure(_accB), (err) => IO.raiseError(err));

  @override
  IO<B> out(IList<O> head, Scope scope, Pull<O, Unit> tail) {
    try {
      _accB = foldChunk(_accB, head);
      return go(scope, none(), this, tail);
    } catch (e, s) {
      final viewTail = viewL(tail);
      final err = IOError(e, s);

      if (viewTail is _Action<O, dynamic>) {
        return go(scope, none(), this, getCont()(_Fail(err)));
      } else if (viewTail is _Succeeded) {
        return IO.raiseError(err);
      } else if (viewTail is _Fail) {
        return IO.raiseError(CompositeError.from(viewTail.error, err));
      } else if (viewTail is _Interrupted) {
        return IO.raiseError(viewTail.deferredError.fold(
            () => IOError(e, s), (err2) => CompositeError.from(err2, err)));
      } else {
        throw UnimplementedError('OuterRun.catch: $viewTail');
      }
    }
  }
}

class _RunF<Y, End> extends _Run<Y, IO<End>> {
  final Function1<Scope, IO<End>> doneF;
  final Function1<IOError, IO<End>> failF;
  final Function1<_Interrupted, IO<End>> interruptedF;
  final Function3<IList<Y>, Scope, Pull<Y, Unit>, IO<End>> outF;

  _RunF({
    required this.doneF,
    required this.failF,
    required this.interruptedF,
    required this.outF,
  });

  @override
  IO<End> done(Scope scope) => doneF(scope);

  @override
  IO<End> fail(IOError error) => failF(error);

  @override
  IO<End> interrupted(_Interrupted inter) => interruptedF(inter);

  @override
  IO<End> out(IList<Y> head, Scope scope, Pull<Y, Unit> tail) =>
      outF(head, scope, tail);
}

class _ViewRunner<X, End> extends _RunF<X, End> {
  _Cont<Unit, X> view;
  _Run<X, IO<End>> prevRunner;

  _ViewRunner({
    required this.view,
    required this.prevRunner,
    required super.doneF,
    required super.failF,
    required super.interruptedF,
    required super.outF,
  });

  @override
  IO<End> out(IList<X> head, Scope scope, Pull<X, Unit> tail) {
    IO<End> outLoop(Pull<X, Unit> acc, _Run<X, IO<End>> pred) {
      if (pred is _ViewRunner<X, End>) {
        return outLoop(_bindView(acc, pred.view), pred.prevRunner);
      } else {
        return pred.out(head, scope, acc);
      }
    }

    return outLoop(tail, this);
  }
}
