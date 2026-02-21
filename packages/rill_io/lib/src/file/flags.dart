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

final class Flags {
  static final Read = Flags(ilist([Flag.read]));
  static final Write = Flags(ilist([Flag.write, Flag.create, Flag.truncate]));
  static final Append = Flags(ilist([Flag.write, Flag.create, Flag.append]));

  final IList<Flag> value;

  const Flags(this.value);

  Flags operator |(Flag flag) => addIfAbsent(flag);

  bool contains(Flag flag) => value.contains(flag);

  Flags addIfAbsent(Flag flag) => contains(flag) ? this : Flags(value.prepended(flag));
}
