import 'dart:io' as io;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_http/src/media_range.dart';

final class ContentType {
  final MediaType mediaType;
  final Option<String> charset;

  const ContentType(
    this.mediaType, [
    this.charset = const None(),
  ]);

  // TODO: petit parser?
  static Option<ContentType> parse(String s) => Either.catching(
    () => io.ContentType.parse(s),
    (_, _) => '',
  ).toOption().map(
    (ct) => ContentType(MediaType(ct.primaryType, IMap.empty(), ct.subType), Option(ct.charset)),
  );

  ContentType copy({
    MediaType? mediaType,
    Option<String>? charset,
  }) => ContentType(
    mediaType ?? this.mediaType,
    charset ?? this.charset,
  );

  ContentType withMediaType(MediaType mediaType) => copy(mediaType: mediaType);
  ContentType withCharset(String charset) => copy(charset: Option(charset));
  ContentType withoutCharset() => copy(charset: const None());

  @override
  String toString() => mediaType.toString() + charset.fold(() => '', (cs) => ';$cs');
}
