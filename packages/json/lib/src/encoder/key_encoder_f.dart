import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// A [KeyEncoder] backed by a plain function.
///
/// Prefer constructing instances via [KeyEncoder.instance] rather than
/// directly.
final class KeyEncoderF<A> extends KeyEncoder<A> {
  /// The function that converts an [A] to a JSON object key string.
  final Function1<A, String> f;

  /// Creates a [KeyEncoderF] that delegates to [f].
  KeyEncoderF(this.f);

  @override
  String encode(A a) => f(a);
}
