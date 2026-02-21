import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/file/files_platform/files_platform.dart';

final class Files {
  const Files._();

  static const _defaultChunkSize = 64 * 1024;

  static final _platform = FilesPlatform();

  static IO<Unit> copy(Path source, Path target) => _platform.copy(source, target);

  static IO<Unit> createDirectory(Path path, {bool? recursive}) =>
      _platform.createDirectory(path, recursive: recursive);

  static IO<Unit> createFile(
    Path path, {
    bool? recursive,
    bool? exclusive,
  }) => _platform.createFile(path, recursive: recursive, exclusive: exclusive);

  static IO<Path> createTempDirectory({
    Option<Path> dir = const None(),
    String prefix = '',
  }) => _platform.createTempDirectory(dir: dir, prefix: prefix);

  static IO<Path> createTempFile({
    Option<Path> dir = const None(),
    String prefix = '',
    String suffix = '.tmp',
  }) => _platform.createTempFile(dir: dir, prefix: prefix, suffix: suffix);

  static IO<Unit> delete(Path path) => _platform.delete(path);

  static IO<bool> deleteIfExists(Path path) =>
      exists(path).ifM(() => delete(path).as(true), () => IO.pure(false));

  static IO<Unit> deleteRecursively(Path path) => _platform.deleteRecursively(path);

  static IO<bool> exists(Path path) => _platform.exists(path);

  static IO<bool> isDirectory(Path path) => _platform.isDirectory(path);

  static IO<bool> isRegularFile(Path path) => _platform.isRegularFile(path);

  static IO<bool> isSameFile(Path path1, Path path2) => _platform.isSameFile(path1, path2);

  static IO<bool> isSymbolicLink(Path path) => _platform.isSymbolicLink(path);

  static final String lineSeparator = _platform.lineSeparator;

  static Rill<Path> list(Path path, {bool followLinks = false}) =>
      _platform.list(path, followLinks: followLinks);

  static IO<Unit> move(Path source, Path target) => _platform.move(source, target);

  static Resource<FileHandle> open(Path path, Flags flags) => _platform.open(path, flags);

  static Resource<ReadCursor> readCursor(Path path, Flags flags) =>
      open(path, flags).map((fileHandle) => ReadCursor.of(fileHandle, 0));

  static Rill<int> readAll(
    Path path, {
    Flags? flags,
    int chunkSize = _defaultChunkSize,
  }) => Rill.resource(Files.readCursor(path, flags ?? Flags.Read)).flatMap((cursor) {
    return cursor.readAll(chunkSize).voided.rill;
  });

  static Rill<int> readRange(
    Path path, {
    int chunkSize = _defaultChunkSize,
    required int start,
    required int end,
  }) => Rill.resource(Files.readCursor(path, Flags.Read)).flatMap((cursor) {
    return cursor.seek(start).readUntil(chunkSize, end).voided.rill;
  });

  static Rill<String> readUtf8(
    Path path, {
    int chunkSize = _defaultChunkSize,
  }) => readAll(path).through(Pipes.text.utf8.decode);

  static Rill<String> readUtf8Lines(
    Path path, {
    int chunkSize = _defaultChunkSize,
  }) => readUtf8(path, chunkSize: chunkSize).through(Pipes.text.lines);

  static IO<int> size(Path path) => _platform.size(path);

  static Rill<int> tail(
    Path path, {
    int chunkSize = _defaultChunkSize,
    int offset = 0,
    Duration pollDelay = const Duration(seconds: 1),
  }) => Rill.resource(readCursor(path, Flags.Read)).flatMap((cursor) {
    return cursor.seek(offset).tail(chunkSize, pollDelay).voided.rill;
  });

  static Resource<Path> get tempDirectory => Resource.make(
    Files.createTempDirectory(),
    (p) => Files.deleteIfExists(p).voided(),
  );

  static Resource<Path> get tempFile => Resource.make(
    Files.createTempFile(),
    (p) => Files.deleteIfExists(p).voided(),
  );

  static Rill<WatcherEvent> watch(
    Path path, {
    List<WatcherEventType> types = WatcherEventType.values,
  }) => _platform.watch(path, types: types);

  static Pipe<int, Never> writeAll(Path path, {Flags? flags}) =>
      (rill) => Rill.resource(
        writeCursor(path, flags ?? Flags.Write),
      ).flatMap((cursor) => cursor.writeAll(rill).voided.rill);

  static Resource<WriteCursor> writeCursor(Path path, Flags flags) =>
      Files.open(path, flags).flatMap((handle) {
        final size = flags.contains(Flag.append) ? handle.size : IO.pure(0);
        final cursor = size.map((offset) => WriteCursor.of(handle, offset));

        return Resource.eval(cursor);
      });

  static Pipe<String, Never> writeUtf8(Path path) =>
      (rill) => rill.through(Pipes.text.utf8.encode).through(writeAll(path));

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
