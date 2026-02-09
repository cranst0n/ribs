import 'package:code_builder/code_builder.dart';

final class TupleResourceOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../resource.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateTupleResourceOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Option of Tuple sized [size]
  static String _generateTupleResourceOpsExtension(int size) {
    final extensionName = 'Tuple${size}ResourceOps<${_typeParams(size).join(', ')}>';
    final onType = '(${_typeParams(size).map((t) => 'Resource<$t>').join(',')})';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on a tuple of $size [Resource]s.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              mapN(size),
              parMapN(size),
              tupledN(size),
              parTupledN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Resource<$returnTypeParam>';

    final paramType = 'Function$size<${[..._typeParams(size), returnTypeParam].join(', ')}>';

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
              '/// Creates a new Resource that applies [fn] to the values of each respective tuple',
              '/// member if all Resources succeed. If **any** item fails or is canceled, the',
              '/// first instance encountered will be returned. Each item is evaluated',
              '/// synchronously.',
            ])
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('tupled.map(fn.tupled)')
            ..lambda = true,
    );
  }

  static Method parMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Resource<$returnTypeParam>';

    final paramType = 'Function$size<${[..._typeParams(size), returnTypeParam].join(', ')}>';

    final param = Parameter(
      (b) =>
          b
            ..name = 'fn'
            ..type = refer(paramType),
    );

    return Method(
      (b) =>
          b
            ..name = 'parMapN'
            ..docs.addAll([
              '/// Creates a new Resource that applies [fn] to the values of each respective tuple',
              '/// member if all Resources succeed. If **any** item fails or is canceled, the',
              '/// first instance encountered will be returned. Each item is evaluated',
              '/// synchronously.',
            ])
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('parTupled.map(fn.tupled)')
            ..lambda = true,
    );
  }

  static Method tupledN(int size) {
    final returnTypeParams = _typeParams(size);
    final returnType = 'Resource<(${returnTypeParams.join(',')})>';

    final impl =
        size == 2
            ? const Code('\$1.flatMap((a) => \$2.map((b) => (a, b)))')
            : const Code('init.tupled.flatMap((x) => last.map(x.appended))');

    return Method(
      (b) =>
          b
            ..name = 'tupled'
            ..docs.addAll([
              '/// Creates a new [Resource] that will return the tuple of all items if they all',
              '/// evaluate successfully. If **any** item fails or is canceled, the first',
              '/// instance encountered will be returned. Each item is evaluated',
              '/// synchronously.',
            ])
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = impl
            ..lambda = true,
    );
  }

  static Method parTupledN(int size) {
    final returnTypeParams = _typeParams(size);
    final returnType = 'Resource<(${returnTypeParams.join(',')})>';

    final impl =
        size == 2
            ? const Code('Resource.both(\$1, \$2)')
            : const Code('Resource.both(init.parTupled, last).map((t) => t.\$1.appended(t.\$2))');

    return Method(
      (b) =>
          b
            ..name = 'parTupled'
            ..docs.addAll([
              '/// Creates a new [Resource] that will return the tuple of all items if they all',
              '/// evaluate successfully. If **any** item fails or is canceled, the first',
              '/// instance encountered will be returned. Items are evaluated',
              '/// asynchronously.',
            ])
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = impl
            ..lambda = true,
    );
  }
}
