import 'package:code_builder/code_builder.dart';

final class RillTupleOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../rill.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(generateOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  static String generateOpsExtension(int size) {
    final extensionName = 'RillTuple${size}Ops<${typeParams(size).join(', ')}>';
    final onType = 'Rill<(${typeParams(size).join(',')})>';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on a Rill of a $size element tuple.',
            )
            ..on = refer(onType)
            ..methods.addAll([
              collectN(size),
              evalMapN(size),
              evalTapN(size),
              filterN(size),
              filterNotN(size),
              flatMapN(size),
              mapN(size),
              parEvalMapN(size),
              parEvalMapUnboundedN(size),
              parEvalMapUnorderedN(size),
              parEvalMapUnorderedUnboundedN(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static Parameter _functionParam(int size, String returnType) => Parameter(
    (b) =>
        b
          ..name = 'f'
          ..type = refer('Function$size<${typeParams(size).join(', ')}, $returnType>'),
  );

  static Parameter _maxConcurrentParam() => Parameter(
    (b) =>
        b
          ..name = 'maxConcurrent'
          ..type = refer('int'),
  );

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------

  static Method collectN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'collectN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, 'Option<$returnTypeParam>'))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('collect(f.tupled)')
            ..lambda = true,
    );
  }

  static Method evalMapN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'evalMapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, 'IO<$returnTypeParam>'))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('evalMap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method evalTapN(int size) {
    final selfType = 'Rill<(${typeParams(size).join(', ')})>';

    return Method(
      (b) =>
          b
            ..name = 'evalTapN'
            ..types.add(refer('T${size + 1}'))
            ..requiredParameters.add(_functionParam(size, 'IO<T${size + 1}>'))
            ..returns = refer(selfType)
            ..body = const Code('evalTap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method filterN(int size) {
    final selfType = 'Rill<(${typeParams(size).join(', ')})>';

    return Method(
      (b) =>
          b
            ..name = 'filterN'
            ..requiredParameters.add(_functionParam(size, 'bool'))
            ..returns = refer(selfType)
            ..body = const Code('filter(f.tupled)')
            ..lambda = true,
    );
  }

  static Method filterNotN(int size) {
    final selfType = 'Rill<(${typeParams(size).join(', ')})>';

    return Method(
      (b) =>
          b
            ..name = 'filterNotN'
            ..requiredParameters.add(_functionParam(size, 'bool'))
            ..returns = refer(selfType)
            ..body = const Code('filterNot(f.tupled)')
            ..lambda = true,
    );
  }

  static Method flatMapN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'flatMapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, 'Rill<$returnTypeParam>'))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('flatMap(f.tupled)')
            ..lambda = true,
    );
  }

  static Method mapN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'mapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, returnTypeParam))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('map(f.tupled)')
            ..lambda = true,
    );
  }

  static Method parEvalMapN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'parEvalMapN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.addAll([
              _maxConcurrentParam(),
              _functionParam(size, 'IO<$returnTypeParam>'),
            ])
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('parEvalMap(maxConcurrent, f.tupled)')
            ..lambda = true,
    );
  }

  static Method parEvalMapUnboundedN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'parEvalMapUnboundedN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, 'IO<$returnTypeParam>'))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('parEvalMapUnbounded(f.tupled)')
            ..lambda = true,
    );
  }

  static Method parEvalMapUnorderedN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'parEvalMapUnorderedN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.addAll([
              _maxConcurrentParam(),
              _functionParam(size, 'IO<$returnTypeParam>'),
            ])
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('parEvalMapUnordered(maxConcurrent, f.tupled)')
            ..lambda = true,
    );
  }

  static Method parEvalMapUnorderedUnboundedN(int size) {
    final returnTypeParam = 'T${size + 1}';

    return Method(
      (b) =>
          b
            ..name = 'parEvalMapUnorderedUnboundedN'
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(_functionParam(size, 'IO<$returnTypeParam>'))
            ..returns = refer('Rill<$returnTypeParam>')
            ..body = const Code('parEvalMapUnorderedUnbounded(f.tupled)')
            ..lambda = true,
    );
  }
}
