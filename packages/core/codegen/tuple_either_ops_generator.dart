import 'package:code_builder/code_builder.dart';

final class TupleEitherOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../either.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(generateOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Tuple of N [Either] types
  static String generateOpsExtension(int size) {
    final extensionName = 'Tuple${size}EitherOps<E, ${typeParams(size).join(', ')}>';
    final onType = '(${typeParams(size).map((t) => 'Either<E, $t>').join(', ')})';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on tuple with $size [Either]s.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              mapN(size),
              tupledN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Either<E, $returnTypeParam>';

    final paramType = 'Function$size<${[...typeParams(size), returnTypeParam].join(', ')}>';

    final param = Parameter(
      (b) =>
          b
            ..name = 'fn'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'mapN'
            ..docs.addAll([
              '/// Applies [fn] to the values of each respective tuple member if all values',
              '/// are a [Right]. If **any** item is a [Left], the first [Left] encountered',
              '/// will be returned.',
            ])
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('tupled.map(fn.tupled)')
            ..lambda = true,
    );
  }

  static Method tupledN(int size) {
    final returnType = 'Either<E, (${typeParams(size).join(', ')})>';

    final impl =
        size == 2
            ? const Code('\$1.flatMap((a) => \$2.map((b) => (a, b)))')
            : const Code('init.tupled.flatMap((x) => last.map(x.appended))');

    return Method(
      (b) =>
          b
            ..name = 'tupled'
            ..docs.addAll([
              '/// If **all** items of this tuple are a [Right], the respective items are',
              '/// turned into a tuple and returned as a [Right]. If **any** item is a',
              '/// [Left], the first [Left] encountered is returned.',
            ])
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = impl
            ..lambda = true,
    );
  }
}
