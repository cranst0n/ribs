enum Method {
  ACL._idempotent('ACL'),
  BASELINE_CONTROL._idempotent('BASELINE-CONTROL'),
  BIND._idempotent('BIND'),
  CHECKIN._idempotent('CHECKIN'),
  CHECKOUT._idempotent('CHECKOUT'),
  CONNECT._('CONNECT'),
  COPY._idempotent('COPY'),
  DELETE._idempotent('DELETE'),
  GET._safe('GET'),
  HEAD._safe('HEAD'),
  LABEL._idempotent('LABEL'),
  LINK._idempotent('LINK'),
  LOCK._('LOCK'),
  MERGE._idempotent('MERGE'),
  MKACTIVITY._idempotent('MKACTIVITY'),
  MKCALENDAR._idempotent('MKCALENDAR'),
  MKCOL._idempotent('MKCOL'),
  MKREDIRECTREF._idempotent('MKREDIRECTREF'),
  MKWORKSPACE._idempotent('MKWORKSPACE'),
  MOVE._idempotent('MOVE'),
  OPTIONS._safe('OPTIONS'),
  ORDERPATCH._idempotent('ORDERPATCH'),
  PATCH._('PATCH'),
  POST._('POST'),
  PRI._safe('PRI'),
  PROPFIND._safe('PROPFIND'),
  PROPPATCH._idempotent('PROPPATCH'),
  PUT._idempotent('PUT'),
  REBIND._idempotent('REBIND'),
  REPORT._safe('REPORT'),
  SEARCH._safe('SEARCH'),
  TRACE._safe('TRACE'),
  UNBIND._idempotent('UNBIND'),
  UNCHECKOUT._idempotent('UNCHECKOUT'),
  UNLINK._idempotent('UNLINK'),
  UNLOCK._idempotent('UNLOCK'),
  UPDATE._idempotent('UPDATE'),
  UPDATEREDIRECTREF._idempotent('UPDATEREDIRECTREF'),
  VERSION_CONTROL._idempotent('VERSION-CONTROL');

  final String name;
  // no state change is expected on the server side
  final bool isSafe;
  // is the expected effect on the server the same with one request or multiple
  final bool isIdempotent;

  const Method._(this.name) : isIdempotent = false, isSafe = false;

  const Method._idempotent(this.name) : isIdempotent = true, isSafe = false;

  const Method._safe(this.name) : isIdempotent = true, isSafe = true;

  @override
  String toString() => name;
}
