import 'package:ribs_core/ribs_core.dart';

/// Alias type for `IList<Object?>` used to abstract row types used by different
/// database drivers.
extension type Row(IList<Object?> _columns) {
  Object? operator [](int index) => _columns[index];

  int get length => _columns.length;
}
