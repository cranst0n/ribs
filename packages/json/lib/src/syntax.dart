/// Extension methods providing tuple product syntax for building [Codec]s.
///
/// Re-exports the generated syntax extensions from
/// `codec/generated/syntax.dart`, enabling construction like:
///
/// ```dart
/// final codec = (
///   ('name', Codec.string),
///   ('age',  Codec.integer),
/// ).product(Person.new, (p) => (p.name, p.age));
/// ```
library;

export 'codec/generated/syntax.dart';
