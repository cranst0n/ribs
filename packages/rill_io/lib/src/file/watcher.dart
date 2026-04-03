import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

/// The kind of filesystem change that triggered a [WatcherEvent].
enum WatcherEventType {
  /// A new file or directory was created.
  created,

  /// A file or directory was deleted.
  deleted,

  /// A file or directory was modified.
  modified,

  /// A file or directory was moved (renamed).
  moved,
}

/// Base class for filesystem change notifications emitted by [Files.watch].
///
/// Every event carries the [path] of the filesystem entry that changed.
/// Pattern-match on the sealed subtypes to handle specific event kinds:
///
/// ```dart
/// Files.watch(directory).evalMap((event) => switch (event) {
///   WatcherCreatedEvent(:final path)  => handleCreated(path),
///   WatcherDeletedEvent(:final path)  => handleDeleted(path),
///   WatcherModifiedEvent(:final path) => handleModified(path),
///   WatcherMovedEvent(:final path)    => handleMoved(path),
/// });
/// ```
sealed class WatcherEvent {
  /// The path of the filesystem entry that triggered this event.
  final Path path;

  const WatcherEvent(this.path);
}

/// Emitted when a new file or directory is created at [path].
class WatcherCreatedEvent extends WatcherEvent {
  /// Creates a [WatcherCreatedEvent] for the given [path].
  const WatcherCreatedEvent(super.path);

  @override
  String toString() => 'WatchEvent.created: $path';
}

/// Emitted when a file or directory at [path] is deleted.
class WatcherDeletedEvent extends WatcherEvent {
  /// Creates a [WatcherDeletedEvent] for the given [path].
  const WatcherDeletedEvent(super.path);

  @override
  String toString() => 'WatchEvent.deleted: $path';
}

/// Emitted when a file or directory at [path] is modified.
class WatcherModifiedEvent extends WatcherEvent {
  /// Whether the file's content changed (`true`) as opposed to only metadata
  /// (e.g. permissions or timestamps) being updated.
  final bool contentChanged;

  /// Creates a [WatcherModifiedEvent] for the given [path].
  const WatcherModifiedEvent(super.path, this.contentChanged);

  @override
  String toString() => 'WatchEvent.modified: $path, content changed: $contentChanged';
}

/// Emitted when a file or directory at [path] is moved or renamed.
class WatcherMovedEvent extends WatcherEvent {
  /// The new location of the entry, or [None] if the destination could not
  /// be determined (e.g. the entry was moved outside the watched tree).
  final Option<Path> destination;

  /// Creates a [WatcherMovedEvent] for the given [path] and [destination].
  const WatcherMovedEvent(super.path, this.destination);

  @override
  String toString() => 'WatchEvent.moved: $path -> $destination';
}
