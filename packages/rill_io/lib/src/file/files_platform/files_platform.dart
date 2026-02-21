import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/file/files_platform/files_platform_stub.dart'
    if (dart.library.io) 'package:ribs_rill_io/src/file/files_platform/files_platform_io.dart';

abstract class FilesPlatform {
  factory FilesPlatform() => FilesPlatformImpl();

  IO<Unit> copy(Path source, Path target);

  IO<Unit> createDirectory(Path path, {bool? recursive});

  IO<Unit> createFile(
    Path path, {
    bool? recursive,
    bool? exclusive,
  });

  IO<Path> createTempDirectory({
    Option<Path> dir = const None(),
    String prefix = '',
  });

  IO<Path> createTempFile({
    Option<Path> dir = const None(),
    String prefix = '',
    String suffix = '.tmp',
  });

  IO<Unit> delete(Path path);

  IO<Unit> deleteRecursively(Path path);

  IO<bool> exists(Path path);

  IO<bool> isDirectory(Path path);

  IO<bool> isRegularFile(Path path);

  IO<bool> isSameFile(Path path1, Path path2);

  IO<bool> isSymbolicLink(Path path);

  String get lineSeparator;

  Rill<Path> list(Path path, {bool followLinks = false});

  IO<Unit> move(Path source, Path target);

  Resource<FileHandle> open(Path path, Flags flags);

  IO<int> size(Path path);

  Rill<WatcherEvent> watch(
    Path path, {
    List<WatcherEventType> types = WatcherEventType.values,
  });
}
