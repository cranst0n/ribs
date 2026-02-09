part of '../io.dart';

sealed class _Continuation {
  const _Continuation();
}

final class _MapK<A, B> extends _Continuation {
  final Fn1<A, B> fn;

  const _MapK(this.fn);
}

final class _FlatMapK<A, B> extends _Continuation {
  final Fn1<A, IO<B>> fn;

  const _FlatMapK(this.fn);
}

final class _CancelationLoopK extends _Continuation {
  const _CancelationLoopK();
}

final class _RunTerminusK extends _Continuation {
  const _RunTerminusK();
}

final class _HandleErrorWithK<A> extends _Continuation {
  final Fn1<Object, IO<A>> fn;

  const _HandleErrorWithK(this.fn);
}

final class _OnCancelK extends _Continuation {
  const _OnCancelK();
}

final class _UncancelableK extends _Continuation {
  const _UncancelableK();
}

final class _UnmaskK extends _Continuation {
  const _UnmaskK();
}

final class _AttemptK<A> extends _Continuation {
  final Fn1<A, Either<Object, A>> right;
  final Fn1<Object, Either<Object, A>> left;

  const _AttemptK(this.right, this.left);
}
