final class ReadWriteSyntaxGenerator {
  static String generate(int arity) {
    final buf = StringBuffer();
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
    final onType = typeParams.map((t) => 'ReadWrite<$t>').join(', ');
    final readTuple = List.generate(size, (i) => '\$${i + 1}.read').join(', ');
    final writeTuple = List.generate(size, (i) => '\$${i + 1}.write').join(', ');

    return '''
extension Tuple${size}ReadWriteOps<$typeParamList> on ($onType) {
  ReadWrite<($typeParamList)> get tupled => ReadWrite(($readTuple).tupled, ($writeTuple).tupled);
}
''';
  }
}
