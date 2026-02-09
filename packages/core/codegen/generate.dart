// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_style/dart_style.dart';

import 'either_tuple_ops_generator.dart';
import 'function_ops_generator.dart';
import 'function_typedef_generator.dart';
import 'functionc_ops_generator.dart';
import 'functionc_typedef_generator.dart';
import 'ilist_tuple_generator.dart';
import 'option_tuple_generator.dart';
import 'tuple_either_ops_generator.dart';
import 'tuple_generator.dart';
import 'tuple_option_generator.dart';
import 'tuple_validated_nel_generator.dart';

const arity = 22;

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
  pageWidth: 100,
  trailingCommas: TrailingCommas.preserve,
);

void main(List<String> args) {
  final libFile = File('lib/ribs_core.dart');

  if (!libFile.existsSync()) {
    print('Script should be run from base of dart package.');
    exit(1);
  }

  // Functions
  genFile('lib/src/generated/function_typedefs.dart', FunctionTypedefGenerator.generate);
  genFile('lib/src/generated/functionc_typedefs.dart', FunctionCTypedefGenerator.generate);
  genFile('lib/src/generated/function_ops.dart', FunctionOpsGenerator.generate);
  genFile('lib/src/generated/functionc_ops.dart', FunctionCOpsGenerator.generate);

  // Either
  genFile('lib/src/syntax/generated/either_tuple.dart', EitherTupleOpsGenerator.generate);
  genFile('lib/src/syntax/generated/tuple_either.dart', TupleEitherOpsGenerator.generate);

  // Option
  genFile('lib/src/syntax/generated/option_tuple.dart', OptionTupleOpsGenerator.generate);
  genFile('lib/src/syntax/generated/tuple_option.dart', TupleOptionOpsGenerator.generate);

  genFile('lib/src/syntax/generated/tuple.dart', TupleOpsGenerator.generate);

  // Validated
  genFile(
    'lib/src/syntax/generated/tuple_validated_nel.dart',
    TupleValidatedNelOpsGenerator.generate,
  );

  // IList
  genFile(
    'lib/src/collection/immutable/generated/ilist_tuple.dart',
    IListTupleOpsGenerator.generate,
  );
}

void genFile(String destinationPath, String Function(int) generator) {
  final tupleResourceFile = File(destinationPath);
  tupleResourceFile.createSync(recursive: true);
  tupleResourceFile.writeAsStringSync(formatter.format(generator(arity)));
}
