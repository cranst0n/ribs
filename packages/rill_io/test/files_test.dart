import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:test/test.dart';

/// Temp directory resource that cleans up recursively (including any files
/// created inside during the test).
Resource<Path> tempDir() => Resource.make(
  Files.createTempDirectory(),
  (p) => Files.deleteRecursively(p).voided(),
);

void main() {
  group('Files', () {
    group('read / write round-trip', () {
      test(
        'writeAll + readAll round-trips bytes',
        () {
          const bytes = [1, 2, 3, 4, 5];

          final result = Files.tempFile.use((path) {
            return Rill.emits(bytes)
                .through(Files.writeAll(path))
                .compile
                .drain
                .productR(Files.readAll(path).compile.toIList);
          });

          expect(result, succeeds(ilist(bytes)));
        },
        testOn: 'vm',
      );

      test(
        'writeUtf8 + readUtf8 round-trips a string',
        () {
          const text = 'foo, bar, baz!';

          final result = Files.tempFile.use((path) {
            return Rill.emit(text)
                .through(Files.writeUtf8(path))
                .compile
                .drain
                .productR(
                  Files.readUtf8(path).compile.toIList.map(
                    (chunks) => chunks.toList().join(),
                  ),
                );
          });

          expect(result, succeeds(text));
        },
        testOn: 'vm',
      );

      test(
        'writeUtf8Lines + readUtf8Lines round-trips lines',
        () {
          const lines = ['alpha', 'beta', 'gamma'];

          final result = Files.tempFile.use((path) {
            return Rill.emits(lines)
                .through(Files.writeUtf8Lines(path))
                .compile
                .drain
                .productR(
                  Files.readUtf8Lines(path).filter((line) => line.isNotEmpty).compile.toIList,
                );
          });

          expect(result, succeeds(ilist(lines)));
        },
        testOn: 'vm',
      );
    });

    group('append', () {
      test(
        'Flags.Append appends to existing content',
        () {
          const first = [1, 2, 3];
          const second = [4, 5, 6];

          final result = Files.tempFile.use((path) {
            return Rill.emits(first)
                .through(Files.writeAll(path))
                .compile
                .drain
                .productR(
                  Rill.emits(
                    second,
                  ).through(Files.writeAll(path, flags: Flags.Append)).compile.drain,
                )
                .productR(Files.readAll(path).compile.toIList);
          });

          expect(result, succeeds(ilist([...first, ...second])));
        },
        testOn: 'vm',
      );
    });

    group('metadata', () {
      test(
        'exists returns false for a non-existent path',
        () {
          expect(
            tempDir().use((dir) => Files.exists(dir / 'ghost.txt')),
            succeeds(false),
          );
        },
        testOn: 'vm',
      );

      test(
        'exists returns true for a created file',
        () {
          expect(
            Files.tempFile.use(Files.exists),
            succeeds(true),
          );
        },
        testOn: 'vm',
      );

      test('size returns the number of bytes written', () {
        const bytes = [10, 20, 30, 40, 50];

        final result = Files.tempFile.use(
          (path) => Rill.emits(
            bytes,
          ).through(Files.writeAll(path)).compile.drain.productR(Files.size(path)),
        );

        expect(result, succeeds(5));
      }, testOn: 'vm');

      test(
        'isRegularFile is true for a file and false for a directory',
        () {
          final result = Files.tempFile.use((filePath) {
            return tempDir().use((dirPath) {
              return Files.isRegularFile(filePath).product(Files.isRegularFile(dirPath));
            });
          });

          expect(result, succeeds((true, false)));
        },
        testOn: 'vm',
      );

      test(
        'isDirectory is true for a directory and false for a file',
        () {
          final result = tempDir().use((dirPath) {
            return Files.tempFile.use((filePath) {
              return Files.isDirectory(dirPath).product(Files.isDirectory(filePath));
            });
          });

          expect(result, succeeds((true, false)));
        },
        testOn: 'vm',
      );
    });

    group('file operations', () {
      test(
        'copy duplicates file content',
        () {
          const bytes = [7, 8, 9];

          final result = tempDir().use((dir) {
            final src = dir / 'src.bin';
            final dst = dir / 'dst.bin';

            return Rill.emits(bytes)
                .through(Files.writeAll(src))
                .compile
                .drain
                .productR(Files.copy(src, dst))
                .productR(Files.readAll(dst).compile.toIList);
          });

          expect(result, succeeds(ilist(bytes)));
        },
        testOn: 'vm',
      );

      test(
        'move relocates file; source is absent, target has content',
        () {
          const bytes = [1, 2, 3];

          final result = tempDir().use((dir) {
            final src = dir / 'src.bin';
            final dst = dir / 'dst.bin';

            return Rill.emits(bytes)
                .through(Files.writeAll(src))
                .compile
                .drain
                .productR(Files.move(src, dst))
                .productR<(bool, IList<int>)>(
                  Files.exists(src).product(Files.readAll(dst).compile.toIList),
                );
          });

          expect(result, succeeds((false, ilist(bytes))));
        },
        testOn: 'vm',
      );

      test(
        'delete removes the file',
        () {
          final result = tempDir().use((dir) {
            final file = dir / 'to-delete.txt';
            return Files.createFile(
              file,
            ).productR(Files.delete(file)).productR(Files.exists(file));
          });

          expect(result, succeeds(false));
        },
        testOn: 'vm',
      );

      test(
        'deleteIfExists returns false when file does not exist',
        () {
          expect(
            tempDir().use((dir) => Files.deleteIfExists(dir / 'nobody.txt')),
            succeeds(false),
          );
        },
        testOn: 'vm',
      );
    });

    group('directories', () {
      test('createDirectory creates a directory', () {
        final result = tempDir().use((parent) {
          final newDir = parent / 'subdir';
          return Files.createDirectory(newDir).productR(Files.isDirectory(newDir));
        });

        expect(result, succeeds(true));
      }, testOn: 'vm');

      test(
        'createDirectory with recursive creates nested directories',
        () {
          final result = tempDir().use((parent) {
            final nested = parent / 'a' / 'b' / 'c';

            return Files.createDirectory(
              nested,
              recursive: true,
            ).productR(Files.isDirectory(nested));
          });

          expect(result, succeeds(true));
        },
        testOn: 'vm',
      );

      test(
        'list returns all entries in a directory',
        () {
          final result = tempDir()
              .use((dir) {
                return Files.createFile(dir / 'a.txt')
                    .productR(Files.createFile(dir / 'b.txt'))
                    .productR(Files.createFile(dir / 'c.txt'))
                    .productR(Files.list(dir).compile.toIList);
              })
              .map((list) => list.length);

          expect(result, succeeds(3));
        },
        testOn: 'vm',
      );
    });

    group('isSameFile', () {
      test(
        'returns true when both paths refer to the same file',
        () {
          expect(
            Files.tempFile.use((path) => Files.isSameFile(path, path)),
            succeeds(true),
          );
        },
        testOn: 'vm',
      );

      test(
        'returns false for two different files',
        () {
          final result = Files.tempFile.use(
            (a) => Files.tempFile.use((b) => Files.isSameFile(a, b)),
          );
          expect(result, succeeds(false));
        },
        testOn: 'vm',
      );
    });

    group('isSymbolicLink', () {
      test(
        'returns false for a regular file',
        () {
          expect(
            Files.tempFile.use(Files.isSymbolicLink),
            succeeds(false),
          );
        },
        testOn: 'vm',
      );

      test(
        'returns true for a symbolic link',
        () {
          final result = tempDir().use((dir) {
            final target = dir / 'target.txt';
            final link = dir / 'link.txt';
            return Files.createFile(target).flatMap((_) {
              return Files.createSymbolicLink(
                link,
                target,
              ).productR(Files.isSymbolicLink(link));
            });
          });

          expect(result, succeeds(true));
        },
        testOn: 'vm',
      );
    });

    group('tempDirectory getter', () {
      test(
        'provides a path that is a directory and cleans up on release',
        () {
          late Path captured;

          final result = Files.tempDirectory
              .use((dir) {
                captured = dir;
                return Files.isDirectory(dir);
              })
              .flatMap((_) => Files.exists(captured));

          expect(result, succeeds(false));
        },
        testOn: 'vm',
      );
    });

    group('writeUtf8Lines with empty input', () {
      test(
        'writing empty rill produces no output',
        () {
          final result = Files.tempFile.use((path) {
            return Rill.empty<String>()
                .through(Files.writeUtf8Lines(path))
                .compile
                .drain
                .productR(Files.size(path));
          });

          expect(result, succeeds(0));
        },
        testOn: 'vm',
      );
    });

    group('writeRotate', () {
      test(
        'rotates into new files at the byte limit',
        () {
          final result = tempDir().use((dir) {
            final paths = <Path>[];
            var i = 0;

            final computePath = IO.delay(() {
              final p = dir / 'part_$i.bin';
              paths.add(p);
              i += 1;
              return p;
            });

            // 7 bytes with limit 3 → file0:[0,1,2]  file1:[3,4,5]  file2:[6]
            const bytes = [0, 1, 2, 3, 4, 5, 6];

            return Rill.emits(bytes)
                .through(Files.writeRotate(computePath, 3, Flags.Write))
                .compile
                .drain
                .productR(
                  IO
                      .delay(() => paths)
                      .flatMap(
                        (ps) =>
                            ps.map((p) => Files.readAll(p).compile.toIList).toIList().parSequence(),
                      ),
                );
          });

          expect(
            result,
            succeeds(
              ilist([
                ilist([0, 1, 2]),
                ilist([3, 4, 5]),
                ilist([6]),
              ]),
            ),
          );
        },
        testOn: 'vm',
      );

      test(
        'rotates with append flag, continuing from file size',
        () {
          final result = tempDir().use((dir) {
            final paths = <Path>[];
            var i = 0;

            final computePath = IO.delay(() {
              final p = dir / 'part_$i.bin';
              paths.add(p);
              i += 1;
              return p;
            });

            const bytes = [10, 20, 30, 40];

            return Rill.emits(bytes)
                .through(Files.writeRotate(computePath, 2, Flags.Write))
                .compile
                .drain
                .productR(
                  IO
                      .delay(() => paths)
                      .flatMap(
                        (ps) =>
                            ps.map((p) => Files.readAll(p).compile.toIList).toIList().parSequence(),
                      ),
                );
          });

          expect(
            result,
            succeeds(
              ilist([
                ilist([10, 20]),
                ilist([30, 40]),
                ilist([]),
              ]),
            ),
          );
        },
        testOn: 'vm',
      );
    });

    group('range read', () {
      test('readRange reads the specified byte slice', () {
        const bytes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

        final result = Files.tempFile.use((path) {
          return Rill.emits(bytes)
              .through(Files.writeAll(path))
              .compile
              .drain
              .productR(
                Files.readRange(path, start: 2, end: 6).compile.toIList,
              );
        });

        expect(result, succeeds(ilist([2, 3, 4, 5])));
      }, testOn: 'vm');
    });

    group('watch', () {
      test(
        'emits a created event when a file is created in a watched directory',
        () {
          final io = tempDir().use((dir) {
            final file = dir / 'watched.txt';
            return Files.watch(dir)
                .take(1)
                .concurrently(
                  Rill.eval(
                    IO.sleep(const Duration(milliseconds: 100)).productR(Files.createFile(file)),
                  ),
                )
                .compile
                .toIList
                .flatMap(
                  (events) => IO.exec(() {
                    expect(events.length, 1);
                    expect(events.head, isA<WatcherCreatedEvent>());
                  }),
                );
          });

          expect(io, succeeds());
        },
        testOn: 'vm',
      );

      test(
        'emits a deleted event when a file is deleted in a watched directory',
        () {
          final io = tempDir().use((dir) {
            final file = dir / 'delete-me.txt';
            return Files.createFile(file).productR(
              Files.watch(dir)
                  .take(1)
                  .concurrently(
                    Rill.eval(
                      IO.sleep(const Duration(milliseconds: 100)).productR(Files.delete(file)),
                    ),
                  )
                  .compile
                  .toIList
                  .flatMap(
                    (events) => IO.exec(() {
                      expect(events.length, 1);
                      expect(events.head, isA<WatcherDeletedEvent>());
                    }),
                  ),
            );
          });

          expect(io, succeeds());
        },
        testOn: 'vm',
      );

      test(
        'emits a moved event when a file in a watched directory is renamed',
        () {
          final io = tempDir().use((dir) {
            final src = dir / 'before.txt';
            final dst = dir / 'after.txt';
            return Files.createFile(src).productR(
              Files.watch(dir, types: [WatcherEventType.moved])
                  .take(1)
                  .concurrently(
                    Rill.eval(
                      IO.sleep(const Duration(milliseconds: 100)).productR(Files.move(src, dst)),
                    ),
                  )
                  .compile
                  .toIList
                  .flatMap(
                    (events) => IO.exec(() {
                      expect(events.length, 1);
                      expect(events.head, isA<WatcherMovedEvent>());
                    }),
                  ),
            );
          });

          expect(io, succeeds());
        },
        testOn: 'vm',
      );

      test(
        'emits a modified event when a file in a watched directory is written',
        () {
          final io = tempDir().use((dir) {
            final file = dir / 'modify-me.txt';
            return Files.createFile(file).productR(
              Files.watch(dir, types: [WatcherEventType.modified])
                  .take(1)
                  .concurrently(
                    Rill.eval(
                      IO
                          .sleep(const Duration(milliseconds: 100))
                          .productR(
                            Rill.emits([1, 2, 3]).through(Files.writeAll(file)).compile.drain,
                          ),
                    ),
                  )
                  .compile
                  .toIList
                  .flatMap(
                    (events) => IO.exec(() {
                      expect(events.length, 1);
                      expect(events.head, isA<WatcherModifiedEvent>());
                    }),
                  ),
            );
          });

          expect(io, succeeds());
        },
        testOn: 'vm',
      );
    });

    group('cursors', () {
      test(
        'writeCursor and readCursor seek to the correct offset',
        () {
          final first = Chunk.fromList([10, 20, 30]);
          final second = Chunk.fromList([40, 50, 60]);

          final result = Files.tempFile
              .use((path) {
                return Files.writeCursor(path, Flags.Write)
                    .use((cursor) {
                      return cursor.write(first).flatMap((c2) => c2.write(second));
                    })
                    .productR(
                      Files.readCursor(path, Flags.Read).use((cursor) {
                        return cursor.seek(3).read(3);
                      }),
                    );
              })
              .map((opt) => opt.map((tuple) => tuple.$2));

          expect(result, succeeds(Some(second)));
        },
        testOn: 'vm',
      );
    });
  });
}
