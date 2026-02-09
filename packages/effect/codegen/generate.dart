// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'io_tuple_ops_generator.dart';
import 'resource_tuple_ops_generator.dart';
import 'tuple_io_ops_generator.dart';
import 'tuple_resource_ops_generator.dart';

const arity = 22;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_effect.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  genFile('lib/src/syntax/generated/io_tuple.dart', IOTupleOpsGenerator.generate);
  genFile('lib/src/syntax/generated/tuple_io.dart', TupleIOOpsGenerator.generate);
  genFile('lib/src/syntax/generated/resource_tuple.dart', ResourceTupleOpsGenerator.generate);
  genFile('lib/src/syntax/generated/tuple_resource.dart', TupleResourceOpsGenerator.generate);
}

void genFile(String destinationPath, String Function(int) generator) {
  final tupleResourceFile = File(destinationPath);
  tupleResourceFile.createSync(recursive: true);
  tupleResourceFile.writeAsStringSync(formatter.format(generator(arity)));
}
