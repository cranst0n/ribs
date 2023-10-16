import 'package:ribs_core/ribs_core.dart';

final class MediaRange {
  final String mainType;
  final IMap<String, String> extensions;

  const MediaRange(
    this.mainType, {
    this.extensions = const IMap.empty(),
  });

  MediaRange withExtensions(IMap<String, String> ext) =>
      MediaRange(mainType, extensions: ext);

  static const all = MediaRange('*');
  static const application = MediaRange('application');
  static const audio = MediaRange('audio');
  static const image = MediaRange('image');
  static const message = MediaRange('message');
  static const multipart = MediaRange('multipart');
  static const text = MediaRange('text');
  static const video = MediaRange('video');
}

final class MediaType extends MediaRange {
  final String subType;
  final bool compressible;
  final bool binary;
  final IList<String> fileExtensions;

  const MediaType(
    super.mainType,
    this.subType, {
    this.compressible = false,
    this.binary = false,
    this.fileExtensions = const IList.nil(),
    super.extensions,
  });

  const MediaType._basic(
    super.mainType,
    this.subType,
    this.compressible,
    this.binary,
  ) : fileExtensions = const IList.nil();

  const MediaType._full(
    super.mainType,
    this.subType,
    this.compressible,
    this.binary,
    this.fileExtensions,
  );

  @override
  MediaType withExtensions(IMap<String, String> ext) =>
      MediaType(mainType, subType,
          compressible: compressible,
          binary: binary,
          fileExtensions: fileExtensions,
          extensions: ext);

  @override
  String toString() => '$mainType/$subType${_renderExtensions()}';

  String _renderExtensions() {
    if (extensions.nonEmpty) {
      return extensions.map((k, v) => '; $k=${_quote(v)}').mkString(sep: '');
    } else {
      return '';
    }
  }

  String _quote(String s) {
    final buf = StringBuffer('"');
    int i = 0;

    while (i < s.length) {
      final char = s[i];
      if (char == '"' || char == '\\') buf.write('\\');
      buf.write(char);
      i++;
    }

    buf.write('"');

    return buf.toString();
  }

  static final application = _Application();
  static final audio = _Audio();
  static final image = _Image();
  static final multipart = _Multipart();
  static final text = _Text();
  static final video = _Video();
}

final class _Application {
  static final _Application _singleton = _Application._();

  factory _Application() => _singleton;

  _Application._();

  static const type = 'application';

  final javascript = MediaType._full(
      type, 'javascript', _Compressible, _NotBinary, ilist(['js', 'mjs']));

  final json = MediaType._full(
      type, 'json', _Compressible, _Binary, ilist(['json', 'map']));

  final octet_stream = MediaType._full(
      type,
      'octet-stream',
      _Uncompressible,
      _Binary,
      ilist([
        'bin',
        'dms',
        'lrf',
        'mar',
        'so',
        'dist',
        'distz',
        'pkg',
        'bpk',
        'dump',
        'elc',
        'deploy',
        'exe',
        'dll',
        'deb',
        'dmg',
        'iso',
        'img',
        'msi',
        'msp',
        'msm',
        'buffer'
      ]));

  final pdf =
      MediaType._full(type, 'pdf', _Uncompressible, _Binary, ilist(['pdf']));

  final xWwwFormUrlEncoded = const MediaType._basic(
      type, 'x-www-form-urlencoded', _Compressible, _NotBinary);

  final xml = MediaType._full(type, 'xml', _Compressible, _NotBinary,
      ilist(['xml', 'xsl', 'xsd', 'rng']));

  final zip =
      MediaType._full(type, 'zip', _Uncompressible, _Binary, ilist(['zip']));
}

final class _Audio {
  static final _Audio _singleton = _Audio._();

  factory _Audio() => _singleton;

  _Audio._();

  static const type = 'audio';

  final aac = const MediaType._basic(type, 'aac', _Compressible, _Binary);

  final plain = MediaType._full(type, 'mpeg', _Uncompressible, _Binary,
      ilist(['mpga', 'mp2', 'mp2a', 'mp3', 'm2a', 'm3a']));
}

final class _Image {
  static final _Image _singleton = _Image._();

  factory _Image() => _singleton;

  _Image._();

  static const type = 'image';

  final gif =
      MediaType._full(type, 'gif', _Uncompressible, _Binary, ilist(['gif']));

  final jpeg = MediaType._full(
      type, 'jpeg', _Uncompressible, _Binary, ilist(['jpeg', 'jpg', 'jpe']));

  final png =
      MediaType._full(type, 'png', _Uncompressible, _Binary, ilist(['png']));

  final svg_xml = MediaType._full(
      type, 'svg_xml', _Compressible, _Binary, ilist(['svg', 'svgz']));

  final tiff = MediaType._full(
      type, 'tiff', _Uncompressible, _Binary, ilist(['tif', 'tiff']));
}

final class _Multipart {
  static final _Multipart _singleton = _Multipart._();

  factory _Multipart() => _singleton;

  _Multipart._();

  static const type = 'multipart';

  final form_data =
      const MediaType._basic(type, 'form-data', _Uncompressible, _NotBinary);
}

final class _Text {
  static final _Text _singleton = _Text._();

  factory _Text() => _singleton;

  _Text._();

  static const type = 'text';

  final css =
      MediaType._full(type, 'css', _Compressible, _NotBinary, ilist(['css']));

  final csv =
      MediaType._full(type, 'csv', _Compressible, _NotBinary, ilist(['csv']));

  final html = MediaType._full(
      type, 'html', _Compressible, _NotBinary, ilist(['html', 'htm', 'shtml']));

  final plain = MediaType._full(type, 'plain', _Compressible, _NotBinary,
      ilist(['txt', 'text', 'conf', 'def', 'list', 'log', 'in', 'ini']));
}

final class _Video {
  static final _Video _singleton = _Video._();

  factory _Video() => _singleton;

  _Video._();

  static const type = 'video';

  final mp4 = MediaType._full(
      type, 'mp4', _Uncompressible, _Binary, ilist(['mp4', 'mp4v', 'mpg4']));

  final mpeg = MediaType._full(type, 'mpeg', _Uncompressible, _Binary,
      ilist(['mpeg', 'mpg', 'mpe', 'm1v', 'm2v']));
}

const _Compressible = true;
const _Uncompressible = false;

const _Binary = true;
const _NotBinary = false;
