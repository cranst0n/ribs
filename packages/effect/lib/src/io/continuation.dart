part of '../io.dart';

/// Internal continuation types used by the IO runtime.
sealed class _Continuation {
  const _Continuation();
}

/// Represents a continuation for an attempted IO operation, containing both
/// the success and error handlers.
final class _AttemptK<A> extends _Continuation {
  final Fn1<A, Either<Object, A>> right;
  final Fn1<Object, Either<Object, A>> left;

  const _AttemptK(this.right, this.left);
}

/// Represents a continuation for cancelation handling, allowing the fiber to
/// continue the cancelation process.
final class _CancelationLoopK extends _Continuation {
  const _CancelationLoopK();
}

/// Represents a continuation for a flatMap operation, containing the function
/// to apply to the result of the previous IO operation.
final class _FlatMapK<A, B> extends _Continuation {
  final Fn1<A, IO<B>> fn;

  const _FlatMapK(this.fn);
}

final class _HandleErrorWithK<A> extends _Continuation {
  final Fn1<Object, IO<A>> fn;

  const _HandleErrorWithK(this.fn);
}

final class _MapK<A, B> extends _Continuation {
  final Fn1<A, B> fn;

  const _MapK(this.fn);
}

final class _OnCancelK extends _Continuation {
  const _OnCancelK();
}

final class _RunTerminusK extends _Continuation {
  const _RunTerminusK();
}

final class _UncancelableK extends _Continuation {
  const _UncancelableK();
}

final class _UnmaskK extends _Continuation {
  const _UnmaskK();
}
