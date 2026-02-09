import 'package:code_builder/code_builder.dart';

final class FunctionOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../function.dart';''');

    for (int numParams = 0; numParams <= arity; numParams++) {
      generatedCode.writeln(generateOps(numParams));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size + 1, (i) => 'T$i');

  static String generateOps(int size) {
    final functionNType = 'Function$size<${typeParams(size).join(', ')}>';

    final extension = Extension(
      (b) =>
          b
            ..name = 'Function${size}Ops<${typeParams(size).join(', ')}>'
            ..docs.add(
              '/// Provides additional functions on functions with $size parameters.',
            )
            ..on = (refer(functionNType))
            ..methods.addAll([
              andThen(size),
              if (size > 0) compose(size),
              if (size > 1) curried(size),
              if (size > 1) tupled(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method andThen(int size) {
    final paramType = 'Function1<T$size, T${size + 1}>';
    final returnType =
        'Function$size<${[...typeParams(size).take(size), 'T${size + 1}'].join(', ')}>';

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

  static Method compose(int size) {
    final paramType =
        size > 1
            ? 'Function1<T${size + 1}, (${typeParams(size).take(size).join(', ')})>'
            : 'Function1<T${size + 1}, ${typeParams(size).take(size).join(', ')}>';

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

  static Method curried(int size) {
    final returnType = 'Function${size}C<${typeParams(size).join(', ')}>';

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

  static Method tupled(int size) {
    final returnType = 'Function1<(${typeParams(size).take(size).join(', ')}), T$size>';

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
}
