import 'package:code_builder/code_builder.dart';

final class FunctionCTypedefGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../function.dart';''');

    for (int numParams = 2; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateCurriedFunctionTypeDef(numParams));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size + 1, (i) => 'T$i');

  static String _generateCurriedFunctionTypeDef(int size) {
    final curriedQualifier = size > 2 ? 'C' : '';
    final expression =
        'Function1<${_typeParams(size)[0]}, Function${size - 1}$curriedQualifier<${_typeParams(size).skip(1).join(', ')}>>';

    return TypeDef(
      (b) =>
          b
            ..name = 'Function${size}C'
            ..types.addAll(_typeParams(size).map((t) => refer(t)))
            ..docs.add(
              '/// Type alias for curried function that takes $size arguments, one at a time.',
            )
            ..definition = refer(expression),
    ).accept(DartEmitter()).toString();
  }
}
