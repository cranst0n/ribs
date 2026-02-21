import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class ListCodec<A> extends Codec<List<A>> {
  final Codec<A> codec;
  final Option<int> limit;

  ListCodec(this.codec, {this.limit = const None()});

  @override
  Either<Err, DecodeResult<List<A>>> decode(BitVector bv) {
    var currentBV = bv;
    final acc = List<A>.empty(growable: true);

    while (true) {
      if (currentBV.isEmpty || limit.exists((l) => acc.length >= l)) {
        return Either.right(DecodeResult(acc, currentBV));
      }

      final result = codec.decode(currentBV);
      if (result.isLeft) {
        return Either.left(result.swap().getOrElse(() => throw StateError('unreachable')));
      }

      final r = result.getOrElse(() => throw StateError('unreachable'));
      acc.add(r.value);
      currentBV = r.remainder;
    }
  }

  @override
  Either<Err, BitVector> encode(List<A> a) => codec.encodeAll(a);
}
