import 'package:code_builder/code_builder.dart';

final class CodecSyntaxGenerator {
  static String generate(int arity) {
    final generatedCode = StringBuffer();

    generatedCode.writeln("import 'package:ribs_binary/ribs_binary.dart';");
    generatedCode.writeln("import 'package:ribs_core/ribs_core.dart';");

    for (int tupleSize = 2; tupleSize <= arity; tupleSize++) {
      generatedCode.writeln(_opsExtension(tupleSize));
    }

    return generatedCode.toString();
  }

  static List<String> _typeParams(int size) => List.generate(size, (i) => 'T$i');

  static String _outputParam(int size) => 'T$size';

  static String _opsExtension(int size) {
    final params = _typeParams(size);
    final output = _outputParam(size);
    final extensionName = 'CodecTuple${size}Ops<${params.join(', ')}>';
    final onType = '(${params.map((t) => 'Codec<$t>').join(', ')})';
    final dollarArgs = List.generate(size, (i) => 'this.\$${i + 1}').join(', ');

    final extension = Extension(
      (b) =>
          b
            ..name = extensionName
            ..docs.add('/// Provides a product operation on a $size-tuple of [Codec]s.')
            ..on = refer(onType)
            ..methods.add(_productMethod(size, params, output, dollarArgs)),
    );

    return extension.accept(DartEmitter()).toString();
  }

  static Method _productMethod(
    int size,
    List<String> params,
    String output,
    String args,
  ) {
    final tupleType = '(${params.join(', ')})';
    final applyType = 'Function$size<${[...params, output].join(', ')}>';
    final tupledType = 'Function1<$output, $tupleType>';

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
            ..body = Code('Codec.product$size($args, apply, tupled)')
            ..lambda = true,
    );
  }
}
