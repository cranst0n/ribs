import 'package:ribs_core/ribs_core.dart';

/// Base type for errors that occur during binary decoding or encoding.
sealed class Err {
  String get message;
  IList<String> get context;

  String get messageWithContext =>
      (context.isEmpty ? '' : context.mkString(sep: '/', end: ': ')) + message;

  Err pushContext(String ctx);

  @override
  String toString() => messageWithContext;

  static Err general(String message) => General(message, nil());

  static Err insufficientBits(int needed, int have) => InsufficientBits(needed, have, nil());
}

/// A general-purpose codec error with a freeform [message].
final class General extends Err {
  @override
  final String message;
  @override
  final IList<String> context;

  General(this.message, this.context);

  @override
  Err pushContext(String ctx) => General(message, context.appended(ctx));
}

/// Error indicating that decoding requires more bits than are available.
final class InsufficientBits extends Err {
  final int needed;
  final int have;
  @override
  final IList<String> context;

  InsufficientBits(this.needed, this.have, this.context);

  @override
  String get message => 'cannot acquire $needed bits from a vector that contains $have bits';

  @override
  Err pushContext(String ctx) => InsufficientBits(have, needed, context.appended(ctx));
}
