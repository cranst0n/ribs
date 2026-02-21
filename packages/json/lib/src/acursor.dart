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

  Option<Json> focus();

  IList<CursorOp> history() {
    final ops = <CursorOp>[];
    var current = this as ACursor?;

    while (current != null && current.lastOp != null) {
      ops.add(current.lastOp!);
      current = current.lastCursor;
    }

    return ilist(ops);
  }

  bool get succeeded;

  bool get failed => !succeeded;

  Option<HCursor> success();

  Option<Json> top();

  HCursor? root() => null;

  ACursor withFocus(Function1<Json, Json> f);

  ACursor set(Json j) => withFocus((_) => j);

  Option<IList<Json>> get values;

  Option<int> get index => none();

  Option<IList<String>> get keys;

  Option<String> get key => none();

  /// Delete the focus and move to the parent.
  ACursor delete();

  /// Move focus to the parent.
  ACursor up();

  /// If the focus is an element in a JSON array, move to the left.
  ACursor left();

  /// If the focus is an element in a JSON array, move to the right.
  ACursor right();

  /// If the focus is a JSON array, move to the first element.
  ACursor downArray();

  /// If the focus is a JSON array, move to element at the given
  /// index.
  ACursor downN(int n);

  /// If the focus is a JSON object, move to the sibling at the given key.
  ACursor field(String key);

  /// If the focus is a JSON object, move to the value at the given key.
  ACursor downField(String key);

  String get pathString => PathToRoot.toPathString(pathToRoot());

  PathToRoot pathToRoot() {
    // TODO: Revisit lastCursorParentOrLastCursor
    var currentCursor = this as ACursor?;
    var acc = PathToRoot.empty;

    while (currentCursor != null) {
      if (currentCursor.failed) {
        // If the cursor is in a failed state, we lose context on what the
        // attempted last position was. Since we usually want to know this
        // for error reporting, we use the lastOp to attempt to recover that
        // state. We only care about operations which imply a path to the
        // root, such as a field selection.

        final lastCursor = currentCursor.lastCursor;
        final lastOp = currentCursor.lastOp;

        switch (lastOp) {
          case Field _:
            currentCursor = currentCursor.lastCursor;
            acc = acc.prependElem(PathElem.objectKey(lastOp.key));
          case DownField _:
            // We tried to move down, and then that failed, so the field was missing.
            currentCursor = currentCursor.lastCursor;
            acc = acc.prependElem(PathElem.objectKey(lastOp.key));
          case DownArray _:
            // We tried to move into an array, but it must have been empty.
            currentCursor = currentCursor.lastCursor;
            acc = acc.prependElem(PathElem.arrayIndex(0));
          case DownN _:
            // We tried to move into an array at index N, but there was no element there.
            currentCursor = currentCursor.lastCursor;
            acc = acc.prependElem(PathElem.arrayIndex(lastOp.n));
          case MoveLeft _:
            // We tried to move to before the start of the array.
            currentCursor = currentCursor.lastCursor;
            acc = acc.prependElem(PathElem.arrayIndex(-1));
          case MoveRight _:
            if (lastCursor is ArrayCursor) {
              // We tried to move to past the end of the array.
              currentCursor = lastCursor.parent;
              acc = acc.prependElem(PathElem.arrayIndex(lastCursor.indexValue + 1));
            } else {
              // Invalid state, skip for now.
              currentCursor = currentCursor.lastCursor;
            }
          default:
            // CursorOp.MoveUp or CursorOp.DeleteGoParent, both are move up
            // events.
            //
            // Recalling we are in a failed branch here, this should only
            // fail if we are already at the top of the tree or if the
            // cursor state is broken, in either
            // case this is the only valid action to take.
            currentCursor = currentCursor.lastCursor;
        }
      } else {
        switch (currentCursor) {
          case ArrayCursor _:
            final cursor = currentCursor;
            currentCursor = cursor.parent;
            acc = acc.prependElem(PathElem.arrayIndex(cursor.indexValue));
          case ObjectCursor _:
            final cursor = currentCursor;
            currentCursor = cursor.parent;
            acc = acc.prependElem(PathElem.objectKey(cursor.keyValue));
          case TopCursor _:
            currentCursor = null; // Exit loop
          default:
            currentCursor = currentCursor.lastCursor;
        }
      }
    }

    return acc;
  }

  DecodeResult<A> decode<A>(Decoder<A> decoder) => decoder.tryDecodeC(this);

  DecodeResult<A> get<A>(String key, Decoder<A> decoder) => downField(key).decode(decoder);

  DecodeResult<A> getOrElse<A>(String key, Decoder<A> decoder, Function0<A> fallback) =>
      get(key, decoder.optional()).fold(
        (err) => fallback().asRight(),
        (aOpt) => aOpt.fold(() => fallback().asRight(), (a) => a.asRight()),
      );

  @override
  String toString() => 'ACursor($lastCursor, $lastOp)';
}
