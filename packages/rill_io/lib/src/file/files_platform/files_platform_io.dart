import 'dart:io';
import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/file/files_platform/files_platform.dart';

final class FilesPlatformImpl implements FilesPlatform {
  @override
  IO<Unit> copy(Path source, Path target) =>
      IO.fromFutureF(() => source.toFile.copy(target.toString())).voided();

  @override
  IO<Unit> createDirectory(Path path, {bool? recursive}) =>
      IO.fromFutureF(() => path.toDirectory.create(recursive: recursive ?? false)).voided();

  @override
  IO<Unit> createFile(
    Path path, {
    bool? recursive,
    bool? exclusive,
  }) =>
      IO
          .fromFutureF(
            () => path.toFile.create(
              recursive: recursive ?? false,
              exclusive: exclusive ?? false,
            ),
          )
          .voided();

  @override
  IO<Unit> createSymbolicLink(
    Path link,
    Path existing, {
    bool recursive = false,
  }) =>
      IO
          .fromFutureF(
            () => Link(link.toString()).create(existing.toString(), recursive: recursive),
          )
          .voided();

  @override
  IO<Path> createTempDirectory({
    Option<Path> dir = const None(),
    String prefix = '',
  }) {
    final parentDir = dir.getOrElse(() => Path(Directory.systemTemp.path));

    return IO
        .delay(() => _randomName(prefix, ''))
        .map((name) => parentDir / name)
        .iterateWhileM(Files.exists)
        .flatTap(Files.createDirectory);
  }

  @override
  IO<Path> createTempFile({
    Option<Path> dir = const None(),
    String prefix = '',
    String suffix = '.tmp',
  }) {
    final parentDir = dir.getOrElse(() => Path(Directory.systemTemp.path));

    return IO
        .delay(() => _randomName(prefix, suffix))
        .map((name) => parentDir / name)
        .iterateWhileM(Files.exists)
        .flatTap(Files.createFile);
  }

  @override
  IO<Unit> delete(Path path) => _delete(path, false);

  @override
  IO<Unit> deleteRecursively(Path path) => _delete(path, true);

  IO<Unit> _delete(Path path, bool recursive) => isDirectory(path).ifM(
    () => IO.fromFutureF(() => path.toDirectory.delete(recursive: recursive)).voided(),
    () => IO.fromFutureF(() => path.toFile.delete(recursive: recursive)).voided(),
  );

  @override
  IO<bool> exists(Path path) => IO.fromFutureF(() => path.toFile.exists());

  @override
  IO<bool> isDirectory(Path path) =>
      IO.fromFutureF(() => FileSystemEntity.isDirectory(path.toString()));

  @override
  IO<bool> isRegularFile(Path path) =>
      IO.fromFutureF(() => FileSystemEntity.isFile(path.toString()));

  @override
  IO<bool> isSameFile(Path path1, Path path2) =>
      IO.fromFutureF(() => FileSystemEntity.identical(path1.toString(), path2.toString()));

  @override
  IO<bool> isSymbolicLink(Path path) =>
      IO.fromFutureF(() => FileSystemEntity.isLink(path.toString()));

  @override
  final String lineSeparator = Platform.lineTerminator;

  @override
  Rill<Path> list(Path path, {bool followLinks = false}) {
    return Rill.eval(isDirectory(path)).flatMap((isDirectory) {
      if (isDirectory) {
        return Rill.fromStream(
          path.toDirectory.list(recursive: true, followLinks: followLinks),
        ).map((entity) => Path(entity.path));
      } else {
        return Rill.empty();
      }
    });
  }

  @override
  IO<Unit> move(Path source, Path target) =>
      IO.fromFutureF(() => source.toFile.rename(target.toString())).voided();

  @override
  Resource<FileHandle> open(Path path, Flags flags) {
    IO<RandomAccessFile> acquire() {
      final failIfExists =
          flags.contains(Flag.createNew)
              ? exists(
                path,
              ).ifM(() => IO.raiseError<Unit>('File already exists: $path'), () => IO.unit)
              : IO.unit;

      final createIfNeeded = flags.contains(Flag.create) ? createFile(path) : IO.unit;

      return failIfExists
          .productR(() => createIfNeeded)
          .productR(() => IO.fromFutureF(() => path.toFile.open(mode: flags.toFileMode)));
    }

    IO<Unit> release(RandomAccessFile raf) {
      final deleteIfRequested = flags.contains(Flag.deleteOnClose) ? Files.delete(path) : IO.unit;
      return IO.fromFutureF(() => raf.close()).productR(() => deleteIfRequested);
    }

    return Resource.make(acquire(), release).map((raf) => FileHandleIO(raf));
  }

  @override
  IO<int> size(Path path) => IO.fromFutureF(() => path.toFile.length());

  @override
  Rill<WatcherEvent> watch(
    Path path, {
    List<WatcherEventType> types = WatcherEventType.values,
  }) {
    if (FileSystemEntity.isWatchSupported) {
      final canWatch = Files.isDirectory(path).product(Files.isRegularFile(path));

      return Rill.eval(canWatch).flatMap((tuple) {
        final (isDir, isFile) = tuple;

        if (isDir || isFile) {
          final events = types.fold(0, (acc, type) => acc | type.toFileSystemEventId);

          final stream =
              isDir
                  ? path.toDirectory.watch(events: events, recursive: true)
                  : path.toFile.watch(events: events);

          return Rill.fromStream(stream).map(
            (event) => switch (event) {
              FileSystemCreateEvent _ => WatcherCreatedEvent(Path(event.path)),
              FileSystemDeleteEvent _ => WatcherDeletedEvent(Path(event.path)),
              final FileSystemModifyEvent modified => WatcherModifiedEvent(
                Path(modified.path),
                modified.contentChanged,
              ),
              final FileSystemMoveEvent moved => WatcherMovedEvent(
                Path(moved.path),
                Option(moved.destination).map(Path.new),
              ),
            },
          );
        } else {
          return Rill.raiseError('Can only watch directory: $path');
        }
      });
    } else {
      return Rill.raiseError('Watch not supported on this platform');
    }
  }

  String _randomName(String prefix, String suffix) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    final rnd = Random();

    final generated = String.fromCharCodes(
      Iterable.generate(10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );

    return '$prefix$generated$suffix';
  }
}

extension on Path {
  Directory get toDirectory => Directory(toString());
  File get toFile => File(toString());
}

extension on Flags {
  FileMode get toFileMode {
    if (contains(Flag.read) && !contains(Flag.write)) {
      return FileMode.read;
    } else if (contains(Flag.write) && !contains(Flag.read)) {
      if (contains(Flag.append)) {
        return FileMode.writeOnlyAppend;
      } else {
        return FileMode.writeOnly;
      }
    } else {
      return FileMode.write;
    }
  }
}

class FileHandleIO implements FileHandle {
  final RandomAccessFile _raf;

  FileHandleIO(this._raf);

  @override
  IO<Unit> flush() => IO.fromFutureF(() => _raf.flush()).voided();

  @override
  IO<Option<Chunk<int>>> read(int numBytes, int offset) {
    if (numBytes < 0) {
      return IO.none();
    } else if (numBytes == 0) {
      return IO.pure(Some(Chunk.empty()));
    } else {
      return IO
          .fromFutureF(() => _raf.setPosition(offset))
          .productR(() => IO.fromFutureF(() => _raf.read(numBytes)))
          .map((bytes) => bytes.isNotEmpty ? Some(Chunk.bytes(bytes)) : const None());
    }
  }

  @override
  IO<int> get size => IO.fromFutureF(() => _raf.length());

  @override
  IO<Unit> truncate(int size) => IO.fromFutureF(() => _raf.truncate(size)).voided();

  @override
  IO<int> write(Chunk<int> bytes, int offset) {
    return IO
        .fromFutureF(() => _raf.setPosition(offset))
        .productR(() => IO.fromFutureF(() => _raf.writeFrom(bytes.toDartList())))
        .as(bytes.length);
  }
}

extension on WatcherEventType {
  int get toFileSystemEventId => switch (this) {
    WatcherEventType.created => FileSystemEvent.create,
    WatcherEventType.deleted => FileSystemEvent.delete,
    WatcherEventType.modified => FileSystemEvent.modify,
    WatcherEventType.moved => FileSystemEvent.move,
  };
}
