import 'package:code_builder/code_builder.dart';

final class FunctionGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../function.dart';''');

    for (int numParams = 0; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateFunctionTypeDef(numParams));
    }

    for (int numParams = 2; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateCurriedFunctionTypeDef(numParams));
    }

    for (int numParams = 0; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateFunctionOps(numParams));
    }

    for (int numParams = 2; numParams <= arity; numParams++) {
      generatedCode.writeln(_generateFunctionCOps(numParams));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size + 1, (i) => 'T$i');

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

  static String _generateFunctionOps(int size) {
    final functionNType = 'Function$size<${_typeParams(size).join(', ')}>';

    final extension = Extension(
      (b) =>
          b
            ..name = 'Function${size}Ops<${_typeParams(size).join(', ')}>'
            ..docs.add(
              '/// Provides additional functions on functions with $size parameters.',
            )
            ..on = (refer(functionNType))
            ..methods.addAll([
              _generateAndThenMethod(size),
              if (size > 0) _generateComposeMethod(size),
              if (size > 1) _generateCurriedMethod(size),
              if (size > 1) _generateTupledMethod(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static String _generateFunctionCOps(int size) {
    final extension = Extension(
      (b) =>
          b
            ..name = 'Function${size}COps<${_typeParams(size).join(', ')}>'
            ..docs.add(
              '/// Provides additional functions on curried functions with $size parameters.',
            )
            ..on = (refer('Function${size}C<${_typeParams(size).join(', ')}>'))
            ..methods.addAll([
              if (size > 1) _generateUncurriedMethod(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method _generateAndThenMethod(int size) {
    final paramType = 'Function1<T$size, T${size + 1}>';
    final returnType =
        'Function$size<${[..._typeParams(size).take(size), 'T${size + 1}'].join(', ')}>';

    final params = Parameter(
      (b) =>
          b
            ..name = 'fn'
            ..type = refer(paramType),
    );

    final implParams = List.generate(size, (i) => 't$i').join(', ');

    return Method(
      (b) =>
          b
            ..name = 'andThen'
            ..docs.add(
              '/// Composes this function with the provided function, this function being applied first.',
            )
            ..types.add(refer('T${size + 1}'))
            ..returns = refer(returnType)
            ..requiredParameters.add(params)
            ..body = Code('($implParams) => fn(this($implParams))')
            ..lambda = true,
    );
  }

  static Method _generateComposeMethod(int size) {
    final paramType =
        size > 1
            ? 'Function1<T${size + 1}, (${_typeParams(size).take(size).join(', ')})>'
            : 'Function1<T${size + 1}, ${_typeParams(size).take(size).join(', ')}>';

    final returnType = 'Function1<T${size + 1}, T$size>';

    final params = Parameter(
      (b) =>
          b
            ..name = 'fn'
            ..type = refer(paramType),
    );

    final implParams = 't${size + 1}';
    final impl = size > 1 ? 'tupled(fn(t${size + 1}))' : 'this(fn(t${size + 1}))';

    return Method(
      (b) =>
          b
            ..name = 'compose'
            ..docs.add(
              '/// Composes this function with the provided function, this function being applied first.',
            )
            ..types.add(refer('T${size + 1}'))
            ..returns = refer(returnType)
            ..requiredParameters.add(params)
            ..body = Code('($implParams) => $impl')
            ..lambda = true,
    );
  }

  static Method _generateCurriedMethod(int size) {
    final returnType = 'Function${size}C<${_typeParams(size).join(', ')}>';

    final curriedParams = List.generate(size, (i) => '(t$i)').join(' => ');
    final curriedBody = 'this(${List.generate(size, (i) => 't$i').join(', ')})';

    return Method(
      (b) =>
          b
            ..name = 'curried'
            ..type = MethodType.getter
            ..docs.add('/// Return the curried form of this function.')
            ..returns = refer(returnType)
            ..body = Code('$curriedParams => $curriedBody')
            ..lambda = true,
    );
  }

  static Method _generateTupledMethod(int size) {
    final returnType = 'Function1<(${_typeParams(size).take(size).join(', ')}), T$size>';

    return Method(
      (b) =>
          b
            ..name = 'tupled'
            ..type = MethodType.getter
            ..docs.add(
              '/// Returns a function that takes a tuple of parameters rather than individual parameters.',
            )
            ..returns = refer(returnType)
            ..body = const Code('(t) => t(this)')
            ..lambda = true,
    );
  }

  static Method _generateUncurriedMethod(int size) {
    final returnType = 'Function$size<${_typeParams(size).join(', ')}>';

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
