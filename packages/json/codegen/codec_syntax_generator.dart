import 'package:code_builder/code_builder.dart';

final class CodecSyntaxGenerator {
  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln("import 'package:ribs_core/ribs_core.dart';");
    generatedCode.writeln("import 'package:ribs_json/ribs_json.dart';");
    generatedCode.writeln();
    generatedCode.writeln('extension<A> on (String, Codec<A>) {');
    generatedCode.writeln(
      '  KeyValueCodec<A> get kv => KeyValueCodec(\$1, \$2);',
    );
    generatedCode.writeln('}');

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_kvOpsExtension(tupleSize));
      generatedCode.writeln(_opsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) =>
      List.generate(size, (i) => _letters[i]);

  static String _outputParam(int size) => _letters[size];

  static String _kvOpsExtension(int size) {
    final params = _typeParams(size);
    final output = _outputParam(size);
    final extensionName = 'Codec${size}KVOps<${params.join(', ')}>';
    final onType =
        '(${params.map((t) => 'KeyValueCodec<$t>').join(', ')})';

    final dollarArgs = List.generate(size, (i) => '\$${i + 1}').join(', ');

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides a product operation on a $size-tuple of [KeyValueCodec]s.',
            )
            ..on = refer(onType)
            ..methods.add(_productMethod(size, params, output, dollarArgs, kv: true)),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static String _opsExtension(int size) {
    final params = _typeParams(size);
    final output = _outputParam(size);
    final extensionName = 'Codec${size}Ops<${params.join(', ')}>';
    final onType =
        '(${params.map((t) => '(String, Codec<$t>)').join(', ')})';

    final kvArgs = List.generate(size, (i) => '\$${i + 1}.kv').join(', ');

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add(
              '/// Provides a product operation on a $size-tuple of (String, [Codec]) pairs.',
            )
            ..on = refer(onType)
            ..methods.add(_productMethod(size, params, output, kvArgs, kv: false)),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method _productMethod(
    int size,
    List<String> params,
    String output,
    String args, {
    required bool kv,
  }) {
    final tupleType = '(${params.join(', ')})';
    final applyType = 'Function$size<${[...params, output].join(', ')}>';
    final tupledType = 'Function1<$output, $tupleType>';

    final body =
        kv
            ? Code('Codec.product$size($args, apply, tupled)')
            : Code('($args).product(apply, tupled)');

    return Method(
      (b) =>
          b
            ..name = 'product'
            ..types.add(refer(output))
            ..requiredParameters.addAll([
              Parameter(
                (b) =>
                    b
                      ..name = 'apply'
                      ..type = refer(applyType),
              ),
              Parameter(
                (b) =>
                    b
                      ..name = 'tupled'
                      ..type = refer(tupledType),
              ),
            ])
            ..returns = refer('Codec<$output>')
            ..body = body
            ..lambda = true,
    );
  }
}
