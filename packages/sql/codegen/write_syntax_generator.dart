final class WriteSyntaxGenerator {
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
    final onType = typeParams.map((t) => 'Write<$t>').join(', ');
    final returnType = '($typeParamList)';

    if (size == 2) {
      return '''
extension Tuple${size}WriteOps<$typeParamList> on ($onType) {
  Write<$returnType> get tupled => Write.instance(
    ilist([\$1.puts, \$2.puts]).flatten(),
    (params, n, tuple) {
      final p0 = \$1.setParameter(params, n, tuple.\$1);
      return \$2.setParameter(p0, n + \$1.length, tuple.\$2);
    },
  );
}
''';
    }

    return '''
extension Tuple${size}WriteOps<$typeParamList> on ($onType) {
  Write<$returnType> get tupled {
    final initWrite = init.tupled;
    return Write.instance(initWrite.puts.concat(last.puts), (params, n, tuple) {
      final stmtParams = initWrite.setParameter(params, n, tuple.init);
      return last.setParameter(stmtParams, n + initWrite.length, tuple.last);
    });
  }
}
''';
  }
}
