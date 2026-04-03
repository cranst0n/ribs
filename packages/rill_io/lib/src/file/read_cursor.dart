import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

/// An immutable cursor for reading bytes from a [FileHandle] at a tracked
/// offset.
///
/// [ReadCursor] pairs a [FileHandle] with a byte [offset], enabling
/// sequential reads without manually managing file positions. Each read
/// operation returns a **new** [ReadCursor] whose offset has been advanced by
/// the number of bytes consumed, leaving the original cursor unchanged.
///
/// Cursors are typically obtained via [Files.readCursor] rather than
/// constructed directly:
///
/// ```dart
/// Files.readCursor(path, Flags.Read).use((cursor) {
///   return cursor.readAll(8192).rill.compile.drain;
/// });
/// ```
extension type ReadCursor((FileHandle, int) _repr) {
  /// Creates a [ReadCursor] positioned at [offset] within [file].
  static ReadCursor of(FileHandle file, int offset) => ReadCursor((file, offset));

  /// The underlying file handle this cursor reads from.
  FileHandle get file => _repr.$1;

  /// The current byte offset into the file.
  int get offset => _repr.$2;

  /// Reads up to [chunkSize] bytes starting at the current [offset].
  ///
  /// Returns [None] when the end of the file has been reached. Otherwise
  /// returns a [Some] containing a tuple of the advanced [ReadCursor] and
  /// the [Chunk] of bytes that were read.
  IO<Option<(ReadCursor, Chunk<int>)>> read(int chunkSize) {
    return file.read(chunkSize, offset).map((chunkOpt) {
      return chunkOpt.map((chunk) {
        return (ReadCursor((file, offset + chunk.size)), chunk);
      });
    });
  }

  /// Lifts [read] into a [Pull], making it composable with other pull-based
  /// operations.
  ///
  /// The resulting [Pull] evaluates a single [read] of [chunkSize] bytes and
  /// completes with the optional cursor/chunk pair.
  Pull<Never, Option<(ReadCursor, Chunk<int>)>> readPull(int chunkSize) =>
      Pull.eval(read(chunkSize));

  /// Reads the entire file from the current [offset] to EOF, emitting chunks
  /// of at most [chunkSize] bytes.
  ///
  /// The returned [Pull] outputs byte chunks as downstream elements and
  /// completes with the final [ReadCursor] positioned at EOF.
  Pull<int, ReadCursor> readAll(int chunkSize) => readPull(chunkSize).flatMap(
    (nextOpt) => nextOpt.foldN(
      () => Pull.pure(this),
      (next, chunk) => Pull.output(chunk).append(() => next.readAll(chunkSize)),
    ),
  );

  /// Reads bytes from the current [offset] up to (but not including) the
  /// [end] byte position, emitting chunks of at most [chunkSize] bytes.
  ///
  /// If the current [offset] is already at or past [end], the [Pull]
  /// completes immediately. Otherwise, each read is clamped so that no
  /// bytes beyond [end] are requested. The [Pull] completes with the final
  /// [ReadCursor], which may be positioned before [end] if the file is
  /// shorter than expected.
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

  /// Returns a new [ReadCursor] positioned at the given byte [position]
  /// within the same file.
  ReadCursor seek(int position) => ReadCursor((file, position));

  /// Continuously reads from the file, following new data as it is appended
  /// (similar to `tail -f`).
  ///
  /// Reads chunks of at most [chunkSize] bytes. When the end of the file is
  /// reached, the [Pull] sleeps for [pollDelay] before retrying, allowing it
  /// to pick up newly appended content. This [Pull] never terminates on its
  /// own — it must be cancelled or interrupted externally.
  Pull<int, ReadCursor> tail(int chunkSize, Duration pollDelay) {
    return readPull(chunkSize).flatMap((nextOpt) {
      return nextOpt.foldN(
        () => Pull.eval(IO.sleep(pollDelay)).append(() => tail(chunkSize, pollDelay)),
        (next, chunk) => Pull.output(chunk).append(() => next.tail(chunkSize, pollDelay)),
      );
    });
  }
}
