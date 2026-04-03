final class PropSyntaxGenerator {
  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static String generate(int arity) {
    final buf = StringBuffer();
    buf.writeln("import 'dart:async';");
    buf.writeln();
    buf.writeln("import 'package:meta/meta.dart';");
    buf.writeln("import 'package:ribs_check/ribs_check.dart';");
    buf.writeln("import 'package:ribs_core/ribs_core.dart';");
    buf.writeln("import 'package:test/test.dart';");
    buf.writeln();
    buf.writeln(_forAllFunction());
    buf.writeln();
    buf.writeln(_propOpsExtension());

    for (int size = 2; size <= arity; size++) {
      buf.writeln();
      buf.writeln(_propTupleExtension(size));
    }

    return buf.toString();
  }

  static List<String> _typeParams(int size) =>
      List.generate(size, (i) => _letters[i]);

  static String _forAllFunction() => '''
@isTest
void _forAll<T>(
  String description,
  Gen<T> gen,
  TestBody<T> testBody, {
  int? numTests,
  int? seed,
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) => Prop(description, gen, testBody).run(
  numTests: numTests,
  seed: seed,
  testOn: testOn,
  timeout: timeout,
  skip: skip,
  tags: tags,
  onPlatform: onPlatform,
  retry: retry,
);''';

  static String _propOpsExtension() => '''
extension PropOps<A> on Gen<A> {
  @isTest
  void forAll(
    String description,
    Function1<A, FutureOr<void>> testBody, {
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) => _forAll(
    description,
    this,
    testBody,
    numTests: numTests,
    seed: seed,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}''';

  static String _propTupleExtension(int size) {
    final params = _typeParams(size);
    final onType = '(${params.map((p) => 'Gen<$p>').join(', ')})';
    final tupleType = '(${params.join(', ')})';
    final functionType =
        'Function$size<${[...params, 'FutureOr<void>'].join(', ')}>';
    final dollarArgs =
        List.generate(size, (i) => '\$${i + 1}').join(', ');

    return 'extension PropTuple${size}Ops<${params.join(', ')}> on $onType {\n'
        '  @isTest\n'
        '  void forAll(\n'
        '    String description,\n'
        '    $functionType testBody, {\n'
        '    int? numTests,\n'
        '    int? seed,\n'
        '    String? testOn,\n'
        '    Timeout? timeout,\n'
        '    dynamic skip,\n'
        '    dynamic tags,\n'
        '    Map<String, dynamic>? onPlatform,\n'
        '    int? retry,\n'
        '  }) => _forAll<$tupleType>(\n'
        '    description,\n'
        '    ($dollarArgs).tupled,\n'
        '    testBody.tupled,\n'
        '    numTests: numTests,\n'
        '    seed: seed,\n'
        '    testOn: testOn,\n'
        '    timeout: timeout,\n'
        '    skip: skip,\n'
        '    tags: tags,\n'
        '    onPlatform: onPlatform,\n'
        '    retry: retry,\n'
        '  );\n'
        '}';
  }
}
