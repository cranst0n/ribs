class DecodeFailure implements Exception {
  final Object message;
  final StackTrace stackTrace;

  DecodeFailure(this.message, [StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => message.toString();
}
