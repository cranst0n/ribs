part of '../io.dart';

/// Internal resumption types used by the IO runtime.
sealed class _Resumption {
  const _Resumption();
}

/// Represents a successful asynchronous resumption with the provided value.
final class _AsyncContinueSuccessfulR<A> extends _Resumption {
  final A value;

  const _AsyncContinueSuccessfulR(this.value);
}

/// Represents a failed asynchronous resumption with the provided error.
final class _AsyncContinueFailedR extends _Resumption {
  final Object error;

  const _AsyncContinueFailedR(this.error);
}

/// Represents a canceled asynchronous resumption.
final class _AsyncContinueCanceledR extends _Resumption {
  const _AsyncContinueCanceledR();
}

/// Represents an asynchronous resumption that was canceled, but includes a finalizer to run.
final class _AsyncContinueCanceledWithFinalizerR extends _Resumption {
  final Fn1<Either<Object, Unit>, void> fin;

  const _AsyncContinueCanceledWithFinalizerR(this.fin);
}

/// Represents an automatic yielded resumption, where the fiber is yielding
/// control to allow other fibers to run.
final class _AutoCedeR extends _Resumption {
  const _AutoCedeR();
}

/// Represents a manually yielded resumption, where the fiber is yielding
/// control to allow other fibers to run.
final class _CedeR extends _Resumption {
  const _CedeR();
}

/// Represents a resumption that indicates the fiber has completed its execution.
final class _DoneR extends _Resumption {
  const _DoneR();
}

/// Represents a resumption to continue executing the fiber.
final class _ExecR extends _Resumption {
  const _ExecR();
}
