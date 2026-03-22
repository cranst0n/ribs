// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'codec_syntax_generator.dart';

const arity = 22;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_json.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  genFile('lib/src/codec/generated/syntax.dart', CodecSyntaxGenerator.generate);
}

void genFile(String destinationPath, String Function(int) generator) {
  final file = File(destinationPath);
  file.createSync(recursive: true);
  file.writeAsStringSync(formatter.format(generator(arity)));
}
