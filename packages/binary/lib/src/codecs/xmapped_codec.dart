import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class XMappedCodec<A, B> extends Codec<B> {
  final Codec<A> by;
  final IMap<A, B> cases;

  XMappedCodec(this.by, this.cases);

  @override
  Either<Err, DecodeResult<B>> decode(BitVector bv) {
    return by
        .decode(bv)
        .flatMap(
          (a) => cases
              .get(a.value)
              .toRight(() => Err.general('Missing xmap case for: ${a.value}'))
              .map((b) => a.map((_) => b)),
        );
  }

  @override
  Either<Err, BitVector> encode(B b) {
    return cases
        .find((kv) => kv.$2 == b)
        .toRight(() => Err.general('Missing xmap case for: $b'))
        .flatMap((t) => by.encode(t.$1));
  }
}
