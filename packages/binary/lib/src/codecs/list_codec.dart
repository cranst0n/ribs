import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

class ListCodec<A> extends Codec<List<A>> {
  final Codec<A> codec;
  final Option<int> limit;

  ListCodec(this.codec, {this.limit = const None()});

  @override
  Either<Err, DecodeResult<List<A>>> decode(BitVector bv) {
    Either<Err, DecodeResult<List<A>>> go(BitVector x, List<A> acc) {
      if (x.isEmpty) {
        return Either.right(DecodeResult(acc, x));
      } else {
        return limit.filterNot((l) => acc.length >= l).fold(
              () => Either.right(DecodeResult(acc, x)),
              (limit) => codec
                  .decode(x)
                  .flatMap((a) => go(a.remainder, acc..add(a.value))),
            );
      }
    }

    return go(bv, List.empty(growable: true));
  }

  @override
  Either<Err, BitVector> encode(List<A> a) => codec.encodeAll(a);
}
