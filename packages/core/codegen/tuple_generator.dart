import 'package:code_builder/code_builder.dart';

final class TupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../tuple.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(generateOpsExtension(tupleSize, arity));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  static String generateOpsExtension(int size, int arity) {
    final allTypeParams = typeParams(size).join(', ');
    final tupleType = '($allTypeParams)';

    final extension = Extension(
      (b) =>
          b
            ..name = 'Tuple${size}Ops<$allTypeParams>'
            ..docs.add(
              '// Provides additional functions on tuple/record with $size elements.',
            )
            ..on = (refer(tupleType))
            ..methods.addAll([
              if (size < arity) appended(size),
              call(size),
              copy(size),
              head(size),
              if (size > 2) init(size),
              last(size),
              if (size < arity) prepended(size),
              if (size > 2) tail(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method appended(int size) {
    final returnTypeParams = [...typeParams(size), 'T${size + 1}'];
    final returnType = '(${returnTypeParams.join(', ')})';

    final paramType = 'T${size + 1}';
    final param = Parameter(
      (b) =>
          b
            ..name = '\$${size + 1}'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'appended'
            ..docs.add('// Returns a new tuple with [\$${size + 1}] appended to the end.')
            ..types.add(refer(paramType))
            ..returns = refer(returnType)
            ..requiredParameters.add(param)
            ..body = Code('(${List.generate(size + 1, (i) => '\$${i + 1}').join(', ')})')
            ..lambda = true,
    );
  }

  static Method call(int size) {
    final returnType = 'T${size + 1}';

    final parameterType = 'Function$size<${typeParams(size).join(', ')}, $returnType>';
    final param = Parameter(
      (b) =>
          b
            ..name = 'f'
            ..type = refer(parameterType),
    );

    return Method(
      (b) =>
          b
            ..name = 'call'
            ..docs.add('// Applies each element of this tuple to the function [f].')
            ..types.add(refer(returnType))
            ..returns = refer(returnType)
            ..requiredParameters.add(param)
            ..body = Code('f(${List.generate(size, (i) => '\$${i + 1}').join(', ')})')
            ..lambda = true,
    );
  }

  static Method copy(int size) {
    final returnType = '(${typeParams(size).join(', ')})';

    final params = List.generate(
      size,
      (i) => Parameter(
        (b) =>
            b
              ..name = '\$${i + 1}'
              ..type = refer('${typeParams(size)[i]}?')
              ..named = true,
      ),
    );

    return Method(
      (b) =>
          b
            ..name = 'copy'
            ..docs.add('// Replaces all elements with the given associated value(s).')
            ..returns = refer(returnType)
            ..optionalParameters.addAll(params)
            ..body = Code(
              '(${List.generate(size, (i) => '\$${i + 1} ?? this.\$${i + 1}').join(',')})',
            )
            ..lambda = true,
    );
  }

  static Method head(int size) {
    final returnType = typeParams(size).first;

    return Method(
      (b) =>
          b
            ..name = 'head'
            ..docs.add('// Returns the first element of the tuple.')
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = const Code('\$1')
            ..lambda = true,
    );
  }

  static Method init(int size) {
    final returnTypeParams = typeParams(size).sublist(0, size - 1);
    final returnType = '(${returnTypeParams.join(', ')})';

    return Method(
      (b) =>
          b
            ..name = 'init'
            ..docs.add(
              '// Returns a new tuple with all elements from this tuple except the last.',
            )
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = Code('(${List.generate(size - 1, (i) => '\$${i + 1}').join(', ')})')
            ..lambda = true,
    );
  }

  static Method last(int size) {
    final returnType = typeParams(size).last;

    return Method(
      (b) =>
          b
            ..name = 'last'
            ..docs.add('// Returns the last element of the tuple.')
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = Code('\$$size')
            ..lambda = true,
    );
  }

  static Method prepended(int size) {
    final returnTypeParams = ['T${size + 1}', ...typeParams(size)];
    final returnType = '(${returnTypeParams.join(', ')})';

    final paramType = 'T${size + 1}';
    final param = Parameter(
      (b) =>
          b
            ..name = '\$${size + 1}'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'prepended'
            ..docs.add(
              '// Returns a new tuple with [\$${size + 1}] prepended to the beginning.',
            )
            ..types.add(refer(paramType))
            ..returns = refer(returnType)
            ..requiredParameters.add(param)
            ..body = Code(
              '(\$${size + 1}, ${List.generate(size, (i) => '\$${i + 1}').join(', ')})',
            )
            ..lambda = true,
    );
  }

  static Method tail(int size) {
    final returnTypeParams = typeParams(size).skip(1);
    final returnType = '(${returnTypeParams.join(', ')})';

    return Method(
      (b) =>
          b
            ..name = 'tail'
            ..docs.add(
              '// Returns a new tuple with all elements from this tuple except the first.',
            )
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = Code('(${List.generate(size - 1, (i) => '\$${i + 2}').join(', ')})')
            ..lambda = true,
    );
  }
}
