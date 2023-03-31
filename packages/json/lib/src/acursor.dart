import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/array_cursor.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';
import 'package:ribs_json/src/cursor/top_cursor.dart';

@immutable
abstract class ACursor {
  final HCursor? lastCursor;
  final CursorOp? lastOp;

  const ACursor(this.lastCursor, this.lastOp);

  Option<Json> get focus;

  IList<CursorOp> history() {
    IList<CursorOp> loop(ACursor? c) => Option.of(c?.lastOp).fold(
          () => IList.empty(),
          (op) => loop(c?.lastCursor).prepend(op),
        );

    return loop(this);
  }

  bool get succeeded;

  bool get failed => !succeeded;

  Option<HCursor> get success;

  Option<Json> top();

  HCursor? root() => null;

  ACursor withFocus(Function1<Json, Json> f);

  ACursor set(Json j) => withFocus((_) => j);

  Option<IList<Json>> get values;

  Option<int> get index => none();

  Option<IList<String>> get keys;

  Option<String> get key => none();

  ACursor delete();
  ACursor up();
  ACursor left();
  ACursor right();
  ACursor downArray();

  ACursor downN(int n);
  ACursor field(String key);
  ACursor downField(String key);

  String get pathString => PathToRoot.toPathString(pathToRoot());

  PathToRoot pathToRoot() {
    // TODO: Revisit lastCursorParentOrLastCursor

    PathToRoot loop(ACursor? cursor, PathToRoot acc) {
      if (cursor == null) {
        return acc;
      } else {
        if (cursor.failed) {
          // If the cursor is in a failed state, we lose context on what the
          // attempted last position was. Since we usually want to know this
          // for error reporting, we use the lastOp to attempt to recover that
          // state. We only care about operations which imply a path to the
          // root, such as a field selection.

          final lastCursor = cursor.lastCursor;
          final lastOp = cursor.lastOp;

          switch (lastOp) {
            case Field _:
              return loop(cursor.lastCursor,
                  acc.prependElem(PathElem.objectKey(lastOp.key)));
            case DownField _:
              // We tried to move down, and then that failed, so the field was missing.
              return loop(cursor.lastCursor,
                  acc.prependElem(PathElem.objectKey(lastOp.key)));
            case DownArray _:
              // We tried to move into an array, but it must have been empty.
              return loop(
                  cursor.lastCursor, acc.prependElem(PathElem.arrayIndex(0)));
            case DownN _:
              // We tried to move into an array at index N, but there was no element there.
              return loop(cursor.lastCursor,
                  acc.prependElem(PathElem.arrayIndex(lastOp.n)));
            case MoveLeft _:
              // We tried to move to before the start of the array.
              return loop(
                  cursor.lastCursor, acc.prependElem(PathElem.arrayIndex(-1)));
            case MoveRight _:
              if (lastCursor is ArrayCursor) {
                // We tried to move to past the end of the array.
                return loop(
                  lastCursor.parent,
                  acc.prependElem(
                      PathElem.arrayIndex(lastCursor.indexValue + 1)),
                );
              } else {
                // Invalid state, skip for now.
                return loop(cursor.lastCursor, acc);
              }
            default:
              // CursorOp.MoveUp or CursorOp.DeleteGoParent, both are move up
              // events.
              //
              // Recalling we are in a failed branch here, this should only
              // fail if we are already at the top of the tree or if the
              // cursor state is broken, in either
              // case this is the only valid action to take.
              return loop(cursor.lastCursor, acc);
          }
        } else {
          switch (cursor) {
            case ArrayCursor _:
              return loop(cursor.parent,
                  acc.prependElem(PathElem.arrayIndex(cursor.indexValue)));
            case ObjectCursor _:
              return loop(cursor.parent,
                  acc.prependElem(PathElem.objectKey(cursor.keyValue)));
            case TopCursor _:
              return acc;
            default:
              return loop(cursor.lastCursor, acc);
          }
        }
      }
    }

    return loop(this, PathToRoot.empty);
  }

  DecodeResult<A> as<A>(Decoder<A> decoder) => decoder.tryDecode(this);

  DecodeResult<A> get<A>(String key, Decoder<A> decoder) =>
      downField(key).as(decoder);

  @override
  String toString() => 'ACursor($lastCursor, $lastOp)';
}
