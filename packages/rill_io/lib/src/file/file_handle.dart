import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A low-level handle to an open file, providing random-access read and write
/// operations.
///
/// [FileHandle] is obtained via [Files.open] and is resource-managed — the
/// handle is automatically closed when the enclosing [Resource] is released.
/// For sequential access patterns, prefer [ReadCursor] and [WriteCursor]
/// which track the file offset for you.
abstract class FileHandle {
  /// Flushes any buffered writes to the underlying storage.
  IO<Unit> flush();

  /// Reads up to [numBytes] bytes starting at the given byte [offset].
  ///
  /// Returns [None] when the end of the file has been reached. Otherwise
  /// returns a [Some] containing the [Chunk] of bytes that were read,
  /// which may be shorter than [numBytes].
  IO<Option<Chunk<int>>> read(int numBytes, int offset);

  /// Returns the current size of the file in bytes.
  IO<int> get size;

  /// Truncates (or extends) the file to the given [size] in bytes.
  IO<Unit> truncate(int size);

  /// Writes [bytes] to the file starting at the given byte [offset].
  ///
  /// Returns the number of bytes actually written, which may be fewer than
  /// `bytes.length` (a short write). Callers should retry with the
  /// remaining bytes if needed — see [WriteCursor.write] for an
  /// implementation that handles this automatically.
  IO<int> write(Chunk<int> bytes, int offset);
}
