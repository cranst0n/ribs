import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/ribs_http.dart';

typedef DecodeResult<A> = Either<DecodeFailure, A>;

class DecodeResults {
  DecodeResults._();

  static DecodeResult<A> success<A>(A value) => value.asRight();

  static DecodeResult<A> failure<A>(DecodeFailure failure) => failure.asLeft();
}
