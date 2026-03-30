// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// #region pipe-basic
// A Pipe<I, O> is just a type alias for a function from Rill<I> to Rill<O>.
// Define one as an ordinary Dart function or a named variable.

Pipe<int, String> numberToLabel = (rill) => rill.map((int n) => 'item-$n');

IO<Unit> pipeBasic() => Rill.range(1, 4)
    .through(numberToLabel)
    .compile
    .toIList
    .flatMap((IList<String> xs) => IO.print('labels: $xs')); // [item-1, item-2, item-3]
// #endregion pipe-basic

// #region pipe-compose
// Compose pipes by applying one after the other with .through, or wrap
// two pipes in a new function to create a named composed pipe.

Pipe<int, String> evensAsLabels = (rill) => rill.filter((int n) => n.isEven).through(numberToLabel);

IO<Unit> pipeCompose() => Rill.range(1, 11)
    .through(evensAsLabels)
    .compile
    .toIList
    .flatMap(
      (IList<String> xs) => IO.print('even labels: $xs'),
    ); // [item-2, item-4, item-6, item-8, item-10]
// #endregion pipe-compose

// #region pipe-text
/// Decode a raw byte stream to newline-delimited strings.
///
/// This is the typical shape for reading a text file:
///   bytes → UTF-8 decode → split by line
Rill<String> decodeLines(Rill<int> bytes) =>
    bytes.through(Pipes.text.utf8.decode).through(Pipes.text.lines);

/// Encode a `Rill<String>` to UTF-8 bytes then to a base64 string stream.
Rill<String> encodeBase64(Rill<String> text) =>
    text.through(Pipes.text.utf8.encode).through(Pipes.text.base64.encode);

IO<Unit> pipeTextExample() {
  // Simulate a raw byte stream for "hello\nworld" encoded as UTF-8.
  final bytes = Rill.emits('hello\nworld'.codeUnits.toList());

  return decodeLines(bytes).compile.toIList.flatMap(
    (IList<String> lines) => IO.print('lines: $lines'),
  ); // [hello, world]
}

// #endregion pipe-text
