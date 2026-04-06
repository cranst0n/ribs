import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/array_cursor.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';
import 'package:ribs_json/src/cursor/top_cursor.dart';

/// Abstract cursor over a [Json] tree, providing navigation and decoding.
///
/// An [ACursor] is either an [HCursor] (succeeded) or a [FailedCursor]
/// (failed). Navigation methods return a new cursor; failed cursors propagate
/// silently until [decode] is called, at which point the error is surfaced.
@immutable
abstract class ACursor {
  /// The cursor that was active before the last operation, or `null` at the
  /// root.
  final HCursor? lastCursor;

  /// The operation that produced this cursor from [lastCursor], or `null` at
  /// the root.
  final CursorOp? lastOp;

  const ACursor(this.lastCursor, this.lastOp);

  /// Returns [Some] with the focused [Json] if the cursor succeeded, or [None]
  /// if it failed.
  Option<Json> focus();

  /// Returns the list of [CursorOp]s that led to this cursor, most-recent
  /// first. Used to reconstruct a path for [DecodingFailure] messages.
  IList<CursorOp> history() {
    final ops = <CursorOp>[];
    var current = this as ACursor?;

    while (current != null && current.lastOp != null) {
      ops.add(current.lastOp!);
      current = current.lastCursor;
    }

    return ilist(ops);
  }

  /// Returns `true` if the cursor is in a successful state.
  bool get succeeded;

  /// Returns `true` if the cursor is in a failed state.
  bool get failed => !succeeded;

  /// Returns [Some] with this cursor if it succeeded, or [None] if it failed.
  Option<HCursor> success();

  /// Returns [Some] with the root [Json] value if the cursor succeeded.
  Option<Json> top();

  /// Returns the root [HCursor] of the cursor chain, or `null` if unavailable.
  HCursor? root() => null;

  /// Returns a new cursor with the focused [Json] replaced by `f(focused)`.
  ACursor withFocus(Function1<Json, Json> f);

  /// Returns a new cursor with the focus replaced by [j].
  ACursor set(Json j) => withFocus((_) => j);

  /// If the focus is a [JArray], returns [Some] with its elements.
  Option<IList<Json>> get values;

  /// If the cursor is inside a [JArray], returns [Some] with the current index.
  Option<int> get index => none();

  /// If the focus is a [JObject], returns [Some] with its keys.
  Option<IList<String>> get keys;

  /// If the cursor is inside a [JObject], returns [Some] with the current key.
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

  /// Decodes the focused value using [decoder].
  DecodeResult<A> decode<A>(Decoder<A> decoder) => decoder.tryDecodeC(this);

  /// Navigates to [key] and decodes the value using [decoder].
  DecodeResult<A> get<A>(String key, Decoder<A> decoder) => downField(key).decode(decoder);

  /// Navigates to [key] and decodes the value; returns [fallback] if the field
  /// is absent or decoding yields [None].
  DecodeResult<A> getOrElse<A>(String key, Decoder<A> decoder, Function0<A> fallback) =>
      get(key, decoder.optional()).fold(
        (err) => fallback().asRight(),
        (aOpt) => aOpt.fold(() => fallback().asRight(), (a) => a.asRight()),
      );

  /// A dot/bracket string representing the current cursor position
  /// (e.g. `.user.address[0]`).
  String get pathString => PathToRoot.toPathString(pathToRoot());

  /// Reconstructs the full [PathToRoot] from the cursor chain.
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

  @override
  String toString() => 'ACursor($lastCursor, $lastOp)';
}
