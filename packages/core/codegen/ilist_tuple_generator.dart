import 'package:code_builder/code_builder.dart';

final class IListTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../ilist.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateOptionTupleOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Option of Tuple sized [size]
  static String _generateOptionTupleOpsExtension(int size) {
    final extensionName = 'IListTuple${size}Ops<${typeParams(size).join(', ')}>';
    final onType = 'IList<(${typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on an IList of a $size element tuple.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              dropWhileN(size),
              filterN(size),
              filterNotN(size),
              flatMapN(size),
              foreachN(size),
              mapN(size),
              takeWhileN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method dropWhileN(int size) => _predicateFn(size, 'dropWhile');

  static Method filterN(int size) => _predicateFn(size, 'filter');

  static Method filterNotN(int size) => _predicateFn(size, 'filterNot');

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'IList<$returnTypeParam>';

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
    final returnType = 'IList<$returnTypeParam>';

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

  static Method takeWhileN(int size) => _predicateFn(size, 'takeWhile');

  static Method _predicateFn(int size, String fn) {
    final returnType = 'IList<(${typeParams(size).join(', ')})>';

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
            ..name = '${fn}N'
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = Code('$fn(p.tupled)')
            ..lambda = true,
    );
  }
}
