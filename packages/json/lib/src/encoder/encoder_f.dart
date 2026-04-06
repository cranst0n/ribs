import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An [Encoder] backed by a plain function.
///
/// Prefer constructing instances via [Encoder.instance] rather than directly.
final class EncoderF<A> extends Encoder<A> {
  /// The function that converts an [A] to [Json].
  final Function1<A, Json> f;

  /// Creates an [EncoderF] that delegates to [f].
  EncoderF(this.f);

  @override
  Json encode(A a) => f(a);
}
