import 'package:ribs_core/ribs_core.dart';

sealed class Outcome<A> {
  const Outcome();

  // factory Outcome.succeeded(A a) => Succeeded(a);
  // factory Outcome.errored(IOError error) => Errored<A>(error);
  // factory Outcome.canceled() => const Canceled();

  static Outcome<A> succeeded<A>(A a) => Succeeded(a);
  static Outcome<A> errored<A>(IOError error) => Errored(error);
  static Outcome<A> canceled<A>() => const Canceled();

  IO<A> embed(IO<A> onCancel) => fold(
        () => onCancel,
        (err) => IO.raiseError(err),
        (a) => IO.pure(a),
      );

  IO<A> embedNever() => embed(IO.never());

  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  );

  bool get isCanceled => fold(() => true, (_) => false, (_) => false);
  bool get isError => fold(() => false, (_) => true, (_) => false);
  bool get isSuccess => fold(() => false, (_) => false, (_) => true);

  @override
  String toString() => fold(
        () => 'Canceled',
        (err) => 'Errored($err)',
        (value) => 'Succeeded($value)',
      );

  @override
  bool operator ==(dynamic other);

  @override
  int get hashCode;
}

final class Succeeded<A> extends Outcome<A> {
  final A value;

  const Succeeded(this.value);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  ) =>
      succeeded(value);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Succeeded && other.value == this.value);

  @override
  int get hashCode => value.hashCode;
}

final class Errored<A> extends Outcome<A> {
  final IOError error;

  const Errored(this.error);

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function1<A, B> succeeded,
  ) =>
      errored(error);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || (other is Errored && other.error == this.error);

  @override
  int get hashCode => error.hashCode;
}

final class Canceled extends Outcome<Never> {
  const Canceled();

  @override
  B fold<B>(
    Function0<B> canceled,
    Function1<IOError, B> errored,
    Function1<Never, B> succeeded,
  ) =>
      canceled();

  @override
  bool operator ==(dynamic other) => other is Canceled;

  @override
  int get hashCode => 0;
}
