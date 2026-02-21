import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

enum WatcherEventType { created, deleted, modified, moved }

sealed class WatcherEvent {
  final Path path;

  const WatcherEvent(this.path);
}

class WatcherCreatedEvent extends WatcherEvent {
  const WatcherCreatedEvent(super.path);

  @override
  String toString() => 'WatchEvent.created: $path';
}

class WatcherDeletedEvent extends WatcherEvent {
  const WatcherDeletedEvent(super.path);

  @override
  String toString() => 'WatchEvent.deleted: $path';
}

class WatcherModifiedEvent extends WatcherEvent {
  final bool contentChanged;

  const WatcherModifiedEvent(super.path, this.contentChanged);

  @override
  String toString() => 'WatchEvent.modified: $path, content changed: $contentChanged';
}

class WatcherMovedEvent extends WatcherEvent {
  final Option<Path> destination;

  const WatcherMovedEvent(super.path, this.destination);

  @override
  String toString() => 'WatchEvent.moved: $path -> $destination';
}
