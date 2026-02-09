import 'package:code_builder/code_builder.dart';

final class TupleValidatedNelOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../validated.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(generateOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Tuple of N [ValidatedNel] types
  static String generateOpsExtension(int size) {
    final extensionName = 'Tuple${size}ValidatedNelOps<E, ${typeParams(size).join(', ')}>';
    final onType = '(${typeParams(size).map((t) => 'ValidatedNel<E, $t>').join(', ')})';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on tuple with $size [ValidatedNel]s.',
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
    final returnType = 'ValidatedNel<E, $returnTypeParam>';

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
              '/// are a [Valid]. If **any** item is an [Invalid], the accumulation of all',
              '/// [Invalid] instances is returned.',
            ])
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('tupled.map(fn.tupled)')
            ..lambda = true,
    );
  }

  static Method tupledN(int size) {
    final returnType = 'ValidatedNel<E, (${typeParams(size).join(', ')})>';

    final impl =
        size == 2
            ? const Code('\$1.product(\$2)')
            : const Code('init.tupled.product(last).map((t) => t.\$1.appended(t.\$2))');

    return Method(
      (b) =>
          b
            ..name = 'tupled'
            ..docs.addAll([
              '/// If **all** items of this tuple are a [Valid], the respective items are',
              '/// turned into a tuple and returned as a [ValidatedNel]. If **any** item is an',
              '/// [Invalid], the accumulation of all [Invalid] instances is returned.',
            ])
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = impl
            ..lambda = true,
    );
  }
}
