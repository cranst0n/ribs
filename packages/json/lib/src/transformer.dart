import 'dart:async';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart';

/// A [StreamTransformer] that parses a stream of [A] chunks into a stream of
/// [Json] values using an [AsyncParser].
///
/// Use [JsonTransformer.bytes] for `Stream<List<int>>` inputs and
/// [JsonTransformer.strings] for `Stream<String>` inputs. The [mode] controls
/// whether the stream contains a single value, multiple whitespace-separated
/// values, or a top-level JSON array to be unwrapped.
abstract class JsonTransformer<A> extends StreamTransformerBase<A, Json> {
  /// The parsing mode passed to the internal [AsyncParser].
  final AsyncParserMode mode;

  /// Creates a [JsonTransformer] that accepts `List<int>` byte chunks.
  static JsonTransformer<List<int>> bytes(AsyncParserMode mode) => _BytesJsonTransformer(mode);

  /// Creates a [JsonTransformer] that accepts [String] chunks.
  static JsonTransformer<String> strings(AsyncParserMode mode) => _StringJsonTransformer(mode);

  JsonTransformer(this.mode);

  /// Feeds chunk [a] to [parser] and returns any [Json] values completed so
  /// far, or a [ParseException] on error.
  Either<ParseException, IList<Json>> absorb(AsyncParser parser, A a);

  @override
  Stream<Json> bind(Stream<A> stream) {
    StreamController<Json>? controller;
    StreamSubscription<A>? subscription;
    late AsyncParser parser;

    void emit(Either<ParseException, IList<Json>> value) {
      value.fold(
        (err) => controller!.addError(err),
        (items) => items.foreach(controller!.add),
      );
    }

    controller = StreamController<Json>(
      onListen: () {
        parser = AsyncParser(mode: mode);
        subscription = stream.listen(
          (element) => emit(absorb(parser, element)),
          onError: controller!.addError,
          onDone: () {
            emit(parser.finalAbsorb(Uint8List(0)));
            controller?.close();
          },
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }
}

class _BytesJsonTransformer extends JsonTransformer<List<int>> {
  _BytesJsonTransformer(super.mode);

  @override
  Either<ParseException, IList<Json>> absorb(AsyncParser parser, List<int> a) =>
      parser.absorb(Uint8List.fromList(a));
}

class _StringJsonTransformer extends JsonTransformer<String> {
  _StringJsonTransformer(super.mode);

  @override
  Either<ParseException, IList<Json>> absorb(AsyncParser parser, String a) =>
      parser.absorbString(a);
}
