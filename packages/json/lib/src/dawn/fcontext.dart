import 'package:ribs_json/ribs_json.dart';

/// Accumulator context used by [Parser] to build up a [Json] value during
/// parsing.
///
/// Each context corresponds to the JSON structure currently being assembled:
/// an array, an object, or a single top-level value. The parser calls
/// [addStringAt] / [addValueAt] to push parsed values into the context, and
/// [finishAt] to obtain the completed [Json].
abstract class FContext {
  /// Creates a context for accumulating a JSON array.
  static FContext array(int i) => _ArrayContext();

  /// Creates a context for accumulating a JSON object.
  static FContext object(int i) => _ObjectContext();

  /// Creates a context for a single top-level JSON value.
  static FContext single(int i) => _SingleContext();

  /// Adds a parsed string at position [index].
  void addStringAt(String s, int index);

  /// Adds a parsed string spanning [[start], [limit]).
  /// Defaults to delegating to [addStringAt].
  void addStringLimit(String s, int start, int limit) => addStringAt(s, start);

  /// Adds a parsed [Json] value at position [index].
  void addValueAt(Json v, int index);

  /// Returns the completed [Json] value, finalised at position [index].
  Json finishAt(int index);

  /// Returns `true` if this context is accumulating a JSON object.
  bool get isObject;
}

class _ArrayContext extends FContext {
  final buffer = List<Json>.empty(growable: true);

  @override
  void addStringAt(String s, int index) => buffer.add(JString(s));

  @override
  void addValueAt(Json v, int index) => buffer.add(v);

  @override
  Json finishAt(int index) => Json.arr(buffer);

  @override
  bool get isObject => false;
}

class _ObjectContext extends FContext {
  String? key;
  final Map<String, Json> m = {};

  @override
  void addStringAt(String s, int index) {
    if (key == null) {
      key = s;
    } else {
      m[key!] = JString(s);
      key = null;
    }
  }

  @override
  void addValueAt(Json v, int index) {
    m[key!] = v;
    key = null;
  }

  @override
  Json finishAt(int index) => Json.fromJsonObject(JsonObject.fromMap(m));

  @override
  bool get isObject => true;
}

class _SingleContext extends FContext {
  late Json _value;

  @override
  void addStringAt(String s, int index) => _value = JString(s);

  @override
  void addValueAt(Json v, int index) => _value = v;

  @override
  Json finishAt(int index) => _value;

  @override
  bool get isObject => false;
}
