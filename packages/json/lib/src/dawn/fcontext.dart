import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

abstract class FContext {
  static FContext array(int i) => _ArrayContext();
  static FContext object(int i) => _ObjectContext();
  static FContext single(int i) => _SingleContext();

  void addStringAt(String s, int index);
  void addStringLimit(String s, int start, int limit) => addStringAt(s, start);
  void addValueAt(Json v, int index);

  Json finishAt(int index);
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
  Json finishAt(int index) => Json.fromJsonObject(
      JsonObject.fromIList(ilist(m.entries).map((e) => (e.key, e.value))));

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
