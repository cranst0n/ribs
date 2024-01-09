// TODO: ...
import 'package:ribs_core/ribs_core.dart';

class Range {
  static int count(int start, int end, int step, bool isInclusive) {
    if (step == 0) throw ArgumentError('zero step');

    // final isEmpty =
    final bool isEmpty;

    if (start == end) {
      isEmpty = !isInclusive;
    } else if (start < end) {
      isEmpty = step < 0;
    } else {
      isEmpty = step > 0;
    }

    if (isEmpty) {
      return 0;
    } else {
      final gap = end - start;
      final jumps = gap ~/ step;

      // Whether the size of this range is one larger than the
      // number of full-sized jumps.
      final hasStub = isInclusive || (gap % step != 0);
      final result = jumps + (hasStub ? 1 : 0);

      if (result > Integer.MaxValue) {
        return -1;
      } else {
        return result;
      }
    }
  }
}
