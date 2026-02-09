import 'package:code_builder/code_builder.dart';

final class EncodersGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln('''import 'package:ribs_binary/ribs_binary.dart';''');
    generatedCode.writeln('''import 'package:ribs_core/ribs_core.dart';''');

    final tupleMethods = List.generate(
      arity + 1,
      (n) => n,
    ).where((n) => n >= 2).map((n) => tupleN(n));

    final clazz = Class(
      (b) =>
          b
            ..name = 'Encoders'
            ..sealed = true
            ..methods.addAll(tupleMethods),
    );

    generatedCode.writeln(clazz.accept(DartEmitter()).toString());

    return generatedCode.toString();
  }

  static Method tupleN(int size) {
    final typeParams = List.generate(size, (i) => 'T$i');

    final returnType = 'Encoder<(${typeParams.join(', ')})>';

    final params = List.generate(
      size,
      (i) => Parameter(
        (b) =>
            b
              ..name = 'encode$i'
              ..type = refer('Encoder<${typeParams[i]}>'),
      ),
    );

    late String impl;

    if (size == 2) {
      impl = '''
        Encoder.instance(
          (tuple) => encode0.encode(tuple.\$1).flatMap((bits) => encode1.encode(tuple.last).map(bits.concat)),
        )
      ''';
    } else {
      final tupleFn = 'tuple${size - 1}';
      final tupleParams = List.generate(size - 1, (i) => 'encode$i').join(', ');

      final lastEncoder = 'encode${size - 1}';

      impl = '''
        Encoder.instance((tuple) =>
          $tupleFn($tupleParams)
            .encode(tuple.init)
            .flatMap((bits) => $lastEncoder.encode(tuple.last).map(bits.concat))
        )
      ''';
    }

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
