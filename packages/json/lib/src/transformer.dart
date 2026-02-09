import 'dart:async';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart';

abstract class JsonTransformer<A> implements StreamTransformer<A, Json> {
  final AsyncParser _parser;

  final StreamController<Json> _controller;
  StreamSubscription<A>? _subscription;

  static JsonTransformer<List<int>> bytes(AsyncParserMode mode) => _BytesJsonTransformer(mode);

  static JsonTransformer<String> strings(AsyncParserMode mode) => _StringJsonTransformer(mode);

  JsonTransformer(AsyncParserMode mode)
    : _parser = AsyncParser(mode: mode),
      _controller = StreamController();

  Either<ParseException, IList<Json>> absorb(A a);

  @override
  Stream<Json> bind(Stream<A> stream) {
    _subscription = stream.listen(
      (element) => _emit(absorb(element)),
      onError: (Object err, StackTrace st) => _controller.addError(err, st),
      onDone: () {
        _emit(_parser.finalAbsorb(Uint8List(0)));
        _subscription?.cancel();
        _controller.close();
      },
    );

    return _controller.stream;
  }

  void _emit(Either<ParseException, IList<Json>> value) {
    value.fold(
      (err) => _controller.addError(err),
      (items) => items.foreach(_controller.add),
    );
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}

class _BytesJsonTransformer extends JsonTransformer<List<int>> {
  _BytesJsonTransformer(super.mode);

  @override
  Either<ParseException, IList<Json>> absorb(List<int> a) => _parser.absorb(Uint8List.fromList(a));
}

class _StringJsonTransformer extends JsonTransformer<String> {
  _StringJsonTransformer(super.mode);

  @override
  Either<ParseException, IList<Json>> absorb(String a) => _parser.absorbString(a);
}
