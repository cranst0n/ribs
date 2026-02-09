// ignore_for_file: avoid_print, unused_element

import 'dart:io';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

Future<void> snippet1() async {
  // file-example
  final Resource<RandomAccessFile> fileResource = Resource.make(
    IO.fromFutureF(() => File('/path/to/file.bin').open()),
    (raf) => IO.exec(() => raf.close()),
  );
  // file-example

  // file-example-use
  // Use the resource by passing an IO op to the 'use' function
  final IO<Uint8List> program = fileResource.use((raf) => IO.fromFutureF(() => raf.read(100)));

  (await program.unsafeRunFutureOutcome()).fold(
    () => print('Program canceled.'),
    (err, stackTrace) => print('Error: $err. But the file was still closed!'),
    (bytes) => print('Read ${bytes.length} bytes from file.'),
  );

  // file-example-use
}

void snippet2() {
  // multiple-resources
  Resource<RandomAccessFile> openFile(String path) => Resource.make(
    IO.fromFutureF(() => File(path).open()),
    (raf) => IO.exec(() => raf.close()),
  );

  IO<Uint8List> readBytes(RandomAccessFile raf, int n) => IO.fromFutureF(() => raf.read(n));
  IO<Unit> writeBytes(RandomAccessFile raf, Uint8List bytes) =>
      IO.fromFutureF(() => raf.writeFrom(bytes)).voided();

  Uint8List concatBytes(Uint8List a, Uint8List b) =>
      Uint8List.fromList([a, b].expand((element) => element).toList());

  /// Copy the first [n] bytes from [fromPathA] and [fromPathB], then write
  /// bytes to [toPath]
  IO<Unit> copyN(String fromPathA, String fromPathB, String toPath, int n) =>
      (openFile(fromPathA), openFile(fromPathB), openFile(toPath)).tupled.useN(
        (fromA, fromB, to) {
          return (
            readBytes(fromA, n),
            readBytes(fromB, n),
          ).parMapN(concatBytes).flatMap((a) => writeBytes(to, a));
        },
      );

  copyN(
    '/from/this/file',
    '/and/this/file',
    '/to/that/file',
    100,
  ).unsafeRunAndForget();
  // multiple-resources
}
