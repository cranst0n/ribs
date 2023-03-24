import 'package:ribs_core/ribs_core.dart';

abstract class Outcome<A> {
  const Outcome();

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

class Succeeded<A> extends Outcome<A> {
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

class Errored<A> extends Outcome<A> {
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

class Canceled extends Outcome<Never> {
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
