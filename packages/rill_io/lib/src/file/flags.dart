import 'package:ribs_core/ribs_core.dart';

enum Flag {
  /// Open file for read access.
  read,

  /// Open file for write access.
  write,

  /// When combined with [write], writes are performed at the end of the file.
  append,

  /// When combined with [write], file is truncated to 0 bytes when opening the file.
  truncate,

  /// Creates the file if it doesn't exist.
  create,

  /// Creates the file if it doesn't exists, but fails if it already exists.
  createNew,

  /// File should be deleted after it's closed.
  deleteOnClose,
}

/// A set of [Flag] values that control how a file is opened.
///
/// [Flags] is an immutable collection of individual [Flag] options. Use the
/// predefined constants for common open modes, or compose custom
/// combinations with the `|` operator:
///
/// ```dart
/// // Open for reading:
/// Files.open(path, Flags.Read);
///
/// // Open for writing with delete-on-close:
/// Files.open(path, Flags.Write | Flag.deleteOnClose);
/// ```
final class Flags {
  /// Opens a file for reading only.
  static final Read = Flags(ilist([Flag.read]));

  /// Opens a file for writing, creating it if it doesn't exist and
  /// truncating it to zero bytes if it does.
  static final Write = Flags(ilist([Flag.write, Flag.create, Flag.truncate]));

  /// Opens a file for appending, creating it if it doesn't exist. Writes
  /// are always performed at the end of the file.
  static final Append = Flags(ilist([Flag.write, Flag.create, Flag.append]));

  /// The underlying list of individual [Flag] values.
  final IList<Flag> value;

  /// Creates a [Flags] instance from the given [value] list.
  const Flags(this.value);

  /// Adds [flag] to this set if it is not already present.
  ///
  /// Returns a new [Flags] instance; the original is unchanged.
  Flags operator |(Flag flag) => addIfAbsent(flag);

  /// Returns `true` if this set includes [flag].
  bool contains(Flag flag) => value.contains(flag);

  /// Returns a new [Flags] with [flag] included. If [flag] is already
  /// present, returns `this` unchanged.
  Flags addIfAbsent(Flag flag) => contains(flag) ? this : Flags(value.prepended(flag));
}
