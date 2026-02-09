import 'package:code_builder/code_builder.dart';

final class FunctionCOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../function.dart';''');

    for (int numParams = 2; numParams <= arity; numParams++) {
      generatedCode.writeln(generateOps(numParams));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size + 1, (i) => 'T$i');

  static String generateOps(int size) {
    final extension = Extension(
      (b) =>
          b
            ..name = 'Function${size}COps<${typeParams(size).join(', ')}>'
            ..docs.add(
              '/// Provides additional functions on curried functions with $size parameters.',
            )
            ..on = (refer('Function${size}C<${typeParams(size).join(', ')}>'))
            ..methods.addAll([
              if (size > 1) uncurried(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method uncurried(int size) {
    final returnType = 'Function$size<${typeParams(size).join(', ')}>';

    final implParams = '(${List.generate(size, (i) => 't$i').join(', ')})';
    final implBody = 'this${List.generate(size, (i) => '(t$i)').join()}';

    return Method(
      (b) =>
          b
            ..name = 'uncurried'
            ..type = MethodType.getter
            ..docs.add('/// Return the uncurried form of this function.')
            ..returns = refer(returnType)
            ..body = Code('$implParams => $implBody')
            ..lambda = true,
    );
  }
}
