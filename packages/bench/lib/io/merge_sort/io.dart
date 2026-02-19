import 'package:ribs_bench/io/merge_sort/common.dart';
import 'package:ribs_effect/ribs_effect.dart';

void main(List<String> args) async {
  final unsorted = generateUnsortedList();
  await mergeSortIO(unsorted, threshold).unsafeRunFuture();
}

IO<List<int>> mergeSortIO(List<int> list, int threshold) {
  if (list.length <= threshold) {
    return IO.delay(() {
      final copy = List.of(list);
      copy.sort();
      return copy;
    });
  } else {
    final mid = list.length ~/ 2;

    final left = list.sublist(0, mid);
    final right = list.sublist(mid);

    final leftTask = mergeSortIO(left, threshold);
    final rightTask = mergeSortIO(right, threshold);

    return IO.both(leftTask, rightTask).mapN((l, r) => merge(l, r));
  }
}
