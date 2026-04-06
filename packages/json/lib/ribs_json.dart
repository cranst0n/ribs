/// A functional JSON library for Dart.
///
/// [Json] is a sealed ADT ([JNull], [JBoolean], [JNumber], [JString],
/// [JArray], [JObject]) with support for parsing, formatting via [Printer], and
/// streaming via [JsonTransformer]. [Decoder], [Encoder], and [Codec] provide
/// type-safe conversion to and from Dart types, with built-in instances for
/// primitives, enums, and collections; structured types compose via the product
/// syntax on [KeyValueCodec]. Navigation uses a cursor zipper ([HCursor],
/// [FailedCursor]) that tracks the path through the tree so that
/// [DecodingFailure] errors carry precise location information.
library;

export 'src/acursor.dart';
export 'src/codec.dart';
export 'src/codec/key_codec.dart';
export 'src/codec/key_value_codec.dart';
export 'src/cursor_op.dart';
export 'src/dawn/async_parser.dart';
export 'src/decoder.dart';
export 'src/encoder.dart';
export 'src/error.dart';
export 'src/failed_cursor.dart';
export 'src/hcursor.dart';
export 'src/json.dart';
export 'src/json_object.dart';
export 'src/key_decoder.dart';
export 'src/key_encoder.dart';
export 'src/path_to_root.dart';
export 'src/printer.dart';
export 'src/syntax.dart';
export 'src/transformer.dart';
