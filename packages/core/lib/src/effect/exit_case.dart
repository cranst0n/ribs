import 'package:ribs_core/ribs_core.dart';

sealed class ExitCase {
  const ExitCase();

  factory ExitCase.succeeded() => const _Succeeded();
  factory ExitCase.errored(IOError error) => _Errored(error);
  factory ExitCase.canceled() => const _Canceled();

  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function0<B> succeeded,
  );

  bool get isCanceled => fold(() => true, (_) => false, () => false);
  bool get isError => fold(() => false, (_) => true, () => false);
  bool get isSuccess => fold(() => false, (_) => false, () => true);

  Outcome<Unit> toOutcome() => fold(
        () => Outcome.canceled(),
        (err) => Outcome.errored(err),
        () => Outcome.succeeded(Unit()),
      );

  static ExitCase fromOutcome<A>(Outcome<A> outcome) => outcome.fold(
        () => const _Canceled(),
        (err) => _Errored(err),
        (_) => const _Succeeded(),
      );
}

final class _Succeeded extends ExitCase {
  const _Succeeded();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function0<B> succeeded,
  ) =>
      succeeded();
}

final class _Errored extends ExitCase {
  final IOError error;

  const _Errored(this.error);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function0<B> succeeded,
  ) =>
      errored(error);
}

final class _Canceled extends ExitCase {
  const _Canceled();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function0<B> succeeded,
  ) =>
      canceled();
}
