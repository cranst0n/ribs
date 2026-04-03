final class GenSyntaxGenerator {
  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _maxShrinkerArity = 10;

  static String generate(int arity) {
    final buf = StringBuffer();
    buf.writeln("import 'package:ribs_check/ribs_check.dart';");
    buf.writeln("import 'package:ribs_core/ribs_core.dart';");

    for (int size = 2; size <= arity; size++) {
      buf.writeln();
      buf.writeln(_extension(size));
    }

    return buf.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size, (i) => _letters[i]);

  static String _extension(int size) {
    final params = _typeParams(size);
    final onType = '(${params.map((p) => 'Gen<$p>').join(', ')})';
    final returnType = '(${params.join(', ')})';
    final body = _body(size);

    return 'extension GenTuple${size}Ops<${params.join(', ')}> on $onType {\n'
        '  Gen<$returnType> get tupled => $body;\n'
        '}';
  }

  static String _body(int size) {
    if (size == 2) {
      return r'$1.flatMap((a) => $2.map((b) => (a, b))).withShrinker(Shrinker.tuple2($1.shrinker, $2.shrinker))';
    }

    const base = 'init.tupled.flatMap((t) => last.map(t.appended))';

    if (size > _maxShrinkerArity) {
      return base;
    }

    final shrinkerArgs = List.generate(size, (i) => '\$${i + 1}.shrinker').join(', ');
    return '$base.withShrinker(Shrinker.tuple$size($shrinkerArgs))';
  }
}
