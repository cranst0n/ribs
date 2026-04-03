import 'package:path/path.dart' as p;
import 'package:ribs_core/ribs_core.dart';

/// A cross-platform filesystem path.
///
/// [Path] wraps a [String] and delegates to the `path` package for
/// platform-aware joining, normalization, and decomposition. All operations
/// that combine or resolve paths produce normalized results.
///
/// ```dart
/// final config = Path('/etc') / 'app' / 'config.yaml';
/// print(config);           // /etc/app/config.yaml
/// print(config.fileName);  // config.yaml
/// print(config.extension); // .yaml
/// print(config.parent);    // Some(/etc/app)
/// ```
extension type Path(String _repr) {
  /// The current working directory of the process.
  static Path get current => Path(p.current);

  /// Joins this path with [path], returning a normalized result.
  ///
  /// Equivalent to [p.join] followed by [normalize].
  Path operator +(Path path) => Path(p.join(_repr, path._repr)).normalize;

  /// Appends a single path segment [name] to this path, returning a
  /// normalized result.
  ///
  /// This is a convenient shorthand for joining with a literal string:
  ///
  /// ```dart
  /// Path('/home') / 'user' / 'docs'  // /home/user/docs
  /// ```
  Path operator /(String name) => Path(p.join(_repr, name)).normalize;

  /// Returns the absolute form of this path, resolved against the current
  /// working directory if it is relative.
  Path get absolute => Path(p.absolute(_repr));

  /// The file extension of this path, including the leading dot
  /// (e.g. `'.dart'`). Returns an empty string if there is no extension.
  String get extension => p.extension(_repr);

  /// The final component of this path (the file or directory name).
  Path get fileName => Path(p.basename(_repr));

  /// Whether this path is absolute.
  bool get isAbsolute => p.isAbsolute(_repr);

  /// Splits this path into its individual components.
  ///
  /// For example, `Path('/home/user/file.txt').names` yields
  /// `['/', 'home', 'user', 'file.txt']`.
  IList<Path> get names => p.split(_repr).map((p) => Path(p)).toIList();

  /// Returns a normalized copy of this path, resolving `.` and `..` segments
  /// and removing redundant separators.
  Path get normalize => Path(p.normalize(_repr));

  /// The parent directory of this path, or [None] if this path is already a
  /// root (e.g. `'/'` or `'C:\'`).
  Option<Path> get parent => Some(Path(p.dirname(_repr))).filter((p) => p._repr != _repr);

  /// Computes the relative path from this directory to [path].
  ///
  /// ```dart
  /// Path('/home/user').relativize(Path('/home/user/docs/readme.md'))
  /// // => docs/readme.md
  /// ```
  Path relativize(Path path) => Path(p.relative(path._repr, from: _repr));
}
