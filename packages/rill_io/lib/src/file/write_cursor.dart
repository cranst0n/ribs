import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

/// An immutable cursor for writing bytes to a [FileHandle] at a tracked
/// offset.
///
/// [WriteCursor] pairs a [FileHandle] with a byte [offset], enabling
/// sequential writes without manually managing file positions. Each write
/// operation returns a **new** [WriteCursor] whose offset has been advanced by
/// the number of bytes written, leaving the original cursor unchanged.
///
/// Cursors are typically obtained via [Files.writeCursor] rather than
/// constructed directly:
///
/// ```dart
/// Files.writeCursor(path, Flags.Write).use((cursor) {
///   return cursor.writeAll(byteRill).rill.compile.drain;
/// });
/// ```
extension type WriteCursor((FileHandle, int) _repr) {
  /// Creates a [WriteCursor] positioned at [offset] within [file].
  static WriteCursor of(FileHandle file, int offset) => WriteCursor((file, offset));

  /// The underlying file handle this cursor writes to.
  FileHandle get file => _repr.$1;

  /// The current byte offset into the file.
  int get offset => _repr.$2;

  /// Returns a new [WriteCursor] positioned at the given byte [position]
  /// within the same file.
  WriteCursor seek(int position) => WriteCursor((file, position));

  /// Writes all of [bytes] to the file starting at the current [offset].
  ///
  /// If the underlying file handle performs a short write (fewer bytes than
  /// requested), the remaining bytes are retried automatically until the
  /// entire chunk has been written. The returned [WriteCursor] is positioned
  /// immediately after the last byte written.
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

  /// Lifts [write] into a [Pull], making it composable with other pull-based
  /// operations.
  ///
  /// The resulting [Pull] evaluates a single [write] of [bytes] and completes
  /// with the advanced [WriteCursor]. No output elements are emitted.
  Pull<Never, WriteCursor> writePull(Chunk<int> bytes) => Pull.eval(write(bytes));

  /// Consumes the entire [rill] stream, writing each chunk sequentially to
  /// the file.
  ///
  /// Chunks are pulled one at a time and written in order. The [Pull]
  /// completes with the final [WriteCursor] positioned after all bytes have
  /// been written. No output elements are emitted.
  Pull<Never, WriteCursor> writeAll(Rill<int> rill) {
    return rill.pull.uncons.flatMap((hdtl) {
      return hdtl.foldN(
        () => Pull.pure(this),
        (hd, tl) => writePull(hd).flatMap((cursor) => cursor.writeAll(tl)),
      );
    });
  }
}
