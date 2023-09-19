import 'dart:async';

import 'package:ribs_binary/ribs_binary.dart';

class StreamEncoder<A> implements StreamTransformer<A, BitVector> {
  final Encoder<A> encoder;

  final StreamController<BitVector> _controller;
  StreamSubscription<A>? _subscription;

  StreamEncoder(this.encoder) : _controller = StreamController();

  @override
  Stream<BitVector> bind(Stream<A> stream) {
    _subscription = stream.listen(
      (a) {
        encoder.encode(a).fold(
              (err) => _controller.addError(err),
              (bv) => _controller.add(bv),
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
