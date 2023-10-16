final class RequestCookie {
  final String name;
  final String content;

  const RequestCookie(this.name, this.content);

  @override
  String toString() => '$name=$content';
}
