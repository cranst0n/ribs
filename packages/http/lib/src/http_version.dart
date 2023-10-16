final class HttpVersion {
  final int major;
  final int minor;

  const HttpVersion(this.major, this.minor);

  @override
  String toString() => 'HTTP/$major.$minor';

  static const Http1_0 = HttpVersion(1, 0);
  static const Http1_1 = HttpVersion(1, 1);
  static const Http2_0 = HttpVersion(2, 0);
}
