import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:test/test.dart';

void main() {
  group('Path', () {
    group('operator +', () {
      test('joins two paths', () {
        expect(Path('/foo') + Path('bar'), equals(Path('/foo/bar')));
      });

      test('normalizes the result', () {
        expect(Path('/foo') + Path('../baz'), equals(Path('/baz')));
      });

      test('joining empty path returns normalized self', () {
        expect(Path('/foo/bar/') + Path(''), equals(Path('/foo/bar')));
      });
    });

    group('operator /', () {
      test('joins a path with a string segment', () {
        expect(Path('/foo') / 'bar', equals(Path('/foo/bar')));
      });

      test('joins multiple segments sequentially', () {
        expect((Path('/foo') / 'bar') / 'baz', equals(Path('/foo/bar/baz')));
      });

      test('normalizes parent directory references', () {
        expect(Path('/foo') / '../baz', equals(Path('/baz')));
      });

      test('normalizes current directory references', () {
        expect(Path('/foo') / './bar', equals(Path('/foo/bar')));
      });
    });

    group('absolute', () {
      test('absolute path is unchanged', () {
        expect(Path('/foo/bar').absolute, equals(Path('/foo/bar')));
      });

      test('relative path becomes absolute', () {
        expect(Path('foo').absolute.isAbsolute, isTrue);
      });
    });

    group('extension', () {
      test('returns file extension including the dot', () {
        expect(Path('foo.dart').extension, equals('.dart'));
      });

      test('returns empty string when no extension', () {
        expect(Path('foo').extension, equals(''));
      });

      test('returns only the last extension for multiple dots', () {
        expect(Path('foo.bar.dart').extension, equals('.dart'));
      });

      test('works on a full absolute path', () {
        expect(Path('/path/to/foo.dart').extension, equals('.dart'));
      });
    });

    group('fileName', () {
      test('returns the basename of a file path', () {
        expect(Path('/path/to/foo.dart').fileName, equals(Path('foo.dart')));
      });

      test('returns the last segment for a directory path', () {
        expect(Path('/path/to/dir').fileName, equals(Path('dir')));
      });

      test('returns the filename for a relative path', () {
        expect(Path('foo/bar.txt').fileName, equals(Path('bar.txt')));
      });
    });

    group('isAbsolute', () {
      test('absolute path returns true', () {
        expect(Path('/foo/bar').isAbsolute, isTrue);
      });

      test('relative path returns false', () {
        expect(Path('foo/bar').isAbsolute, isFalse);
      });

      test('current-directory-relative path returns false', () {
        expect(Path('./foo').isAbsolute, isFalse);
      });
    });

    group('names', () {
      test('splits absolute path into components', () {
        expect(
          Path('/foo/bar/baz').names,
          equals(ilist([Path('/'), Path('foo'), Path('bar'), Path('baz')])),
        );
      });

      test('splits relative path into components', () {
        expect(
          Path('foo/bar').names,
          equals(ilist([Path('foo'), Path('bar')])),
        );
      });

      test('single segment path has one name', () {
        expect(Path('foo').names, equals(ilist([Path('foo')])));
      });
    });

    group('normalize', () {
      test('resolves parent directory references', () {
        expect(Path('/foo/../bar').normalize, equals(Path('/bar')));
      });

      test('resolves current directory references', () {
        expect(Path('/foo/./bar').normalize, equals(Path('/foo/bar')));
      });

      test('removes trailing separator', () {
        expect(Path('/foo/bar/').normalize, equals(Path('/foo/bar')));
      });

      test('already normalized path is unchanged', () {
        expect(Path('/foo/bar').normalize, equals(Path('/foo/bar')));
      });
    });

    group('parent', () {
      test('returns Some with the parent directory', () {
        expect(Path('/foo/bar').parent, equals(Some(Path('/foo'))));
      });

      test('returns Some for nested path', () {
        expect(Path('/foo/bar/baz').parent, equals(Some(Path('/foo/bar'))));
      });

      test('returns None for root path', () {
        expect(Path('/').parent, equals(none<Path>()));
      });

      test('returns None for current directory', () {
        expect(Path('.').parent, equals(none<Path>()));
      });

      test('returns Some for relative path with parent', () {
        expect(Path('foo/bar').parent, equals(Some(Path('foo'))));
      });
    });

    group('relativize', () {
      test('returns relative path from this to a descendant', () {
        expect(
          Path('/foo').relativize(Path('/foo/bar/baz')),
          equals(Path('bar/baz')),
        );
      });

      test('returns path with parent traversal for sibling directory', () {
        expect(
          Path('/foo/bar').relativize(Path('/foo/baz')),
          equals(Path('../baz')),
        );
      });

      test('returns single segment for direct child', () {
        expect(
          Path('/foo/bar').relativize(Path('/foo/bar/baz')),
          equals(Path('baz')),
        );
      });
    });

    group('current', () {
      test('is an absolute path', () {
        expect(Path.current.isAbsolute, isTrue);
      });

      test('has a parent', () {
        expect(Path.current.parent.isDefined, isTrue);
      });
    });
  });
}
