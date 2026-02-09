import 'package:code_builder/code_builder.dart';

/// Either of Tuple sized [size]
final class EitherTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../either.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  static String _generateOpsExtension(int size) {
    final extensionName = 'EitherTuple${size}Ops<E, ${typeParams(size).join(', ')}>';
    final onType = 'Either<E, (${typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on an Either where the right value is a $size element tuple.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              ensureN(size),
              filterOrElseN(size),
              flatMapN(size),
              foldN(size),
              foreachN(size),
              mapN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method ensureN(int size) {
    final returnType = 'Either<E, (${typeParams(size).join(', ')})>';

    final paramAType = 'Function$size<${typeParams(size).join(', ')}, bool>';
    final paramA = Parameter(
      (b) =>
          b
            ..name = 'p'
            ..type = refer(paramAType),
    );

    final paramB = Parameter(
      (b) =>
          b
            ..name = 'onFailure'
            ..type = refer('Function0<E>'),
    );

    return Method(
      (b) =>
          b
            ..name = 'ensureN'
            ..requiredParameters.addAll([paramA, paramB])
            ..returns = refer(returnType)
            ..body = const Code('ensure(p.tupled, onFailure)')
            ..lambda = true,
    );
  }

  static Method filterOrElseN(int size) {
    final returnType = 'Either<E, (${typeParams(size).join(', ')})>';

    final paramAType = 'Function$size<${typeParams(size).join(', ')}, bool>';
    final paramA = Parameter(
      (b) =>
          b
            ..name = 'p'
            ..type = refer(paramAType),
    );

    final paramB = Parameter(
      (b) =>
          b
            ..name = 'zero'
            ..type = refer('Function0<E>'),
    );

    return Method(
      (b) =>
          b
            ..name = 'filterOrElseN'
            ..requiredParameters.addAll([paramA, paramB])
            ..returns = refer(returnType)
            ..body = const Code('filterOrElse(p.tupled, zero)')
            ..lambda = true,
    );
  }

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Either<E, $returnTypeParam>';

    final paramType = 'Function$size<${typeParams(size).join(', ')}, Either<E, $returnTypeParam>>';
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

    final paramAType = 'Function1<E, $returnType>';
    final paramA = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramAType),
    );

    final paramBType = 'Function$size<${typeParams(size).join(', ')}, $returnType>';
    final paramB = Parameter(
      (b) =>
          b
            ..name = 'g'
            ..type = refer(paramBType),
    );

    return Method(
      (b) =>
          b
            ..name = 'foldN'
            ..types.add(refer(returnType))
            ..requiredParameters.addAll([paramA, paramB])
            ..returns = refer(returnType)
            ..body = const Code('fold(f, g.tupled)')
            ..lambda = true,
    );
  }

  static Method foreachN(int size) {
    final paramType = 'Function$size<${typeParams(size).join(', ')}, void>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'foreachN'
            ..requiredParameters.add(param)
            ..returns = refer('void')
            ..body = const Code('foreach(f.tupled)')
            ..lambda = true,
    );
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Either<E, $returnTypeParam>';

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
