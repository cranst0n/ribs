import 'package:ribs_core/ribs_core.dart';

enum Status {
  // 1xx
  Continue._(100, 'Continue', isEntityAllowed: false),
  SwitchingProtocols._(101, 'Switching Protocols', isEntityAllowed: false),
  Processing._(102, 'Processing', isEntityAllowed: false),
  EarlyHints._(103, 'Earl yHints', isEntityAllowed: false),
  // 2xx
  Ok._(200, 'OK'),
  Created._(201, 'Created'),
  Accepted._(202, 'Accepted'),
  NonAuthoritativeInformation._(203, 'Non-Authoritative Information'),
  NoContent._(204, 'No Content', isEntityAllowed: false),
  ResetContent._(205, 'Reset Content', isEntityAllowed: false),
  PartialContent._(206, 'Partial Content'),
  MultiStatus._(207, 'Multi-Status'),
  AlreadyReported._(208, 'Already Reported'),
  IMUsed._(226, 'IM Used'),
  // 3xx
  MultipleChoices._(300, 'Multiple Choices'),
  MovedPermanently._(301, 'Moved Permanently'),
  Found._(302, 'Found'),
  SeeOther._(303, 'See Other'),
  NotModified._(304, 'Not Modified', isEntityAllowed: false),
  UseProxy._(305, 'Use Proxy'),
  TemporaryRedirect._(307, 'Temporary Redirect'),
  PermanentRedirect._(308, 'Permanent Redirect'),
  // 4xx
  BadRequest._(400, 'BadRequest'),
  Unauthorized._(401, 'Unauthorized'),
  PaymentRequired._(402, 'Payment Required'),
  Forbidden._(403, 'Forbidden'),
  NotFound._(404, 'Not Found'),
  MethodNotAllowed._(405, 'Method Not Allowed'),
  NotAcceptable._(406, 'Not Acceptable'),
  ProxyAuthenticationRequired._(407, 'Proxy Authentication Required'),
  RequestTimeout._(408, 'Request Timeout'),
  Conflict._(409, 'Conflict'),
  Gone._(410, 'Gone'),
  LengthRequired._(411, 'Length Required'),
  PreconditionFailed._(412, 'Precondition Failed'),
  PayloadTooLarge._(413, 'Payload Too Large'),
  UriTooLong._(414, 'URI Too Long'),
  UnsupportedMediaType._(415, 'Unsupported Media Type'),
  RangeNotSatisfiable._(416, 'Range Not Satisfiable'),
  ExpectationFailed._(417, 'Expectation Failed'),
  ImATeapot._(418, "I'm A Teapot"),
  MisdirectedRequest._(421, 'Misdirected Request'),
  UnprocessableEntity._(422, 'Unprocessable Entity'),
  Locked._(423, 'Locked'),
  FailedDependency._(424, 'Failed Dependency'),
  TooEarly._(425, 'Too Early'),
  UpgradeRequired._(426, 'Upgrade Required'),
  PreconditionRequired._(428, 'Precondition Required'),
  TooManyRequests._(429, 'Too Many Requests'),
  RequestHeaderFieldsTooLarge._(431, 'Request Header Fields Too Large'),
  UnavailableForLegalReasons._(451, 'Unavailable For Legal Reasons'),
  // 5xx
  InternalServerError._(500, 'Internal Server Error'),
  NotImplemented._(500, 'Not Implemented'),
  BadGateway._(502, 'Bad Gateway'),
  ServiceUnavailable._(503, 'Service Unavailable'),
  GatewayTimeout._(504, 'Gateway Timeout'),
  HttpVersionNotSupported._(505, 'HTTP Version not supported'),
  VariantAlsoNegotiates._(506, 'Variant Also Negotiates'),
  InsufficientStorage._(507, 'Insufficient Storage'),
  LoopDetected._(508, 'Loop Detected'),
  NotExtended._(510, 'Not Extended'),
  NetworkAuthenticationRequired._(511, "Network Authentication Required"),
  ;

  final int code;
  final String reason;
  final bool isEntityAllowed;

  const Status._(this.code, this.reason, {this.isEntityAllowed = true});

  static Either<String, Status> fromInt(int code) => ilist(values)
      .find((status) => status.code == code)
      .toRight(() => 'Invalid Status Code: $code');

  bool get isSuccess => responseClass.isSuccess;

  ResponseClass get responseClass => switch (code) {
        _ when code < 200 => ResponseClass.informational,
        _ when code < 300 => ResponseClass.successful,
        _ when code < 400 => ResponseClass.redirection,
        _ when code < 500 => ResponseClass.clientError,
        _ => ResponseClass.serverError,
      };
}

enum ResponseClass {
  informational(true),
  successful(true),
  redirection(true),
  clientError(false),
  serverError(false),
  ;

  final bool isSuccess;

  const ResponseClass(this.isSuccess);
}
