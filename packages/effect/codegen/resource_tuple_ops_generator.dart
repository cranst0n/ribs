import 'package:code_builder/code_builder.dart';

final class ResourceTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../resource.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateResourceTupleOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Option of Tuple sized [size]
  static String _generateResourceTupleOpsExtension(int size) {
    final extensionName = 'ResourceTuple${size}Ops<${_typeParams(size).join(', ')}>';
    final onType = 'Resource<(${_typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on a Resource of a $size element tuple.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              evalMapN(size),
              evalTapN(size),
              flatMapN(size),
              mapN(size),
              useN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method evalMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Resource<$returnTypeParam>';

    final paramType = 'Function$size<${_typeParams(size).join(', ')}, IO<$returnTypeParam>>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'evalMapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('evalMap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method evalTapN(int size) {
    final returnType = 'Resource<(${_typeParams(size).join(', ')})>';

    final paramType = 'Function$size<${_typeParams(size).join(', ')}, IO<T${size + 1}>>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'evalTapN'
            ..types.add(refer('T${size + 1}'))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('evalTap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Resource<$returnTypeParam>';

    final paramType = 'Function$size<${_typeParams(size).join(', ')}, $returnType>';
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
    final returnType = 'Resource<$returnTypeParam>';

    final paramType = 'Function$size<${_typeParams(size).join(', ')}, $returnTypeParam>';
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

  static Method useN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'IO<$returnTypeParam>';

    final paramType = 'Function$size<${_typeParams(size).join(', ')}, $returnType>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'useN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('use(f.tupled)')
            ..lambda = true,
    );
  }
}
