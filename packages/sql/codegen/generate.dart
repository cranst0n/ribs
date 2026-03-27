// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'read_syntax_generator.dart';
import 'read_write_syntax_generator.dart';
import 'write_syntax_generator.dart';

const arity = 22;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_sql.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  genFile('lib/src/generated/read_syntax.dart', ReadSyntaxGenerator.generate);
  genFile('lib/src/generated/read_write_syntax.dart', ReadWriteSyntaxGenerator.generate);
  genFile('lib/src/generated/write_syntax.dart', WriteSyntaxGenerator.generate);
}

void genFile(String destinationPath, String Function(int) generator) {
  final file = File(destinationPath);
  file.createSync(recursive: true);
  file.writeAsStringSync(formatter.format(generator(arity)));
}
