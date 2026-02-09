part of '../io.dart';

sealed class _Resumption {
  const _Resumption();
}

final class _ExecR extends _Resumption {
  const _ExecR();
}

final class _AsyncContinueSuccessfulR<A> extends _Resumption {
  final A value;

  const _AsyncContinueSuccessfulR(this.value);
}

final class _AsyncContinueFailedR extends _Resumption {
  final Object error;

  const _AsyncContinueFailedR(this.error);
}

final class _AsyncContinueCanceledR extends _Resumption {
  const _AsyncContinueCanceledR();
}

final class _AsyncContinueCanceledWithFinalizerR extends _Resumption {
  final Fn1<Either<Object, Unit>, void> fin;

  const _AsyncContinueCanceledWithFinalizerR(this.fin);
}

final class _CedeR extends _Resumption {
  const _CedeR();
}

final class _AutoCedeR extends _Resumption {
  const _AutoCedeR();
}

final class _DoneR extends _Resumption {
  const _DoneR();
}
