import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class FilteredCodec<A> extends Codec<A> {
  final Codec<A> codec;
  final Codec<BitVector> filter;

  FilteredCodec(this.codec, this.filter);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) =>
      filter.decode(bv).flatMap((r1) => codec
          .decode(r1.value)
          .map((r2) => r2.mapRemainder((a) => a.concat(r1.remainder))));

  @override
  Either<Err, BitVector> encode(A a) => codec.encode(a).flatMap(filter.encode);

  @override
  String? get description => 'filtered($codec, $filter)';
}
