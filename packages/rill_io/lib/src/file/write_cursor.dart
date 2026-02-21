import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

extension type WriteCursor((FileHandle, int) _repr) {
  static WriteCursor of(FileHandle file, int offset) => WriteCursor((file, offset));

  FileHandle get file => _repr.$1;
  int get offset => _repr.$2;

  WriteCursor seek(int position) => WriteCursor((file, position));

  IO<WriteCursor> write(Chunk<int> bytes) {
    return file.write(bytes, offset).flatMap((written) {
      final next = WriteCursor((file, offset + written));

      if (written == bytes.length) {
        return IO.pure(next);
      } else {
        return next.write(bytes.drop(written));
      }
    });
  }

  Pull<Never, WriteCursor> writePull(Chunk<int> bytes) => Pull.eval(write(bytes));

  Pull<Never, WriteCursor> writeAll(Rill<int> rill) {
    return rill.pull.uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(this),
        (hd, tl) => writePull(hd).flatMap((cursor) => cursor.writeAll(tl)),
      );
    });
  }
}
