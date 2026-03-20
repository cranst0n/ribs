import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/file/files_platform/files_platform.dart';

class FilesPlatformImpl implements FilesPlatform {
  @override
  IO<Unit> copy(Path source, Path target) => throw UnimplementedError('Files.copy');

  @override
  IO<Unit> createDirectory(Path path, {bool? recursive}) =>
      throw UnimplementedError('Files.createDirectory');

  @override
  IO<Unit> createFile(
    Path path, {
    bool? recursive,
    bool? exclusive,
  }) => throw UnimplementedError('Files.createFile');

  @override
  IO<Unit> createSymbolicLink(
    Path link,
    Path existing, {
    bool recursive = false,
  }) => throw UnimplementedError('Files.createSymbolicLink');

  @override
  IO<Path> createTempDirectory({
    Option<Path> dir = const None(),
    String prefix = '',
  }) => throw UnimplementedError('Files.createTempDirectory');

  @override
  IO<Path> createTempFile({
    Option<Path> dir = const None(),
    String prefix = '',
    String suffix = '.tmp',
  }) => throw UnimplementedError('Files.createTempFile');

  @override
  IO<Unit> delete(Path path) => throw UnimplementedError('Files.delete');

  @override
  IO<Unit> deleteRecursively(Path path) => throw UnimplementedError('Files.deleteRecursively');

  @override
  IO<bool> exists(Path path) => throw UnimplementedError('Files.exists');

  @override
  IO<bool> isDirectory(Path path) => throw UnimplementedError('Files.isDirectory');

  @override
  IO<bool> isRegularFile(Path path) => throw UnimplementedError('Files.isRegularFile');

  @override
  IO<bool> isSameFile(Path path1, Path path2) => throw UnimplementedError('Files.isSameFile');

  @override
  IO<bool> isSymbolicLink(Path path) => throw UnimplementedError('Files.isSymbolicLink');

  @override
  String get lineSeparator => throw UnimplementedError('Files.lineSeparator');

  @override
  Rill<Path> list(Path path, {bool followLinks = false}) => throw UnimplementedError('Files.list');

  @override
  IO<Unit> move(Path source, Path target) => throw UnimplementedError('Files.move');

  @override
  Resource<FileHandle> open(Path path, Flags flags) => throw UnimplementedError('Files.open');

  @override
  IO<int> size(Path path) => throw UnimplementedError('Files.size');

  @override
  Rill<WatcherEvent> watch(
    Path path, {
    List<WatcherEventType> types = WatcherEventType.values,
  }) => throw UnimplementedError('Files.watch');
}
