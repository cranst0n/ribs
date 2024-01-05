import 'package:ribs_core/ribs_core.dart';

sealed class Err {
  String get message;
  IList<String> get context;

  String get messageWithContext =>
      (context.isEmpty ? '' : context.mkString(sep: '/', end: ': ')) + message;

  Err pushContext(String ctx);

  @override
  String toString() => messageWithContext;

  static Err general(String message) => General(message, nil());

  static Err insufficientBits(int needed, int have) =>
      InsufficientBits(needed, have, nil());
}

final class General extends Err {
  @override
  final String message;
  @override
  final IList<String> context;

  General(this.message, this.context);

  @override
  Err pushContext(String ctx) => General(message, context.appended(ctx));
}

final class InsufficientBits extends Err {
  final int needed;
  final int have;
  @override
  final IList<String> context;

  InsufficientBits(this.needed, this.have, this.context);

  @override
  String get message =>
      'cannot acquire $needed bits from a vector that contains $have bits';

  @override
  Err pushContext(String ctx) =>
      InsufficientBits(have, needed, context.appended(ctx));
}
