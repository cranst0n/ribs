import 'package:code_builder/code_builder.dart';

final class IOTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../io.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(generateOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Option of Tuple sized [size]
  static String generateOpsExtension(int size) {
    final extensionName = 'IOTuple${size}Ops<${typeParams(size).join(', ')}>';
    final onType = 'IO<(${typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on an IO of a $size element tuple.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              flatMapN(size),
              mapN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'IO<$returnTypeParam>';

    final paramType = 'Function$size<${typeParams(size).join(', ')}, $returnType>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'flatMapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('flatMap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'IO<$returnTypeParam>';

    final paramType = 'Function$size<${typeParams(size).join(', ')}, $returnTypeParam>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'mapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('map(f.tupled)')
            ..lambda = true,
    );
  }
}
