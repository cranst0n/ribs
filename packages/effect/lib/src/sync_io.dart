import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/std/internal/stack.dart';

sealed class SyncIO<A> with Functor<A>, Applicative<A>, Monad<A> {
  static SyncIO<A> delay<A>(Function0<A> thunk) => _Suspend(Fn0(thunk));

  static SyncIO<A> pure<A>(A a) => _Pure(a);

  static SyncIO<A> raiseError<A>(RuntimeException error) => _Error(error);

  SyncIO<B> as<B>(B b) => map((_) => b);

  SyncIO<Either<RuntimeException, A>> attempt() => _Attempt(this);

  @override
  SyncIO<B> flatMap<B>(covariant Function1<A, SyncIO<B>> f) => _FlatMap(this, Fn1(f));

  SyncIO<A> handleError(Function1<RuntimeException, A> f) =>
      handleErrorWith((e) => SyncIO.pure(f(e)));

  SyncIO<A> handleErrorWith(covariant Function1<RuntimeException, SyncIO<A>> f) =>
      _HandleErrorWith(this, Fn1(f));

  @override
  SyncIO<B> map<B>(covariant Function1<A, B> f) => _Map(this, Fn1(f));

  SyncIO<A> productL<B>(Function0<SyncIO<B>> that) => flatMap((a) => that().as(a));

  SyncIO<B> productR<B>(Function0<SyncIO<B>> that) => flatMap((_) => that());

  SyncIO<B> redeem<B>(Function1<RuntimeException, B> recover, Function1<A, B> map) =>
      attempt().map((a) => a.fold(recover, map));

  SyncIO<B> redeemWith<B>(
    Function1<RuntimeException, SyncIO<B>> recover,
    Function1<A, SyncIO<B>> bind,
  ) => attempt().flatMap((a) => a.fold(recover, bind));

  SyncIO<Unit> voided() => map((_) => Unit());

  A unsafeRunSync() => runLoop();

  A runLoop() {
    final conts = Stack<_Cont>();
    final objectState = Stack<dynamic>();

    conts.push(_Cont.RunTerminus);

    SyncIO<dynamic> cur0 = this;

    while (true) {
      if (cur0 is _Pure) {
        cur0 = succeeded(conts, objectState, cur0.value, 0);
      } else if (cur0 is _Suspend) {
        dynamic result;
        RuntimeException? error;

        try {
          result = cur0.thunk();
        } catch (e, s) {
          error = RuntimeException(e, s);
        }

        cur0 =
            error == null
                ? succeeded(conts, objectState, result, 0)
                : failed(conts, objectState, error, 0);
      } else if (cur0 is _Error) {
        cur0 = failed(conts, objectState, cur0.value, 0);
      } else if (cur0 is _Map) {
        objectState.push(cur0.f);
        conts.push(_Cont.Map);
        cur0 = cur0.ioa;
      } else if (cur0 is _FlatMap) {
        objectState.push(cur0.f);
        conts.push(_Cont.FlatMap);
        cur0 = cur0.ioa;
      } else if (cur0 is _HandleErrorWith) {
        objectState.push(cur0.f);
        conts.push(_Cont.HandleErrorWith);
        cur0 = cur0.ioa;
      } else if (cur0 is _Success) {
        return cur0.value as A;
      } else if (cur0 is _Failure) {
        throw cur0.ex;
      } else if (cur0 is _Attempt) {
        final attempt = cur0;

        // Push this function on to allow proper type tagging when running
        // the continuation
        objectState.push(Fn1((x) => attempt.smartCast(x)));
        conts.push(_Cont.Attempt);
        cur0 = cur0.ioa;
      } else {
        throw StateError('SyncIO.runLoop: $cur0');
      }
    }
  }

  // todo: tailrec
  SyncIO<dynamic> succeeded(
    Stack<_Cont> conts,
    Stack<dynamic> objectState,
    dynamic result,
    int depth,
  ) {
    switch (conts.pop()) {
      case _Cont.Map:
        return mapK(conts, objectState, result, depth);
      case _Cont.FlatMap:
        return flatMapK(conts, objectState, result, depth);
      case _Cont.HandleErrorWith:
        objectState.pop();
        return succeeded(conts, objectState, result, depth);
      case _Cont.RunTerminus:
        return _Success(result);
      case _Cont.Attempt:
        final f = objectState.pop() as Fn1;
        return succeeded(
          conts,
          objectState,
          f(result),
          depth + 1,
        );
    }
  }

  SyncIO<dynamic> failed(
    Stack<_Cont> conts,
    Stack<dynamic> objectState,
    RuntimeException error,
    int depth,
  ) {
    var cont = conts.pop();

    // Drop all the maps / flatMaps since they don't deal with errors
    while (cont == _Cont.Map || cont == _Cont.FlatMap && conts.nonEmpty) {
      objectState.pop();
      cont = conts.pop();
    }

    switch (cont) {
      case _Cont.Map:
      case _Cont.FlatMap:
        objectState.pop();
        return failed(conts, objectState, error, depth);
      case _Cont.HandleErrorWith:
        final f = objectState.pop() as Fn1;

        try {
          return f(error) as SyncIO<dynamic>;
        } catch (e, s) {
          return failed(conts, objectState, RuntimeException(e, s), depth + 1);
        }
      case _Cont.RunTerminus:
        return _Failure(error);
      case _Cont.Attempt:
        // TODO: pop function to get proper Either cast
        final f = objectState.pop() as Fn1;

        return succeeded(
          conts,
          objectState,
          f(error),
          depth + 1,
        );
    }
  }

  SyncIO<dynamic> mapK(
    Stack<_Cont> conts,
    Stack<dynamic> objectState,
    dynamic result,
    int depth,
  ) {
    final f = objectState.pop() as Fn1;

    dynamic transformed;
    RuntimeException? error;

    try {
      transformed = f(result);
    } catch (e, s) {
      error = RuntimeException(e, s);
    }

    if (depth > _DefaultMaxStackDepth) {
      if (error == null) {
        return _Pure(transformed);
      } else {
        return _Error(error);
      }
    } else {
      if (error == null) {
        return succeeded(conts, objectState, transformed, depth + 1);
      } else {
        return failed(conts, objectState, error, depth + 1);
      }
    }
  }

  SyncIO<dynamic> flatMapK(
    Stack<_Cont> conts,
    Stack<dynamic> objectState,
    dynamic result,
    int depth,
  ) {
    final f = objectState.pop() as Fn1;

    try {
      return f(result) as SyncIO<dynamic>;
    } catch (e, s) {
      return failed(conts, objectState, RuntimeException(e, s), depth + 1);
    }
  }

  static const int _DefaultMaxStackDepth = 512;
}

final class _Pure<A> extends SyncIO<A> {
  final A value;

  _Pure(this.value);
}

final class _Error<A> extends SyncIO<A> {
  final RuntimeException value;

  _Error(this.value);
}

final class _Suspend<A> extends SyncIO<A> {
  final Fn0<A> thunk;

  _Suspend(this.thunk);
}

final class _Map<A, B> extends SyncIO<B> {
  final SyncIO<A> ioa;
  final Fn1<A, B> f;

  _Map(this.ioa, this.f);
}

final class _FlatMap<A, B> extends SyncIO<B> {
  final SyncIO<A> ioa;
  final Fn1<A, SyncIO<B>> f;

  _FlatMap(this.ioa, this.f);
}

final class _Attempt<A> extends SyncIO<Either<RuntimeException, A>> {
  final SyncIO<A> ioa;

  Either<RuntimeException, A> smartCast(dynamic value) =>
      value is RuntimeException ? value.asLeft() : (value as A).asRight();

  _Attempt(this.ioa);

  @override
  String toString() => 'Attempt($ioa)';
}

final class _HandleErrorWith<A> extends SyncIO<A> {
  final SyncIO<A> ioa;
  final Fn1<RuntimeException, SyncIO<A>> f;

  _HandleErrorWith(this.ioa, this.f);

  @override
  String toString() => 'HandleErrorWith($ioa, $f)';
}

final class _Success<A> extends SyncIO<A> {
  final A value;

  _Success(this.value);
}

final class _Failure<A> extends SyncIO<A> {
  final RuntimeException ex;

  _Failure(this.ex);
}

enum _Cont {
  Map,
  FlatMap,
  HandleErrorWith,
  RunTerminus,
  Attempt,
}
