import 'dart:async';

import 'package:ribs_binary/ribs_binary.dart';

class StreamDecoder<To> implements StreamTransformer<BitVector, To> {
  final Decoder<To> decoder;

  final StreamController<To> _controller;
  StreamSubscription<BitVector>? _subscription;

  BitVector _buffer = BitVector.empty();

  StreamDecoder(this.decoder) : _controller = StreamController();

  @override
  Stream<To> bind(Stream<BitVector> stream) {
    _subscription = stream.listen(
      (event) {
        _buffer = _buffer.concat(event);

        final res = decoder.decode(_buffer);

        res.fold(
          (err) {
            if (err is! InsufficientBits) {
              _controller.addError(err);
            }
          },
          (result) {
            _controller.add(result.value);
            _buffer = result.remainder;
          },
        );
      },
      onError: (Object err, StackTrace st) => _controller.addError(err, st),
      onDone: () {
        _subscription?.cancel();
        _controller.close();
      },
    );

    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}
