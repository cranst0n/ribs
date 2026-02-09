// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'codecs_generator.dart';
import 'decoders_generator.dart';
import 'encoders_generator.dart';

const arity = 22;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_binary.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  // There are useful to generate the functions, but API-wise I want
  // the generated code as static members on the classes themselves so
  // when needed, generate the files, copy and paste the generated code
  // into the resprective classes and then delete the generated files.
  genFile('lib/src/generated/codecs.dart', CodecsGenerator.generate);
  genFile('lib/src/generated/decoders.dart', DecodersGenerator.generate);
  genFile('lib/src/generated/encoders.dart', EncodersGenerator.generate);
}

void genFile(String destinationPath, String Function(int) generator) {
  final tupleResourceFile = File(destinationPath);
  tupleResourceFile.createSync(recursive: true);
  tupleResourceFile.writeAsStringSync(formatter.format(generator(arity)));
}
