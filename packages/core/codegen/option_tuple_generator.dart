import 'package:code_builder/code_builder.dart';

final class OptionTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../option.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateOptionTupleOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Option of Tuple sized [size]
  static String _generateOptionTupleOpsExtension(int size) {
    final extensionName = 'OptionTuple${size}Ops<${typeParams(size).join(', ')}>';
    final onType = 'Option<(${typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on an Option of a $size element tuple.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              filterN(size),
              filterNotN(size),
              flatMapN(size),
              foldN(size),
              foreachN(size),
              mapN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method filterN(int size) {
    final returnType = 'Option<(${typeParams(size).join(', ')})>';

    final paramType = 'Function$size<${typeParams(size).join(', ')}, bool>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'p'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'filterN'
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('filter(p.tupled)')
            ..lambda = true,
    );
  }

  static Method filterNotN(int size) {
    final returnType = 'Option<(${typeParams(size).join(', ')})>';

    final paramType = 'Function$size<${typeParams(size).join(', ')}, bool>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'p'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'filterNotN'
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('filterNot(p.tupled)')
            ..lambda = true,
    );
  }

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Option<$returnTypeParam>';

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

  static Method foldN(int size) {
    final returnType = 'T${size + 1}';

    final paramAType = 'Function0<$returnType>';
    final paramBType = 'Function$size<${typeParams(size).join(', ')}, $returnType>';

    final paramA = Parameter(
      (b) =>
          b
            ..name = 'ifEmpty'
            ..type = refer(paramAType),
    );

    final paramB = Parameter(
      (b) =>
          b
            ..name = 'ifSome'
            ..type = refer(paramBType),
    );

    return Method(
      (b) =>
          b
            ..name = 'foldN'
            ..types.add(refer(returnType))
            ..requiredParameters.addAll([paramA, paramB])
            ..returns = refer(returnType)
            ..body = const Code('fold(ifEmpty, ifSome.tupled)')
            ..lambda = true,
    );
  }

  static Method foreachN(int size) {
    final paramType = 'Function$size<${typeParams(size).join(', ')}, void>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'ifSome'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'foreachN'
            ..requiredParameters.add(param)
            ..returns = refer('void')
            ..body = const Code('foreach(ifSome.tupled)')
            ..lambda = true,
    );
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Option<$returnTypeParam>';

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
