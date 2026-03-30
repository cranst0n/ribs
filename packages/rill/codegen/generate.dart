// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'rill_tuple_ops_generator.dart';

const arity = 22;
const fnArity = 5;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_rill.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  genFile('lib/src/syntax/generated/rill_tuple.dart', RillTupleOpsGenerator.generate, fnArity);
}

void genFile(String destinationPath, String Function(int) generator, [int? arityOverride]) {
  final file = File(destinationPath);
  file.createSync(recursive: true);
  file.writeAsStringSync(formatter.format(generator(arityOverride ?? arity)));
}
