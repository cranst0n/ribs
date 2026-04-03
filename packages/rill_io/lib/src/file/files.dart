import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/file/files_platform/files_platform.dart';

/// Pure, effectful filesystem operations.
///
/// [Files] provides a static API for common filesystem tasks — reading,
/// writing, copying, deleting, watching, and more — all expressed as [IO],
/// [Rill], or [Resource] values that are referentially transparent and only
/// execute when interpreted.
///
/// ```dart
/// // Read a file as UTF-8 text, line by line:
/// final lines = Files.readUtf8Lines(Path('readme.md'));
///
/// // Write a stream of bytes to a file:
/// byteRill.through(Files.writeAll(Path('output.bin'))).compile.drain;
/// ```
final class Files {
  const Files._();

  static const _defaultChunkSize = 64 * 1024;

  static final _platform = FilesPlatform();

  /// Copies the file at [source] to [target].
  static IO<Unit> copy(Path source, Path target) => _platform.copy(source, target);

  /// Creates a directory at [path].
  ///
  /// If [recursive] is `true`, any missing parent directories are also
  /// created.
  static IO<Unit> createDirectory(Path path, {bool? recursive}) =>
      _platform.createDirectory(path, recursive: recursive);

  /// Creates an empty file at [path].
  ///
  /// If [recursive] is `true`, any missing parent directories are created
  /// first. If [exclusive] is `true`, the operation fails when the file
  /// already exists.
  static IO<Unit> createFile(
    Path path, {
    bool? recursive,
    bool? exclusive,
  }) => _platform.createFile(path, recursive: recursive, exclusive: exclusive);

  /// Creates a symbolic link at [link] pointing to [existing].
  ///
  /// If [recursive] is `true`, any missing parent directories of [link] are
  /// created first.
  static IO<Unit> createSymbolicLink(
    Path link,
    Path existing, {
    bool recursive = false,
  }) => _platform.createSymbolicLink(link, existing);

  /// Creates a temporary directory.
  ///
  /// The directory is created inside [dir] (or the system default temp
  /// location when [None]) with an optional name [prefix].
  static IO<Path> createTempDirectory({
    Option<Path> dir = const None(),
    String prefix = '',
  }) => _platform.createTempDirectory(dir: dir, prefix: prefix);

  /// Creates a temporary file.
  ///
  /// The file is created inside [dir] (or the system default temp location
  /// when [None]) with an optional name [prefix] and [suffix].
  static IO<Path> createTempFile({
    Option<Path> dir = const None(),
    String prefix = '',
    String suffix = '.tmp',
  }) => _platform.createTempFile(dir: dir, prefix: prefix, suffix: suffix);

  /// Deletes the file or empty directory at [path].
  static IO<Unit> delete(Path path) => _platform.delete(path);

  /// Deletes the file or directory at [path] if it exists.
  ///
  /// Returns `true` if the entry was deleted, `false` if it did not exist.
  static IO<bool> deleteIfExists(Path path) =>
      exists(path).ifM(() => delete(path).as(true), () => IO.pure(false));

  /// Recursively deletes the file or directory at [path] and all of its
  /// contents.
  static IO<Unit> deleteRecursively(Path path) => _platform.deleteRecursively(path);

  /// Returns `true` if a filesystem entry exists at [path].
  static IO<bool> exists(Path path) => _platform.exists(path);

  /// Returns `true` if [path] refers to a directory.
  static IO<bool> isDirectory(Path path) => _platform.isDirectory(path);

  /// Returns `true` if [path] refers to a regular file.
  static IO<bool> isRegularFile(Path path) => _platform.isRegularFile(path);

  /// Returns `true` if [path1] and [path2] refer to the same filesystem
  /// entry (e.g. via hard links or symbolic links).
  static IO<bool> isSameFile(Path path1, Path path2) => _platform.isSameFile(path1, path2);

  /// Returns `true` if [path] refers to a symbolic link.
  static IO<bool> isSymbolicLink(Path path) => _platform.isSymbolicLink(path);

  /// The platform-specific line separator (`'\n'` on Unix, `'\r\n'` on
  /// Windows).
  static final String lineSeparator = _platform.lineSeparator;

  /// Emits the children of the directory at [path] as a [Rill].
  ///
  /// When [recursive] is `true`, the directory is traversed recursively.
  /// When [followLinks] is `true`, symbolic links are resolved to their
  /// targets.
  static Rill<Path> list(
    Path path, {
    bool recursive = false,
    bool followLinks = false,
  }) => _platform.list(path, recursive: recursive, followLinks: followLinks);

  /// Moves (renames) [source] to [target].
  static IO<Unit> move(Path source, Path target) => _platform.move(source, target);

  /// Opens the file at [path] with the given [flags], returning a
  /// resource-managed [FileHandle].
  ///
  /// The handle is automatically closed when the [Resource] is released.
  static Resource<FileHandle> open(Path path, Flags flags) => _platform.open(path, flags);

  /// Opens the file at [path] and returns a resource-managed [ReadCursor]
  /// positioned at the beginning of the file.
  static Resource<ReadCursor> readCursor(Path path, Flags flags) =>
      open(path, flags).map((fileHandle) => ReadCursor.of(fileHandle, 0));

  /// Reads the entire contents of the file at [path] as a byte stream.
  ///
  /// Emits chunks of at most [chunkSize] bytes. Uses [Flags.Read] by
  /// default unless custom [flags] are specified.
  static Rill<int> readAll(
    Path path, {
    Flags? flags,
    int chunkSize = _defaultChunkSize,
  }) => Rill.resource(Files.readCursor(path, flags ?? Flags.Read)).flatMap((cursor) {
    return cursor.readAll(chunkSize).voided.rill;
  });

  /// Reads a byte range from the file at [path], starting at byte offset
  /// [start] and ending before byte offset [end].
  ///
  /// Emits chunks of at most [chunkSize] bytes.
  static Rill<int> readRange(
    Path path, {
    int chunkSize = _defaultChunkSize,
    required int start,
    required int end,
  }) => Rill.resource(Files.readCursor(path, Flags.Read)).flatMap((cursor) {
    return cursor.seek(start).readUntil(chunkSize, end).voided.rill;
  });

  /// Reads the entire file at [path] and decodes it as UTF-8.
  ///
  /// Emits decoded string chunks. Use [readUtf8Lines] to split on line
  /// boundaries instead.
  static Rill<String> readUtf8(
    Path path, {
    int chunkSize = _defaultChunkSize,
  }) => readAll(path).through(Pipes.text.utf8.decode);

  /// Reads the entire file at [path] as UTF-8 and splits it into
  /// individual lines.
  ///
  /// Line terminators are stripped from the output.
  static Rill<String> readUtf8Lines(
    Path path, {
    int chunkSize = _defaultChunkSize,
  }) => readUtf8(path, chunkSize: chunkSize).through(Pipes.text.lines);

  /// Returns the size of the file at [path] in bytes.
  static IO<int> size(Path path) => _platform.size(path);

  /// Follows a file as it grows, similar to `tail -f`.
  ///
  /// Begins reading at [offset] (defaults to the start of the file) and
  /// emits chunks of at most [chunkSize] bytes. When the end of the file is
  /// reached, waits [pollDelay] before checking for new content. The
  /// resulting stream never completes on its own.
  static Rill<int> tail(
    Path path, {
    int chunkSize = _defaultChunkSize,
    int offset = 0,
    Duration pollDelay = const Duration(seconds: 1),
  }) => Rill.resource(readCursor(path, Flags.Read)).flatMap((cursor) {
    return cursor.seek(offset).tail(chunkSize, pollDelay).voided.rill;
  });

  /// A resource-managed temporary directory that is deleted when released.
  static Resource<Path> get tempDirectory => Resource.make(
    Files.createTempDirectory(),
    (p) => Files.deleteIfExists(p).voided(),
  );

  /// A resource-managed temporary file that is deleted when released.
  static Resource<Path> get tempFile => Resource.make(
    Files.createTempFile(),
    (p) => Files.deleteIfExists(p).voided(),
  );

  /// Watches [path] for filesystem changes, emitting [WatcherEvent]s.
  ///
  /// Only events matching the given [types] are emitted (defaults to all
  /// event types).
  static Rill<WatcherEvent> watch(
    Path path, {
    List<WatcherEventType> types = WatcherEventType.values,
  }) => _platform.watch(path, types: types);

  /// A [Pipe] that writes all incoming byte chunks to the file at [path].
  ///
  /// Uses [Flags.Write] by default (create + truncate) unless custom
  /// [flags] are specified.
  static Pipe<int, Never> writeAll(Path path, {Flags? flags}) =>
      (rill) => Rill.resource(
        writeCursor(path, flags ?? Flags.Write),
      ).flatMap((cursor) => cursor.writeAll(rill).voided.rill);

  /// Opens the file at [path] and returns a resource-managed [WriteCursor].
  ///
  /// If [flags] includes [Flag.append], the cursor is positioned at the
  /// current end of the file; otherwise it starts at offset 0.
  static Resource<WriteCursor> writeCursor(Path path, Flags flags) =>
      Files.open(path, flags).flatMap((handle) {
        final size = flags.contains(Flag.append) ? handle.size : IO.pure(0);
        final cursor = size.map((offset) => WriteCursor.of(handle, offset));

        return Resource.eval(cursor);
      });

  /// A [Pipe] that encodes incoming strings as UTF-8 and writes them to the
  /// file at [path].
  static Pipe<String, Never> writeUtf8(Path path) =>
      (rill) => rill.through(Pipes.text.utf8.encode).through(writeAll(path));

  /// A [Pipe] that writes incoming strings to the file at [path] as UTF-8,
  /// separated by [lineSeparator], with a trailing line separator.
  static Pipe<String, Never> writeUtf8Lines(Path path) {
    return (rill) {
      return rill.pull.uncons
          .flatMap((hdtl) {
            return hdtl.foldN(
              () => Pull.done,
              (next, rest) =>
                  Rill.chunk(next)
                      .append(() => rest)
                      .intersperse(lineSeparator)
                      .append(() => Rill.emit(lineSeparator))
                      .underlying,
            );
          })
          .rill
          .through(writeUtf8(path));
    };
  }

  /// A [Pipe] that writes incoming byte chunks across multiple files,
  /// rotating to a new file each time [limit] bytes have been written.
  ///
  /// [computePath] is evaluated each time a new file is needed, allowing
  /// dynamic file naming (e.g. timestamps). The file is opened with the
  /// given [flags]. When [Flag.append] is included, each file's initial
  /// write position accounts for existing content.
  static Pipe<int, Never> writeRotate(
    IO<Path> computePath,
    int limit,
    Flags flags,
  ) {
    Resource<FileHandle> openNewFile() => Resource.eval(computePath).flatMap((p) => open(p, flags));

    IO<WriteCursor> newCursor(FileHandle file) =>
        flags.contains(Flag.append)
            ? file.size.map((size) => WriteCursor.of(file, size))
            : IO.pure(WriteCursor.of(file, 0));

    Pull<Unit, Unit> go(
      Hotswap<FileHandle> fileHotswap,
      WriteCursor cursor,
      int acc,
      Rill<int> s,
    ) {
      final toWrite = limit - acc;

      return s.pull.unconsLimit(toWrite).flatMap((hdtl) {
        return hdtl.foldN(
          () => Pull.done,
          (hd, tl) {
            final newAcc = acc + hd.size;

            return cursor.writePull(hd).flatMap((nextCursor) {
              if (newAcc >= limit) {
                return Pull.eval(
                  fileHotswap
                      .swap(openNewFile())
                      .flatMap((_) => fileHotswap.current.use(newCursor)),
                ).flatMap((nextCursor) => go(fileHotswap, nextCursor, 0, tl));
              } else {
                return go(fileHotswap, nextCursor, newAcc, tl);
              }
            });
          },
        );
      });
    }

    return (rill) => Rill.resource(Hotswap.create(openNewFile())).flatMap((fileHotswap) {
      return Rill.eval(fileHotswap.current.use(newCursor)).flatMap((cursor) {
        return go(fileHotswap, cursor, 0, rill).rill.drain();
      });
    });
  }
}
