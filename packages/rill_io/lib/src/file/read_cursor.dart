import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

extension type ReadCursor((FileHandle, int) _repr) {
  static ReadCursor of(FileHandle file, int offset) => ReadCursor((file, offset));

  FileHandle get file => _repr.$1;
  int get offset => _repr.$2;

  IO<Option<(ReadCursor, Chunk<int>)>> read(int chunkSize) {
    return file.read(chunkSize, offset).map((chunkOpt) {
      return chunkOpt.map((chunk) {
        return (ReadCursor((file, offset + chunk.size)), chunk);
      });
    });
  }

  Pull<Never, Option<(ReadCursor, Chunk<int>)>> readPull(int chunkSize) =>
      Pull.eval(read(chunkSize));

  Pull<int, ReadCursor> readAll(int chunkSize) => readPull(chunkSize).flatMap(
    (nextOpt) => nextOpt.foldN(
      () => Pull.pure(this),
      (next, chunk) => Pull.output(chunk).append(() => next.readAll(chunkSize)),
    ),
  );

  Pull<int, ReadCursor> readUntil(int chunkSize, int end) {
    if (offset < end) {
      final toRead = min(end - offset, chunkSize);
      return readPull(toRead).flatMap((nextOpt) {
        return nextOpt.foldN(
          () => Pull.pure(this),
          (next, chunk) => Pull.output(chunk).append(() => next.readUntil(chunkSize, end)),
        );
      });
    } else {
      return Pull.pure(this);
    }
  }

  ReadCursor seek(int position) => ReadCursor((file, position));

  Pull<int, ReadCursor> tail(int chunkSize, Duration pollDelay) {
    return readPull(chunkSize).flatMap((nextOpt) {
      return nextOpt.foldN(
        () => Pull.eval(IO.sleep(pollDelay)).append(() => tail(chunkSize, pollDelay)),
        (next, chunk) => Pull.output(chunk).append(() => next.tail(chunkSize, pollDelay)),
      );
    });
  }
}
