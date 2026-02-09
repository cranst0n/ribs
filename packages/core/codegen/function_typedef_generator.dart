import 'package:code_builder/code_builder.dart';

final class FunctionTypedefGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../function.dart';''');

    for (int numParams = 0; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateFunctionTypeDef(numParams));
    }

    return generatedCode.toString();
  }

  static String _generateFunctionTypeDef(int size) {
    final typeParams = List.generate(size, (i) => 'T$i');
    final returnType = 'T$size';
    final expression = '$returnType Function(${typeParams.join(', ')})';

    return TypeDef(
      (b) =>
          b
            ..name = 'Function$size'
            ..types.addAll([...typeParams, returnType].map((t) => refer(t)))
            ..docs.add('/// Type alias for function taking $size arguments.')
            ..definition = refer(expression),
    ).accept(DartEmitter()).toString();
  }
}
