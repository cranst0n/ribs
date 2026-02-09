import 'package:code_builder/code_builder.dart';

final class DecodersGenerator {
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
            ..name = 'Decoders'
            ..sealed = true
            ..methods.addAll(tupleMethods),
    );

    generatedCode.writeln(clazz.accept(DartEmitter()).toString());

    return generatedCode.toString();
  }

  static Method tupleN(int size) {
    final typeParams = List.generate(size, (i) => 'T$i');

    final returnType = 'Decoder<(${typeParams.join(', ')})>';

    final params = List.generate(
      size,
      (i) => Parameter(
        (b) =>
            b
              ..name = 'decode$i'
              ..type = refer('Decoder<${typeParams[i]}>'),
      ),
    );

    late String impl;

    if (size == 2) {
      impl = '''
        Decoder.instance(
          (bv) => decode0
            .decode(bv)
            .flatMap(
              (t0) =>
                  decode1.decode(t0.remainder).map((t1) => DecodeResult((t0.value, t1.value), t1.remainder)),
            ),
        )
      ''';
    } else {
      final tupleFn = 'tuple${size - 1}';
      final tupleParams = List.generate(size - 1, (i) => 'decode$i').join(', ');

      final lastDecoder = 'decode${size - 1}';

      impl = '''
        Decoder.instance((bv) {
          return $tupleFn($tupleParams).decode(bv).flatMap((t) {
             return $lastDecoder
              .decode(t.remainder)
              .map((x) => DecodeResult(t.value.appended(x.value), x.remainder));
          });
        })
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
