final class ReadSyntaxGenerator {
  static String generate(int arity) {
    final buf = StringBuffer();
    buf.writeln("import 'package:ribs_core/ribs_core.dart';");
    buf.writeln("import 'package:ribs_sql/ribs_sql.dart';");
    buf.writeln();

    for (int size = 2; size <= arity; size++) {
      buf.writeln(_generateExtension(size));
    }

    return buf.toString();
  }

  static List<String> _typeParams(int size) =>
      List.generate(size, (i) => String.fromCharCode('A'.codeUnitAt(0) + i));

  static String _generateExtension(int size) {
    final typeParams = _typeParams(size);
    final typeParamList = typeParams.join(', ');
    final onType = typeParams.map((t) => 'Read<$t>').join(', ');
    final returnType = '($typeParamList)';

    if (size == 2) {
      return '''
extension Tuple${size}ReadOps<$typeParamList> on ($onType) {
  Read<$returnType> get tupled => Read.instance(
    \$1.gets.concat(\$2.gets),
    (row, n) => (\$1.unsafeGet(row, n), \$2.unsafeGet(row, n + \$1.length)),
  );
}
''';
    }

    return '''
extension Tuple${size}ReadOps<$typeParamList> on ($onType) {
  Read<$returnType> get tupled {
    final initRead = init.tupled;
    return Read.instance(
      initRead.gets.concat(last.gets),
      (row, n) => initRead.unsafeGet(row, n).appended(last.unsafeGet(row, n + initRead.length)),
    );
  }
}
''';
  }
}
