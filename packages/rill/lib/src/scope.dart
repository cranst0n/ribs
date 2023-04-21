import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

class Scope {
  final UniqueToken id;
  final Option<Scope> parent;
  final Option<InterruptContext> interruptible;
  final Ref<_ScopeState> state;

  Scope._(this.id, this.parent, this.interruptible, this.state);

  static IO<Scope> create(
    UniqueToken id,
    Option<Scope> parent,
    Option<InterruptContext> interruptible,
  ) =>
      Ref.of(_ScopeState.initial)
          .map((state) => Scope._(UniqueToken(), parent, interruptible, state));

  static IO<Scope> newRoot() => create(UniqueToken(), none(), none());

  bool get isRoot => parent.isEmpty;

  int get level {
    int go(Scope scope, int acc) =>
        scope.parent.fold(() => acc, (a) => go(a, acc + 1));

    return go(this, 0);
  }

  IO<bool> _register(ScopedResource resource) => state.modify((s) => s.fold(
        (s) => (s.copy(resources: s.resources.prepend(resource)), true),
        () => (s, false),
      ));

  IO<Either<IOError, Scope>> open(bool interruptible) {
    IO<Scope> createScope() {
      final newScopeId = UniqueToken();

      return this.interruptible.fold(
        () {
          final optFCtx = Option.when(() => interruptible,
              () => InterruptContext.create(newScopeId, IO.unit));
          return optFCtx
              .sequence()
              .flatMap((iCtx) => Scope.create(newScopeId, Some(this), iCtx));
        },
        (parentICtx) {
          return parentICtx.childContext(interruptible, newScopeId).flatMap(
              (iCtx) => Scope.create(newScopeId, Some(this), Some(iCtx)));
        },
      );
    }

    return createScope().flatMap((scope) {
      return state.modify<Option<Scope>>((s) {
        return s.fold(
          (s) => (s.copy(children: s.children.prepend(scope)), Some(scope)),
          () => (s, none<Scope>()),
        );
      }).flatMap((s) {
        return s.fold(
          () => parent.fold(
            () => IO.pure(IOError('cannot re-open root scope').asLeft()),
            (parent) => this
                .interruptible
                .map((a) => a.cancelParent)
                .getOrElse(() => IO.unit)
                .productR(() => parent.open(interruptible)),
          ),
          (s) => IO.pure(s.asRight()),
        );
      });
    });
  }

  IO<Outcome<Either<UniqueToken, R>>> acquireResource<R>(
    Function1<Poll, IO<R>> acquire,
    Function2<R, ExitCase, IO<Unit>> release,
  ) {
    return interruptibleEval<Either<IOError, R>>(
        ScopedResource.create().flatMap((resource) {
      return IO.uncancelable((poll) {
        return acquire(poll).redeemWith(
          (err) => IO.pure(Left(err)),
          (r) {
            IO<Unit> finalizer(ExitCase ec) =>
                IO.uncancelable((_) => release(r, ec));

            return resource.acquired(finalizer).flatMap((result) {
              if (result.exists(identity)) {
                return _register(resource).flatMap((successful) => successful
                    ? IO.pure(Right(r))
                    : finalizer(ExitCase.canceled())
                        .as(Left(IOError('Acquire after scope closed'))));
              } else {
                return finalizer(ExitCase.canceled()).as(Left(result
                    .swap()
                    .getOrElse(() => IOError('Acquire after scope closed'))));
              }
            });
          },
        );
      });
    })).map(
      (either) => either.fold(
        (oc) => oc.fold(
          () => Outcome.canceled(),
          (err) => Outcome.errored(err),
          (token) => Outcome.succeeded(Left(token)),
        ),
        (e) => e.fold(
          (err) => Outcome.errored(err),
          (r) => Outcome.succeeded(Right(r)),
        ),
      ),
    );
  }

  IO<Unit> _releaseChildScope(UniqueToken id) =>
      state.update((s) => s.fold((s) => s.unregisterChild(id), () => s));

  IO<IList<ScopedResource>> _resources() => state.value().map((s) => s.fold(
        (s) => s.resources,
        () => IList.empty(),
      ));

  IO<Either<IOError, Unit>> _traverseError<A>(
    IList<A> ca,
    Function1<A, IO<Either<IOError, Unit>>> f,
  ) =>
      ca.traverseIO(f).map((results) => CompositeError.fromIList(
              results.foldLeft(
                  IList.empty<IOError>(),
                  (acc, elem) =>
                      elem.fold((err) => acc.append(err), (_) => acc)))
          .toLeft(() => Unit()));

  IO<Either<IOError, Unit>> close(ExitCase ec) =>
      state.modify((s) => (_ScopeState.closed, s)).flatMap((s) {
        return s.fold(
          (previous) => (
            _traverseError(previous.children, (a) => a.close(ec)),
            _traverseError(previous.resources, (a) => a.release(ec)),
            interruptible.map((a) => a.cancelParent).getOrElse(() => IO.unit),
            parent.fold(() => IO.unit, (a) => a._releaseChildScope(id)),
          )
              .mapN((resultChildren, resultResources, _, __) =>
                  CompositeError.fromResults(resultChildren, resultResources)),
          () => IO.pure(Right(Unit())),
        );
      });

  IO<Scope> _openScope() => state.value().flatMap((s) => s.fold(
        (_) => IO.pure(this),
        () => openAncestor(),
      ));

  IO<Scope> openAncestor() => parent.fold(
      () => IO.pure(this),
      (parent) => parent.state.value().flatMap((parentState) => parentState
          .fold((_) => IO.pure(parent), () => parent.openAncestor())));

  IList<Scope> get _ancestors {
    IList<Scope> go(Scope curr, IList<Scope> acc) => curr.parent.fold(
          () => acc,
          (parent) => go(parent, acc.append(parent)),
        );

    return go(this, IList.empty());
  }

  bool descendsFrom(UniqueToken scopeId) =>
      _findSelfOrAncestor(scopeId).isDefined;

  Option<Scope> _findSelfOrAncestor(UniqueToken scopeId) {
    Option<Scope> go(Scope curr) {
      if (curr.id == scopeId) {
        return Some(curr);
      } else {
        return curr.parent.fold(
          () => none(),
          (parent) => go(parent),
        );
      }
    }

    return go(this);
  }

  IO<Option<Scope>> findInLineage(UniqueToken scopeId) => IO
      .pure(_findSelfOrAncestor(scopeId))
      .orElse(() => _findSelfOrChild(scopeId));

  IO<Option<Scope>> _findSelfOrChild(UniqueToken scopeId) {
    IO<Option<Scope>> go(IList<Scope> scopes) {
      return scopes.uncons((x) => x.fold(
            () => IO.pure(none()),
            (x) {
              final (scope, tail) = x;

              if (scope.id == scopeId) {
                return IO.pure(Some(scope));
              } else {
                return scope.state.value().flatMap((s) => s.fold(
                      (s) {
                        if (s.children.isEmpty) {
                          return go(tail);
                        } else {
                          return go(s.children).flatMap((scope) => scope.fold(
                                () => go(tail),
                                (scope) => IO.pure(Some(scope)),
                              ));
                        }
                      },
                      () => go(tail),
                    ));
              }
            },
          ));
    }

    if (id == scopeId) {
      return IO.pure(Some(this));
    } else {
      return state.value().flatMap((s) => s.fold(
            (s) => go(s.children),
            () => IO.pure(none()),
          ));
    }
  }

  IO<Scope> shiftScope(UniqueToken scopeId, String context) =>
      findStepScope(scopeId).flatMap(
        (s) => s.fold(
          () => IO.raiseError(IOError(
              "Scope lookup failed! Scope ID: $scopeId, Step: $context")),
          (scope) => IO.pure(scope),
        ),
      );

  IO<Option<Scope>> findStepScope(UniqueToken scopeId) {
    Scope go(Scope scope) =>
        scope.parent.fold(() => scope, (parent) => go(parent));

    if (scopeId == id) {
      return IO.pure(Some(this));
    } else {
      return parent.fold(
        () => _findSelfOrChild(scopeId),
        (parent) => parent._findSelfOrChild(scopeId).flatMap((s) => s.fold(
            () => go(this)._findSelfOrChild(scopeId),
            (scope) => IO.pure(Some(scope)))),
      );
    }
  }

  IO<IOFiber<Unit>> interruptWhen(IO<Either<IOError, Unit>> haltWhen) =>
      interruptible.fold(
        () => IO.pure(IOFiber(IO.unit)),
        (iCtx) {
          final outcome = haltWhen.map((a) => a.fold(
                (err) => Outcome.errored<UniqueToken>(err),
                (_) => Outcome.succeeded(iCtx.interruptRoot),
              ));

          return iCtx.completeWhen(outcome);
        },
      );

  IO<Option<InterruptionOutcome>> get isInterrupted =>
      _openScope().flatMap((scope) => scope.interruptible.fold(
            () => IO.pure(none()),
            (iCtx) => iCtx.ref.value(),
          ));

  IO<Either<InterruptionOutcome, A>> interruptibleEval<A>(IO<A> f) =>
      _openScope().map((a) => a.interruptible).flatMap((iCtx) => iCtx.fold(
            () => f
                .attempt()
                .map((a) => a.leftMap((err) => Outcome.errored(err))),
            (iCtx) => iCtx.eval(f),
          ));

  IO<Lease> lease() {
    return state.value().flatMap((s) {
      final children = s.fold(
        (x) => IO.pure(x.children),
        () => IO
            .raiseError<IList<Scope>>(IOError('Scope closed at time of lease')),
      );

      return children.flatMap((children) {
        return children
            .append(this)
            .concat(_ancestors)
            .flatTraverseIO((scope) => scope._resources())
            .flatMap((res) => res.traverseFilterIO((a) => a.lease()))
            .map((l) => Lease.of(_traverseError(l, (a) => a.cancel())));
      });
    });
  }

  @override
  String toString() => 'Scope(id=$id,interruptible=${interruptible.nonEmpty})';
}

sealed class _ScopeState {
  static final _ScopeState initial = _ScopeOpen(IList.empty(), IList.empty());
  static final _ScopeState closed = _ScopeClosed();

  B fold<B>(Function1<_ScopeOpen, B> ifOpen, Function0<B> ifClosed);
}

final class _ScopeOpen extends _ScopeState {
  final IList<ScopedResource> resources;
  final IList<Scope> children;

  _ScopeOpen(this.resources, this.children);

  _ScopeState unregisterChild(UniqueToken id) =>
      children.deleteFirst((a) => a.id == id).fold(
            () => this,
            (result) => copy(children: result.$2),
          );

  @override
  B fold<B>(Function1<_ScopeOpen, B> ifOpen, Function0<B> ifClosed) =>
      ifOpen(this);

  _ScopeOpen copy({
    IList<ScopedResource>? resources,
    IList<Scope>? children,
  }) =>
      _ScopeOpen(
        resources ?? this.resources,
        children ?? this.children,
      );
}

final class _ScopeClosed extends _ScopeState {
  @override
  B fold<B>(Function1<_ScopeOpen, B> ifOpen, Function0<B> ifClosed) =>
      ifClosed();
}
