import 'package:code_builder/code_builder.dart';

final class TupleOptionOpsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''part of '../option.dart';''');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_generateTupleOptionOpsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size, (i) => 'T${i + 1}');

  /// Tuple of [size] [Option]
  static String _generateTupleOptionOpsExtension(int size) {
    final extensionName = 'Tuple${size}OptionOps<${_typeParams(size).join(', ')}>';
    final onType = '(${_typeParams(size).map((t) => 'Option<$t>').join(',')})';

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides additional functions on a tuple of $size Options.',
            )
            ..on = (refer(onType))
            ..methods.addAll([
              _tupleOptionMapN(size),
              _tupleOptionTupled(size),
            ]),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method _tupleOptionMapN(int size) {
    final returnTypeParam = 'T${size + 1}';
    final returnType = 'Option<$returnTypeParam>';

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
              '/// Applies [fn] to the values of each respective tuple member if all values',
              '/// are a [Some]. If **any** item is a [None], [None] will be returned.',
            ])
            ..types.add(refer(returnTypeParam))
            ..requiredParameters.add(param)
            ..returns = refer(returnType)
            ..body = const Code('tupled.map(fn.tupled)')
            ..lambda = true,
    );
  }

  static Method _tupleOptionTupled(int size) {
    final returnTypeParams = _typeParams(size);
    final returnType = 'Option<(${returnTypeParams.join(',')})>';

    final impl =
        size == 2
            ? const Code('\$1.flatMap((a) => \$2.map((b) => (a, b)))')
            : const Code('init.tupled.flatMap((x) => last.map(x.appended))');

    return Method(
      (b) =>
          b
            ..name = 'tupled'
            ..docs.addAll([
              '/// If **all** items of this tuple are a [Some], the respective items are',
              '/// turned into a tuple and returned as a [Some]. If **any** item is a',
            ])
            ..type = MethodType.getter
            ..returns = refer(returnType)
            ..body = impl
            ..lambda = true,
    );
  }
}
