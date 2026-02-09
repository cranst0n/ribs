import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Represents the outcome of performing some kind of computation. The exit
/// case can be one of 3 states:
///
/// * succeeded
/// * errored
/// * canceled
sealed class ExitCase {
  const ExitCase();

  /// Creates an [ExitCase] to signal a successful completion.
  factory ExitCase.succeeded() => const _Succeeded();

  /// Creates an [ExitCase] to signal an error was encountered.
  factory ExitCase.errored(Object error, [StackTrace? stackTrace]) => _Errored(error, stackTrace);

  /// Creates an [ExitCase] to signal a cancelation.
  factory ExitCase.canceled() => const _Canceled();

  /// Applies the appropriate function to the instance of this [ExitCase].
  ///
  /// [canceled] will be applied if this instance signals cancelation.
  /// [errored] will be applied if this instance signals error.
  /// [succeeded] will be applied if this instance signals success.
  B fold<B>(
    Function0<B> canceled,
    Function2<Object, StackTrace?, B> errored,
    Function0<B> succeeded,
  );

  /// Returns `true` if this instance signals cancelation, `false` otherwise.
  bool get isCanceled => fold(() => true, (_, _) => false, () => false);

  /// Returns `true` if this instance signals an error, `false` otherwise.
  bool get isError => fold(() => false, (_, _) => true, () => false);

  /// Returns `true` if this instance signals success, `false` otherwise.
  bool get isSuccess => fold(() => false, (_, _) => false, () => true);

  /// Converts this [ExitCase] to an [Outcome], supplying [Unit] as a
  /// successful value.
  Outcome<Unit> toOutcome() => fold(
    () => Outcome.canceled(),
    (err, stackTrace) => Outcome.errored(err, stackTrace),
    () => Outcome.succeeded(Unit()),
  );

  /// Converts [outcome] to an [ExitCase].
  static ExitCase fromOutcome<A>(Outcome<A> outcome) => outcome.fold(
    () => const _Canceled(),
    (err, stackTrace) => _Errored(err, stackTrace),
    (_) => const _Succeeded(),
  );
}

final class _Succeeded extends ExitCase {
  const _Succeeded();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function2<Object, StackTrace?, B> errored,
    Function0<B> succeeded,
  ) => succeeded();
}

final class _Errored extends ExitCase {
  final Object error;
  final StackTrace? stackTrace;

  const _Errored(this.error, [this.stackTrace]);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function2<Object, StackTrace?, B> errored,
    Function0<B> succeeded,
  ) => errored(error, stackTrace);

  @override
  String toString() => 'Errored: $error';
}

final class _Canceled extends ExitCase {
  const _Canceled();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function2<Object, StackTrace?, B> errored,
    Function0<B> succeeded,
  ) => canceled();
}
