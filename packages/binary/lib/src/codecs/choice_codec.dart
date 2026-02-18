import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class ChoiceCodec<A> extends Codec<A> {
  IList<Codec<A>> choices;

  ChoiceCodec(this.choices);

  @override
  Either<Err, DecodeResult<A>> decode(BitVector bv) {
    if (choices.isEmpty) {
      return Err.general('ChoiceCodec: no decoders provided').asLeft();
    } else {
      var available = choices;

      DecodeResult<A>? success;
      Err? lastError;

      while (success == null && available.nonEmpty) {
        final result = available.head.decode(bv);

        result.fold(
          (err) => lastError = err,
          (result) => success = result,
        );

        available = available.tail;
      }

      if (success != null) {
        return success!.asRight();
      } else {
        return (lastError ?? Err.general('ChoiceCodec: all decoders failed')).asLeft();
      }
    }
  }

  @override
  Either<Err, BitVector> encode(A a) {
    if (choices.isEmpty) {
      return Err.general('ChoiceCodec: no encoders provided').asLeft();
    } else {
      var available = choices;

      BitVector? success;
      Err? lastError;

      while (success == null && available.nonEmpty) {
        final result = available.head.encode(a);

        result.fold(
          (err) => lastError = err,
          (result) => success = result,
        );

        available = available.tail;
      }

      if (success != null) {
        return success!.asRight();
      } else {
        return (lastError ?? Err.general('ChoiceCodec: all encoders failed')).asLeft();
      }
    }
  }

  @override
  String? get description => 'choice($choices)';
}
