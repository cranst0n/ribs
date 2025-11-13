import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Type to encode the result of an [IO] fiber. A fiber can complete in one of
/// 3 ways:
///
/// * [Succeeded]: The fiber completed normally, yielding a value
/// * [Errored]: The fiber encountered an error/exception
/// * [Canceled]: The fiber was canceled before it was able to complete.
sealed class Outcome<A> {
  const Outcome();

  /// Creates a [Succeeded] cast as an [Outcome];
  static Outcome<A> succeeded<A>(A a) => Succeeded(a);

  /// Creates a [Errored] cast as an [Outcome];
  static Outcome<A> errored<A>(RuntimeException error) => Errored(error);

  /// Creates a [Canceled] cast as an [Outcome];
  static Outcome<A> canceled<A>() => Canceled();

  /// Returns an [IO] that will resolve to [onCancel] if the outcome if a
  /// [Canceled], raise an error if the outcome is [Errored] or return the
  /// successful value if the outcome is [Succeeded].
  IO<A> embed(IO<A> onCancel) => fold(
        () => onCancel,
        (err) => IO.raiseError(err),
        (a) => IO.pure(a),
      );

  /// Returns an [IO] that will never complete if the outcome is a [Canceled].
  IO<A> embedNever() => embed(IO.never());

  /// Applies the appropriate function to the instance of this Outcome.
  ///
  /// [canceled] will be applied if this instance is a [Canceled].
  /// [errored] will be applied if this instance is a [Errored].
  /// [succeeded] will be applied if this instance is a [Succeeded].
  B fold<B>(
    Function0<B> canceled,
    Function1<RuntimeException, B> errored,
    Function1<A, B> succeeded,
  );

  /// Returns `true` if this instance is a [Canceled], `false` otherwise.
  bool get isCanceled => fold(() => true, (_) => false, (_) => false);

  /// Returns `true` if this instance is a [Errored], `false` otherwise.
  bool get isError => fold(() => false, (_) => true, (_) => false);

  /// Returns `true` if this instance is a [Succeeded], `false` otherwise.
  bool get isSuccess => fold(() => false, (_) => false, (_) => true);

  /// Returns `true` if this instance is the same kind of outcome as [other].
  /// This will *not* take the wrapped values into consideration of equality.
  /// Any 2 [Succeeded] instances will result is true being returned, as well
  /// as any 2 [Errored] or [Canceled].
  bool isSameType<B>(Outcome<B> other) =>
      (isSuccess && other.isSuccess) ||
      (isError && other.isError) ||
      (isCanceled && other.isCanceled);

  @override
  String toString() => fold(
        () => 'Canceled',
        (err) => 'Errored($err)',
        (value) => 'Succeeded($value)',
      );

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Succsseful [Outcome] of an [IO] evaluation, yielding a result.
final class Succeeded<A> extends Outcome<A> {
  /// The successful value.
  final A value;

  const Succeeded(this.value);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<RuntimeException, B> errored,
    Function1<A, B> succeeded,
  ) =>
      succeeded(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Succeeded && other.value == value);

  @override
  int get hashCode => value.hashCode;
}

/// Failed [Outcome] of an [IO] evaluation, with the [RuntimeException] that caused it.
final class Errored<A> extends Outcome<A> {
  /// The underlying error.
  final RuntimeException error;

  const Errored(this.error);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<RuntimeException, B> errored,
    Function1<A, B> succeeded,
  ) =>
      errored(error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Errored && other.error == error);

  @override
  int get hashCode => error.hashCode;
}

/// [IO] [Outcome] when it was canceled before completion.
final class Canceled<A> extends Outcome<A> {
  Canceled();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<RuntimeException, B> errored,
    Function1<Never, B> succeeded,
  ) =>
      canceled();

  @override
  bool operator ==(Object other) => other is Canceled;

  @override
  int get hashCode => 0;
}
