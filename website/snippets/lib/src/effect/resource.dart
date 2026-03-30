// ignore_for_file: avoid_print, unused_element

import 'dart:io';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// #region try-catch-finally
Future<Uint8List> copyFirstN_tryCatch(String src, String dst, int n) async {
  final input = await File(src).open();

  try {
    final output = await File(dst).open(mode: FileMode.write);

    try {
      final bytes = await input.read(n);

      await output.writeFrom(bytes);

      return bytes;
    } finally {
      await output.close();
    }
  } finally {
    await input.close();
  }
}
// #endregion try-catch-finally

// #region io-bracket
IO<Uint8List> copyFirstN_bracket(String src, String dst, int n) => IO
    .fromFutureF(() => File(src).open())
    .bracket(
      (input) => IO
          .fromFutureF(() => File(dst).open(mode: FileMode.write))
          .bracket(
            (output) => IO
                .fromFutureF(() => input.read(n))
                .flatMap((bytes) => IO.fromFutureF(() => output.writeFrom(bytes)).as(bytes)),
            (output) => IO.fromFutureF(() => output.close()).voided(),
          ),
      (input) => IO.fromFutureF(() => input.close()).voided(),
    );
// #endregion io-bracket

// #region file-example
Resource<RandomAccessFile> openFile(String path, [FileMode mode = FileMode.read]) => Resource.make(
  IO.fromFutureF(() => File(path).open(mode: mode)),
  (raf) => IO.fromFutureF(() => raf.close()).voided(),
);
// #endregion file-example

// #region file-example-use
IO<Uint8List> readFirstN(String path, int n) =>
    openFile(path).use((raf) => IO.fromFutureF(() => raf.read(n)));
// #endregion file-example-use

// #region file-example-outcome
IO<Unit> readAndReport(String path, int n) {
  final program = openFile(path).use((raf) => IO.fromFutureF(() => raf.read(n)));

  return program
      .start()
      .flatMap((fiber) => fiber.join())
      .flatMap(
        (oc) => oc.fold(
          () => IO.print('Program canceled.'),
          (err, _) => IO.print('Error: $err — but the file was still closed!'),
          (bytes) => IO.print('Read ${bytes.length} bytes.'),
        ),
      );
}
// #endregion file-example-outcome

// #region multiple-resources
/// Copy the first [n] bytes from [src] and [src2] concatenated to [dst].
IO<Unit> copyN(String src, String src2, String dst, int n) => (
  openFile(src),
  openFile(src2),
  openFile(dst, FileMode.write),
).tupled.useN(
  (a, b, out) => IO
      .fromFutureF(() => a.read(n))
      .flatMap((bytesA) => IO.fromFutureF(() => b.read(n)).map((bytesB) => [...bytesA, ...bytesB]))
      .flatMap((bytes) => IO.fromFutureF(() => out.writeFrom(bytes)).voided()),
);
// #endregion multiple-resources
