import 'package:code_builder/code_builder.dart';

final class CodecsGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''import 'package:ribs_binary/ribs_binary.dart';''');
    generatedCode.writeln('''import 'package:ribs_core/ribs_core.dart';''');

    final productMethods = List.generate(
      arity + 1,
      (n) => n,
    ).where((n) => n >= 2).map((n) => productN(n));

    final tupleMethods = List.generate(
      arity + 1,
      (n) => n,
    ).where((n) => n >= 2).map((n) => tupleN(n));

    final clazz = Class(
      (b) =>
          b
            ..name = 'Codecs'
            ..sealed = true
            ..methods.addAll(tupleMethods)
            ..methods.addAll(productMethods),
    );

    generatedCode.writeln(clazz.accept(DartEmitter()).toString());

    return generatedCode.toString();
  }

  static Method productN(int size) {
    final typeParams = List.generate(size + 1, (i) => 'T$i');

    final returnType = 'Codec<${typeParams.last}>';

    final codecParams = List.generate(
      size,
      (i) => Parameter(
        (b) =>
            b
              ..name = 'codec$i'
              ..type = refer('Codec<${typeParams[i]}>'),
      ),
    );

    final applyParam = Parameter(
      (b) =>
          b
            ..name = 'apply'
            ..type = refer('Function$size<${typeParams.join(', ')}>'),
    );

    final tupledParam = Parameter(
      (b) =>
          b
            ..name = 'tupled'
            ..type = refer('Function1<${typeParams.last},(${typeParams.take(size).join(', ')})>'),
    );

    final impl =
        'tuple$size(${codecParams.map((p) => p.name).join(', ')}).xmap(apply.tupled, tupled)';

    return Method(
      (b) =>
          b
            ..static = true
            ..name = 'product$size'
            ..types.addAll(typeParams.map(refer))
            ..returns = refer(returnType)
            ..requiredParameters.addAll([...codecParams, applyParam, tupledParam])
            ..body = Code(impl)
            ..lambda = true,
    );
  }

  static Method tupleN(int size) {
    final typeParams = List.generate(size, (i) => 'T$i');

    final returnType = 'Codec<(${typeParams.join(', ')})>';

    final params = List.generate(
      size,
      (i) => Parameter(
        (b) =>
            b
              ..name = 'codec$i'
              ..type = refer('Codec<${typeParams[i]}>'),
      ),
    );

    final tupleCall = 'tuple$size(${List.generate(size, (i) => 'codec$i').join(', ')})';

    final impl = 'Codec.of(Decoder.$tupleCall, Encoder.$tupleCall)';

    return Method(
      (b) =>
          b
            ..static = true
            ..name = 'tuple$size'
            ..types.addAll(typeParams.map(refer))
            ..returns = refer(returnType)
            ..requiredParameters.addAll(params)
            ..body = Code(impl)
            ..lambda = true,
    );
  }
}
