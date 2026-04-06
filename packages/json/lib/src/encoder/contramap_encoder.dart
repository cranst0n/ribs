import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An [Encoder] that converts a [B] to an [A] before delegating to [encodeA].
///
/// Created by [Encoder.contramap].
final class ContramapEncoder<A, B> extends Encoder<B> {
  /// The underlying encoder for the intermediate type [A].
  final Encoder<A> encodeA;

  /// The function that converts a [B] to the [A] expected by [encodeA].
  final Function1<B, A> f;

  /// Creates a [ContramapEncoder] from [encodeA] and conversion function [f].
  ContramapEncoder(this.encodeA, this.f);

  @override
  Json encode(B b) => encodeA.encode(f(b));
}
