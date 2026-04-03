import 'package:ribs_core/ribs_core.dart';

/// Alias type for `IList<Object?>` used to abstract row types used by different
/// database drivers.
extension type Row(IList<Object?> _columns) {
  /// Returns the column value at [index], or throws if out of range.
  Object? operator [](int index) => _columns[index];

  /// The number of columns in this row.
  int get length => _columns.length;
}
